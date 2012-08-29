
#ifndef PHP_LZ4_H
#define PHP_LZ4_H

#define LZ4_EXT_VERSION "0.1.0"

extern zend_module_entry lz4_module_entry;
#define phpext_lz4_ptr &lz4_module_entry

#ifdef PHP_WIN32
#   define PHP_LZ4_API __declspec(dllexport)
#elif defined(__GNUC__) && __GNUC__ >= 4
#   define PHP_LZ4_API __attribute__ ((visibility("default")))
#else
#   define PHP_LZ4_API
#endif

#ifdef ZTS
#include "TSRM.h"
#endif

#ifdef ZTS
#define LZ4_G(v) TSRMG(lz4_globals_id, zend_lz4_globals *, v)
#else
#define LZ4_G(v) (lz4_globals.v)
#endif

#endif  /* PHP_LZ4_H */
