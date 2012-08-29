--TEST--
Test lz4_uncompress() function : error conditions
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

echo "*** Testing lz4_uncompress() : error conditions ***\n";

// Zero arguments
echo "\n-- Testing lz4_uncompress() function with Zero arguments --\n";
var_dump( lz4_uncompress() );

//Test lz4_uncompress with one more than the expected number of arguments
echo "\n-- Testing lz4_uncompress() function with more than expected no. of arguments --\n";
$data = 'string_val';
$extra_arg = 10;
var_dump( lz4_uncompress($data, -1, -1, $extra_arg) );


echo "\n-- Testing with incorrect arguments --\n";
var_dump(lz4_uncompress(123));

class Tester
{
    function Hello()
    {
        echo "Hello\n";
    }
}

$testclass = new Tester();
var_dump(lz4_uncompress($testclass));
?>
===DONE===
--EXPECTF--
*** Testing lz4_uncompress() : error conditions ***

-- Testing lz4_uncompress() function with Zero arguments --

Warning: lz4_uncompress() expects at least 1 parameter, 0 given in %s on line %d
bool(false)

-- Testing lz4_uncompress() function with more than expected no. of arguments --

Warning: lz4_uncompress() expects at most 3 parameters, 4 given in %s on line %d
bool(false)

-- Testing with incorrect arguments --

Warning: lz4_uncompress : expects parameter to be string. in %s on line %d
bool(false)

Warning: lz4_uncompress : expects parameter to be string. in %s on line %d
bool(false)
===DONE===
