--TEST--
Test lz4_compress() : compress level
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

error_reporting(0);

function check_compress($data, $level)
{
  $output = (string)lz4_compress($data, $level);
  echo $level, ' -- ', strlen($output), ' -- ',
    var_export(lz4_uncompress($output) === $data, true), PHP_EOL;
}

echo "*** Data size ***", PHP_EOL;
echo strlen($data), PHP_EOL;

echo "*** Compression Level ***", PHP_EOL;
for ($level = 1; $level <= 12; $level++) {
  check_compress($data, $level);
}

echo "*** Invalid Compression Level ***", PHP_EOL;
check_compress($data, 100);
check_compress($data, -1);
?>
===Done===
--EXPECTF--
*** Data size ***
3547
*** Compression Level ***
1 -- %d -- true
2 -- 2%d -- true
3 -- 2%d -- true
4 -- 2%d -- true
5 -- 2%d -- true
6 -- 2%d -- true
7 -- 2%d -- true
8 -- 2%d -- true
9 -- 2%d -- true
10 -- 2%d -- true
11 -- 2%d -- true
12 -- 2%d -- true
*** Invalid Compression Level ***
100 -- 0 -- false
-1 -- 0 -- false
===Done===
