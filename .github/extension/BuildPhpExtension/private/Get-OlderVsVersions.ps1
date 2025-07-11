function Get-OlderVsVersion {
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
        $majorMinor = $PhpVersion.Substring(0, 3)
        $vsList = ($VsConfig.vs | Get-Member -MemberType *Property).Name
        return $vsList | Where-Object {
            # vs15 and above builds are compatible.
            ($_ -lt $($VsConfig.php.$majorMinor) -and $_ -ge "vc15")
        }
    }
    end {
    }
}