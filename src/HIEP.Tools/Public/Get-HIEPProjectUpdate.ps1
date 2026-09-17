function Get-HIEPProjectUpdate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullName')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    process {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
            throw "HIEP Project Update '$Path' does not exist."
        }

        $ResolvedPath = (Resolve-Path -LiteralPath $Path).Path

        $Content = Get-Content `
            -LiteralPath $ResolvedPath `
            -Raw

        $Lines = $Content -split '\r?\n'

        if (
            $Lines.Count -eq 0 -or
            $Lines[0].Trim() -ne '---'
        ) {
            throw "HIEP Project Update '$ResolvedPath' does not begin with YAML front matter."
        }

        $ClosingDelimiter = $null

        for ($Index = 1; $Index -lt $Lines.Count; $Index++) {
            if ($Lines[$Index].Trim() -eq '---') {
                $ClosingDelimiter = $Index
                break
            }
        }

        if ($null -eq $ClosingDelimiter) {
            throw "HIEP Project Update '$ResolvedPath' contains unterminated YAML front matter."
        }

        if ($ClosingDelimiter -le 1) {
            throw "HIEP Project Update '$ResolvedPath' contains empty YAML front matter."
        }

        $FrontMatter = $Lines[1..($ClosingDelimiter - 1)] -join "`n"

        $Metadata = ConvertFrom-HIEPProjectUpdateFrontMatter `
            -Content $FrontMatter

        $RequiredFields = @(
            'id'
            'title'
            'date'
            'type'
            'status'
            'summary'
            'tags'
        )

        foreach ($Field in $RequiredFields) {
            $Property = $Metadata.PSObject.Properties[$Field]

            if ($null -eq $Property) {
                throw "HIEP Project Update '$ResolvedPath' does not contain required metadata field '$Field'."
            }

            if (
                $Field -ne 'tags' -and
                [string]::IsNullOrWhiteSpace([string]$Property.Value)
            ) {
                throw "HIEP Project Update '$ResolvedPath' contains an empty required metadata field '$Field'."
            }

            if (
                $Field -eq 'tags' -and
                @($Property.Value).Count -eq 0
            ) {
                throw "HIEP Project Update '$ResolvedPath' must contain at least one tag."
            }
        }

        if ($Metadata.id -notmatch '^HIEP-UPD-[0-9]{4}$') {
            throw "HIEP Project Update '$ResolvedPath' contains invalid identifier '$($Metadata.id)'."
        }

        $ValidTypes = @(
            'development'
            'documentation'
            'architecture'
            'governance'
            'research'
            'release'
            'milestone'
        )

        if ($Metadata.type -notin $ValidTypes) {
            throw "HIEP Project Update '$ResolvedPath' contains invalid type '$($Metadata.type)'."
        }

        $ValidStatuses = @(
            'planned'
            'in-progress'
            'completed'
            'cancelled'
            'superseded'
        )

        if ($Metadata.status -notin $ValidStatuses) {
            throw "HIEP Project Update '$ResolvedPath' contains invalid status '$($Metadata.status)'."
        }

        $ParsedDate = [datetime]::MinValue

        if (
            -not [datetime]::TryParseExact(
                [string]$Metadata.date,
                'yyyy-MM-dd',
                [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None,
                [ref]$ParsedDate
            )
        ) {
            throw "HIEP Project Update '$ResolvedPath' contains invalid date '$($Metadata.date)'."
        }

        $Metadata |
            Add-Member `
                -NotePropertyName 'path' `
                -NotePropertyValue $ResolvedPath

        return $Metadata
    }
}