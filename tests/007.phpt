--TEST--
Test phpinfo() displays lz4 info
--SKIPIF--
<?php if (!extension_loaded('lz4')) die('skip'); ?>
--FILE--
<?php
$ref = new ReflectionExtension('lz4');
ob_start();
$ref->info();
$info = ob_get_contents();
ob_end_clean();
// skip uninteresting lines
$lines = [];
foreach(explode("\n", $info) as $line) {
    if ($line && $line !== 'lz4') {
        $lines[] = $line;
    }
}
$verNum = '(([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,2}))';

if (count($lines) >= 4) {
    echo preg_match('/^Extension\sversion\s\=\>\s'.$verNum.'$/', $lines[0]) ? "Ext version OK\n" : "Fail\n";
    $libLz4 = '(bundled|external)';
    $hasApcu = null;
    if (file_exists($configH = dirname(__DIR__) . '/config.h')) {
        $configH = file_get_contents($configH);
        $libLz4 = preg_match('/define\sHAVE_BUNDLED_LZ4\s1/', $configH) ? 'bundled' : 'external';
        $hasApcu = PHP_MAJOR_VERSION > 5 && preg_match('/define\sHAVE_APCU_SUPPORT\s1/', $configH) ? true : false;
    }
    echo preg_match('/^LZ4\slibrary\s\=\>\s'.$libLz4.'$/', $lines[1]) ? "Bundled/external LZ4 OK\n" : "Fail\n";
    echo preg_match('/^LZ4\slibrary\sversion\s\=\>\s'.$verNum.'$/', $lines[2]) ? "LZ4 version OK\n" : "Fail\n";

    if ($hasApcu === null) {
        echo "Apcu OK\n"; // just assume it is okay
    } else if ($hasApcu) {
        if (substr($lines[3], 0, 18) !== 'APCu serializer =>') {
            echo "Fail\n";
        } else {
            $fail = '';
            $value = substr($lines[3], 19);
            if (!extension_loaded('apcu')) {
                if ($value !== 'APCu extension not loaded') {
                    $fail .= 'should be not loaded ';
                }
            } else if ($value !== (ini_get('apc.serializer') === 'lz4' ? 'lz4 active' : 'lz4 inactive')) {
                $fail .= 'active/inactive mismatch ';
            }
            if (
                !isset($lines[4])
                ||
                !preg_match('/^APCu\sserializer\sinterface\sversion\s\=\>\s([0-9])/', $lines[4])
            ) {
                $fail .= 'ABI ';
            }
            echo !$fail ? "Apcu OK\n" : ("Fail: " . $fail . "");
        }
    } else {
        echo ($lines[3] == 'APCu serializer support => not built') ? "Apcu OK\n" : "Fail: not built\n";
    }
}
--EXPECTF--
Ext version OK
Bundled/external LZ4 OK
LZ4 version OK
Apcu OK
