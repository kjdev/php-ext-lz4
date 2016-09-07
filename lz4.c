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
#include "php_verdep.h"
#include "php_lz4.h"

/* lz4 */
#include "lz4.h"
#include "lz4hc.h"

static ZEND_FUNCTION(lz4_compress);
static ZEND_FUNCTION(lz4_uncompress);

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_compress, 0, 0, 1)
    ZEND_ARG_INFO(0, data)
    ZEND_ARG_INFO(0, high)
    ZEND_ARG_INFO(0, extra)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_uncompress, 0, 0, 1)
    ZEND_ARG_INFO(0, data)
    ZEND_ARG_INFO(0, max)
    ZEND_ARG_INFO(0, offset)
ZEND_END_ARG_INFO()

static zend_function_entry lz4_functions[] = {
    ZEND_FE(lz4_compress, arginfo_lz4_compress)
    ZEND_FE(lz4_uncompress, arginfo_lz4_uncompress)
    ZEND_FE_END
};

ZEND_MINFO_FUNCTION(lz4)
{
    char buffer[128];
    php_info_print_table_start();
    php_info_print_table_row(2, "LZ4 support", "enabled");
    php_info_print_table_row(2, "Extension Version", LZ4_EXT_VERSION);
#ifdef HAVE_LIBSNAPPY
    snprintf(buffer, sizeof(buffer), "%s", "system library");
#else
    snprintf(buffer, sizeof(buffer), "%d.%d.%d",
             LZ4_VERSION_MAJOR, LZ4_VERSION_MINOR, LZ4_VERSION_RELEASE);
#endif
    php_info_print_table_row(2, "LZ4 Version", buffer);
    php_info_print_table_end();
}

zend_module_entry lz4_module_entry = {
#if ZEND_MODULE_API_NO >= 20010901
    STANDARD_MODULE_HEADER,
#endif
    "lz4",
    lz4_functions,
    NULL,
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

static ZEND_FUNCTION(lz4_compress)
{
    zval *data;
    char *output;
    int output_len, data_len;
    zend_bool high = 0;
    char *extra = NULL;
#if ZEND_MODULE_API_NO >= 20141001
    size_t extra_len = -1;
#else
    int extra_len = -1;
#endif
    int offset = 0;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC,
                              "z|bs", &data, &high,
                              &extra, &extra_len) == FAILURE) {
        RETURN_FALSE;
    }

    if (Z_TYPE_P(data) != IS_STRING) {
        zend_error(E_WARNING,
                   "lz4_compress : expects parameter to be string.");
        RETURN_FALSE;
    }

    if (extra && extra_len > 0) {
        offset = extra_len;
    } else {
        offset = sizeof(int);
    }

    data_len = Z_STRLEN_P(data);

    output = (char *)emalloc(LZ4_compressBound(data_len) + offset);
    if (!output) {
        zend_error(E_WARNING, "lz4_compress : memory error");
        RETURN_FALSE;
    }

    if (extra && extra_len > 0) {
        memcpy(output, extra, offset);
    } else {
        /* Set the data length */
        memcpy(output, &data_len, offset);
    }

    if (high) {
        output_len = LZ4_compressHC(Z_STRVAL_P(data), output + offset, data_len);
    } else {
        output_len = LZ4_compress(Z_STRVAL_P(data), output + offset, data_len);
    }

    if (output_len <= 0) {
        RETVAL_FALSE;
    } else {
#if ZEND_MODULE_API_NO >= 20141001
        RETVAL_STRINGL(output, output_len + offset);
#else
        RETVAL_STRINGL(output, output_len + offset, 1);
#endif
    }

    efree(output);
}

static ZEND_FUNCTION(lz4_uncompress)
{
    zval *data;
    int output_len, data_size;
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

    if (max_size > 0) {
        data_size = max_size;
        if (!offset) {
            offset = sizeof(int);
        }
    } else {
        /* Get data length */
        offset = sizeof(int);
        memcpy(&data_size, Z_STRVAL_P(data), offset);
    }

    if (data_size < 0) {
        zend_error(E_WARNING, "lz4_uncompress : allocate size error");
        RETURN_FALSE;
    }

    output = (char *)malloc(data_size + 1);
    if (!output) {
        zend_error(E_WARNING, "lz4_uncompress : memory error");
        RETURN_FALSE;
    }

    output_len = LZ4_decompress_safe(Z_STRVAL_P(data) + offset,
                                     output,
                                     Z_STRLEN_P(data) - offset,
                                     data_size);

    if (output_len <= 0) {
        zend_error(E_WARNING, "lz4_uncompress : data error");
        RETVAL_FALSE;
    } else {
#if ZEND_MODULE_API_NO >= 20141001
        RETVAL_STRINGL(output, output_len);
#else
        RETVAL_STRINGL(output, output_len, 1);
#endif
    }

    free(output);
}
