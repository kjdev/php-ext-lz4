--TEST--
Test phpinfo() displays lz4 info
--SKIPIF--
--FILE--
<?php
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

phpinfo();
--EXPECTF--
%a
lz4

LZ4 support => enabled
Extension Version => %d.%d.%d
%a
