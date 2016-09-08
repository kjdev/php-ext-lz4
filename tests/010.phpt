--TEST--
Test lz4_uncompress() 32/64 bits consistency
--SKIPIF--
--FILE--
<?php 
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

$enc32 = file_get_contents(dirname(__FILE__) . '/data32.txt');
$dec32 = lz4_uncompress(hex2bin($enc32));
var_dump($data === $dec32);

$enc64 = file_get_contents(dirname(__FILE__) . '/data64.txt');
$dec64 = lz4_uncompress(hex2bin($enc64));
var_dump($data === $dec64);
?>
===Done===
--EXPECT--
bool(true)
bool(true)
===Done===
