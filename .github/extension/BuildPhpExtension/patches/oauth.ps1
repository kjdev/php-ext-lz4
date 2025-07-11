Set-Content config.w32 -Value (Get-Content config.w32 | Where-Object { $_ -notmatch 'zlib' })
(Get-Content config.w32) | ForEach-Object { $_.Replace('CHECK_LIB("normaliz.lib", "oauth", PHP_OAUTH)', 'CHECK_LIB("normaliz.lib", "oauth", PHP_OAUTH) && CHECK_LIB("zlib.lib;zlib_a.lib", "oauth", PHP_OAUTH) && CHECK_LIB("crypt32.lib", "oauth", PHP_OAUTH)') } | Set-Content config.w32
