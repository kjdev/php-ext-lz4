--TEST--
Test lz4_uncompress() function : max size
--SKIPIF--
<?php if (PHP_INT_SIZE==4) die("skip 64bits only"); ?>
--FILE--
<?php 
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

$output = lz4_compress($data);
var_dump(md5($output));
var_dump(strcmp(lz4_uncompress($output, strlen($data)), $data));
?>
===Done===
--EXPECT--
string(32) "58a645dbce1fcaf21f488b597726efa1"
int(0)
===Done===
