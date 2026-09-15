#Requires -Version 7.4

<#
.SYNOPSIS
    Initializes the Healthcare Identity Eco Platform (HIEP) repository.

.DESCRIPTION
    Creates the repository folder structure and base files from the
    configuration stored in build\Config\HIEP.json.

.NOTES
    Project : Healthcare Identity Eco Platform
    Version : 0.1.0
    Author  : Remco de Kievit / ChatGPT
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Logging

function Write-Log {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('INFO','SUCCESS','WARNING','ERROR')]
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

#endregion

#region Configuration

function Get-HIEPConfiguration {

    $ConfigFile = Join-Path $PSScriptRoot "Config\HIEP.json"

    if (-not (Test-Path $ConfigFile)) {
        throw "Configuration file not found: $ConfigFile"
    }

    Write-Log "Loading configuration..."

    try {
        return Get-Content -Path $ConfigFile -Raw | ConvertFrom-Json
    }
    catch {
        throw "Unable to parse HIEP.json.`n$($_.Exception.Message)"
    }
}

#endregion

#region FileSystem

function Initialize-HIEPFileSystem {

    param(
        [Parameter(Mandatory)]
        $Configuration
    )

    $FolderCount = 0
    $FileCount = 0

    Write-Log "Creating folder structure..."

    foreach ($Folder in $Configuration.filesystem.folders) {

        if (-not (Test-Path $Folder)) {

            New-Item `
                -ItemType Directory `
                -Path $Folder `
                -Force | Out-Null

            Write-Log "Created folder : $Folder" SUCCESS
            $FolderCount++
        }
        else {

            Write-Log "Folder exists   : $Folder"
        }
    }

    Write-Log "Creating files..."

    foreach ($File in $Configuration.filesystem.files) {

        if (-not (Test-Path $File)) {

            $Parent = Split-Path $File -Parent

            if ($Parent -and (-not (Test-Path $Parent))) {

                New-Item `
                    -ItemType Directory `
                    -Path $Parent `
                    -Force | Out-Null
            }

            New-Item `
                -ItemType File `
                -Path $File `
                -Force | Out-Null

            Write-Log "Created file   : $File" SUCCESS
            $FileCount++
        }
        else {

            Write-Log "File exists    : $File"
        }
    }

    return @{
        Folders = $FolderCount
        Files   = $FileCount
    }
}

#endregion

#region Main

Clear-Host

Write-Host ""
Write-Host "=========================================================" -ForegroundColor DarkCyan
Write-Host " Healthcare Identity Eco Platform" -ForegroundColor Cyan
Write-Host " Repository Bootstrap" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor DarkCyan
Write-Host ""

$Configuration = Get-HIEPConfiguration

$Result = Initialize-HIEPFileSystem -Configuration $Configuration

Write-Host ""
Write-Host "=========================================================" -ForegroundColor DarkGreen
Write-Host " Bootstrap completed successfully." -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor DarkGreen
Write-Host ""

Write-Log "Folders created : $($Result.Folders)" SUCCESS
Write-Log "Files created   : $($Result.Files)" SUCCESS

Write-Host ""

#endregion