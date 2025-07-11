Function Add-BuildTools {
    <#
    .SYNOPSIS
        Add build tools.
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
        if($Config.build_tools.Count -ne 0) {
            Add-StepLog "Adding build tools"
        }
        $Config.build_tools | ForEach-Object {
            try {
                $tool = $_
                if($null -eq (Get-Command $_ -ErrorAction SilentlyContinue)) {
                    switch ($_)
                    {
                        nasm {
                            choco install nasm -y --force
                            Add-Path -Path "$env:ProgramFiles\NASM"
                        }
                        cmake {
                            choco install cmake --installargs 'ADD_CMAKE_TO_PATH=User' -y --force
                        }
                        cargo {
                            choco install rust -y --force
                            Add-Path -Path "$env:USERPROFILE\.cargo\bin"
                        }
                        git {
                            choco install git.install --params "'/GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf'" -y --force
                        }
                        Default {
                            $program = $_
                            $resultLines = (choco search $_ --limit-output) -split "\`r?\`n"
                            if($resultLines | Where-Object { $_ -match "^$program\|" }) {
                                choco install $_ -y --force
                            }
                        }
                    }
                } else {
                    switch ($_)
                    {
                        # Check if python is actually installed.
                        python {
                            $pythonVersion = python --version 2>&1
                            if($pythonVersion -match "not found") {
                                choco install python -y --force
                            }
                            $pythonPath = (Get-Command python).Source
                            $pythonHome = Split-Path $pythonPath
                            [Environment]::SetEnvironmentVariable("PYTHONPATH", $pythonPATH, [System.EnvironmentVariableTarget]::User)
                            $env:PYTHONPATH = $pythonPath
                            [Environment]::SetEnvironmentVariable("PYTHONHOME", $pythonHome, [System.EnvironmentVariableTarget]::User)
                            $env:PYTHONHOME = $pythonHome
                        }
                    }
                }
                Add-BuildLog tick $tool "Added"
            } catch {
                Add-BuildLog cross $tool "Failed to add $tool"
                throw
            }
        }
    }
    end {
    }
}