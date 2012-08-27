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
string(32) "b70826de14e8fc0b06f2c9f3502132d1"
string(32) "8325787a0f15fa24208da1dafde20250"
===Done===
