--TEST--
Test lz4_compress() / lz4_uncompress() function : extras and offset
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

$extras = 'TEST';

$output = lz4_compress($data, 6, $extras);
var_dump(strcmp(lz4_uncompress($output, strlen($data), strlen($extras)), $data));
?>
===Done===
--EXPECT--
int(0)
===Done===
