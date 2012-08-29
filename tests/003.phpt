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
var_dump( md5($output));
var_dump(md5(lz4_compress($output)));

?>
===Done===
--EXPECTF--
*** Testing lz4_compress() : variation ***

-- Testing multiple compression --
string(32) "58a645dbce1fcaf21f488b597726efa1"
string(32) "91336cf7e1da47b49f03cd666d586450"
===Done===
