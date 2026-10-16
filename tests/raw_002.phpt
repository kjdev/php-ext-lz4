--TEST--
Test lz4_compress_raw() : test vectors (Python compatibility)
--SKIPIF--
<?php if (!extension_loaded('lz4')) die('skip lz4 extension not available'); ?>
--FILE--
<?php
echo "*** Testing lz4_compress_raw() with known test vectors ***\n";

$tests = [
    ['data' => 'Hello, World!', 'hex' => 'd048656c6c6f2c20576f726c6421'],
    ['data' => 'test', 'hex' => '4074657374'],
    ['data' => str_repeat('A', 100), 'hex' => '1f4101004b504141414141'],
];

foreach ($tests as $i => $test) {
    $compressed = lz4_compress_raw($test['data']);
    $actual_hex = bin2hex($compressed);

    echo "Test " . ($i + 1) . ": ";
    if ($actual_hex === $test['hex']) {
        echo "PASS\n";
    } else {
        echo "FAIL\n";
        echo "  Expected: {$test['hex']}\n";
        echo "  Actual:   $actual_hex\n";
    }
}
?>
--EXPECT--
*** Testing lz4_compress_raw() with known test vectors ***
Test 1: PASS
Test 2: PASS
Test 3: PASS
