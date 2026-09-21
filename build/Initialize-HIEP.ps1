#Requires -Version 7.4

param(
    [string]$RepositoryRoot,
    [string]$ConfigurationPath,
    [switch]$WhatIf,
    [switch]$Force
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


function Show-HIEPBanner {

    Write-Host ''
    Write-Host '=========================================================' -ForegroundColor DarkCyan
    Write-Host ' Healthcare Identity Eco Platform' -ForegroundColor Cyan
    Write-Host ' Repository Bootstrap v0.2.0' -ForegroundColor Cyan
    Write-Host '=========================================================' -ForegroundColor DarkCyan
    Write-Host ''
}


# ============================================================================
# Repository
# ============================================================================

function Get-HIEPRepositoryRoot {

    param(
        [string]$Path
    )

    if (-not [string]::IsNullOrWhiteSpace($Path)) {

        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            throw "Repository root does not exist: $Path"
        }

        return (Resolve-Path -LiteralPath $Path).Path
    }

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

    if ($null -ne $Configuration.content) {

        if (
            $Configuration.content.enabled -eq $true -and
            $null -eq $Configuration.content.templates
        ) {
            throw 'Content bootstrap is enabled but content.templates is missing.'
        }

        foreach ($Template in $Configuration.content.templates) {

            if ([string]::IsNullOrWhiteSpace([string]$Template.source)) {
                throw 'Content template is missing source.'
            }

            if ([string]::IsNullOrWhiteSpace([string]$Template.destination)) {
                throw 'Content template is missing destination.'
            }
        }
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

    $NormalizedPath = $RelativePath.Replace(
        '/',
        [System.IO.Path]::DirectorySeparatorChar
    )

    $NormalizedPath = $NormalizedPath.Replace(
        '\',
        [System.IO.Path]::DirectorySeparatorChar
    )

    $RootPath = [System.IO.Path]::GetFullPath($RepositoryRoot)

    $FullPath = [System.IO.Path]::GetFullPath(
        (Join-Path -Path $RootPath -ChildPath $NormalizedPath)
    )

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
# Filesystem bootstrap
# ============================================================================

function New-HIEPDirectory {

    param(
        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory)]
        [string]$RelativePath,

        [bool]$WhatIfMode = $false
    )

    $FullPath = Get-HIEPFullPath `
        -RepositoryRoot $RepositoryRoot `
        -RelativePath $RelativePath

    if (Test-Path -LiteralPath $FullPath -PathType Container) {
        Write-Verbose "Folder exists: $RelativePath"
        return 'Existing'
    }

    if (Test-Path -LiteralPath $FullPath) {
        throw "Expected folder but another filesystem object exists: $RelativePath"
    }

    if ($WhatIfMode) {
        Write-Host "What if: create folder '$RelativePath'"
        return 'Planned'
    }

    New-Item `
        -ItemType Directory `
        -Path $FullPath `
        -Force |
        Out-Null

    Write-HIEPLog "Created folder : $RelativePath" SUCCESS

    return 'Created'
}


function New-HIEPFile {

    param(
        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory)]
        [string]$RelativePath,

        [bool]$WhatIfMode = $false
    )

    $FullPath = Get-HIEPFullPath `
        -RepositoryRoot $RepositoryRoot `
        -RelativePath $RelativePath

    if (Test-Path -LiteralPath $FullPath -PathType Leaf) {
        Write-Verbose "File exists: $RelativePath"
        return 'Existing'
    }

    if (Test-Path -LiteralPath $FullPath) {
        throw "Expected file but another filesystem object exists: $RelativePath"
    }

    if ($WhatIfMode) {
        Write-Host "What if: create file '$RelativePath'"
        return 'Planned'
    }

    $Parent = Split-Path -Path $FullPath -Parent

    if (-not (Test-Path -LiteralPath $Parent -PathType Container)) {

        New-Item `
            -ItemType Directory `
            -Path $Parent `
            -Force |
            Out-Null
    }

    New-Item `
        -ItemType File `
        -Path $FullPath |
        Out-Null

    Write-HIEPLog "Created file   : $RelativePath" SUCCESS

    return 'Created'
}


function Initialize-HIEPFileSystem {

    param(
        [Parameter(Mandatory)]
        [object]$Configuration,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

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
            'Created'  { $Statistics.FoldersCreated++ }
            'Existing' { $Statistics.FoldersExisting++ }
            'Planned'  { $Statistics.FoldersPlanned++ }
        }
    }

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
            'Created'  { $Statistics.FilesCreated++ }
            'Existing' { $Statistics.FilesExisting++ }
            'Planned'  { $Statistics.FilesPlanned++ }
        }
    }

    return [PSCustomObject]$Statistics
}


# ============================================================================
# Content bootstrap
# ============================================================================

function Test-HIEPTemplateSources {

    param(
        [Parameter(Mandatory)]
        [object]$Configuration,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot
    )

    if ($null -eq $Configuration.content) {
        return
    }

    if ($Configuration.content.enabled -ne $true) {
        return
    }

    Write-HIEPLog 'Validating content templates...'

    $MissingTemplates = [System.Collections.Generic.List[string]]::new()

    foreach ($Template in $Configuration.content.templates) {

        $SourceRelativePath = [string]$Template.source

        $SourcePath = Get-HIEPFullPath `
            -RepositoryRoot $RepositoryRoot `
            -RelativePath $SourceRelativePath

        if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
            $MissingTemplates.Add($SourceRelativePath)
        }
    }

    if ($MissingTemplates.Count -gt 0) {

        $Message = [System.Collections.Generic.List[string]]::new()

        $Message.Add('One or more content templates are missing:')
        $Message.Add('')

        foreach ($MissingTemplate in $MissingTemplates) {
            $Message.Add(" - $MissingTemplate")
        }

        throw ($Message -join [Environment]::NewLine)
    }

    Write-HIEPLog 'Content templates valid.' SUCCESS
}


function Get-HIEPFileState {

    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return 'Missing'
    }

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return 'Conflict'
    }

    $FileInfo = Get-Item -LiteralPath $Path

    if ($FileInfo.Length -eq 0) {
        return 'Empty'
    }

    return 'Populated'
}


function Set-HIEPTemplateContent {

    param(
        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory)]
        [object]$Template,

        [bool]$PopulateEmptyFiles = $true,

        [bool]$OverwriteExisting = $false,

        [bool]$ForceMode = $false,

        [bool]$WhatIfMode = $false
    )

    $SourceRelativePath = [string]$Template.source
    $DestinationRelativePath = [string]$Template.destination

    $TemplateName = if (
        -not [string]::IsNullOrWhiteSpace([string]$Template.name)
    ) {
        [string]$Template.name
    }
    else {
        $DestinationRelativePath
    }

    $SourcePath = Get-HIEPFullPath `
        -RepositoryRoot $RepositoryRoot `
        -RelativePath $SourceRelativePath

    $DestinationPath = Get-HIEPFullPath `
        -RepositoryRoot $RepositoryRoot `
        -RelativePath $DestinationRelativePath

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
        throw "Template source does not exist: $SourceRelativePath"
    }

    $DestinationState = Get-HIEPFileState `
        -Path $DestinationPath

    if ($DestinationState -eq 'Conflict') {
        throw "Content destination is not a file: $DestinationRelativePath"
    }

    $Action = switch ($DestinationState) {

        'Missing' {
            'Create'
        }

        'Empty' {

            if (
                $PopulateEmptyFiles -or
                $OverwriteExisting -or
                $ForceMode
            ) {
                'Populate'
            }
            else {
                'Preserve'
            }
        }

        'Populated' {

            if ($OverwriteExisting -or $ForceMode) {
                'Replace'
            }
            else {
                'Preserve'
            }
        }
    }

    if ($Action -eq 'Preserve') {

        Write-Verbose "Content preserved: $DestinationRelativePath"

        return 'Existing'
    }

    if ($WhatIfMode) {

        switch ($Action) {

            'Create' {
                Write-Host "What if: create content '$DestinationRelativePath'"
                return 'PlannedCreate'
            }

            'Populate' {
                Write-Host "What if: populate empty file '$DestinationRelativePath'"
                return 'PlannedPopulate'
            }

            'Replace' {
                Write-Host "What if: replace content '$DestinationRelativePath'"
                return 'PlannedReplace'
            }
        }
    }

    $DestinationParent = Split-Path `
        -Path $DestinationPath `
        -Parent

    if (-not (
        Test-Path `
            -LiteralPath $DestinationParent `
            -PathType Container
    )) {
        New-Item `
            -ItemType Directory `
            -Path $DestinationParent `
            -Force |
            Out-Null
    }

    Copy-Item `
        -LiteralPath $SourcePath `
        -Destination $DestinationPath `
        -Force

    switch ($Action) {

        'Create' {

            Write-HIEPLog `
                "Created content : $TemplateName -> $DestinationRelativePath" `
                SUCCESS

            return 'Created'
        }

        'Populate' {

            Write-HIEPLog `
                "Populated file  : $TemplateName -> $DestinationRelativePath" `
                SUCCESS

            return 'Populated'
        }

        'Replace' {

            Write-HIEPLog `
                "Replaced file   : $TemplateName -> $DestinationRelativePath" `
                WARNING

            return 'Replaced'
        }
    }
}


function Initialize-HIEPContent {

    param(
        [Parameter(Mandatory)]
        [object]$Configuration,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [bool]$ForceMode = $false,

        [bool]$WhatIfMode = $false
    )

    $Statistics = [ordered]@{
        Enabled          = $false

        Created          = 0
        Populated        = 0
        Replaced         = 0
        Existing         = 0

        PlannedCreate    = 0
        PlannedPopulate  = 0
        PlannedReplace   = 0
    }

    if ($null -eq $Configuration.content) {

        Write-HIEPLog `
            'No content configuration found. Content bootstrap skipped.' `
            WARNING

        return [PSCustomObject]$Statistics
    }

    if ($Configuration.content.enabled -ne $true) {

        Write-HIEPLog 'Content bootstrap disabled.'

        return [PSCustomObject]$Statistics
    }

    $Statistics.Enabled = $true

    $PopulateEmptyFiles = $true
    $OverwriteExisting = $false

    if ($null -ne $Configuration.content.populateEmptyFiles) {
        $PopulateEmptyFiles = [bool]$Configuration.content.populateEmptyFiles
    }

    if ($null -ne $Configuration.content.overwriteExisting) {
        $OverwriteExisting = [bool]$Configuration.content.overwriteExisting
    }

    Write-HIEPLog 'Processing content templates...'

    foreach ($Template in $Configuration.content.templates) {

        $Status = Set-HIEPTemplateContent `
            -RepositoryRoot $RepositoryRoot `
            -Template $Template `
            -PopulateEmptyFiles $PopulateEmptyFiles `
            -OverwriteExisting $OverwriteExisting `
            -ForceMode $ForceMode `
            -WhatIfMode $WhatIfMode

        switch ($Status) {

            'Created' {
                $Statistics.Created++
            }

            'Populated' {
                $Statistics.Populated++
            }

            'Replaced' {
                $Statistics.Replaced++
            }

            'Existing' {
                $Statistics.Existing++
            }

            'PlannedCreate' {
                $Statistics.PlannedCreate++
            }

            'PlannedPopulate' {
                $Statistics.PlannedPopulate++
            }

            'PlannedReplace' {
                $Statistics.PlannedReplace++
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
        [object]$FileSystemStatistics,

        [Parameter(Mandatory)]
        [object]$ContentStatistics,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [bool]$ForceMode = $false,

        [bool]$WhatIfMode = $false
    )

    Write-Host ''
    Write-Host '=========================================================' -ForegroundColor DarkGreen

    if ($WhatIfMode) {
        Write-Host ' Bootstrap simulation completed.' -ForegroundColor Yellow
    }
    else {
        Write-Host ' Bootstrap completed successfully.' -ForegroundColor Green
    }

    Write-Host '=========================================================' -ForegroundColor DarkGreen
    Write-Host ''

    Write-HIEPLog "Project         : $($Configuration.repository.title)"
    Write-HIEPLog "Repository      : $($Configuration.repository.name)"
    Write-HIEPLog "Version         : $($Configuration.repository.version)"
    Write-HIEPLog "Owner           : $($Configuration.repository.owner)"
    Write-HIEPLog "Branch          : $($Configuration.repository.defaultBranch)"
    Write-HIEPLog "License         : $($Configuration.repository.license)"
    Write-HIEPLog "Visibility      : $($Configuration.repository.visibility)"
    Write-HIEPLog "Repository root : $RepositoryRoot"
    Write-HIEPLog "Force           : $ForceMode"

    Write-Host ''
    Write-Host 'Filesystem' -ForegroundColor White
    Write-Host '----------'

    if ($WhatIfMode) {

        Write-HIEPLog `
            "Folders to create : $($FileSystemStatistics.FoldersPlanned)" `
            WARNING

        Write-HIEPLog `
            "Folders existing  : $($FileSystemStatistics.FoldersExisting)"

        Write-HIEPLog `
            "Files to create   : $($FileSystemStatistics.FilesPlanned)" `
            WARNING

        Write-HIEPLog `
            "Files existing    : $($FileSystemStatistics.FilesExisting)"
    }
    else {

        Write-HIEPLog `
            "Folders created   : $($FileSystemStatistics.FoldersCreated)" `
            SUCCESS

        Write-HIEPLog `
            "Folders existing  : $($FileSystemStatistics.FoldersExisting)"

        Write-HIEPLog `
            "Files created     : $($FileSystemStatistics.FilesCreated)" `
            SUCCESS

        Write-HIEPLog `
            "Files existing    : $($FileSystemStatistics.FilesExisting)"
    }

    Write-Host ''
    Write-Host 'Content' -ForegroundColor White
    Write-Host '-------'

    if (-not $ContentStatistics.Enabled) {

        Write-HIEPLog 'Content bootstrap : disabled'
    }
    elseif ($WhatIfMode) {

        Write-HIEPLog `
            "Content to create   : $($ContentStatistics.PlannedCreate)" `
            WARNING

        Write-HIEPLog `
            "Empty files to fill : $($ContentStatistics.PlannedPopulate)" `
            WARNING

        Write-HIEPLog `
            "Content to replace  : $($ContentStatistics.PlannedReplace)" `
            WARNING

        Write-HIEPLog `
            "Content preserved   : $($ContentStatistics.Existing)"
    }
    else {

        Write-HIEPLog `
            "Content created     : $($ContentStatistics.Created)" `
            SUCCESS

        Write-HIEPLog `
            "Empty files filled  : $($ContentStatistics.Populated)" `
            SUCCESS

        if ($ContentStatistics.Replaced -gt 0) {

            Write-HIEPLog `
                "Content replaced    : $($ContentStatistics.Replaced)" `
                WARNING
        }
        else {

            Write-HIEPLog `
                "Content replaced    : $($ContentStatistics.Replaced)"
        }

        Write-HIEPLog `
            "Content preserved   : $($ContentStatistics.Existing)"
    }

    Write-Host ''
}


# ============================================================================
# Main
# ============================================================================

try {

    Show-HIEPBanner

    $ResolvedRepositoryRoot = Get-HIEPRepositoryRoot `
        -Path $RepositoryRoot

    Write-HIEPLog "Repository root: $ResolvedRepositoryRoot"

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
    # Phase 1 - filesystem
    #

    $FileSystemStatistics = Initialize-HIEPFileSystem `
        -Configuration $Configuration `
        -RepositoryRoot $ResolvedRepositoryRoot `
        -WhatIfMode $WhatIf.IsPresent

    Write-Host ''

    #
    # Phase 2 - content
    #
    # Validate every source before changing any destination content.
    #

    Test-HIEPTemplateSources `
        -Configuration $Configuration `
        -RepositoryRoot $ResolvedRepositoryRoot

    $ContentStatistics = Initialize-HIEPContent `
        -Configuration $Configuration `
        -RepositoryRoot $ResolvedRepositoryRoot `
        -ForceMode $Force.IsPresent `
        -WhatIfMode $WhatIf.IsPresent

    Show-HIEPSummary `
        -Configuration $Configuration `
        -FileSystemStatistics $FileSystemStatistics `
        -ContentStatistics $ContentStatistics `
        -RepositoryRoot $ResolvedRepositoryRoot `
        -ForceMode $Force.IsPresent `
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