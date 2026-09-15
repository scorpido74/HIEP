function Get-HIEPConfiguration {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter()]
        [string]
        $Path = (Get-Location).Path
    )

    $RepositoryRoot = Get-HIEPRepositoryRoot -Path $Path

    $ConfigurationPath = Join-Path `
        -Path $RepositoryRoot.FullName `
        -ChildPath 'build/config/HIEP.json'

    try {
        $ConfigurationContent = Get-Content `
            -LiteralPath $ConfigurationPath `
            -Raw

        $Configuration = $ConfigurationContent | ConvertFrom-Json
    }
    catch {
        throw "Unable to read HIEP configuration '$ConfigurationPath': $($_.Exception.Message)"
    }

    return $Configuration
}
