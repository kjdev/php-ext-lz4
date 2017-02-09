--TEST--
Test lz4_uncompress() 32/64 bits consistency
--SKIPIF--
--FILE--
<?php 
if (!extension_loaded('lz4')) {
    dl('lz4.' . PHP_SHLIB_SUFFIX);
}

/**
 * For PHP 5.3 and less
 * http://php.net/manual/ru/function.hex2bin.php#113057
 */
if ( !function_exists( 'hex2bin' ) ) {
    function hex2bin( $str ) {
        $sbin = "";
        $len = strlen( $str );
        for ( $i = 0; $i < $len; $i += 2 ) {
            $sbin .= pack( "H*", substr( $str, $i, 2 ) );
        }
        return $sbin;
    }
}

include(dirname(__FILE__) . '/data.inc');

$enc32 = file_get_contents(dirname(__FILE__) . '/data32.txt');
$dec32 = lz4_uncompress(hex2bin($enc32));
var_dump($data === $dec32);

$enc64 = file_get_contents(dirname(__FILE__) . '/data64.txt');
$dec64 = lz4_uncompress(hex2bin($enc64));
var_dump($data === $dec64);
?>
===Done===
--EXPECT--
bool(true)
bool(true)
===Done===
