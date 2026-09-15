function Get-HIEPRepositoryRoot {
    [CmdletBinding()]
    [OutputType([System.IO.DirectoryInfo])]
    param (
        [Parameter()]
        [string]
        $Path = (Get-Location).Path
    )

    $CurrentPath = if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Split-Path -Path $Path -Parent
    }
    else {
        $Path
    }

    $CurrentDirectory = Get-Item -LiteralPath $CurrentPath

    while ($null -ne $CurrentDirectory) {
        $ConfigurationPath = Join-Path `
            -Path $CurrentDirectory.FullName `
            -ChildPath 'build/config/HIEP.json'

        if (Test-Path -LiteralPath $ConfigurationPath -PathType Leaf) {
            return $CurrentDirectory
        }

        $CurrentDirectory = $CurrentDirectory.Parent
    }

    throw "Unable to locate the HIEP repository root from path '$Path'."
}
