function Get-HIEPProjectUpdateId {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter()]
        [string]
        $Path = (Get-Location).Path
    )

    $RepositoryRoot = Get-HIEPRepositoryRoot -Path $Path

    $UpdatesPath = Join-Path `
        -Path $RepositoryRoot.FullName `
        -ChildPath 'updates'

    if (-not (Test-Path -LiteralPath $UpdatesPath -PathType Container)) {
        throw "HIEP Project Updates path '$UpdatesPath' does not exist."
    }

    $HighestSequence = 0
    $Pattern = '^HIEP-UPD-([0-9]{4})$'

    Get-ChildItem `
        -LiteralPath $UpdatesPath `
        -Filter '*.md' `
        -File `
        -Recurse |
    Where-Object {
        $_.Name -ne 'README.md'
    } |
    ForEach-Object {
        $Metadata = Get-HIEPProjectUpdate `
            -Path $_.FullName

        if ($Metadata.id -match $Pattern) {
            $Sequence = [int]$Matches[1]

            if ($Sequence -gt $HighestSequence) {
                $HighestSequence = $Sequence
            }
        }
    }

    $NextSequence = $HighestSequence + 1

    if ($NextSequence -gt 9999) {
        throw 'No HIEP Project Update identifiers remain available.'
    }

    return 'HIEP-UPD-{0:D4}' -f $NextSequence
}
