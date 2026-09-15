# HIEP Document Standard

## Purpose

This standard defines the common document contract for managed documentation
within the Healthcare Identity Eco Platform (HIEP).

The purpose of this standard is to ensure that HIEP documentation can be
created, identified, managed, validated and processed consistently.

This standard defines:

- document identification;
- document types;
- document metadata;
- document versioning;
- file naming;
- repository placement;
- document templates;
- automated document creation;
- automated document validation.

Lifecycle rules are defined in `standards/Document-Lifecycle.md`.

Markdown formatting rules are defined in `standards/Markdown-Standards.md`.

Diagram conventions are defined in `standards/Mermaid-Standards.md`.

Architecture-specific principles are defined in
`standards/Architecture-Principles.md`.

## Design Principles

The HIEP Document Framework follows several core principles.

### Markdown First

Managed HIEP documentation uses Markdown as the default source format.

Markdown provides:

- human-readable source files;
- native Git compatibility;
- simple version control;
- broad tooling support;
- automated processing;
- compatibility with AI-assisted workflows.

Markdown formatting must follow `standards/Markdown-Standards.md`.

### Metadata Driven

Every managed HIEP document contains structured metadata.

Metadata must be machine-readable and provide sufficient information to
identify, classify, manage and validate the document.

YAML front matter is the standard metadata format for managed HIEP documents.

### Stable Identity

Every managed HIEP document receives a unique HIEP document identifier.

The identifier represents the permanent identity of the document and must not
change when the document version, lifecycle status, title or filename changes.

### Git as Source of Truth

The HIEP repository is the authoritative source for managed HIEP
documentation.

Git provides:

- change history;
- authorship history;
- review workflows;
- traceability;
- rollback capabilities.

Document metadata complements Git history but does not replace it.

Complete change history should not be duplicated inside individual documents.

### Automation by Default

Document conventions should be deterministic and machine-verifiable.

Where practical, document creation and validation should be performed through
the `HIEP.Tools` PowerShell module.

Automation should use repository configuration instead of duplicating
repository structure or document configuration in code.

## Document Types

HIEP uses document types to classify managed documentation.

| Code | Type | Purpose |
|---|---|---|
| `BUS` | Business | Business requirements, propositions, use cases and business concepts |
| `ARC` | Architecture | Architecture designs, models, patterns and technical decisions |
| `SEC` | Security | Security requirements, controls, threat models and security designs |
| `VND` | Vendor | Vendor-specific integration and implementation documentation |
| `GOV` | Governance | Governance, policies, processes and decision frameworks |
| `GLS` | Glossary | Terminology, definitions and shared vocabulary |

Additional document types may be introduced in future versions of the HIEP
Document Framework.

New document type codes must:

- be unique;
- consist of exactly three characters;
- use uppercase characters.

## Document Identification

Every managed HIEP document must have a unique document identifier.

The identifier format is:

```text
HIEP-{TYPE}-{NUMBER}
```

Examples:

```text
HIEP-BUS-001
HIEP-ARC-001
HIEP-SEC-001
HIEP-VND-001
HIEP-GOV-001
HIEP-GLS-001
```

The components are:

- `HIEP` identifies the Healthcare Identity Eco Platform;
- `TYPE` identifies the document type;
- `NUMBER` identifies the sequence number within that document type.

### Sequence Numbers

Sequence numbers must:

- contain exactly three digits;
- start at `001`;
- be unique within a document type;
- not be reused after a document is deprecated or archived.

Example:

```text
HIEP-ARC-001
HIEP-ARC-002
HIEP-ARC-003
```

Sequence numbers are independent between document types.

For example, both of the following identifiers are valid:

```text
HIEP-ARC-001
HIEP-SEC-001
```

### Stable Document Identity

A document identifier represents the permanent identity of a document.

The identifier must not change when:

- the document version changes;
- the lifecycle status changes;
- the title changes;
- the filename slug changes;
- ownership changes;
- the document is deprecated;
- the document is archived.

For example, `HIEP-ARC-001` remains the same document across versions:

```text
0.1.0
0.2.0
1.0.0
1.1.0
2.0.0
```

Document versions must not be encoded into document identifiers.

## File Naming

Managed HIEP documents should use the following filename format:

```text
{DOCUMENT-ID}-{SLUG}.md
```

Example:

```text
HIEP-ARC-001-identity-architecture.md
```

The filename slug should:

- use lowercase characters;
- use hyphens as separators;
- contain no spaces;
- contain no version number;
- contain no lifecycle status;
- remain reasonably short;
- describe the subject of the document.

Valid example:

```text
HIEP-SEC-003-device-authentication.md
```

Avoid filenames such as:

```text
Security Document Final.md
HIEP-SEC-003-v1.0.md
HIEP-SEC-003-FINAL.md
```

The document identifier is authoritative.

The descriptive slug may change without changing the document identity.

## Document Metadata

Every managed HIEP document must contain YAML front matter at the beginning of
the file.

The standard metadata structure is:

```yaml
---
document:
  id: HIEP-ARC-001
  title: Identity Architecture
  type: ARC
  version: 0.1.0
  status: Draft

  owner: Architecture

  authors:
    - Name

  created: 2026-09-15
  updated: 2026-09-15

  classification: Internal

  reviewers: []
  approvers: []

  tags: []
---
```

## Required Metadata

The following metadata fields are required.

| Field | Description |
|---|---|
| `id` | Unique HIEP document identifier |
| `title` | Human-readable document title |
| `type` | HIEP document type |
| `version` | Document version |
| `status` | Current lifecycle state |
| `owner` | Responsible person, role or team |
| `authors` | Document authors |
| `created` | Original creation date |
| `updated` | Most recent meaningful update |
| `classification` | Information classification |

## Document ID Metadata

The `id` field contains the unique HIEP document identifier.

Example:

```yaml
id: HIEP-ARC-001
```

For the document types defined by this version of the framework, the identifier
must match:

```text
^HIEP-(BUS|ARC|SEC|VND|GOV|GLS)-[0-9]{3}$
```

The document identifier must be unique within the repository.

## Document Title

The `title` field contains the human-readable title of the document.

Example:

```yaml
title: Identity Architecture
```

The title should clearly describe the subject of the document.

The title may change without changing the document identifier.

## Document Type Metadata

The `type` field contains the HIEP document type.

Example:

```yaml
type: ARC
```

The document type must be one of the supported document type codes.

The type must match the type encoded in the document identifier.

Valid:

```yaml
id: HIEP-ARC-001
type: ARC
```

Invalid:

```yaml
id: HIEP-ARC-001
type: SEC
```

## Document Version

The `version` field represents the version of the document.

HIEP document versions use the following format:

```text
MAJOR.MINOR.PATCH
```

Examples:

```text
0.1.0
0.2.0
0.2.1
1.0.0
1.1.0
2.0.0
```

### Development Versions

Documents under development should normally use `0.x.x` versions.

The default version for a newly created document is:

```text
0.1.0
```

### First Approved Version

The first formally approved version should normally use:

```text
1.0.0
```

### Major Version

Increment the major version when a significant change alters the scope,
meaning, architecture, policy, requirements or conclusions of an approved
document.

Example:

```text
1.4.2 -> 2.0.0
```

### Minor Version

Increment the minor version for meaningful additions or changes that do not
fundamentally replace the document.

Example:

```text
1.2.0 -> 1.3.0
```

### Patch Version

Increment the patch version for corrections or clarifications that do not
materially change the meaning of the document.

Examples include:

- spelling corrections;
- formatting corrections;
- broken links;
- minor clarifications.

Example:

```text
1.2.0 -> 1.2.1
```

Git remains the authoritative source for detailed change history.

## Lifecycle Status

The `status` field represents the lifecycle state of the document.

Supported states are:

```text
Draft
Review
Approved
Deprecated
Archived
```

Example:

```yaml
status: Draft
```

New documents must initially use:

```text
Draft
```

Lifecycle semantics, transitions, review, approval, deprecation and archival
requirements are defined in:

`standards/Document-Lifecycle.md`

This standard intentionally does not duplicate those lifecycle rules.

## Document Ownership

The `owner` field identifies the person, role, team or organizational function
responsible for maintaining the document.

Example:

```yaml
owner: Architecture
```

Ownership does not necessarily imply authorship.

Changing document authors does not automatically change document ownership.

## Document Authors

The `authors` field identifies the authors of the document.

Example:

```yaml
authors:
  - Jane Doe
  - John Doe
```

At least one author should normally be defined.

Automation must not invent author identities.

## Document Dates

The `created` field contains the original document creation date.

The `updated` field contains the date of the most recent meaningful document
update.

Both fields use the following format:

```text
YYYY-MM-DD
```

Example:

```yaml
created: 2026-09-15
updated: 2026-09-15
```

The `created` value must remain unchanged throughout the lifetime of the
document.

The `updated` value must not be earlier than `created`.

## Classification

The `classification` field identifies the information classification of the
document.

Initial supported values are:

```text
Public
Internal
Confidential
Restricted
```

New managed HIEP documents should default to:

```yaml
classification: Internal
```

unless another classification is explicitly required.

## Optional Metadata

The following metadata fields are supported but may be empty:

- `reviewers`;
- `approvers`;
- `tags`.

### Reviewers

The `reviewers` field identifies people, roles or teams responsible for
reviewing the document.

Example:

```yaml
reviewers:
  - Security Architecture
  - Platform Architecture
```

An empty list is valid:

```yaml
reviewers: []
```

Review requirements are defined in `standards/Document-Lifecycle.md`.

Automation must not invent reviewers.

### Approvers

The `approvers` field identifies people, roles or governance bodies authorized
to approve the document.

Example:

```yaml
approvers:
  - HIEP Architecture Board
```

An empty list is valid when approval has not yet occurred:

```yaml
approvers: []
```

Approval requirements are defined in `standards/Document-Lifecycle.md`.

Automation must not invent approvers.

### Tags

Tags may be used to improve document discovery and classification.

Example:

```yaml
tags:
  - identity
  - authentication
  - healthcare
```

Tags should:

- use lowercase;
- be concise;
- avoid duplicate meanings;
- not replace document types.

## Repository Organization

Managed documents are organized according to their document type.

The logical document categories are:

| Type | Category |
|---|---|
| `BUS` | Business documentation |
| `ARC` | Architecture documentation |
| `SEC` | Security documentation |
| `VND` | Vendor documentation |
| `GOV` | Governance documentation |
| `GLS` | Glossary documentation |

Physical repository paths should be defined by the HIEP repository
configuration.

Automation should use repository configuration rather than hard-coded paths
where practical.

Framework standards are stored in:

```text
standards/
```

This includes standards such as:

```text
standards/Architecture-Principles.md
standards/Document-Lifecycle.md
standards/HIEP-Document-Standard.md
standards/Markdown-Standards.md
standards/Mermaid-Standards.md
```

## Document Structure

Managed HIEP documents must follow the Markdown conventions defined in:

`standards/Markdown-Standards.md`

A generic HIEP document template provides the common baseline structure for
managed documentation.

Document-type-specific templates may extend that baseline for:

- BUS;
- ARC;
- SEC;
- VND;
- GOV;
- GLS.

Document-specific templates must remain compatible with the metadata contract
defined by this standard.

## Document Templates

The HIEP Document Framework should provide the following templates:

```text
HIEP-Document.md
HIEP-BUS.md
HIEP-ARC.md
HIEP-SEC.md
HIEP-VND.md
HIEP-GOV.md
HIEP-GLS.md
```

`HIEP-Document.md` defines the generic document baseline.

Type-specific templates extend the generic baseline for their respective
document types.

Templates must not redefine or conflict with the common metadata contract.

Template locations should be defined by repository configuration where
practical.

## Document Creation

Managed HIEP documents should be created through `HIEP.Tools` where practical.

The primary document creation command is:

```powershell
New-HIEPDocument
```

Target usage:

```powershell
New-HIEPDocument `
    -Type ARC `
    -Title "Identity Architecture" `
    -Owner "Architecture"
```

`New-HIEPDocument` should:

1. validate the requested document type;
2. determine the next available document identifier;
3. select the appropriate document template;
4. generate the filename slug;
5. populate required metadata;
6. set the initial version to `0.1.0`;
7. set the initial lifecycle status to `Draft`;
8. determine the correct repository location;
9. create the document without overwriting existing content.

Repository locations and template mappings should be obtained from HIEP
configuration rather than duplicated inside the command where practical.

The command should support standard PowerShell safety mechanisms such as
`-WhatIf` where applicable.

## Document Validation

Managed HIEP documents should be validated through:

```powershell
Test-HIEPDocument
```

Validation should verify at minimum:

- YAML front matter exists;
- required metadata fields exist;
- document identifier syntax is valid;
- document type is supported;
- document identifier and type match;
- document version syntax is valid;
- lifecycle status is supported;
- classification is supported;
- date formats are valid;
- `updated` is not earlier than `created`;
- filename contains the correct document identifier;
- document identifier is unique within the repository;
- repository location is valid for the document type.

Additional validation may be performed by specialized standards or
document-type-specific rules.

### Validation Errors

An error represents a violation of the HIEP document contract.

Examples include:

- invalid document identifier;
- missing required metadata;
- unsupported document type;
- document type does not match the identifier;
- invalid version format;
- unsupported lifecycle state;
- duplicate document identifier.

Errors should cause automated document validation to fail.

### Validation Warnings

A warning identifies a potential quality or governance issue that does not
necessarily make the document invalid.

Examples include:

- no reviewers assigned;
- no tags defined;
- optional document sections missing.

Warnings should not automatically cause validation to fail unless explicitly
configured.

### Validation Output

Validation should return actionable results.

Example:

```text
[ERROR] HIEP-ARC-004: Missing required metadata field 'owner'.
[ERROR] HIEP-SEC-002: Document type does not match document ID.
[WARNING] HIEP-BUS-003: No reviewers have been assigned.
```

## HIEP.Tools Integration

The HIEP Document Framework is designed to integrate with the `HIEP.Tools`
PowerShell module.

The module should eventually provide public functionality including:

```powershell
New-HIEPDocument
Test-HIEPDocument
Get-HIEPDocument
```

Supporting functionality may include:

```powershell
Get-HIEPDocumentMetadata
Get-HIEPDocumentId
```

Future functionality may include:

```powershell
Set-HIEPDocumentStatus
Set-HIEPDocumentVersion
Get-HIEPDocumentIndex
Update-HIEPDocumentIndex
```

Public and private functions should follow the existing `HIEP.Tools` module
structure.

Automation must preserve existing document content unless modification is
explicitly requested.

## CI/CD Integration

Document validation should eventually be integrated into repository CI/CD
workflows.

CI/CD validation should be able to validate managed HIEP documents using the
same document contract used by `HIEP.Tools`.

Pull requests containing invalid managed documents should fail document
validation.

Warnings may be reported without blocking a pull request.

This allows the HIEP Document Standard to become an enforceable repository
contract rather than only a written convention.

## AI-Assisted Documentation

AI-generated or AI-modified documentation must follow the same standards as
manually authored documentation.

AI tooling should:

- preserve document identifiers;
- preserve valid metadata;
- use the appropriate document type;
- use the appropriate document template;
- follow HIEP Markdown standards;
- respect document lifecycle rules.

AI tooling must not:

- invent approvals;
- invent reviewers;
- silently change document ownership;
- silently change lifecycle status;
- change document identifiers during normal document updates.

AI-generated content begins as `Draft` unless it has been reviewed and
approved through the applicable HIEP process.

Lifecycle requirements for AI-generated content are defined in
`standards/Document-Lifecycle.md`.

## Related Standards

This standard is part of the HIEP standards framework.

Related standards include:

- `standards/Architecture-Principles.md`;
- `standards/Document-Lifecycle.md`;
- `standards/Markdown-Standards.md`;
- `standards/Mermaid-Standards.md`.

When requirements overlap, the specialized standard governs its respective
subject.

For example:

- lifecycle behavior is governed by `Document-Lifecycle.md`;
- Markdown formatting is governed by `Markdown-Standards.md`;
- Mermaid diagrams are governed by `Mermaid-Standards.md`;
- architecture principles are governed by `Architecture-Principles.md`.

## HIEP v0.3.0 Scope

The minimum HIEP Document Framework scope for v0.3.0 is:

- standard document metadata;
- stable HIEP document identifiers;
- BUS, ARC, SEC, VND, GOV and GLS document types;
- document versioning;
- lifecycle integration;
- generic document template;
- document-type-specific templates;
- `New-HIEPDocument`;
- `Test-HIEPDocument`;
- integration with `HIEP.Tools`.

Advanced governance and workflow automation may be introduced in later
versions.

## Summary

Every managed HIEP document has four fundamental characteristics:

```text
Identity    -> HIEP-ARC-001
Type        -> ARC
Version     -> 0.1.0
Status      -> Draft
```

The document identifier provides stable identity.

The document type defines its purpose.

The version represents the evolution of its content.

The lifecycle status represents its governance state.

Together with standardized metadata, templates, Git and `HIEP.Tools`, these
rules form the common contract for managed HIEP documentation.
