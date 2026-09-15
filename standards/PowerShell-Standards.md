# HIEP PowerShell Standards

## Purpose

This standard defines PowerShell development conventions for HIEP.

## Version

HIEP automation targets PowerShell 7.4 or later.

Scripts may declare:

```powershell
#Requires -Version 7.4
```

## Strict Mode

HIEP scripts should normally use:

```powershell
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
```

## Naming

Use approved PowerShell verbs and PascalCase naming.

HIEP-specific functions should normally include `HIEP` in the noun.

Examples:

```powershell
Get-HIEPConfiguration
Test-HIEPConfiguration
Initialize-HIEPContent
```

## Parameters

Use descriptive parameter names.

Prefer:

```powershell
$RepositoryRoot
$ConfigurationPath
$DestinationPath
```

Avoid cryptic abbreviations unless their meaning is universally clear in the immediate
context.

## Paths

Use PowerShell and .NET path functions rather than manually concatenating paths.

Prefer:

```powershell
Join-Path
Resolve-Path
[System.IO.Path]::GetFullPath()
```

Repository automation must validate that configured relative paths cannot escape the
repository root.

## Files

Do not overwrite existing user-managed content by default.

Destructive or replacement operations require explicit intent.

## Error Handling

Fail clearly when an operation cannot safely continue.

Use exceptions for conditions that make the requested operation invalid.

Do not silently suppress errors without a documented reason.

## Logging

Operational scripts should provide useful status information.

Distinguish where practical between:

- information;
- success;
- warning;
- error.

Never expose secrets in logs.

## Idempotency

Bootstrap and configuration scripts should be idempotent where practical.

Running the same script repeatedly with the same configuration should converge on the
same desired state without unnecessary changes.

## Configuration

Prefer declarative configuration over hardcoded project-specific values.

For HIEP bootstrap operations, `build/config/HIEP.json` is the primary configuration
source.

## Functions

Functions should have one clear responsibility.

Split complex logic into testable functions rather than building monolithic scripts.

## Advanced Functions

Public HIEP functions should use advanced function semantics where appropriate.

Example:

```powershell
function New-HIEPDocument {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('BUS', 'ARC', 'SEC', 'VND', 'GOV', 'GLS')]
        [string]$Type
    )
}
```

Use `[CmdletBinding()]` for public functions that benefit from standard
PowerShell behavior.

Functions that create, modify, replace or remove repository content should
support `ShouldProcess` where practical.

## Parameter Validation

Validate parameters as close to the function boundary as practical.

Use built-in validation attributes where they clearly express the requirement.

Examples include:

```powershell
[Parameter(Mandatory)]
[ValidateNotNullOrEmpty()]
[string]$Title
```

and:

```powershell
[ValidateSet('BUS', 'ARC', 'SEC', 'VND', 'GOV', 'GLS')]
[string]$Type
```

Do not rely on parameter validation alone for rules that require repository or
configuration context.

## WhatIf and Confirm

Functions that change repository state should support `-WhatIf` where
appropriate.

Use `SupportsShouldProcess` instead of implementing custom `-WhatIf`
parameters.

Example:

```powershell
if ($PSCmdlet.ShouldProcess($Path, 'Create HIEP document')) {
    # Create the document.
}
```

Use confirmation behavior appropriate to the impact of the operation.

## Output

Functions should return useful PowerShell objects when callers may need to
consume the result programmatically.

Avoid using formatted console text as the only function output.

Use informational or verbose streams for operational messages where
appropriate.

Do not mix diagnostic output with pipeline output in ways that make automation
unreliable.

## Modules

Reusable PowerShell functionality belongs in:

`src/HIEP.Tools/`

Public functions belong in:

`src/HIEP.Tools/Public/`

Private helper functions belong in:

`src/HIEP.Tools/Private/`

## Security

Never commit:

- passwords;
- API keys;
- tokens;
- private keys;
- production credentials.

Use an appropriate secret-management mechanism instead.

## Testing

Reusable PowerShell functions should be testable with Pester where practical.

Tests belong under:

`tests/`

## Formatting

Use consistent formatting throughout the repository.

Readability is more important than minimizing line count.

Public functions should be tested for successful operation, invalid input and
safe failure behavior.

Functions that support `ShouldProcess` should include tests for `-WhatIf`
behavior where practical.

## Comments

Comments should explain intent, assumptions or non-obvious behavior.

Avoid comments that merely repeat what the code already says.

## Compatibility

Do not add Windows PowerShell 5.1 compatibility constraints unless HIEP has a defined
requirement for them.

HIEP's default PowerShell runtime is PowerShell 7.4 or later.
