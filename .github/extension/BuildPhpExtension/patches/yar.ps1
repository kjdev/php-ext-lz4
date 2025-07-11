(Get-Content yar_request.c) | ForEach-Object {
    $_ -replace 'if \(!BG\(mt_rand_is_seeded\)\) {',
'#if PHP_VERSION_ID < 80200
    if (!BG(mt_rand_is_seeded)) {
#else
    if (!RANDOM_G(mt19937_seeded)) {
#endif'
} | Set-Content yar_request.c
