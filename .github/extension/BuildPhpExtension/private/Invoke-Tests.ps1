Function Invoke-Tests {
    <#
    .SYNOPSIS
        Build the extension
    .PARAMETER Config
        Extension Configuration
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Extension Configuration')]
        [PSCustomObject] $Config
    )
    begin {
    }
    process {
        Add-StepLog "Running tests for $($Config.name) extension"
        try {
            $currentDirectory = (Get-Location).Path
            $php_dir = Join-Path $currentDirectory php-bin
            $env:TEST_PHP_EXECUTABLE = "$php_dir\php.exe"
            $env:REPORT_EXIT_STATUS = 1
            $env:XDEBUG_MODE = ""
            $env:MAGICK_CONFIGURE_PATH = "$currentDirectory\..\deps\bin"
            $env:PHP_AMQP_HOST="rabbitmq"
            $env:PHP_AMQP_SSL_HOST="rabbitmq.example.org"
            if($Config.name -eq 'pdo_oci') {
                Get-PhpSrc -PhpVersion $Config.php_version
                $env:PDO_TEST_DIR = "$currentDirectory\php-$($Config.php_version)-src\ext\pdo\tests"
                $env:PDO_OCI_TEST_DIR = "$currentDirectory\tests"
            }
            $tempOriginal = $env:TEMP
            Get-TempFiles
            $type='extension'
            if ((Select-String -Path 'config.w32' -Pattern 'ZEND_EXTENSION\(' -Quiet) -eq $true) {
                $type='zend_extension'
            }
            $extensionPath = "$currentDirectory\$($Config.build_directory)\php_$($Config.name).dll"
            $php_args = @(
                "-n",
                "-d $type=$extensionPath"
            )
            $env:TEST_PHP_ARGS = $php_args -join ' '
            if ($null -eq $env:TEST_RUNNER) {
                $env:TEST_RUNNER = 'run-tests.php'
            } elseif(-not(Test-Path $env:TEST_RUNNER)) {
                throw "Test runner $env:TEST_RUNNER does not exist."
            }
            $test_runner_args = @(
                '-q',
                '--offline',
                '--show-diff',
                '--show-slow 1000',
                '--set-timeout 120',
                '-g FAIL,XFAIL,BORK,WARN,LEAK,SKIP'
            )
            $test_workers = 8
            if($null -ne $env:TEST_WORKERS -and $env:TEST_WORKERS -ne '') {
                $test_workers = $env:TEST_WORKERS
            }
            if($Config.php_version -ge '7.4') {
                $test_runner_args += ('-j' + $test_workers)
            }

            $opcacheModes = @($env:TEST_OPCACHE_MODE)
            if($env:TEST_OPCACHE_MODE -eq 'both') {
                $opcacheModes = @('on', 'off')
            }
            $success = $True
            foreach($opcacheMode in $opcacheModes) {
                $suffix = ""
                if($env:TEST_OPCACHE_MODE -eq 'both') {
                    $suffix = " (opcache=$opcacheMode)"
                }
                Add-StepLog "Running tests for $($Config.name) extension$suffix"
                Set-GAGroup start
                $tempDirectory = Get-BuildDirectory $currentDirectory
                $env:TEMP=$tempDirectory
                $env:TMP=$tempDirectory
                $test_runner_args += '--temp-source ' + $tempDirectory;
                $test_runner_args += '--temp-target ' + $tempDirectory;
                $opcache_args = @()
                if($opcacheMode -eq 'on') {
                    $opcache_args += "-d zend_extension=$php_dir\ext\php_opcache.dll"
                    $opcache_args += "-d opcache.enable=1"
                    $opcache_args += "-d opcache.enable_cli=1"
                    $opcache_args += "-d opcache.optimization_level=1"
                } else {
                    $opcache_args += "-d opcache.enable=0"
                    $opcache_args += "-d opcache.enable_cli=0"
                    $opcache_args += "-d opcache.optimization_level=0"
                }
                $phpExpression = @(
                    'php',
                    $env:TEST_RUNNER,
                    ($test_runner_args -join ' '),
                    ($opcache_args -join ' ')
                ) -join ' '
                Write-Host "Running tests... $phpExpression"
                Write-Host "TEST_PHP_ARGS $env:TEST_PHP_ARGS"
                Write-Host "TEST_PHP_EXECUTABLE $env:TEST_PHP_EXECUTABLE"
                chcp 65001
                Invoke-Expression $phpExpression
                if ($LASTEXITCODE -ne 0) {
                    $success = $False
                }
                $env:TEMP = $tempOriginal
                $env:TMP = $tempOriginal
                Invoke-CleanupTempFiles
                Set-GAGroup end
            }
            if(-not $success) {
                throw "Failed to run tests successfully"
            }
            Add-BuildLog tick $($Config.name) "Tests run successfully"
        } catch {
            Add-BuildLog cross $($Config.name) "Failed to run tests successfully"
            throw
        }
    }
    end {
    }
}