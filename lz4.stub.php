<?php

namespace {

  /**
   * @var int
   * @cvalue LZ4_CLEVEL_MIN
   */
  const LZ4_CLEVEL_MIN = UNKNOWN;

  /**
   * @var int
   * @cvalue LZ4_CLEVEL_MAX
   */
  const LZ4_CLEVEL_MAX = UNKNOWN;

  /**
   * @var string
   * @cvalue LZ4_VERSION_TEXT
   */
  const LZ4_VERSION_TEXT = UNKNOWN;

  /**
   * @var int
   * @cvalue LZ4_VERSION_NUMBER
   */
  const LZ4_VERSION_NUMBER = UNKNOWN;


  function lz4_compress(string $data, int $level = 0, string $extra = NULL): string|false {}


  function lz4_uncompress(string $data, int $maxsize = -1, int $offset = -1): string|false {}

  /**
   * @param int $max_block_size 4: 64KB, 5: 256KB, 6: 1MB, 7: 4MB, all other values: 64KB
   * @param int $checksums 0: none, 1: frame content, 2: each block, 3: frame content + each block
   */
  function lz4_compress_frame(string $data, int $level = 0, int $max_block_size = 0, int $checksums = 0): string|false {}


  function lz4_uncompress_frame(string $data): string|false {}

}
