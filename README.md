# LZ4 Extension for PHP

[![Linux](https://github.com/kjdev/php-ext-lz4/actions/workflows/linux.yaml/badge.svg?branch=master)](https://github.com/kjdev/php-ext-lz4/actions/workflows/linux.yaml)
[![Windows](https://github.com/kjdev/php-ext-lz4/actions/workflows/windows.yaml/badge.svg?branch=master)](https://github.com/kjdev/php-ext-lz4/actions/workflows/windows.yaml)

This extension allows LZ4.

Documentation for LZ4 can be found at
[» https://github.com/Cyan4973/lz4](https://github.com/Cyan4973/lz4).

## Build from sources

    % git clone --recursive --depth=1 https://github.com/kjdev/php-ext-lz4.git
    % cd php-ext-lz4
    % phpize
    % ./configure
    % make
    % make install

To use the system library

``` bash
% ./configure --with-lz4-includedir=/usr
```

## Distribution binary packages

### Fedora / CentOS / RHEL

RPM packages of this extension are available in [» Remi's RPM repository](https://rpms.remirepo.net/) and are named **php-lz4**.

### Debian

DEB packages of this extension are available in [» Ondřej Surý's DEB repository](https://deb.sury.org/) and are named **php-lz4**.

## Installation via PIE

```bash
pie install kjdev/lz4
```


## Configuration

php.ini:

    extension=lz4.so

## Function

* lz4\_compress — LZ4 compression (block format)
* lz4\_uncompress — LZ4 decompression (block format)
* lz4\_compress\_frame — LZ4 compression (frame format)
* lz4\_uncompress\_frame — LZ4 decompression (frame format)

### lz4\_compress — LZ4 compression

#### Description

string **lz4\_compress** ( string _$data_ [ , int _$level_ = 0 , string _$extra_ = NULL ] )

LZ4 compression.

#### Parameters

* _data_

  The string to compress.

* _level_

  The level of compression (1-12, Recommended values are between 4 and 9).
  (Default to 0, Not High Compression Mode.)

* _extra_

  Prefix to compressed data.

#### Return Values

Returns the compressed data or FALSE if an error occurred.


### lz4\_uncompress — LZ4 decompression

#### Description

string **lz4\_uncompress** ( string _$data_ [ , long _$maxsize_ = -1 , long _$offset_ = -1 ] )

LZ4 decompression.

#### Parameters

* _data_

  The compressed string.

* _maxsize_

  Allocate size output data.

* _offset_

  Offset to decompressed data.

#### Return Values

Returns the decompressed data or FALSE if an error occurred.


### lz4\_compress\_frame — LZ4 compression (frame format)

#### Description

string **lz4\_compress\_frame** ( string _$data_ [ , int _$level_ = 0 , int _$max_block_size_ = 0 , int _$checksums_ = 0 ] )

LZ4 compression to frame.

#### Parameters

* _data_

  The string to compress.

* _level_

  The level of compression (1-12, Recommended values are between 4 and 9).
  (Default to 0, Not High Compression Mode.)

* _max\_block\_size_

  Maximum uncompressed size of each block.
  Pass any of the following values:

  * _LZ4\_BLOCK\_SIZE\_64KB_
  * _LZ4\_BLOCK\_SIZE\_256KB_
  * _LZ4\_BLOCK\_SIZE\_1MB_
  * _LZ4\_BLOCK\_SIZE\_4MB_
  
  Any other value will be treated as _LZ4\_BLOCK\_SIZE\_64KB_.

* _checksums_

  Enable/disable frame-level and block-level checksums.
  Pass a bitwise combination of the following constants:

  * _LZ4\_CHECKSUM\_FRAME_: frame-level checksum
  * _LZ4\_CHECKSUM\_BLOCK_: block-level checksum

#### Return Values

Returns the compressed data or FALSE if an error occurred.


### lz4\_uncompress\_frame — LZ4 decompression (frame format)

#### Description

string **lz4\_uncompress\_frame** ( string _$data_ )

LZ4 decompression from frame.

#### Parameters

* _data_

  The compressed string.

#### Return Values

Returns the decompressed data or FALSE if an error occurred.


## Examples

    $data = lz4_compress('test');

    lz4_uncompress($data);

## Compress Data

### Default

    $data = lz4_compress('test')

![compress-default](docs/compress-default.png)

### Extra prefix data

    $data = lz4_compress('test', false, 'PREFIX')

![compress-extra](docs/compress-extra.png)

## Uncompress Data

### Default

    lz4_uncompress($data);

![uncompress-default](docs/uncompress-default.png)

### Offset

    lz4_uncompress($data, 256, 6);

![uncompress-offset](docs/uncompress-offset.png)
