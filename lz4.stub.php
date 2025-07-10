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

}
