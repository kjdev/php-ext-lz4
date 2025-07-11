function Add-BuildRequirements {
    <#
    .SYNOPSIS
        Add extension build requirements.
    .PARAMETER Extension
        Extension Name
    .PARAMETER ExtensionRef
        Extension Reference
    .PARAMETER PhpVersion
        PHP Version
    .PARAMETER Arch
        Extension Architecture
    .PARAMETER Ts
        Extension Thread Safety
    .PARAMETER VsVersion
        Visual Studio version
    .PARAMETER VsToolset
        Visual Studio toolset
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Extension Name')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $Extension,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='Extension Reference')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $ExtensionRef,
        [Parameter(Mandatory = $true, Position=2, HelpMessage='PHP Version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $PhpVersion,
        [Parameter(Mandatory = $true, Position=3, HelpMessage='Extension Architecture')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $Arch,
        [Parameter(Mandatory = $true, Position=4, HelpMessage='Extension Thread Safety')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $Ts,
        [Parameter(Mandatory = $true, Position=5, HelpMessage='Visual Studio version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $VsVersion,
        [Parameter(Mandatory = $true, Position=6, HelpMessage='Visual Studio toolset')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $VsToolset
    )
    begin {
    }
    process {
        Get-PhpSdk
        $config = Get-ExtensionConfig -Extension $Extension `
                                      -ExtensionRef $ExtensionRef `
                                      -PhpVersion $PhpVersion `
                                      -Arch $Arch `
                                      -Ts $Ts `
                                      -VsVersion $VsVersion `
                                      -VsToolset $VsToolset
        $buildDetails = Get-PhpBuildDetails -Config $Config
        $prefix = Get-PhpBuild -Config $config -BuildDetails $buildDetails
        Get-PhpDevelBuild -Config $config -BuildDetails $buildDetails
        Add-Dependencies -Config $config -Prefix $prefix
        return $config
    }
    end {
    }
}