(Get-Content php_memcached_private.h) | ForEach-Object { $_ -replace '"php_stdint.h"', '<stdint.h>' } | Set-Content php_memcached_private.h
