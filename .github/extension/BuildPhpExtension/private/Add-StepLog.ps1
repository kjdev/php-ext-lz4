function Add-StepLog
{
    <#
    .SYNOPSIS
        Add a message to the build log.
    .PARAMETER Message
        Message to add to the build log
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Message to add to the step log')]
        [string] $Message
    )
    begin {
    }
    process {
        $esc = [char]27
        $grey = "${esc}[90;1m"
        $white = "${esc}[37;1m"
        $reset = "${esc}[0m"
        "$Message" | Out-File -FilePath build.log -Append -Encoding UTF8
        Write-Host "`n$grey==> $reset$white$Message$reset"
    }
    end {
    }
}