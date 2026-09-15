# HIEP Mermaid Standards

## Purpose

This standard defines conventions for Mermaid diagrams in HIEP.

## Preferred Use

Mermaid is the preferred diagram-as-code format for diagrams that can be represented
clearly in text.

Typical uses include:

- architecture diagrams;
- identity flows;
- sequence diagrams;
- trust relationships;
- process flows;
- integration flows.

## Source

Store reusable Mermaid source under:

`diagrams/mermaid/`

Diagrams may also be embedded directly in Markdown where the diagram belongs to a
specific document.

## Direction

Choose diagram direction based on readability.

For architecture diagrams, left-to-right is generally preferred where it reflects the
flow naturally.

Example:

```mermaid
flowchart LR
    User["Healthcare Professional"]
    IdP["Identity Provider"]
    App["Healthcare Application"]

    User --> IdP
    IdP --> App

    Node Identifiers

Use short, stable identifiers.

Prefer:

IdP
EHR
PAM
User

Avoid meaningless identifiers such as:

A1
X37
Node999

unless the diagram itself requires them.

Labels

Labels should describe the actual component or actor.

Avoid excessive text inside diagram nodes.

Move detailed explanation into the surrounding document.

Flows

Label important flows where the protocol or action matters.

Example:

Trust Boundaries

Represent trust boundaries when they are relevant to the architecture or security
discussion.

Explain the meaning of those boundaries in the accompanying text.

Vendor Neutrality

Use logical capability names in vendor-neutral architecture diagrams.

Use product names when the diagram is intentionally a physical or vendor-specific
architecture.

Complexity

Prefer multiple understandable diagrams over one diagram containing every possible
relationship.

A diagram should communicate a specific idea.

Styling

Avoid unnecessary custom styling.

The diagram should remain readable in different renderers and themes.

Validation

Mermaid diagrams should be rendered or otherwise validated before an Approved
document is published.

Syntax validity alone does not guarantee architectural correctness.


## 16. `build/templates/standards/PowerShell-Standards.md`

```markdown
# HIEP PowerShell Standards

## Purpose

This standard defines PowerShell development conventions for HIEP.

## Version

HIEP automation targets:

**PowerShell 7.4 or later**

Scripts may declare:

```powershell
#Requires -Version 7.4
Strict Mode

HIEP scripts should normally use:

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Naming

Use approved PowerShell verbs.

Use PascalCase.

HIEP-specific functions should normally include HIEP in the noun.

Examples:

Get-HIEPConfiguration
Test-HIEPConfiguration
Initialize-HIEPContent
Parameters

Use descriptive parameter names.

Prefer:

$RepositoryRoot
$ConfigurationPath
$DestinationPath

Avoid:

$rr
$cp
$dp

unless the abbreviation is universally clear in the immediate context.

Paths

Use PowerShell and .NET path functions rather than manually concatenating paths.

Prefer:

Join-Path
Resolve-Path
[System.IO.Path]::GetFullPath()

Repository automation should validate that configured relative paths cannot escape the
repository root.

Files

Do not overwrite existing user-managed content by default.

Destructive or replacement operations should require explicit intent.

Error Handling

Fail clearly when an operation cannot safely continue.

Use exceptions for conditions that make the requested operation invalid.

Do not silently suppress errors without a documented reason.

Logging

Operational scripts should provide useful status information.

Distinguish where practical between:

information;
success;
warning;
error.

Do not expose secrets in logs.

Idempotency

Bootstrap and configuration scripts should be idempotent where practical.

Running the same script repeatedly with the same configuration should converge on the
same desired state without unnecessary changes.

Configuration

Prefer declarative configuration over hardcoded project-specific values.

For HIEP bootstrap operations, build/config/HIEP.json is the primary configuration
source.

Functions

Functions should have one clear responsibility.

Split complex logic into testable functions rather than building monolithic scripts.

Modules

Reusable PowerShell functionality belongs in:

src/HIEP.Tools/

Public functions belong in:

src/HIEP.Tools/Public/

Private helper functions belong in:

src/HIEP.Tools/Private/

Security

Never commit:

passwords;
API keys;
tokens;
private keys;
production credentials.

Use appropriate secret-management mechanisms instead.

Testing

Reusable PowerShell functions should be testable with Pester where practical.

Tests belong under:

tests/

Formatting

Use consistent formatting throughout the repository.

Readability is more important than minimizing line count.

Comments

Comments should explain intent, assumptions or non-obvious behavior.

Avoid comments that merely repeat what the code already says.

Compatibility

Do not add Windows PowerShell 5.1 compatibility constraints unless HIEP has a defined
requirement for them.

HIEP's default PowerShell runtime is PowerShell 7.4 or later.