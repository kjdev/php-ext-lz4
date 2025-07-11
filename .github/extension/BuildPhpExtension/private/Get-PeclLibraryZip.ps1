function Get-PeclLibraryZip {
    <#
    .SYNOPSIS
        Get the Visual Studio version.
    .PARAMETER Library
        Library Name
    .PARAMETER PhpVersion
        PHP Version
    .PARAMETER VsVersion
        Visual Studio version
    .PARAMETER Arch
        Architecture
    .PARAMETER ExtensionSeries
        Extension Series
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='PHP Version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $Library,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='PHP Version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $PhpVersion,
        [Parameter(Mandatory = $true, Position=2, HelpMessage='Visual Studio version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $VsVersion,
        [Parameter(Mandatory = $true, Position=3, HelpMessage='Architecture')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $Arch,
        [Parameter(Mandatory = $true, Position=4, HelpMessage='Extension Series')]
        [ValidateNotNull()]
        [PSCustomObject] $ExtensionSeries
    )
    begin {
    }
    process {
        $olderVs = Get-OlderVsVersion -PhpVersion $PhpVersion
        foreach($vs in ((@($olderVs) + @($VsVersion)) | Sort-Object -Descending)) {
            $lib_name, $lib_version = ($Library -split '-')[0, 1]
            $key = $lib_name.toLower() + "-?([0-9].*)-$vs-$Arch\.zip"
            $options = @()
            $ExtensionSeries.Links | ForEach-Object {
                if($_.HREF.toLower() -match $key) {
                    $link_matches = $matches
                    if($null -eq $lib_version -or $matches[1] -match ('^' + $lib_version + '.*'))
                    {
                        if($link_matches[1].Contains('.')) { $suffix="" } else { $suffix=".0" }
                        $versionParts = $link_matches[1] -split '-'
                        if($null -ne $versionParts[1] -and $versionParts[1].Contains('.')) {
                            $versionParts[0] = $versionParts[0] + $versionParts[1].Replace('.', '')
                        }
                        $options += @{
                            name = ($_.HREF -split ('/') | Select-Object -Last 1)
                            version = ($versionParts[0] + $suffix)
                        }
                    }
                }
            }
            if($options.Count -gt 0) {
                $latest = $options | Sort-Object -Property { [version] $_.version } -Descending | Select-Object -First 1
                return $latest.name
            }
        }
    }
    end {
    }
}