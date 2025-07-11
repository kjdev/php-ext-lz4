function Add-BuildLog
{
    <#
    .SYNOPSIS
        Add a message to the build log.
    .PARAMETER Mark
        Mark as success or failure
    .PARAMETER Subject
        Subject of the message
    .PARAMETER Message
        Message to add to the build log
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Mark as success or failure')]
        [string] $Mark,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Subject of the message')]
        [string] $Subject,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = 'Message to add to the build log')]
        [string] $Message
    )
    begin {
        $tick = ([char]8730)
        $cross = ([char]10007)
    }
    process {
        if($Mark -eq 'tick') {
            $colorCode = 32; $MarkValue = $tick
        } else {
            $colorCode = 31; $MarkValue = $cross
        }
        $esc = [char]27
        $blue = "${esc}[34;1m"
        $grey = "${esc}[90;1m"
        $reset = "${esc}[0m"
        "$MarkValue $Subject $Message" | Out-File build.log -Append -Encoding UTF8
        Write-Host "${esc}[$colorCode;1m$MarkValue$reset $blue$Subject$reset $grey$Message$reset"
    }
    end {
    }
}