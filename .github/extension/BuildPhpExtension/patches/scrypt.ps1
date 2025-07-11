$file = @(
    "crypto/params.c",
    "crypto/sha256.c",
    "crypto/sha256.h",
    "crypto/sysendian.h",
    "crypto/crypto_scrypt-nosse.c",
    "crypto/crypto_scrypt.h",
    "php_scrypt_utils.h"
)
foreach ($f in $file) {
    (Get-Content $f) | ForEach-Object { $_ -replace '"win32/php_stdint.h"', '<stdint.h>' } | Set-Content $f
}
