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
string(32) "19a1e65eab6f876ad28ff24b164f4ac2"
int(0)
===Done===
