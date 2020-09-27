--TEST--
Test lz4_compress() function : error conditions
--SKIPIF--
<?php
if (version_compare(PHP_VERSION, '8.0', '<')) die('skip PHP is too new');
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress() : error conditions ***\n";

// Zero arguments
echo "\n-- Testing lz4_compress() function with Zero arguments --\n";
try {
  var_dump(lz4_compress());
} catch (Error $e) {
  echo $e, PHP_EOL;
}

//Test lz4_compress with one more than the expected number of arguments
echo "\n-- Testing lz4_compress() function with more than expected no. of arguments --\n";
$data = 'string_val';
$extra_arg = 10;
try {
  var_dump(lz4_compress($data, 6, false, $extra_arg));
} catch (Error $e) {
  echo $e, PHP_EOL;
}

class Tester {
    function Hello() {
        echo "Hello\n";
    }
}

echo "\n-- Testing with incorrect parameters --\n";
$testclass = new Tester();
try {
  var_dump(lz4_compress($testclass));
} catch (Error $e) {
  echo $e, PHP_EOL;
}
?>
===Done===
--EXPECTF--
*** Testing lz4_compress() : error conditions ***

-- Testing lz4_compress() function with Zero arguments --
ArgumentCountError: lz4_compress() expects at least 1 argument, 0 given in %s:%d
Stack trace:
#0 %s(%d): lz4_compress()
#1 {main}

-- Testing lz4_compress() function with more than expected no. of arguments --
ArgumentCountError: lz4_compress() expects at most 3 arguments, 4 given in %s:%d
Stack trace:
#0 %s(%d): lz4_compress(%s)
#1 {main}

-- Testing with incorrect parameters --

Warning: lz4_compress : expects parameter to be string. in %s on line %d
bool(false)
===Done===
