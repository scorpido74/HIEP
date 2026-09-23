function New-HIEPProjectTimeline {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Path = (Get-Location).Path,

        [Parameter()]
        [string]$OutputPath,

        [Parameter()]
        [switch]$PassThru
    )

    $repositoryRoot = Get-HIEPRepositoryRoot -Path $Path

    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        $OutputPath = Join-Path $repositoryRoot 'portal\data\timeline.json'
    } elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
        $OutputPath = Join-Path $repositoryRoot $OutputPath
    }

    $updates = @(
        Test-HIEPProjectUpdate -Path $repositoryRoot -PassThru |
        Sort-Object `
        @{ Expression = { [datetime]$_.Date }; Descending = $true },
        @{ Expression = { $_.Id }; Descending = $true }
    )

    $timelineUpdates = @(
        foreach ($update in $updates) {
            [pscustomobject][ordered]@{
                id      = $update.Id
                title   = $update.Title
                date    = ([datetime]$update.Date).ToString('yyyy-MM-dd')
                type    = $update.Type
                status  = $update.Status
                summary = $update.Summary
                tags    = @($update.Tags)
                commits = @(
                    if ($update.PSObject.Properties.Name -contains 'commits') {
                        $update.commits
                    }
                )
            }
        }
    )

    $timeline = [ordered]@{
        generated = (Get-Date).ToUniversalTime().ToString('o')
        count     = $timelineUpdates.Count
        updates   = $timelineUpdates
    }

    $outputDirectory = Split-Path -Parent $OutputPath

    if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    $timeline |
    ConvertTo-Json -Depth 10 |
    Set-Content -LiteralPath $OutputPath -Encoding utf8

    if ($PassThru) {
        return [pscustomobject]$timeline
    }

    Get-Item -LiteralPath $OutputPath
}


