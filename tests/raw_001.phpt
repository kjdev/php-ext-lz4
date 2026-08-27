--TEST--
Test lz4_compress_raw() and lz4_uncompress_raw() : basic functionality
--SKIPIF--
<?php if (!extension_loaded('lz4')) die('skip lz4 extension not available'); ?>
--FILE--
<?php
echo "*** Testing lz4_compress_raw() and lz4_uncompress_raw() ***\n";

$data = "Hello, World!";
echo "Original: $data\n";

$compressed = lz4_compress_raw($data);
echo "Compressed hex: " . bin2hex($compressed) . "\n";
echo "Compressed size: " . strlen($compressed) . " bytes\n";

$decompressed = lz4_uncompress_raw($compressed, strlen($data));
echo "Decompressed: $decompressed\n";
echo "Match: " . ($decompressed === $data ? "YES" : "NO") . "\n";
?>
--EXPECT--
*** Testing lz4_compress_raw() and lz4_uncompress_raw() ***
Original: Hello, World!
Compressed hex: d048656c6c6f2c20576f726c6421
Compressed size: 14 bytes
Decompressed: Hello, World!
Match: YES
