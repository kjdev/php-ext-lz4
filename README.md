# LZ4 Extension for PHP #

[![Build Status](https://secure.travis-ci.org/kjdev/php-ext-lz4.png?branch=master)](http://travis-ci.org/kjdev/php-ext-lz4)

This extension allows LZ4.

Documentation for LZ4 can be found at [» http://code.google.com/p/lz4/](http://code.google.com/p/lz4/).

## Build ##

    % phpize
    % ./configure
    % make
    % make install

## Configration ##

lz4.ini:

    extension=lz4.so

## Function ##

* lz4\_compress — LZ4 compression
* lz4\_uncompress — LZ4 decompression

### lz4\_compress — LZ4 compression ###

#### Description ####

string **lz4\_compress** ( string _$data_ [ , bool _$high_ = false , string _$extra_ = NULL ] )

LZ4 compression.

#### Pameters ####

* _data_

  The string to compress.

* _high_

  High Compression Mode.

* _extra_

  Prefix to compressed data.

#### Return Values ####

Returns the compressed data or FALSE if an error occurred.


### lz4\_uncompress — LZ4 decompression ###

#### Description ####

string **lz4\_uncompress** ( string _$data_ [ , long _$maxsize_ = -1 , long _$offset_ = -1 ] )

LZ4 decompression.

#### Pameters ####

* _data_

  The compressed string.

* _maxsize_

  Allocate size output data.

* _offset_

  Offset to decompressed data.

#### Return Values ####

Returns the decompressed data or FALSE if an error occurred.

## Examples ##

    $data = lz4_compress('test');

    lz4_uncompress($data);

## Compress Data ##

### Default ###

    $data = lz4_compress('test')

![compress-default](/kjdev/php-ext-lz4/raw/master/docs/compress-default.png)

### Extra prefix data ###

    $data = lz4_compress('test', false, 'PREFIX')

![compress-extra](/kjdev/php-ext-lz4/raw/master/docs/compress-extra.png)

## Uncompress Data ##

### Default ###

    lz4_uncompress($data);

![uncompress-default](/kjdev/php-ext-lz4/raw/master/docs/uncompress-default.png)

### Offset ###

    lz4_uncompress($data, 256, 6);

![uncompress-offset](/kjdev/php-ext-lz4/raw/master/docs/uncompress-offset.png)

## Related ##

* [code coverage report](http://gcov.at-ninja.jp/php-ext-lz4/)
* [api document](http://api.at-ninja.jp/php-ext-lz4/)
