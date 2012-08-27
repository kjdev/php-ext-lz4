--TEST--
Test lz4_compress() function : hight
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress() : hight functionality ***\n";

// Initialise all required variables

$smallstring = "A small string to compress\n";


// Calling gzcompress() with all possible arguments

// Compressing a big string
echo "-- Compression --\n";
$output = lz4_compress($data, true);
var_dump(md5($output));
var_dump(strcmp(lz4_uncompress($output), $data));

// Compressing a smaller string
echo "-- Compression --\n";
$output = lz4_compress($smallstring, true);
var_dump(bin2hex($output));
var_dump(strcmp(lz4_uncompress($output), $smallstring));

// Calling gzcompress() with mandatory arguments
echo "\n-- Testing with no specified compression --\n";
var_dump( bin2hex(lz4_compress($smallstring) ));

?>
===Done===
--EXPECT--
*** Testing lz4_compress() : hight functionality ***
-- Compression --
string(32) "58c17f9591f1120cd09f4dcccbb328fa"
int(0)
-- Compression --
string(58) "f00c4120736d616c6c20737472696e6720746f20636f6d70726573730a"
int(0)

-- Testing with no specified compression --
string(58) "f00c4120736d616c6c20737472696e6720746f20636f6d70726573730a"
===Done===
