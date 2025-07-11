Function Add-Dependencies {
    <#
    .SYNOPSIS
        Add a directory to PATH environment variable.
    .PARAMETER Config
        Configuration for the extension.
    .PARAMETER Prefix
        Extension build prefix.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Configuration for the extension')]
        [PSCustomObject] $Config,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='Extension build prefix')]
        [string] $Prefix
    )
    begin {
    }
    process {
        Add-PhpDependencies -Config $Config
        Add-ExtensionDependencies -Config $Config
        Add-Path -PathItem (Join-Path (Get-Location).Path ../deps/bin)
        Add-BuildTools -Config $Config
        Add-Extensions -Config $Config -Prefix $Prefix
    }
    end {
    }
}