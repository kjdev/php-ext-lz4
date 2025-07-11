@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'BuildPhpExtension'

    # Version number of this module.
    ModuleVersion = '1.0.0.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = '4413aabc-9413-47ae-ba2b-d4656f256abe'

    # Author of this module
    Author = 'Shivam Mathur'

    # Company or vendor of this module
    CompanyName = 'PHP'

    # Copyright statement for this module
    Copyright = 'MIT LICENSE'

    # Description of the functionality provided by this module
    Description = 'Build PHP Extension'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        # Private functions
        'Add-Boost',
        'Add-BuildLog',
        'Add-BuildRequirements',
        'Add-BuildTools',
        'Add-Dependencies',
        'Add-Extension',
        'Add-ExtensionDependencies',
        'Add-Extensions',
        'Add-OciDB',
        'Add-OciSdk',
        'Add-OdbcCli',
        'Add-Package',
        'Add-Patches',
        'Add-Path',
        'Add-PhpDependencies',
        'Add-StepLog',
        'Add-Vs',
        'Get-ArgumentFromConfig',
        'Get-BuildDirectory',
        'Get-Extension',
        'Get-ExtensionConfig',
        'Get-ExtensionSource',
        'Get-LibrariesFromConfig',
        'Get-OlderVsVersion',
        'Get-PeclLibraryZip',
        'Get-PhpBuild',
        'Get-PhpBuildDetails',
        'Get-PhpDevelBuild',
        'Get-PhpSdk',
        'Get-PhpSrc',
        'Get-TempFiles',
        'Get-VsVersionHelper',
        'Get-VsVersion',
        'Invoke-Build',
        'Invoke-CleanupTempFiles',
        'Invoke-Tests',
        'Set-GAGroup',

        # Public functions
        'Invoke-PhpBuildExtension'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('php', 'build', 'extensions')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/php/php-windows-builder/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/php/php-windows-builder'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/php/php-windows-builder/master/extension/BuildPhpExtension/images/php.png'

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }

    # HelpInfoURI = ''

    # DefaultCommandPrefix = ''

}

