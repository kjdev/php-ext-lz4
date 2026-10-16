<?php

/**
 * @generate-class-entries
 * @generate-legacy-arginfo
 */

/**
* @var int
* @cvalue PHP_LZ4_CLEVEL_MIN
*/
const LZ4_CLEVEL_MIN = UNKNOWN;

/**
* @var int
* @cvalue PHP_LZ4_CLEVEL_MAX
*/
const LZ4_CLEVEL_MAX = UNKNOWN;

/**
* @var string
* @cvalue LZ4_VERSION_STRING
*/
const LZ4_VERSION_TEXT = UNKNOWN;

/**
* @var int
* @cvalue LZ4_VERSION_NUMBER
*/
const LZ4_VERSION_NUMBER = UNKNOWN;

/**
* @var int
* @cvalue PHP_LZ4_CHECKSUM_FRAME
*/
const LZ4_CHECKSUM_FRAME = UNKNOWN;

/**
* @var int
* @cvalue PHP_LZ4_CHECKSUM_BLOCK
*/
const LZ4_CHECKSUM_BLOCK = UNKNOWN;

/**
* @var int
* @cvalue LZ4F_max64KB
*/
const LZ4_BLOCK_SIZE_64KB = UNKNOWN;

/**
* @var int
* @cvalue LZ4F_max256KB
*/
const LZ4_BLOCK_SIZE_256KB = UNKNOWN;

/**
* @var int
* @cvalue LZ4F_max1MB
*/
const LZ4_BLOCK_SIZE_1MB = UNKNOWN;

/**
* @var int
* @cvalue LZ4F_max4MB
*/
const LZ4_BLOCK_SIZE_4MB = UNKNOWN;

function lz4_compress(string $data, int $level = 0, ?string $extra = NULL): string|false {}

function lz4_uncompress(string $data, int $maxsize = -1, int $offset = 0): string|false {}

function lz4_compress_raw(string $data, int $level = 0): string|false {}

function lz4_uncompress_raw(string $data, int $maxsize = -1): string|false {}

/**
* @param int $max_block_size any of the LZ4_BLOCK_SIZE_* constants
* @param int $checksums bitmask of the LZ4_CHECKSUM_* constants
*/
function lz4_compress_frame(string $data, int $level = 0, int $max_block_size = 0, int $checksums = 0): string|false {}

function lz4_uncompress_frame(string $data): string|false {}

