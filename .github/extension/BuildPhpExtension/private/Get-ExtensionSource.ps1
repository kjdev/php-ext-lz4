function Get-ExtensionSource {
    <#
    .SYNOPSIS
        Get the PHP extension.
    .PARAMETER ExtensionUrl
        Extension URL
    .PARAMETER ExtensionRef
        Extension Reference
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, Position=0, HelpMessage='Extension URL')]
        $ExtensionUrl = '',
        [Parameter(Mandatory = $false, Position=1, HelpMessage='Extension Reference')]
        $ExtensionRef = ''
    )
    begin {
    }
    process {
        if($env:GITHUB_ACTIONS -eq "true") {
            if($null -eq $ExtensionUrl -or $ExtensionUrl -eq '') {
                $ExtensionUrl = "https://github.com/$env:GITHUB_REPOSITORY"
            }
            if($null -eq $ExtensionRef -or $ExtensionRef -eq '') {
                if($env:GITHUB_EVENT_NAME -contains "pull_request") {
                    $ExtensionRef = $env:GITHUB_REF
                } elseif($null -ne $env:GITHUB_REF_NAME) {
                    $ExtensionRef = $env:GITHUB_REF_NAME
                } else {
                    $ExtensionRef = $env:GITHUB_SHA
                }
            }
        }
        return [PSCustomObject]@{
            url = $ExtensionUrl;
            ref = $ExtensionRef
        }
    }
    end {
    }
}