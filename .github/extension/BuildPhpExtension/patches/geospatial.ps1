(Get-Content config.w32) | ForEach-Object { $_ -replace 'geohash.c', 'geohash.c rdp.c'} | Set-Content config.w32
