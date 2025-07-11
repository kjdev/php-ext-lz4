Function Add-OdbcCli {
    <#
    .SYNOPSIS
        Add sdk for DB2 extension.
    .PARAMETER Config
        Configuration for the extension.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Configuration for the extension')]
        [PSCustomObject] $Config
    )
    begin {
    }
    process {
        $prefix = if ($Config.arch -eq "x64") {"ntx64"} else {"nt32"}
        $url = "https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/${prefix}_odbc_cli.zip"
        Invoke-WebRequest $url -OutFile "odbc_cli.zip"
        Expand-Archive -Path "odbc_cli.zip" -DestinationPath "../deps"
        Copy-Item ../deps/clidriver/* -Destination "../deps" -Recurse -Force
    }
    end {
    }
}