(Get-Content src\memcache_pool.h) | ForEach-Object { $_ -replace 'win32/php_stdint.h', 'stdint.h' } | Set-Content src\memcache_pool.h
(Get-Content src\memcache_binary_protocol.c) | ForEach-Object { $_ -replace 'win32/php_stdint.h', 'stdint.h' } | Set-Content src\memcache_binary_protocol.c
