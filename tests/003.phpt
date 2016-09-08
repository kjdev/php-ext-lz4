--TEST--
Test lz4_compress() function : variation
--SKIPIF--
<?php if (PHP_INT_SIZE==4) die("skip 64bits only"); ?>
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress() : variation ***\n";

echo "\n-- Testing multiple compression --\n";
$output = lz4_compress($data);
var_dump(md5($output));
var_dump(md5(lz4_compress($output)));

?>
===Done===
--EXPECTF--
*** Testing lz4_compress() : variation ***

-- Testing multiple compression --
string(32) "3fad1911784ea233a021cd95ce3a6fec"
string(32) "be4f22f273b7a7c1b5b186156547e8c2"
===Done===
