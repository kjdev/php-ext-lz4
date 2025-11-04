--TEST--
Test lz4_compress_frame() function : basic functionality
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress_frame() : basic functionality ***\n";

// Initialise all required variables

$smallstring = "A small string to compress\n";

// Compressing a big string
echo "-- Compression --\n";
$output = lz4_compress_frame($data);
var_dump(strcmp(lz4_uncompress_frame($output), $data));

// Compressing a smaller string
echo "-- Compression --\n";
$output = lz4_compress_frame($smallstring);
var_dump(bin2hex($output));
var_dump(strcmp(lz4_uncompress_frame($output), $smallstring));
?>
===Done===
--EXPECT--
*** Testing lz4_compress_frame() : basic functionality ***
-- Compression --
int(0)
-- Compression --
string(100) "04224d1868401b00000000000000fa1b0000804120736d616c6c20737472696e6720746f20636f6d70726573730a00000000"
int(0)
===Done===
