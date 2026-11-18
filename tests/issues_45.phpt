--TEST--
Issue #45: truncated frame and oversized size header
--SKIPIF--
<?php if (!extension_loaded('lz4')) die('skip lz4 extension not loaded'); ?>
--FILE--
<?php
var_dump(lz4_uncompress_frame(base64_decode('BCJNGGhACwCAAACAZQ==')));
var_dump(lz4_uncompress(pack('V', 0x7ffffffe) . "\x00\x00\x00\x00"));
$d = str_repeat('abc', 1000);
var_dump(lz4_uncompress(lz4_compress($d)) === $d);
var_dump(lz4_uncompress_frame(lz4_compress_frame($d)) === $d);
?>
--EXPECTF--
Warning: lz4_uncompress_frame : %s in %s on line %d
bool(false)

Warning: lz4_uncompress : allocate size error in %s on line %d
bool(false)
bool(true)
bool(true)
