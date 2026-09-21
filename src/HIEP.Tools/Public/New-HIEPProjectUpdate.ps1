function New-HIEPProjectUpdate {
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [ValidateSet(
            'development',
            'documentation',
            'architecture',
            'governance',
            'research',
            'release',
            'milestone'
        )]
        [string]
        $Type,

        [Parameter(Mandatory)]
        [ValidateSet(
            'planned',
            'in-progress',
            'completed',
            'cancelled',
            'superseded'
        )]
        [string]
        $Status,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Summary,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Tags,

        [Parameter()]
        [datetime]
        $Date = (Get-Date),

        [Parameter()]
        [string[]]
        $Commits,

        [Parameter()]
        [string]
        $Path = (Get-Location).Path
    )

    $RepositoryRoot = Get-HIEPRepositoryRoot -Path $Path
    $Id = Get-HIEPProjectUpdateId -Path $RepositoryRoot.FullName

    $DateValue = $Date.ToString(
        'yyyy-MM-dd',
        [System.Globalization.CultureInfo]::InvariantCulture
    )

    $Year = $Date.ToString(
        'yyyy',
        [System.Globalization.CultureInfo]::InvariantCulture
    )

    $Slug = $Title.ToLowerInvariant()
    $Slug = $Slug -replace '[^a-z0-9]+', '-'
    $Slug = $Slug.Trim('-')

    if ([string]::IsNullOrWhiteSpace($Slug)) {
        throw "Unable to generate a filename slug from title '$Title'."
    }

    $UpdatesPath = Join-Path `
        -Path $RepositoryRoot.FullName `
        -ChildPath 'updates'

    if (-not (Test-Path -LiteralPath $UpdatesPath -PathType Container)) {
        throw "HIEP Project Updates path '$UpdatesPath' does not exist."
    }

    $YearPath = Join-Path `
        -Path $UpdatesPath `
        -ChildPath $Year

    if (-not (Test-Path -LiteralPath $YearPath -PathType Container)) {
        $null = New-Item `
            -Path $YearPath `
            -ItemType Directory
    }

    $FileName = '{0}-{1}.md' -f $DateValue, $Slug

    $FilePath = Join-Path `
        -Path $YearPath `
        -ChildPath $FileName

    if (Test-Path -LiteralPath $FilePath) {
        throw "HIEP Project Update '$FilePath' already exists."
    }

    $Lines = [System.Collections.Generic.List[string]]::new()

    $Lines.Add('---')
    $Lines.Add("id: $Id")
    $Lines.Add("title: $Title")
    $Lines.Add("date: $DateValue")
    $Lines.Add("type: $Type")
    $Lines.Add("status: $Status")
    $Lines.Add("summary: $Summary")
    $Lines.Add('tags:')

    foreach ($Tag in $Tags) {
        if ([string]::IsNullOrWhiteSpace($Tag)) {
            throw 'HIEP Project Update tags must not contain empty values.'
        }

        $Lines.Add("  - $Tag")
    }

    if ($null -ne $Commits -and $Commits.Count -gt 0) {
        $Lines.Add('commits:')

        foreach ($Commit in $Commits) {
            if ([string]::IsNullOrWhiteSpace($Commit)) {
                throw 'HIEP Project Update commits must not contain empty values.'
            }

            $Lines.Add("  - $Commit")
        }
    }

    $Lines.Add('---')
    $Lines.Add('')
    $Lines.Add("# $Title")
    $Lines.Add('')
    $Lines.Add('## Summary')
    $Lines.Add('')
    $Lines.Add($Summary)
    $Lines.Add('')
    $Lines.Add('## Why this matters')
    $Lines.Add('')
    $Lines.Add('TODO')
    $Lines.Add('')
    $Lines.Add('## Changes')
    $Lines.Add('')
    $Lines.Add('TODO')
    $Lines.Add('')
    $Lines.Add('## Related work')
    $Lines.Add('')
    $Lines.Add('TODO')
    $Lines.Add('')
    $Lines.Add('## Next steps')
    $Lines.Add('')
    $Lines.Add('TODO')

    Set-Content `
        -LiteralPath $FilePath `
        -Value $Lines `
        -Encoding utf8

    $Metadata = Get-HIEPProjectUpdate -Path $FilePath

    if ($Metadata.id -ne $Id) {
        Remove-Item -LiteralPath $FilePath -Force

        throw "Created HIEP Project Update failed identifier validation."
    }

    return Get-Item -LiteralPath $FilePath
}
