function Get-HIEPDocumentId {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Type,

        [Parameter()]
        [string]
        $Path = (Get-Location).Path
    )

    $Configuration = Get-HIEPConfiguration -Path $Path
    $RepositoryRoot = Get-HIEPRepositoryRoot -Path $Path

    $NormalizedType = $Type.ToUpperInvariant()

    $DocumentType = $Configuration.documentation.documentTypes.PSObject.Properties |
        Where-Object {
            $_.Name -eq $NormalizedType
        } |
        Select-Object -First 1

    if ($null -eq $DocumentType) {
        throw "Unknown HIEP document type '$Type'."
    }

    $DocumentPath = Join-Path `
        -Path $RepositoryRoot.FullName `
        -ChildPath $DocumentType.Value.path

    if (-not (Test-Path -LiteralPath $DocumentPath -PathType Container)) {
        throw "HIEP document path '$DocumentPath' does not exist."
    }

    $Pattern = '^HIEP-{0}-([0-9]{{3}})(?:-.*)?\.md$' -f `
        [regex]::Escape($NormalizedType)

    $HighestSequence = 0

    Get-ChildItem `
        -LiteralPath $DocumentPath `
        -Filter "HIEP-$NormalizedType-*.md" `
        -File |
        ForEach-Object {
            if ($_.Name -match $Pattern) {
                $Sequence = [int]$Matches[1]

                if ($Sequence -gt $HighestSequence) {
                    $HighestSequence = $Sequence
                }
            }
        }

    $NextSequence = $HighestSequence + 1

    if ($NextSequence -gt 999) {
        throw "No HIEP document IDs remain available for type '$NormalizedType'."
    }

    return 'HIEP-{0}-{1:D3}' -f `
        $NormalizedType,
        $NextSequence
}
