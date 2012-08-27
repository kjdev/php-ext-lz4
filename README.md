# LZ4 Extension for PHP #

This extension allows LZ4.

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

string **lz4\_compress** ( string _$data_ [ , bool _$high_ = false ] )

LZ4 compression.

#### Pameters ####

* _data_

  The string to compress.

* _high_

  High Compression Mode.

#### Return Values ####

Returns the compressed data or FALSE if an error occurred.


### lz4\_uncompress — LZ4 decompression ###

#### Description ####

string **lz4\_uncompress** ( string _$data_ [ , long _$maxsize_ ] )

LZ4 decompression.

#### Pameters ####

* _data_

  The compressed string.

* _maxsize_

  Allocate size output data.

#### Return Values ####

Returns the decompressed data or FALSE if an error occurred.

## Examples ##

    $data = lz4_compress('test');

    lz4_uncompress($data);
