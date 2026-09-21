function Test-HIEPProjectUpdate {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Path = (Get-Location).Path,

        [Parameter()]
        [switch]$PassThru
    )

    $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop
    $item = Get-Item -LiteralPath $resolvedPath -ErrorAction Stop

    if ($item.PSIsContainer) {
        $repositoryRoot = Get-HIEPRepositoryRoot -Path $item.FullName

        $updatesPath = Join-Path $repositoryRoot 'updates'

        if (-not (Test-Path -LiteralPath $updatesPath -PathType Container)) {
            throw "Project Updates directory not found: $updatesPath"
        }

        $files = @(
            Get-ChildItem -LiteralPath $updatesPath -Recurse -File -Filter '*.md' |
                Where-Object { $_.Name -ne 'README.md' }
        )
    }
    else {
        $files = @($item)
    }

    if ($files.Count -eq 0) {
        throw 'No Project Update files found.'
    }

    $updates = foreach ($file in $files) {
        $update = Get-HIEPProjectUpdate -Path $file.FullName

        if ($file.Name -notmatch '^(?<date>\d{4}-\d{2}-\d{2})-(?<slug>[a-z0-9]+(?:-[a-z0-9]+)*)\.md$') {
            throw "Invalid Project Update filename: $($file.Name)"
        }

        $filenameDate = $Matches.date
        $metadataDate = ([datetime]$update.Date).ToString('yyyy-MM-dd')

        if ($filenameDate -ne $metadataDate) {
            throw "Filename date '$filenameDate' does not match metadata date '$metadataDate' in '$($file.FullName)'."
        }

        $expectedYear = ([datetime]$update.Date).ToString('yyyy')
        $actualYear = $file.Directory.Name

        if ($actualYear -ne $expectedYear) {
            throw "Project Update '$($file.Name)' is in year directory '$actualYear', expected '$expectedYear'."
        }

        $update
    }

    $duplicateIds = @(
        $updates |
            Group-Object -Property Id |
            Where-Object Count -gt 1
    )

    if ($duplicateIds.Count -gt 0) {
        $ids = ($duplicateIds.Name | Sort-Object) -join ', '
        throw "Duplicate Project Update ID detected: $ids"
    }

    if ($PassThru) {
        return $updates
    }

    return $true
}
