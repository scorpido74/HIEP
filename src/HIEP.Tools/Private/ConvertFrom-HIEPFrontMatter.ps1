function ConvertFrom-HIEPFrontMatter {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(Mandatory)]
        [string]
        $Content
    )

    $Lines = $Content -split '\r?\n'

    $Metadata = [ordered]@{}
    $CurrentList = $null
    $InsideDocument = $false

    foreach ($Line in $Lines) {
        if ([string]::IsNullOrWhiteSpace($Line)) {
            continue
        }

        if ($Line -match '^\s*#') {
            continue
        }

        if ($Line -match '^document:\s*$') {
            $InsideDocument = $true
            $CurrentList = $null
            continue
        }

        if (-not $InsideDocument) {
            continue
        }

        if ($Line -match '^  ([A-Za-z][A-Za-z0-9_-]*):\s*(.*)$') {
            $Name = $Matches[1]
            $Value = $Matches[2].Trim()

            if ($Value -eq '[]') {
                $Metadata[$Name] = @()
                $CurrentList = $null
            }
            elseif ([string]::IsNullOrEmpty($Value)) {
                $Metadata[$Name] = @()
                $CurrentList = $Name
            }
            else {
                $Metadata[$Name] = $Value
                $CurrentList = $null
            }

            continue
        }

        if (
            $null -ne $CurrentList -and
            $Line -match '^    -\s+(.+?)\s*$'
        ) {
            $Metadata[$CurrentList] += $Matches[1]
            continue
        }

        throw "Unsupported HIEP front matter syntax: '$Line'."
    }

    if (-not $InsideDocument) {
        throw "HIEP front matter does not contain a 'document' metadata section."
    }

    return [pscustomobject]$Metadata
}
