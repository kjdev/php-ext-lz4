/*
  Copyright (c) 2013 kjdev

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
#include "ext/standard/php_var.h"
#include "ext/apcu/apc_serializer.h"
#include "zend_smart_str.h"
#endif
#include "php_verdep.h"
#include "php_lz4.h"

/* lz4 */
#include "lz4.h"
#include "lz4hc.h"

#if defined(LZ4HC_CLEVEL_MAX)
/* version >= 1.7.5 */
#define PHP_LZ4_CLEVEL_MAX LZ4HC_CLEVEL_MAX

#elif defined (LZ4HC_MAX_CLEVEL)
/* version >= 1.7.3 */
#define PHP_LZ4_CLEVEL_MAX LZ4HC_MAX_CLEVEL

#else
/* older versions */
#define PHP_LZ4_CLEVEL_MAX 16
#endif

#if defined(LZ4HC_CLEVEL_MIN)
/* version >= 1.7.5 */
#define PHP_LZ4_CLEVEL_MIN LZ4HC_CLEVEL_MIN

#elif defined (LZ4HC_MIN_CLEVEL)
/* version >= 1.7.3 */
#define PHP_LZ4_CLEVEL_MIN LZ4HC_MIN_CLEVEL

#else
/* older versions */
#define PHP_LZ4_CLEVEL_MIN 3
#endif

static ZEND_FUNCTION(lz4_compress);
static ZEND_FUNCTION(lz4_uncompress);

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_compress, 0, 0, 1)
    ZEND_ARG_INFO(0, data)
    ZEND_ARG_INFO(0, level)
    ZEND_ARG_INFO(0, extra)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_uncompress, 0, 0, 1)
    ZEND_ARG_INFO(0, data)
    ZEND_ARG_INFO(0, max)
    ZEND_ARG_INFO(0, offset)
ZEND_END_ARG_INFO()

#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
static int APC_SERIALIZER_NAME(lz4)(APC_SERIALIZER_ARGS);
static int APC_UNSERIALIZER_NAME(lz4)(APC_UNSERIALIZER_ARGS);
#endif

static zend_function_entry lz4_functions[] = {
    ZEND_FE(lz4_compress, arginfo_lz4_compress)
    ZEND_FE(lz4_uncompress, arginfo_lz4_uncompress)
    ZEND_FE_END
};


static PHP_MINIT_FUNCTION(lz4)
{
    REGISTER_LONG_CONSTANT("LZ4_CLEVEL_MIN", PHP_LZ4_CLEVEL_MIN, CONST_CS | CONST_PERSISTENT);
    REGISTER_LONG_CONSTANT("LZ4_CLEVEL_MAX", PHP_LZ4_CLEVEL_MAX, CONST_CS | CONST_PERSISTENT);
    REGISTER_LONG_CONSTANT("LZ4_VERSION",    LZ4_versionNumber(), CONST_CS | CONST_PERSISTENT);

#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
    apc_register_serializer("lz4",
                            APC_SERIALIZER_NAME(lz4),
                            APC_UNSERIALIZER_NAME(lz4),
                            NULL);
#endif

    return SUCCESS;
}

ZEND_MINFO_FUNCTION(lz4)
{
    php_info_print_table_start();
    php_info_print_table_row(2, "LZ4 support", "enabled");
    php_info_print_table_row(2, "Extension Version", LZ4_EXT_VERSION);
#if !defined(HAVE_LIBLZ4)
    /* Bundled library */
    php_info_print_table_row(2, "LZ4 Version", LZ4_versionString());
#elif defined(LZ4_VERSION_MAJOR)
    /* Recent system library */
    {
    char buffer[128];

    snprintf(buffer, sizeof(buffer), "%d.%d.%d",
             LZ4_VERSION_MAJOR, LZ4_VERSION_MINOR, LZ4_VERSION_RELEASE);
    php_info_print_table_row(2, "LZ4 headers Version", buffer);

    /* LZ4_versionString is not usable, see https://github.com/lz4/lz4/issues/301 */
    snprintf(buffer, sizeof(buffer), "%d.%d.%d",
             LZ4_versionNumber()/10000, (LZ4_versionNumber()/100)%100, LZ4_versionNumber()%100);
    php_info_print_table_row(2, "LZ4 library Version", buffer);
    }
#else
    /* Old system library */
    php_info_print_table_row(2, "LZ4 Version", "system library");
#endif
#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
    php_info_print_table_row(2, "LZ4 APCu serializer ABI", APC_SERIALIZER_ABI);
#endif
    php_info_print_table_end();
}

#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
static const zend_module_dep lz4_module_deps[] = {
  ZEND_MOD_OPTIONAL("apcu")
  ZEND_MOD_END
};
#endif

zend_module_entry lz4_module_entry = {
#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
    STANDARD_MODULE_HEADER_EX,
    NULL,
    lz4_module_deps,
#elif ZEND_MODULE_API_NO >= 20010901
    STANDARD_MODULE_HEADER,
#endif
    "lz4",
    lz4_functions,
    PHP_MINIT(lz4),
    NULL,
    NULL,
    NULL,
    ZEND_MINFO(lz4),
#if ZEND_MODULE_API_NO >= 20010901
    LZ4_EXT_VERSION,
#endif
    STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_LZ4
ZEND_GET_MODULE(lz4)
#endif

static int php_lz4_compress(char* in, const int in_len,
                            char* extra, const int extra_len,
                            char** out, int* out_len,
                            const int level)
{
    int var_len, var_offset;

    if (extra && extra_len > 0) {
        var_offset = extra_len;
    } else {
        var_offset = sizeof(int);
    }

    var_len = LZ4_compressBound(in_len) + var_offset;

    *out = (char*)emalloc(var_len);
    if (!*out) {
        zend_error(E_WARNING, "lz4_compress : memory error");
        *out_len = 0;
        return FAILURE;
    }

    if (extra && extra_len > 0) {
        memcpy(*out, extra, var_offset);
    } else {
        /* Set the data length */
        memcpy(*out, &in_len, var_offset);
    }

    if (level == 0) {
        *out_len = LZ4_compress_default(in,
                                        (*out) + var_offset,
                                        in_len,
                                        var_len - var_offset - 1);
    } else if (level > 0 && level <= PHP_LZ4_CLEVEL_MAX) {
        *out_len = LZ4_compress_HC(in,
                                   (*out) + var_offset,
                                   in_len,
                                   var_len - var_offset - 1,
                                   level);
    } else {
        zend_error(E_WARNING,
                   "lz4_compress: compression level (%d) must be within 1..%d",
                   level, PHP_LZ4_CLEVEL_MAX);
        efree(*out);
        *out = NULL;
        *out_len = 0;
        return FAILURE;
    }

    if (*out_len <= 0) {
        zend_error(E_WARNING, "lz4_compress : data error");
        efree(*out);
        *out = NULL;
        *out_len = 0;
        return FAILURE;
    }

    *out_len += var_offset;

    return SUCCESS;
}

static int php_lz4_uncompress(const char* in, const int in_len,
                              const int in_max, int in_offset,
                              char** out, int* out_len)
{
    int var_len;

    if (in_max > 0) {
        var_len = in_max;
        if (!in_offset) {
            in_offset = sizeof(int);
        }
    } else {
        /* Get data length */
        in_offset = sizeof(int);
        memcpy(&var_len, in, in_offset);
    }

    if (var_len < 0) {
        zend_error(E_WARNING, "lz4_uncompress : allocate size error");
        return FAILURE;
    }

    *out = (char*)malloc(var_len + 1);
    if (!*out) {
        zend_error(E_WARNING, "lz4_uncompress : memory error");
        return FAILURE;
    }

    *out_len = LZ4_decompress_safe(in + in_offset,
                                   *out,
                                   in_len - in_offset,
                                   var_len);
    if (*out_len <= 0) {
        zend_error(E_WARNING, "lz4_uncompress : data error");
        free(*out);
        *out = NULL;
        *out_len = 0;
        return FAILURE;
    }

    return SUCCESS;
}

static ZEND_FUNCTION(lz4_compress)
{
    zval *data;
    char *output;
    int output_len;
    long level = 0;
    char *extra = NULL;
#if ZEND_MODULE_API_NO >= 20141001
    size_t extra_len = -1;
#else
    int extra_len = -1;
#endif

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC,
                              "z|ls", &data, &level,
                              &extra, &extra_len) == FAILURE) {
        RETURN_FALSE;
    }

    if (Z_TYPE_P(data) != IS_STRING) {
        zend_error(E_WARNING,
                   "lz4_compress : expects parameter to be string.");
        RETURN_FALSE;
    }

    if (php_lz4_compress(Z_STRVAL_P(data), Z_STRLEN_P(data),
                         extra, extra_len,
                         &output, &output_len,
                         (int)level) == FAILURE) {
        RETVAL_FALSE;
    }
#if ZEND_MODULE_API_NO >= 20141001
    RETVAL_STRINGL(output, output_len);
#else
    RETVAL_STRINGL(output, output_len, 1);
#endif

    efree(output);
}

static ZEND_FUNCTION(lz4_uncompress)
{
    zval *data;
    int output_len;
    char *output;
#if ZEND_MODULE_API_NO >= 20141001
    zend_long max_size = -1, offset = 0;
#else
    long max_size = -1, offset = 0;
#endif

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC,
                              "z|ll", &data, &max_size, &offset) == FAILURE) {
        RETURN_FALSE;
    }

    if (Z_TYPE_P(data) != IS_STRING) {
        zend_error(E_WARNING,
                   "lz4_uncompress : expects parameter to be string.");
        RETURN_FALSE;
    }

    if (php_lz4_uncompress(Z_STRVAL_P(data), Z_STRLEN_P(data),
                           (const int)max_size, (const int)offset,
                           &output, &output_len) == FAILURE) {
        RETURN_FALSE;
    }

#if ZEND_MODULE_API_NO >= 20141001
    RETVAL_STRINGL(output, output_len);
#else
    RETVAL_STRINGL(output, output_len, 1);
#endif

    free(output);
}

#if PHP_MAJOR_VERSION >= 7 && defined(HAVE_APCU_SUPPORT)
static int APC_SERIALIZER_NAME(lz4)(APC_SERIALIZER_ARGS)
{
    int result;
    php_serialize_data_t var_hash;
    int out_len, data_size, data_offset = sizeof(int);
    smart_str var = {0};

    PHP_VAR_SERIALIZE_INIT(var_hash);
    php_var_serialize(&var, (zval*) value, &var_hash);
    PHP_VAR_SERIALIZE_DESTROY(var_hash);
    if (var.s == NULL) {
        return 0;
    }

    if (php_lz4_compress(ZSTR_VAL(var.s), ZSTR_LEN(var.s),
                         NULL, 0,
                         (char**)buf, (int*)buf_len,
                         0) == SUCCESS) {
        result = 1;
    } else {
        result = 0;
    }

    smart_str_free(&var);

    return result;
}

static int APC_UNSERIALIZER_NAME(lz4)(APC_UNSERIALIZER_ARGS)
{
    const unsigned char* tmp;
    int result;
    php_unserialize_data_t var_hash;
    int var_len, data_size, data_offset = sizeof(int);
    unsigned char* var;

    if (php_lz4_uncompress(buf, (const int)buf_len,
                           0, 0,
                           (char**)&var, (int*)&var_len) != SUCCESS) {
        ZVAL_NULL(value);
        return 0;
    }

    PHP_VAR_UNSERIALIZE_INIT(var_hash);
    tmp = var;
    result = php_var_unserialize(value, &tmp, var + var_len, &var_hash);
    PHP_VAR_UNSERIALIZE_DESTROY(var_hash);

    if (!result) {
        php_error_docref(NULL, E_NOTICE,
                         "Error at offset %ld of %ld bytes",
                         (zend_long)(tmp - var), (zend_long)var_len);
        ZVAL_NULL(value);
        result = 0;
    } else {
        result = 1;
    }

    free(var);

    return result;
}
#endif
