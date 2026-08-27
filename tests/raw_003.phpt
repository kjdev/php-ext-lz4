--TEST--
Test lz4_uncompress_raw() : error handling
--SKIPIF--
<?php if (!extension_loaded('lz4')) die('skip lz4 extension not available'); ?>
--FILE--
<?php
echo "*** Testing lz4_uncompress_raw() error handling ***\n";

// Zero max_size
error_reporting(E_ALL);
$result = lz4_uncompress_raw("test", 0);
echo "Zero max_size: " . ($result === false ? "REJECTED" : "ACCEPTED") . "\n";

// Negative max_size
$result = lz4_uncompress_raw("test", -1);
echo "Negative max_size: " . ($result === false ? "REJECTED" : "ACCEPTED") . "\n";

// Corrupted data
$result = lz4_uncompress_raw("corrupted_lz4_data", 100);
echo "Corrupted data: " . ($result === false ? "REJECTED" : "ACCEPTED") . "\n";

// Wrong max_size (too small)
$compressed = lz4_compress_raw("Hello, World!");
$result = lz4_uncompress_raw($compressed, 5);  // Should be 13
echo "Wrong max_size: " . ($result === false ? "REJECTED" : "ACCEPTED") . "\n";

echo "Done\n";
?>
--EXPECTF--
*** Testing lz4_uncompress_raw() error handling ***

Warning: lz4_uncompress_raw : max_size parameter is required and must be positive in %s on line %d
Zero max_size: REJECTED

Warning: lz4_uncompress_raw : max_size parameter is required and must be positive in %s on line %d
Negative max_size: REJECTED

Warning: lz4_uncompress_raw : decompression failed (corrupted data or wrong max_size) in %s on line %d
Corrupted data: REJECTED

Warning: lz4_uncompress_raw : decompression failed (corrupted data or wrong max_size) in %s on line %d
Wrong max_size: REJECTED
Done
