Function Get-LibrariesFromConfig {
    <#
    .SYNOPSIS
        Get the Libraries from the config.w32 file
    .PARAMETER Extension
        Extension
    .PARAMETER VsVersion
        Visual Studio Version
    .PARAMETER Arch
        Architecture
    .PARAMETER ConfigW32Content
        config.w32 content
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Extension')]
        [string] $Extension,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='Visual Studio Version')]
        [string] $VsVersion,
        [Parameter(Mandatory = $true, Position=2, HelpMessage='Architecture')]
        [string] $Arch,
        [Parameter(Mandatory = $true, Position=3, HelpMessage='config.w32 content')]
        [string] $ConfigW32Content
    )
    begin {
        $jsonPath = [System.IO.Path]::Combine($PSScriptRoot, '..\config\vs.json')
    }
    process {
        $jsonData = (
        Invoke-WebRequest -Uri "https://downloads.php.net/~windows/pecl/deps/libmapping.json"
        ).Content | ConvertFrom-Json

        $phpSeries = (Invoke-WebRequest -Uri "https://downloads.php.net/~windows/php-sdk/deps/$VsVersion/$Arch").Content.ToLower()

        Function Find-Library {
            param (
                [Parameter(Mandatory=$true, Position=0)]
                [string]$MatchString,
                [Parameter(Mandatory=$true, Position=1)]
                [string[]]$VsVersions
            )
            foreach ($vsVersion in $VsVersions) {
                foreach ($vsVersionData in $JsonData.PSObject.Properties) {
                    if($vsVersionData.Name -eq $VsVersion) {
                        foreach ($archData in $vsVersionData.Value.PSObject.Properties) {
                            if($archData.Name -eq $Arch) {
                                foreach ($libs in $archData.Value.PSObject.Properties) {
                                    if ($libs.Value -match ($MatchString.Replace('*', '.*'))) {
                                        $libs.Name -Match '^(.+?)-\d' | Out-Null
                                        if(!$phpSeries.contains($matches[1].ToLower())) {
                                            $libs.Name -Match '^(.+?-\d)' | Out-Null
                                        }
                                        return $matches[1]
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return $null
        }

        $jsonContent = Get-Content -Path $jsonPath -Raw
        $VsConfig = ConvertFrom-Json -InputObject $jsonContent
        $VsVersions = @($VsVersion)
        $VsVersions += $($VsConfig.vs | Get-Member -MemberType *Property).Name | Where-Object {
            # vs15 and above builds are compatible.
            ($_ -lt $VsVersion -and $_ -ge "vc15")
        }

        $foundItems = @()
        $libraryFilesFound = @()
        [regex]::Matches($ConfigW32Content, 'CHECK_LIB\(["'']([^"'']+)["'']|["'']([^"'']+\.lib)["'']|(\w+\.lib)') | ForEach-Object {
            $_.Groups[1].Value.Split(';') + ($_.Groups[2].Value -Split '[^\w\.]') + ($_.Groups[3].Value -Split '[^\w\.]') | ForEach-Object {
                $libraryFilesFound += $_
            }
        }
        $libraryFilesFound | Select-Object -Unique | ForEach-Object {
            if($_) {
                switch ($_) {
                    libeay32.lib { $library = "openssl" }
                    ssleay32.lib { $library = "openssl" }
                    Default { $library = Find-Library $_ $VsVersions }
                }
                if($library -and (-not($foundItems.Contains($library)))) {
                    $foundItems += $library.ToLower()
                }
            }
        }

        # Exceptions
        # Remove libsasl if the extension is mongodb
        if($Extension -eq "mongodb") {
            $foundItems = $foundItems | Where-Object {$_ -notmatch "libsasl.*"}
        }
        # Add zlib if the extension is memcached
        if($Extension -eq "memcached") {
            $foundItems += "zlib"
        }

        $highestVersions = @{}

        foreach ($item in $foundItems) {
            if ($item -match '^(.*?)-(\d+)$') {
                $libraryName, $version = $matches[1], $matches[2]
                if (-not $highestVersions.ContainsKey($libraryName) -or $highestVersions[$libraryName] -lt $version) {
                    $highestVersions[$libraryName] = $version
                }
            } else {
                $highestVersions[$item] = -1
            }
        }

        $finalItems = @()
        foreach ($library in $highestVersions.Keys) {
            if ($highestVersions[$library] -eq -1) {
                $finalItems += $library
            } else {
                $finalItems += "$library-" + $highestVersions[$library]
            }
        }

        return $finalItems
    }
    end {
    }
}