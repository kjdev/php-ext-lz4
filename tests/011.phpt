--TEST--
Test lz4_compress() : compress level
--SKIPIF--
--FILE--
<?php 
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

function check_compress($data, $level)
{
  $output = (string)lz4_compress($data, $level);
  echo $level, ' -- ', strlen($output), ' -- ',
    var_export(lz4_uncompress($output) === $data, true), PHP_EOL;
}

echo "*** Data size ***", PHP_EOL;
echo strlen($data), PHP_EOL;

echo "*** Compression Level ***", PHP_EOL;
for ($level = 1; $level <= 16; $level++) {
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
1 -- 2715 -- true
2 -- 2697 -- true
3 -- 2688 -- true
4 -- 2687 -- true
5 -- 2687 -- true
6 -- 2686 -- true
7 -- 2686 -- true
8 -- 2686 -- true
9 -- 2686 -- true
10 -- 2686 -- true
11 -- 2686 -- true
12 -- 2686 -- true
13 -- 2686 -- true
14 -- 2686 -- true
15 -- 2686 -- true
16 -- 2686 -- true
*** Invalid Compression Level ***

Warning: lz4_compress: compression level (100) must be within 1..16 in %s on line %d
100 -- 0 -- false

Warning: lz4_compress: compression level (-1) must be within 1..16 in %s on line %d
-1 -- 0 -- false
===Done===
