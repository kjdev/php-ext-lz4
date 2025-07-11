function Get-VsVersion {
    <#
    .SYNOPSIS
        Get the Visual Studio version.
    .PARAMETER PhpVersion
        PHP Version
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='PHP Version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $PhpVersion
    )
    begin {
        $jsonPath = [System.IO.Path]::Combine($PSScriptRoot, '..\config\vs.json')
    }
    process {
        $jsonContent = Get-Content -Path $jsonPath -Raw
        $VsConfig = ConvertFrom-Json -InputObject $jsonContent
        if($PhpVersion -eq 'master') { $majorMinor = 'master'; } else { $majorMinor = $PhpVersion.Substring(0, 3); }
        $VsVersion = $($VsConfig.php.$majorMinor)
        $selectedToolset = $null
        try {
            $selectedToolset = Get-VsVersionHelper -VsVersion $VsVersion -VsConfig $VsConfig
        } catch {
            Add-Vs -VsVersion $VsVersion -VsConfig $VsConfig
            $selectedToolset = Get-VsVersionHelper -VsVersion $VsVersion -VsConfig $VsConfig
        }
        return [PSCustomObject]@{
            vs = $VsVersion
            toolset = $selectedToolset
        }
    }
    end {
    }
}