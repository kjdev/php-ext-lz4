Function Add-Path {
    <#
    .SYNOPSIS
        Add a directory to PATH environment variable.
    .PARAMETER PathItem
        The directory to add to PATH.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Path to Add')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $PathItem
    )
    begin {
    }
    process {
        $currentUserPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
        $machinePath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
        $currentPath = $currentUserPath + ";" + $machinePath
        if (-not($currentPath.Split(';').Contains(($PathItem + ";")))) {
            $newUserPath = $PathItem + ";" + $currentUserPath
            [System.Environment]::SetEnvironmentVariable("PATH", $newUserPath, [System.EnvironmentVariableTarget]::User)
            $machinePath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
            $env:PATH = $newUserPath + ";" + $machinePath
        }
    }
    end {
    }
}