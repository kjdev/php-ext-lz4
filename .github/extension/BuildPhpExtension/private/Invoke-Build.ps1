Function Invoke-Build {
    <#
    .SYNOPSIS
        Build the extension
    .PARAMETER Config
        Extension Configuration
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Extension Configuration')]
        [PSCustomObject] $Config
    )
    begin {
    }
    process {
        Add-StepLog "Building $($Config.name) extension"
        try {
            Set-GAGroup start

            $builder = "php-sdk\phpsdk-starter.bat"
            $task = [System.IO.Path]::Combine($PSScriptRoot, '..\config\task.bat')

            $options = $Config.options
            if ($Config.debug_symbols) {
                $options += " --enable-debug-pack"
            }
            Set-Content -Path $task -Value (Get-Content -Path $task -Raw).Replace("OPTIONS", $options)

            $ref = $Config.ref
            if($env:ARTIFACT_NAMING_SCHEME -eq 'pecl') {
                $ref = $Config.ref.ToLower()
            }
            echo ">>> builder: $builder"
            echo ">>> -c: $Config.vs_version"
            echo ">>> -a: $Config.Arch"
            echo ">>> -s: $Config.vs_toolset"
            echo ">>> -t: $task"
            $suffix = "php_" + (@(
                $Config.name,
                $ref,
                $Config.php_version,
                $Config.ts,
                $Config.vs_version,
                $Config.arch
            ) -join "-")
            & $builder -c $Config.vs_version -a $Config.Arch -s $Config.vs_toolset -t $task | Tee-Object -FilePath "build-$suffix.txt"
            Set-GAGroup end
            if(-not(Test-Path "$((Get-Location).Path)\$($Config.build_directory)\php_$($Config.name).dll")) {
                throw "Failed to build the extension"
            }
            Add-BuildLog tick $Config.name "Extension $($Config.name) built successfully"
        } catch {
            Add-BuildLog cross $Config.name "Failed to build the extension"
            throw
        }
    }
    end {
    }
}
