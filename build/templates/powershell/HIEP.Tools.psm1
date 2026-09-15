#Requires -Version 7.4

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$PublicPath = Join-Path `
    -Path $PSScriptRoot `
    -ChildPath 'Public'

$PrivatePath = Join-Path `
    -Path $PSScriptRoot `
    -ChildPath 'Private'


# ============================================================================
# Private functions
# ============================================================================

if (Test-Path -LiteralPath $PrivatePath -PathType Container) {

    Get-ChildItem `
        -LiteralPath $PrivatePath `
        -Filter '*.ps1' `
        -File |
        ForEach-Object {
            . $_.FullName
        }
}


# ============================================================================
# Public functions
# ============================================================================

$PublicFunctions = @()

if (Test-Path -LiteralPath $PublicPath -PathType Container) {

    $PublicScripts = Get-ChildItem `
        -LiteralPath $PublicPath `
        -Filter '*.ps1' `
        -File

    foreach ($Script in $PublicScripts) {

        . $Script.FullName

        $PublicFunctions += $Script.BaseName
    }
}


# ============================================================================
# Exports
# ============================================================================

if ($PublicFunctions.Count -gt 0) {

    Export-ModuleMember `
        -Function $PublicFunctions
}