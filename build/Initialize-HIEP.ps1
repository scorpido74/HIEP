#Requires -Version 7.4

param(
    [string]$RepositoryRoot,
    [string]$ConfigurationPath,
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'


# ============================================================================
# Logging
# ============================================================================

function Write-HIEPLog {

    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [ValidateSet('INFO', 'SUCCESS', 'WARNING', 'ERROR')]
        [string]$Level = 'INFO'
    )

    $Color = switch ($Level) {
        'INFO'    { 'Cyan' }
        'SUCCESS' { 'Green' }
        'WARNING' { 'Yellow' }
        'ERROR'   { 'Red' }
    }

    Write-Host "[$Level] $Message" -ForegroundColor $Color
}


# ============================================================================
# Banner
# ============================================================================

function Show-HIEPBanner {

    Write-Host ''
    Write-Host '=========================================================' -ForegroundColor DarkCyan
    Write-Host ' Healthcare Identity Eco Platform' -ForegroundColor Cyan
    Write-Host ' Repository Bootstrap' -ForegroundColor Cyan
    Write-Host '=========================================================' -ForegroundColor DarkCyan
    Write-Host ''
}


# ============================================================================
# Repository
# ============================================================================

function Get-HIEPRepositoryRoot {

    param(
        [Parameter()]
        [string]$Path
    )

    if (-not [string]::IsNullOrWhiteSpace($Path)) {

        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            throw "Repository root does not exist: $Path"
        }

        return (Resolve-Path -LiteralPath $Path).Path
    }

    #
    # Script location:
    #
    # <repository>\build\Initialize-HIEP.ps1
    #

    $Root = Split-Path -Path $PSScriptRoot -Parent

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        throw 'Unable to determine repository root.'
    }

    return (Resolve-Path -LiteralPath $Root).Path
}


# ============================================================================
# Configuration
# ============================================================================

function Get-HIEPConfiguration {

    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Configuration file not found: $Path"
    }

    Write-HIEPLog "Loading configuration: $Path"

    try {

        $Json = Get-Content `
            -LiteralPath $Path `
            -Raw `
            -Encoding UTF8

        if ([string]::IsNullOrWhiteSpace($Json)) {
            throw 'Configuration file is empty.'
        }

        return $Json | ConvertFrom-Json
    }
    catch {
        throw "Unable to read HIEP.json: $($_.Exception.Message)"
    }
}


function Test-HIEPConfiguration {

    param(
        [Parameter(Mandatory)]
        [object]$Configuration
    )

    Write-HIEPLog 'Validating configuration...'

    if ($null -eq $Configuration.repository) {
        throw 'Missing configuration section: repository'
    }

    if ($null -eq $Configuration.filesystem) {
        throw 'Missing configuration section: filesystem'
    }

    if ([string]::IsNullOrWhiteSpace(
        [string]$Configuration.repository.name
    )) {
        throw 'Missing configuration value: repository.name'
    }

    if ([string]::IsNullOrWhiteSpace(
        [string]$Configuration.repository.title
    )) {
        throw 'Missing configuration value: repository.title'
    }

    if ([string]::IsNullOrWhiteSpace(
        [string]$Configuration.repository.version
    )) {
        throw 'Missing configuration value: repository.version'
    }

    if ($null -eq $Configuration.filesystem.folders) {
        throw 'Missing configuration value: filesystem.folders'
    }

    if ($null -eq $Configuration.filesystem.files) {
        throw 'Missing configuration value: filesystem.files'
    }

    Write-HIEPLog 'Configuration valid.' SUCCESS
}


# ============================================================================
# Path handling
# ============================================================================

function Get-HIEPFullPath {

    param(
        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory)]
        [string]$RelativePath
    )

    if ([string]::IsNullOrWhiteSpace($RelativePath)) {
        throw 'Configured path cannot be empty.'
    }

    if ([System.IO.Path]::IsPathRooted($RelativePath)) {
        throw "Absolute paths are not allowed: $RelativePath"
    }

    #
    # Convert slash direction where necessary.
    #

    $NormalizedPath = $RelativePath.Replace(
        '/',
        [System.IO.Path]::DirectorySeparatorChar
    )

    $NormalizedPath = $NormalizedPath.Replace(
        '\',
        [System.IO.Path]::DirectorySeparatorChar
    )

    $RootPath = [System.IO.Path]::GetFullPath(
        $RepositoryRoot
    )

    $FullPath = [System.IO.Path]::GetFullPath(
        (Join-Path -Path $RootPath -ChildPath $NormalizedPath)
    )

    #
    # Prevent paths such as:
    #
    # ../../somewhere
    #

    $CalculatedRelativePath = [System.IO.Path]::GetRelativePath(
        $RootPath,
        $FullPath
    )

    if (
        $CalculatedRelativePath -eq '..' -or
        $CalculatedRelativePath.StartsWith(
            "..$([System.IO.Path]::DirectorySeparatorChar)"
        )
    ) {
        throw "Path escapes repository root: $RelativePath"
    }

    return $FullPath
}


# ============================================================================
# Directory creation
# ============================================================================

function New-HIEPDirectory {

    param(
        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory)]
        [string]$RelativePath,

        [Parameter()]
        [bool]$WhatIfMode = $false
    )

    $FullPath = Get-HIEPFullPath `
        -RepositoryRoot $RepositoryRoot `
        -RelativePath $RelativePath

    #
    # Existing directory.
    #

    if (Test-Path -LiteralPath $FullPath -PathType Container) {

        Write-Verbose "Folder exists: $RelativePath"

        return 'Existing'
    }

    #
    # Path exists but is not a directory.
    #

    if (Test-Path -LiteralPath $FullPath) {
        throw "Expected folder but another filesystem object exists: $RelativePath"
    }

    #
    # Simulation.
    #

    if ($WhatIfMode) {

        Write-Host "What if: create folder '$RelativePath'"

        return 'Planned'
    }

    #
    # Create.
    #

    New-Item `
        -ItemType Directory `
        -Path $FullPath `
        -Force |
        Out-Null

    Write-HIEPLog "Created folder : $RelativePath" SUCCESS

    return 'Created'
}


# ============================================================================
# File creation
# ============================================================================

function New-HIEPFile {

    param(
        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory)]
        [string]$RelativePath,

        [Parameter()]
        [bool]$WhatIfMode = $false
    )

    $FullPath = Get-HIEPFullPath `
        -RepositoryRoot $RepositoryRoot `
        -RelativePath $RelativePath

    #
    # Existing file.
    #
    # Never overwrite existing files.
    #

    if (Test-Path -LiteralPath $FullPath -PathType Leaf) {

        Write-Verbose "File exists: $RelativePath"

        return 'Existing'
    }

    #
    # Path exists but is not a file.
    #

    if (Test-Path -LiteralPath $FullPath) {
        throw "Expected file but another filesystem object exists: $RelativePath"
    }

    #
    # Simulation.
    #

    if ($WhatIfMode) {

        Write-Host "What if: create file '$RelativePath'"

        return 'Planned'
    }

    #
    # Make sure the parent folder exists.
    #

    $Parent = Split-Path `
        -Path $FullPath `
        -Parent

    if (-not (Test-Path -LiteralPath $Parent -PathType Container)) {

        New-Item `
            -ItemType Directory `
            -Path $Parent `
            -Force |
            Out-Null
    }

    #
    # Create empty file.
    #

    New-Item `
        -ItemType File `
        -Path $FullPath |
        Out-Null

    Write-HIEPLog "Created file   : $RelativePath" SUCCESS

    return 'Created'
}


# ============================================================================
# Filesystem bootstrap
# ============================================================================

function Initialize-HIEPFileSystem {

    param(
        [Parameter(Mandatory)]
        [object]$Configuration,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter()]
        [bool]$WhatIfMode = $false
    )

    $Statistics = [ordered]@{
        FoldersCreated  = 0
        FoldersExisting = 0
        FoldersPlanned  = 0

        FilesCreated    = 0
        FilesExisting   = 0
        FilesPlanned    = 0
    }

    #
    # Folders
    #

    Write-HIEPLog 'Processing folders...'

    foreach ($Folder in $Configuration.filesystem.folders) {

        $Path = [string]$Folder

        if ([string]::IsNullOrWhiteSpace($Path)) {
            continue
        }

        $Status = New-HIEPDirectory `
            -RepositoryRoot $RepositoryRoot `
            -RelativePath $Path `
            -WhatIfMode $WhatIfMode

        switch ($Status) {

            'Created' {
                $Statistics.FoldersCreated++
            }

            'Existing' {
                $Statistics.FoldersExisting++
            }

            'Planned' {
                $Statistics.FoldersPlanned++
            }
        }
    }

    #
    # Files
    #

    Write-HIEPLog 'Processing files...'

    foreach ($File in $Configuration.filesystem.files) {

        $Path = [string]$File

        if ([string]::IsNullOrWhiteSpace($Path)) {
            continue
        }

        $Status = New-HIEPFile `
            -RepositoryRoot $RepositoryRoot `
            -RelativePath $Path `
            -WhatIfMode $WhatIfMode

        switch ($Status) {

            'Created' {
                $Statistics.FilesCreated++
            }

            'Existing' {
                $Statistics.FilesExisting++
            }

            'Planned' {
                $Statistics.FilesPlanned++
            }
        }
    }

    return [PSCustomObject]$Statistics
}


# ============================================================================
# Summary
# ============================================================================

function Show-HIEPSummary {

    param(
        [Parameter(Mandatory)]
        [object]$Configuration,

        [Parameter(Mandatory)]
        [object]$Statistics,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter()]
        [bool]$WhatIfMode = $false
    )

    Write-Host ''
    Write-Host '=========================================================' `
        -ForegroundColor DarkGreen

    if ($WhatIfMode) {

        Write-Host ' Bootstrap simulation completed.' `
            -ForegroundColor Yellow
    }
    else {

        Write-Host ' Bootstrap completed successfully.' `
            -ForegroundColor Green
    }

    Write-Host '=========================================================' `
        -ForegroundColor DarkGreen

    Write-Host ''

    Write-HIEPLog "Project         : $($Configuration.repository.title)"
    Write-HIEPLog "Repository      : $($Configuration.repository.name)"
    Write-HIEPLog "Version         : $($Configuration.repository.version)"
    Write-HIEPLog "Owner           : $($Configuration.repository.owner)"
    Write-HIEPLog "Branch          : $($Configuration.repository.defaultBranch)"
    Write-HIEPLog "License         : $($Configuration.repository.license)"
    Write-HIEPLog "Visibility      : $($Configuration.repository.visibility)"
    Write-HIEPLog "Repository root : $RepositoryRoot"

    Write-Host ''

    if ($WhatIfMode) {

        Write-HIEPLog `
            "Folders to create : $($Statistics.FoldersPlanned)" `
            WARNING

        Write-HIEPLog `
            "Folders existing  : $($Statistics.FoldersExisting)"

        Write-HIEPLog `
            "Files to create   : $($Statistics.FilesPlanned)" `
            WARNING

        Write-HIEPLog `
            "Files existing    : $($Statistics.FilesExisting)"
    }
    else {

        Write-HIEPLog `
            "Folders created   : $($Statistics.FoldersCreated)" `
            SUCCESS

        Write-HIEPLog `
            "Folders existing  : $($Statistics.FoldersExisting)"

        Write-HIEPLog `
            "Files created     : $($Statistics.FilesCreated)" `
            SUCCESS

        Write-HIEPLog `
            "Files existing    : $($Statistics.FilesExisting)"
    }

    Write-Host ''
}


# ============================================================================
# Main
# ============================================================================

try {

    Show-HIEPBanner

    #
    # Repository root
    #

    $ResolvedRepositoryRoot = Get-HIEPRepositoryRoot `
        -Path $RepositoryRoot

    Write-HIEPLog "Repository root: $ResolvedRepositoryRoot"

    #
    # Configuration path
    #

    if ([string]::IsNullOrWhiteSpace($ConfigurationPath)) {

        $ResolvedConfigurationPath = Join-Path `
            -Path $ResolvedRepositoryRoot `
            -ChildPath 'build\config\HIEP.json'
    }
    elseif ([System.IO.Path]::IsPathRooted($ConfigurationPath)) {

        $ResolvedConfigurationPath = [System.IO.Path]::GetFullPath(
            $ConfigurationPath
        )
    }
    else {

        $ResolvedConfigurationPath = [System.IO.Path]::GetFullPath(
            (
                Join-Path `
                    -Path $ResolvedRepositoryRoot `
                    -ChildPath $ConfigurationPath
            )
        )
    }

    #
    # Git check
    #

    $GitDirectory = Join-Path `
        -Path $ResolvedRepositoryRoot `
        -ChildPath '.git'

    if (Test-Path -LiteralPath $GitDirectory) {

        Write-HIEPLog 'Git repository detected.'
    }
    else {

        Write-HIEPLog `
            'No Git repository detected. Bootstrap will continue.' `
            WARNING
    }

    #
    # Configuration
    #

    $Configuration = Get-HIEPConfiguration `
        -Path $ResolvedConfigurationPath

    Test-HIEPConfiguration `
        -Configuration $Configuration

    Write-Host ''

    Write-HIEPLog "Project    : $($Configuration.repository.title)"
    Write-HIEPLog "Version    : $($Configuration.repository.version)"
    Write-HIEPLog "Branch     : $($Configuration.repository.defaultBranch)"
    Write-HIEPLog "Visibility : $($Configuration.repository.visibility)"

    Write-Host ''

    #
    # Filesystem
    #

    $Statistics = Initialize-HIEPFileSystem `
        -Configuration $Configuration `
        -RepositoryRoot $ResolvedRepositoryRoot `
        -WhatIfMode $WhatIf.IsPresent

    #
    # Summary
    #

    Show-HIEPSummary `
        -Configuration $Configuration `
        -Statistics $Statistics `
        -RepositoryRoot $ResolvedRepositoryRoot `
        -WhatIfMode $WhatIf.IsPresent
}
catch {

    Write-Host ''

    Write-HIEPLog `
        -Message $_.Exception.Message `
        -Level ERROR

    Write-Host ''

    exit 1
}
