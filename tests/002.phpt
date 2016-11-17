--TEST--
Test lz4_compress() function : error conditions
--SKIPIF--
--FILE--
<?php 
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress() : error conditions ***\n";

// Zero arguments
echo "\n-- Testing lz4_compress() function with Zero arguments --\n";
var_dump(lz4_compress());

//Test lz4_compress with one more than the expected number of arguments
echo "\n-- Testing lz4_compress() function with more than expected no. of arguments --\n";
$data = 'string_val';
$extra_arg = 10;
var_dump(lz4_compress($data, 6, false, $extra_arg));

class Tester {
    function Hello() {
        echo "Hello\n";
    }
}

echo "\n-- Testing with incorrect parameters --\n";
$testclass = new Tester();
var_dump(lz4_compress($testclass));
?>
===Done===
--EXPECTF--
*** Testing lz4_compress() : error conditions ***

-- Testing lz4_compress() function with Zero arguments --

Warning: lz4_compress() expects at least 1 parameter, 0 given in %s on line %d
bool(false)

-- Testing lz4_compress() function with more than expected no. of arguments --

Warning: lz4_compress() expects at most 3 parameters, 4 given in %s on line %d
bool(false)

-- Testing with incorrect parameters --

Warning: lz4_compress : expects parameter to be string. in %s on line %d
bool(false)
===Done===
