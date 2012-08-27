--TEST--
Test lz4_uncompress() function : basic functionality
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

include(dirname(__FILE__) . '/data.inc');

echo "*** Testing lz4_uncompress() : basic functionality ***\n";

// Initialise all required variables
$compressed = lz4_compress($data);

echo "\n-- Basic decompress --\n";
var_dump(strcmp($data, lz4_uncompress($compressed)));
?>
===DONE===
--EXPECT--
*** Testing lz4_uncompress() : basic functionality ***

-- Basic decompress --
int(0)
===DONE===
