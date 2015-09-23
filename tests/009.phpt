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

$output = lz4_compress($data, $extras);
var_dump(md5($output));
var_dump(strcmp(lz4_uncompress($output, strlen($data), strlen($extras)), $data));
?>
===Done===
--EXPECT--
string(32) "5930843ebc3b37585a35c8b8b0172a89"
int(0)
===Done===
