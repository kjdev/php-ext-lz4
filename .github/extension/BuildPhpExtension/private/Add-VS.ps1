function Add-Vs {
    <#
    .SYNOPSIS
        Add the required Visual Studio components.
    .PARAMETER VsConfig
        Visual Studio Configuration
    .PARAMETER VsVersion
        Visual Studio Version
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Visual Studio Version')]
        [ValidateNotNull()]
        [ValidateLength(1, [int]::MaxValue)]
        [string] $VsVersion,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='Visual Studio Configuration')]
        [PSCustomObject] $VsConfig
    )
    begin {
        $vsWhereUrl = 'https://github.com/microsoft/vswhere/releases/latest/download/vswhere.exe'
    }
    process {
        Add-StepLog "Adding Visual Studio components"
        try
        {
            Set-GAGroup start
            $Config = $VsConfig.vs.$VsVersion

            $installerDir = Join-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio" 'Installer'
            $vswherePath = Join-Path $installerDir 'vswhere.exe'
            if (-not (Test-Path $vswherePath)) {
                if (-not (Test-Path $installerDir)) {
                    New-Item -Path $installerDir -ItemType Directory -Force | Out-Null
                }
                Invoke-WebRequest -Uri $vsWhereUrl -OutFile $vswherePath -UseBasicParsing
            }

            $instances = & $vswherePath -products '*' -format json 2> $null | ConvertFrom-Json
            $vsInst = $instances | Select-Object -First 1

            $componentArgs = $Config.components | ForEach-Object { '--add'; $_ }

            if ($vsInst) {
                [string]$channel = $vsInst.installationVersion.Split('.')[0]
                $productId = $null
                if ($vsInst.catalog -and $vsInst.catalog.PSObject.Properties['productId']) {
                    $productId = $vsInst.catalog.productId
                } elseif ($vsInst.PSObject.Properties['productId']) {
                    $productId = $vsInst.productId
                }
                if ($productId -match '(Enterprise|Professional|Community)$' ) {
                    $exe = "vs_$($Matches[1].ToLower()).exe"
                } else {
                    $exe = 'vs_buildtools.exe'
                }

                $installerUrl = "https://aka.ms/vs/$channel/release/$exe"
                $installerPath = Join-Path $env:TEMP $exe

                Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing

                & $installerPath modify `
                    --installPath $vsInst.installationPath `
                    --quiet --wait --norestart --nocache `
                    @componentArgs 2>&1 | ForEach-Object { Write-Host $_ }
            } else {
                $channel = $VsVersion -replace '\D', ''
                $exe = 'vs_buildtools.exe'
                $installerUrl = "https://aka.ms/vs/$channel/release/$exe"
                $installerPath = Join-Path $env:TEMP $exe

                Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
                & $installerPath `
                    --quiet --wait --norestart --nocache `
                    @componentArgs 2>&1 | ForEach-Object { Write-Host $_ }
            }
            Set-GAGroup end
            Add-BuildLog tick "Visual Studio" "Visual Studio components installed successfully"
        } catch {
            Add-BuildLog cross "Visual Studio" "Failed to install Visual Studio components"
            throw
        }
    }
    end {
    }
}