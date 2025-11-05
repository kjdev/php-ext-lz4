--TEST--
Test lz4_compress_frame() function : with all parameters
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_compress_frame() : with all parameters ***\n";

// Initialise all required variables

$smallstring = "A small string to compress\n";

// Compressing a big string
echo "-- Compression --\n";
$output = lz4_compress_frame($data, 6, LZ4_BLOCK_SIZE_256KB, LZ4_CHECKSUM_FRAME | LZ4_CHECKSUM_BLOCK);
var_dump(strcmp(lz4_uncompress_frame($output), $data));

// Compressing a smaller string
echo "-- Compression --\n";
$output = lz4_compress_frame($smallstring, 6, LZ4_BLOCK_SIZE_256KB, LZ4_CHECKSUM_FRAME | LZ4_CHECKSUM_BLOCK);
var_dump(bin2hex($output));
var_dump(strcmp(lz4_uncompress_frame($output), $smallstring));
?>
===Done===
--EXPECT--
*** Testing lz4_compress_frame() : with all parameters ***
-- Compression --
int(0)
-- Compression --
string(116) "04224d187c401b00000000000000981b0000804120736d616c6c20737472696e6720746f20636f6d70726573730a2f4da318000000002f4da318"
int(0)
===Done===
