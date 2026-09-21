function ConvertFrom-HIEPProjectUpdateFrontMatter {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Content
    )

    $Lines = $Content -split '\r?\n'

    $Metadata = [ordered]@{}
    $CurrentList = $null

    foreach ($Line in $Lines) {
        if ([string]::IsNullOrWhiteSpace($Line)) {
            continue
        }

        if ($Line -match '^\s*#') {
            continue
        }

        if ($Line -match '^([A-Za-z][A-Za-z0-9_-]*):\s*(.*)$') {
            $Name = $Matches[1]
            $Value = $Matches[2].Trim()

            if ($Metadata.Contains($Name)) {
                throw "Duplicate HIEP Project Update metadata field '$Name'."
            }

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
            $Line -match '^\s{2}-\s+(.+?)\s*$'
        ) {
            $Metadata[$CurrentList] += $Matches[1]
            continue
        }

        throw "Unsupported HIEP Project Update front matter syntax: '$Line'."
    }

    if ($Metadata.Count -eq 0) {
        throw 'HIEP Project Update front matter does not contain metadata.'
    }

    return [pscustomobject]$Metadata
}