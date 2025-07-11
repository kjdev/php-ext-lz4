Function Add-OciDB {
    <#
    .SYNOPSIS
        Add OCI DB.
    #>
    [OutputType()]
    param(
    )
    begin {
    }
    process {
        $dbUrl = 'https://download.oracle.com/otn-pub/otn_software/db-express/OracleXE213_Win64.zip'
        $dbZipFile = 'OracleXE213_Win64.zip'
        Invoke-WebRequest $dbUrl -OutFile $dbZipFile -UseBasicParsing -Verbose
        New-Item -ItemType Directory -Path C:\tools\oracle-setup -Force | Out-Null
        New-Item -ItemType Directory -Path C:\tools\oracle -Force | Out-Null
        Expand-Archive -Path $dbZipFile -DestinationPath C:\tools\oracle-setup -Force
        $rspContent = Get-Content -Path C:\tools\oracle-setup\XEInstall.rsp
        $rspContent = $rspContent -replace 'PASSWORD=.*', "PASSWORD=pass"
        $rspContent = $rspContent -replace 'INSTALLDIR=.*', "INSTALLDIR=C:\tools\oracle\"
        Set-Content -Path C:\tools\oracle-setup\XEInstall-new.rsp -Value $rspContent
        cmd.exe /c 'C:\tools\oracle-setup\setup.exe /s /v"RSP_FILE=C:\tools\oracle-setup\XEInstall-new.rsp" /v"/L*v C:\tools\oracle-setup\setup.log" /v"/qn"'
    }
    end {
    }
}