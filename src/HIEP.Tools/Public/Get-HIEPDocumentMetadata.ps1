function Get-HIEPDocumentMetadata {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullName')]
        [string]
        $Path
    )

    process {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
            throw "HIEP document '$Path' does not exist."
        }

        $Content = Get-Content `
            -LiteralPath $Path `
            -Raw

        $Lines = $Content -split '\r?\n'

        if (
            $Lines.Count -eq 0 -or
            $Lines[0].Trim() -ne '---'
        ) {
            throw "HIEP document '$Path' does not begin with YAML front matter."
        }

        $ClosingDelimiter = $null

        for ($Index = 1; $Index -lt $Lines.Count; $Index++) {
            if ($Lines[$Index].Trim() -eq '---') {
                $ClosingDelimiter = $Index
                break
            }
        }

        if ($null -eq $ClosingDelimiter) {
            throw "HIEP document '$Path' contains unterminated YAML front matter."
        }

        if ($ClosingDelimiter -le 1) {
            throw "HIEP document '$Path' contains empty YAML front matter."
        }

        $FrontMatter = $Lines[1..($ClosingDelimiter - 1)] -join "`n"

        return ConvertFrom-HIEPFrontMatter -Content $FrontMatter
    }
}
