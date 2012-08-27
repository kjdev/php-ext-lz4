
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php_lz4.h"

/* lz4 */
#include "lz4/lz4.h"
#include "lz4/lz4hc.h"

static ZEND_FUNCTION(lz4_compress);
static ZEND_FUNCTION(lz4_uncompress);

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_compress, 0, 0, 1)
    ZEND_ARG_INFO(0, data)
    ZEND_ARG_INFO(0, high)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_uncompress, 0, 0, 1)
    ZEND_ARG_INFO(0, data)
    ZEND_ARG_INFO(0, max)
ZEND_END_ARG_INFO()

static const zend_function_entry lz4_functions[] = {
    ZEND_FE(lz4_compress, arginfo_lz4_compress)
    ZEND_FE(lz4_uncompress, arginfo_lz4_uncompress)
    ZEND_FE_END
};

ZEND_MINFO_FUNCTION(lz4)
{
    php_info_print_table_start();
    php_info_print_table_row(2, "LZ4 support", "enabled");
    php_info_print_table_row(2, "Extension Version", LZ4_EXT_VERSION);
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
    int output_len;
    zend_bool high = 0;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC,
                              "z|b", &data, &high) == FAILURE) {
        RETURN_FALSE;
    }

    if (Z_TYPE_P(data) != IS_STRING) {
        zend_error(E_WARNING,
                   "lz4_compress : expects parameter to be string.");
        RETURN_FALSE;
    }

    output = (char *)emalloc(LZ4_compressBound(Z_STRLEN_P(data)));
    if (!output) {
        zend_error(E_WARNING, "lz4_compress : memory error");
        RETURN_FALSE;
    }

    if (high) {
        output_len = LZ4_compressHC(Z_STRVAL_P(data), output, Z_STRLEN_P(data));
    } else {
        output_len = LZ4_compress(Z_STRVAL_P(data), output, Z_STRLEN_P(data));
    }

    if (output_len <= 0) {
        RETVAL_FALSE;
    } else {
        RETVAL_STRINGL(output, output_len, 1);
    }

    efree(output);
}

static ZEND_FUNCTION(lz4_uncompress)
{
    zval *data;
    int output_len;
    char *output;
    long max_size = -1;
    int i = 1;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC,
                              "z|l", &data, &max_size) == FAILURE) {
        RETURN_FALSE;
    }

    if (Z_TYPE_P(data) != IS_STRING) {
        zend_error(E_WARNING,
                   "lz4_uncompress : expects parameter to be string.");
        RETURN_FALSE;
    }

    /* TODO: output allocate size */
    if (max_size <= 0) {
        max_size = Z_STRLEN_P(data) * 3;
    }

    output = (char *)emalloc(max_size+1);
    if (!output) {
        zend_error(E_WARNING, "lz4_uncompress : memory error");
        RETURN_FALSE;
    }

    output_len = LZ4_uncompress_unknownOutputSize(Z_STRVAL_P(data), output,
                                                  Z_STRLEN_P(data), max_size);

    if (output_len <= 0) {
        zend_error(E_WARNING, "lz4_uncompress : data error");
        RETVAL_FALSE;
    } else {
        RETVAL_STRINGL(output, output_len, 1);
    }

    efree(output);
}
