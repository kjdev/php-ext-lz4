Function Get-BuildDirectory {
    <#
    .SYNOPSIS
        Get the directory to build the extension.
    .PARAMETER ParentBuildDirectory
        Parent directory to create the build directory.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $false, Position=0, HelpMessage='Parent directory to create the build directory.')]
        [string] $ParentBuildDirectory = ""
    )
    begin {
    }
    process {
        if($ParentBuildDirectory -eq "") {
            if ($null -ne $env:BUILD_DIRECTORY -and $env:BUILD_DIRECTORY -ne "") {
                $ParentBuildDirectory = $env:BUILD_DIRECTORY
            } else {
                $ParentBuildDirectory = [System.IO.Path]::GetTempPath()
            }
        }

        $buildDirectory = [System.Guid]::NewGuid().ToString().substring(0, 8)

        $buildDirectoryPath = [System.IO.Path]::Combine($ParentBuildDirectory, $buildDirectory)

        New-Item "$buildDirectoryPath" -ItemType "directory" -Force > $null 2>&1

        return $buildDirectoryPath
    }
    end {
    }
}
