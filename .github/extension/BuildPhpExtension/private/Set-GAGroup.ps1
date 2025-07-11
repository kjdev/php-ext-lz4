Function Set-GAGroup {
    <#
    .SYNOPSIS
        Start or end a group in GitHub Actions.
    .PARAMETER Marker
        Start or end marker.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Start or end marker')]
        [ValidateSet('start', 'end')]
        [string] $Marker
    )
    begin {
    }
    process {
        if($env:GITHUB_ACTIONS -eq 'true') {
            if ($Marker -eq 'start') {
                $esc = [char]27
                $blue = "${esc}[34;1m"
                $reset = "${esc}[0m"
                Write-Host "::group::${blue}Logs $reset"
            } else {
                Write-Host "::endgroup::"
            }
        }
    }
    end {
    }
}