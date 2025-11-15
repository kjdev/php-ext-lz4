--TEST--
Test lz4_compress_raw() : compression levels
--SKIPIF--
<?php if (!extension_loaded('lz4')) die('skip lz4 extension not available'); ?>
--FILE--
<?php
echo "*** Testing lz4_compress_raw() with different compression levels ***\n";

$data = str_repeat("Lorem ipsum dolor sit amet. ", 50);

// Level 0 (default)
$comp_0 = lz4_compress_raw($data, 0);
echo "Level 0 (default): " . strlen($comp_0) . " bytes\n";

// Level 1 (HC mode)
$comp_1 = lz4_compress_raw($data, 1);
echo "Level 1 (HC): " . strlen($comp_1) . " bytes\n";

// Level 9 (max)
$comp_9 = lz4_compress_raw($data, 9);
echo "Level 9 (HC max): " . strlen($comp_9) . " bytes\n";

// All should decompress correctly
$decomp_0 = lz4_uncompress_raw($comp_0, strlen($data));
$decomp_1 = lz4_uncompress_raw($comp_1, strlen($data));
$decomp_9 = lz4_uncompress_raw($comp_9, strlen($data));

echo "Level 0 roundtrip: " . ($decomp_0 === $data ? "PASS" : "FAIL") . "\n";
echo "Level 1 roundtrip: " . ($decomp_1 === $data ? "PASS" : "FAIL") . "\n";
echo "Level 9 roundtrip: " . ($decomp_9 === $data ? "PASS" : "FAIL") . "\n";

// Invalid level
$result = lz4_compress_raw($data, 999);
echo "Invalid level 999: " . ($result === false ? "REJECTED" : "ACCEPTED") . "\n";
?>
--EXPECTF--
*** Testing lz4_compress_raw() with different compression levels ***
Level 0 (default): %d bytes
Level 1 (HC): %d bytes
Level 9 (HC max): %d bytes
Level 0 roundtrip: PASS
Level 1 roundtrip: PASS
Level 9 roundtrip: PASS

Warning: lz4_compress_raw: compression level (999) must be within 1..%d in %s on line %d
Invalid level 999: REJECTED
