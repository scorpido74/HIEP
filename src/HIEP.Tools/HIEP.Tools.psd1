@{
    RootModule        = 'HIEP.Tools.psm1'
    ModuleVersion     = '0.2.0'
    GUID              = '8d51d0ab-ef69-45b6-ae71-48e245f42a37'

    Author            = 'Infinigate Nederland'
    CompanyName       = 'Infinigate Nederland'
    Copyright         = '(c) Infinigate Nederland. All rights reserved.'

    Description       = 'PowerShell tooling for the Healthcare Identity Eco Platform.'

    PowerShellVersion = '7.4'

    FunctionsToExport = @(
        'Get-HIEPDocumentMetadata',
        'Get-HIEPDocumentId',
        'Get-HIEPProjectUpdate'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData       = @{
        PSData = @{
            Tags       = @(
                'HIEP',
                'Healthcare',
                'Identity',
                'Security'
            )

            ProjectUri = ''
        }
    }
}
