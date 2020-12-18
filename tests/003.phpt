--TEST--
Test lz4_compress() function : variation
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress() : variation ***\n";

echo "\n-- Testing multiple compression --\n";
$output = lz4_compress($data);
$first = md5($output);
var_dump($first);
$second = md5(lz4_compress($output));
var_dump($second);
var_dump($first === $second);
?>
===Done===
--EXPECTF--
*** Testing lz4_compress() : variation ***

-- Testing multiple compression --
string(32) "%s"
string(32) "%s"
bool(false)
===Done===
