/* This is a generated file, edit lz4.stub.php instead.
 * Stub hash: 4c2e81c70627612af2b15c5b3e6e77ba37c3436a */

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_compress, 0, 0, 1)
	ZEND_ARG_INFO(0, data)
	ZEND_ARG_INFO(0, level)
	ZEND_ARG_INFO(0, extra)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_uncompress, 0, 0, 1)
	ZEND_ARG_INFO(0, data)
	ZEND_ARG_INFO(0, maxsize)
	ZEND_ARG_INFO(0, offset)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_compress_raw, 0, 0, 1)
	ZEND_ARG_INFO(0, data)
	ZEND_ARG_INFO(0, level)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_uncompress_raw, 0, 0, 1)
	ZEND_ARG_INFO(0, data)
	ZEND_ARG_INFO(0, maxsize)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_compress_frame, 0, 0, 1)
	ZEND_ARG_INFO(0, data)
	ZEND_ARG_INFO(0, level)
	ZEND_ARG_INFO(0, max_block_size)
	ZEND_ARG_INFO(0, checksums)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_INFO_EX(arginfo_lz4_uncompress_frame, 0, 0, 1)
	ZEND_ARG_INFO(0, data)
ZEND_END_ARG_INFO()

ZEND_FUNCTION(lz4_compress);
ZEND_FUNCTION(lz4_uncompress);
ZEND_FUNCTION(lz4_compress_raw);
ZEND_FUNCTION(lz4_uncompress_raw);
ZEND_FUNCTION(lz4_compress_frame);
ZEND_FUNCTION(lz4_uncompress_frame);

static const zend_function_entry ext_functions[] = {
	ZEND_FE(lz4_compress, arginfo_lz4_compress)
	ZEND_FE(lz4_uncompress, arginfo_lz4_uncompress)
	ZEND_FE(lz4_compress_raw, arginfo_lz4_compress_raw)
	ZEND_FE(lz4_uncompress_raw, arginfo_lz4_uncompress_raw)
	ZEND_FE(lz4_compress_frame, arginfo_lz4_compress_frame)
	ZEND_FE(lz4_uncompress_frame, arginfo_lz4_uncompress_frame)
	ZEND_FE_END
};

static void register_lz4_symbols(int module_number)
{
	REGISTER_LONG_CONSTANT("LZ4_CLEVEL_MIN", PHP_LZ4_CLEVEL_MIN, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_CLEVEL_MAX", PHP_LZ4_CLEVEL_MAX, CONST_PERSISTENT | CONST_CS);
	REGISTER_STRING_CONSTANT("LZ4_VERSION_TEXT", LZ4_VERSION_STRING, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_VERSION_NUMBER", LZ4_VERSION_NUMBER, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_CHECKSUM_FRAME", PHP_LZ4_CHECKSUM_FRAME, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_CHECKSUM_BLOCK", PHP_LZ4_CHECKSUM_BLOCK, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_BLOCK_SIZE_64KB", LZ4F_max64KB, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_BLOCK_SIZE_256KB", LZ4F_max256KB, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_BLOCK_SIZE_1MB", LZ4F_max1MB, CONST_PERSISTENT | CONST_CS);
	REGISTER_LONG_CONSTANT("LZ4_BLOCK_SIZE_4MB", LZ4F_max4MB, CONST_PERSISTENT | CONST_CS);
}
