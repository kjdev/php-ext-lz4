Function Add-OciSdk {
    <#
    .SYNOPSIS
        Add sdk for OCI extensions.
    .PARAMETER Config
        The directory to add to PATH.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Configuration for the extension')]
        [PSCustomObject] $Config
    )
    begin {
    }
    process {
        $suffix = if ($Config.arch -eq "x64") {"windows"} else {"nt"}
        @('sdk', 'basic') | ForEach-Object {
            $url = "https://download.oracle.com/otn_software/nt/instantclient/instantclient-$_-$suffix.zip"
            Invoke-WebRequest $url -OutFile "instantclient-$_.zip"
            Expand-Archive -Path "instantclient-$_.zip" -DestinationPath "../deps" -Force
        }
        Copy-Item ../deps/instantclient_*/sdk/* -Destination "../deps" -Recurse -Force
        New-Item -ItemType Directory -Path "../deps/bin" -Force | Out-Null
        Copy-Item ../deps/instantclient_*/* -Destination "../deps" -Recurse -Force
        Add-Path -PathItem (Join-Path (Get-Location).Path ../deps)
    }
    end {
    }
}