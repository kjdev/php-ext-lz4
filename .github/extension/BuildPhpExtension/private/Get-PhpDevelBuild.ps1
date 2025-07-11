function Get-PhpDevelBuild {
    <#
    .SYNOPSIS
        Get the PHP build.
    .PARAMETER Config
        Extension Configuration
    .PARAMETER BuildDetails
        PHP Build Details
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Configuration for the extension')]
        [PSCustomObject] $Config,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='Php Build Details')]
        [PSCustomObject] $BuildDetails
    )
    begin {
    }
    process {
        try {
            Add-StepLog "Adding developer build for PHP $($Config.php_version)"
            Add-Type -Assembly "System.IO.Compression.Filesystem"
            $phpSemver, $baseUrl, $fallbackBaseUrl = $BuildDetails.phpSemver, $BuildDetails.baseUrl, $BuildDetails.fallbackBaseUrl
            $tsPart = if ($Config.ts -eq "nts") {"nts-Win32"} else {"Win32"}
            $binZipFile = "php-devel-pack-$phpSemver-$tsPart-$($Config.vs_version)-$($Config.arch).zip"
            $binUrl = "$baseUrl/$binZipFile"
            $fallBackUrl = "$fallbackBaseUrl/$binZipFile"

            if($Config.php_version -lt '7.4') {
                $fallBackUrl = $fallBackUrl.replace("vc", "VC")
            }

            try {
                Invoke-WebRequest $binUrl -OutFile $binZipFile
            } catch {
                try {
                    Invoke-WebRequest $fallBackUrl -OutFile $binZipFile
                } catch {
                    throw "Failed to download the build for PHP version $($Config.php_version)."
                }
            }

            $currentDirectory = (Get-Location).Path
            $binZipFilePath = Join-Path $currentDirectory $binZipFile
            $binDirectoryPath = Join-Path $currentDirectory php-dev

            [System.IO.Compression.ZipFile]::ExtractToDirectory($binZipFilePath, $binDirectoryPath)
            Move-Item $binDirectoryPath/php-*/* $binDirectoryPath/
            Add-Path -PathItem $binDirectoryPath
            Add-BuildLog tick PHP "PHP developer build added successfully"
            return $binDirectoryPath
        } catch {
            Add-BuildLog cross PHP "Failed to download the PHP developer build"
            throw
        }
    }
    end {
    }
}