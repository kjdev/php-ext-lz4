--TEST--
unexpected exiting when uncompress the wrong format data
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

$str = 'message string';
$input = base64_decode($str);

echo "=== Compress and Uncompress ===", PHP_EOL;
$output = lz4_uncompress(lz4_compress($input));
var_dump($input == $output);

echo "=== Uncompress ===", PHP_EOL;
$output = lz4_uncompress($input);
var_dump($input == $output);
var_dump($output);
?>
===Done===
--EXPECTF--
=== Compress and Uncompress ===
bool(true)
=== Uncompress ===

Warning: lz4_uncompress : data error in %s on line %d
bool(false)
bool(false)
===Done===
