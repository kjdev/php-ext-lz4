--TEST--
Test lz4_uncompress() function : error conditions
--SKIPIF--
<?php
if (version_compare(PHP_VERSION, '8.0', '<')) die('skip PHP is too new');
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

echo "*** Testing lz4_uncompress() : error conditions ***\n";

// Zero arguments
echo "\n-- Testing lz4_uncompress() function with Zero arguments --\n";
try {
  var_dump( lz4_uncompress() );
} catch (Error $e) {
  echo $e, PHP_EOL;
}

//Test lz4_uncompress with one more than the expected number of arguments
echo "\n-- Testing lz4_uncompress() function with more than expected no. of arguments --\n";
$data = 'string_val';
$extra_arg = 10;
try {
  var_dump( lz4_uncompress($data, -1, -1, $extra_arg) );
} catch (Error $e) {
  echo $e, PHP_EOL;
}


echo "\n-- Testing with incorrect arguments --\n";
try {
  var_dump(lz4_uncompress(123));
} catch (Error $e) {
  echo $e, PHP_EOL;
}

class Tester
{
    function Hello()
    {
        echo "Hello\n";
    }
}

$testclass = new Tester();
try {
  var_dump(lz4_uncompress($testclass));
} catch (Error $e) {
  echo $e, PHP_EOL;
}
?>
===DONE===
--EXPECTF--
*** Testing lz4_uncompress() : error conditions ***

-- Testing lz4_uncompress() function with Zero arguments --
ArgumentCountError: lz4_uncompress() expects at least 1 argument, 0 given in %s:%d
Stack trace:
#0 %s(%d): lz4_uncompress()
#1 {main}

-- Testing lz4_uncompress() function with more than expected no. of arguments --
ArgumentCountError: lz4_uncompress() expects at most 3 arguments, 4 given in %s:%d
Stack trace:
#0 %s(%d): lz4_uncompress(%s)
#1 {main}

-- Testing with incorrect arguments --

Warning: lz4_uncompress : expects parameter to be string. in %s on line %d
bool(false)

Warning: lz4_uncompress : expects parameter to be string. in %s on line %d
bool(false)
===DONE===
