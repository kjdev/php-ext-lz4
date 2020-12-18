--TEST--
Test lz4_uncompress() function : max size
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

$output = lz4_compress($data);
var_dump(strcmp(lz4_uncompress($output, strlen($data)), $data));
?>
===Done===
--EXPECT--
int(0)
===Done===
