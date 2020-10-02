$ErrorActionPreference = "Stop"

Set-Location C:\projects\lz4

$env:TEST_PHP_EXECUTABLE = "$env:PHP_PATH\php.exe"
& $env:TEST_PHP_EXECUTABLE -v

$env:TEST_PHP_EXECUTABLE = "$env:PHP_PATH\php.exe"
& $env:TEST_PHP_EXECUTABLE -m

$env:TEST_PHP_EXECUTABLE = "$env:PHP_PATH\php.exe"
& $env:TEST_PHP_EXECUTABLE 'run-tests.php' --show-diff tests
if (-not $?) {
    throw "testing failed with errorlevel $LastExitCode"
}
