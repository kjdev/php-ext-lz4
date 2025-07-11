function Add-Package {
    <#
    .SYNOPSIS
        Create a package for the extension.
    .PARAMETER Config
        Extension Configuration
    #>
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Extension Configuration')]
        [PSCustomObject] $Config
    )
    begin {
    }
    process {
        Add-StepLog "Packaging $($Config.name) extension"
        try {
            Set-GAGroup start
            $currentDirectory = (Get-Location).Path
            New-Item -Path $currentDirectory\artifacts -ItemType Directory -Force | Out-Null
            $docsFiles = @("LICENSE", "COPYRIGHT", "COPYING")
            $docsFiles | ForEach-Object {
                if(Test-Path -Path $_) {
                    Copy-Item -Path $_ -Destination artifacts -Force
                }
            }
            if(Test-Path ..\deps) {
                Get-ChildItem -Path ..\deps -Recurse -Filter "LICENSE*" | ForEach-Object {
                    if(Test-Path -Path $_ -PathType Leaf) {
                        Copy-Item -Path $_.FullName -Destination artifacts -Force
                    }
                }
            }
            $Config.docs | ForEach-Object {
                if($null -ne $_) {
                    $directoryPath = [System.IO.Path]::GetDirectoryName($_)
                    $targetDir = Join-Path -Path artifacts -ChildPath $directoryPath
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                    Copy-Item -Path $_ -Destination $targetDir -Force
                }
            }
            Get-ChildItem -Path $Config.build_directory -Recurse -Filter "*.dll" | ForEach-Object {
                Copy-Item -Path $_.FullName -Destination artifacts -Force
            }
            Get-ChildItem -Path "artifacts\*.dll" | ForEach-Object {
                $pdbFilePath = Join-Path -Path $Config.build_directory -ChildPath ($_.BaseName + ".pdb")
                if (Test-Path -Path $pdbFilePath) {
                    Copy-Item -Path $pdbFilePath -Destination artifacts -Force
                }
            }

            if(Test-Path ..\deps\bin) {
                $dllMap = Invoke-WebRequest -Uri "https://downloads.php.net/~windows/pecl/deps/dllmapping.json"
                Get-ChildItem -Path ..\deps\bin -Recurse -Include "*.dll" | ForEach-Object {
                    if($dllMap.content.Contains($_.Name)) {
                        if(-not(Test-Path "php-bin\$($_.Name)")) {
                            Copy-Item -Path $_.FullName -Destination artifacts -Force
                        }
                    }
                }
                Get-ChildItem -Path ..\deps\bin -Recurse -Include "*.pdb" | ForEach-Object {
                    if(Test-Path "artifacts\$($_.Name.Replace('.pdb', '.dll'))") {
                        Copy-Item -Path $_.FullName -Destination artifacts -Force
                    }
                }
                if(Test-Path (Join-Path -Path ..\deps\bin -ChildPath "*.xml")) {
                    New-Item -ItemType Directory -Path artifacts\config -Force | Out-Null
                    Get-ChildItem -Path ..\deps\bin -Recurse -Filter "*.xml" | ForEach-Object {
                        Copy-Item -Path $_.FullName -Destination artifacts\config -Force
                    }
                }
            }

            Set-Location $currentDirectory\artifacts
            if(Test-Path -Path "vc140.pdb") {
                Remove-Item -Path "vc140.pdb" -Force
            }

            # Keep only the extension DLL for ddtrace.
            if($Config.name -eq 'ddtrace') {
                Get-ChildItem -Filter "*.dll" | ForEach-Object {
                    if($_.Name -ne "php_$($Config.name).dll") {
                        Remove-Item -Path $_.FullName -Force
                    }
                }
            }

            # As per https://github.com/ThePHPF/pie-design#windows-binaries
            $arch = $Config.arch
            if(-not(Test-Path -Path "php_$($Config.name).dll")) {
                throw "Failed to build extension"
            }
            if($env:ARTIFACT_NAMING_SCHEME -eq 'pecl') {
                $artifact = "php_$($Config.package_name)-$($Config.ref.ToLower())-$($Config.php_version)-$($Config.ts)-$($Config.vs_version)-$arch"
            } else {
                if($arch -eq 'x64') {
                    $arch = 'x86_64'
                }
                $artifact = "php_$($Config.package_name)-$($Config.ref)-$($Config.php_version)-$($Config.ts)-$($Config.vs_version)-$arch"
                @("php_$($Config.name).dll", "php_$($Config.name).pdb") | ForEach-Object {
                    $extension = $_.Split('.')[1]
                    if(Test-Path -Path $_) {
                        Move-Item -Path $_ -Destination "$artifact.$extension" -Force
                    }
                }
            }
            Add-Content "artifact=$artifact.zip" -Path $env:GITHUB_OUTPUT -Encoding utf8

            7z a -sdel "$artifact.zip" *

            Set-Location $currentDirectory
            New-Item -Path $currentDirectory\artifacts\logs -ItemType Directory -Force | Out-Null
            Copy-Item -Path build-*.txt -Destination artifacts\logs\ -Force
            Set-Location $currentDirectory\artifacts\logs
            7z a -sdel "$artifact.zip" *
            Set-GAGroup end
            Add-BuildLog tick "Packaging" "Extension $($Config.name) packaged successfully"
        } catch {
            Add-BuildLog cross "Packaging" "Failed to package $($Config.name) extension"
            throw
        }
    }
    end {
    }
}
