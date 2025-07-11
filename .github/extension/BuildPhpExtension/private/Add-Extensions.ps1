Function Add-Extensions {
    <#
    .SYNOPSIS
        Add PHP extensions.
    .PARAMETER Config
        Configuration for the extension.
    .PARAMETER Prefix
        Prefix for the builds.
    #>
    [OutputType()]
    param(
        [Parameter(Mandatory = $true, Position=0, HelpMessage='Configuration for the extension')]
        [PSCustomObject] $Config,
        [Parameter(Mandatory = $true, Position=1, HelpMessage='Extension build prefix')]
        [string] $Prefix
    )
    begin {
    }
    process {
        if($config.extensions.Count -ne 0) {
            Add-StepLog "Adding extensions"
        }
        $config.extensions | ForEach-Object {
            $extension = $_
            try {
                Add-Extension -Extension $extension -Config $Config -Prefix $Prefix
                Add-BuildLog tick $extension "Added"
            } catch {
                Add-BuildLog cross $extension "Failed to add $extension"
                throw
            }
        }
    }
    end {
    }
}