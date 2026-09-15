# HIEP Naming Conventions

## Purpose

This document defines naming conventions used throughout the Healthcare Identity Eco
Platform.

Consistency is preferred over personal naming preferences.

## Project Name

Use:

**Healthcare Identity Eco Platform**

Use the abbreviation:

**HIEP**

Do not introduce alternative expansions of HIEP.

## Document Prefix

Managed HIEP documents use the prefix:

`HIEP`

Examples:

- `HIEP-BUS-001.md`
- `HIEP-ARC-001.md`
- `HIEP-SEC-001.md`
- `HIEP-VND-001.md`
- `HIEP-GOV-001.md`

## Document Categories

Preferred category identifiers include:

| Identifier | Category |
|---|---|
| BUS | Business |
| ARC | Architecture |
| SEC | Security |
| VND | Vendor |
| INT | Integration |
| DEM | Demo platform |
| WKS | Workshop |
| MKT | Marketing |
| GOV | Governance |
| GLS | Glossary |
| ADR | Architecture Decision Record |

Additional identifiers may be introduced when documented and consistently applied.

## Numbering

Numbered documents use three digits.

Examples:

`001`

`002`

`010`

`100`

Do not use:

`1`

`01`

## Markdown Files

Use descriptive PascalCase or the managed HIEP document convention depending on the
purpose of the file.

Examples:

`Architecture-Principles.md`

`Document-Lifecycle.md`

`HIEP-ARC-001.md`

## Directories

Use lowercase directory names unless a technical convention requires otherwise.

Examples:

`docs`

`templates`

`workshops`

`diagrams`

## PowerShell

Use approved PowerShell verb-noun naming.

Examples:

`Get-HIEPConfiguration`

`Test-HIEPConfiguration`

`Initialize-HIEPContent`

HIEP-specific functions should normally use `HIEP` in the noun.

## PowerShell Variables

Use PascalCase for variables.

Examples:

`$RepositoryRoot`

`$ConfigurationPath`

`$TemplatePath`

Avoid cryptic abbreviations.

## JSON

Use camelCase for JSON properties.

Examples:

`defaultBranch`

`overwriteExisting`

`populateEmptyFiles`

`sharedContext`

## Mermaid

Use short, stable node identifiers and readable labels.

Example:

```text
IdP["Identity Provider"]
App["Healthcare Application"]

Do not use generated random identifiers unless required.

Git Branches

Preferred branch prefixes include:

feature/

fix/

docs/

refactor/

chore/

Examples:

feature/content-bootstrap

docs/security-architecture

Commits

HIEP uses Conventional Commits.

Examples:

feat: add content bootstrap

fix: correct repository path validation

docs: add architecture principles

refactor: simplify bootstrap configuration

chore: update development settings

General Rule

Names should communicate intent without requiring repository-specific tribal
knowledge.

When introducing a new naming pattern, document it before using it broadly.


## 9. `build/templates/ai/WRITING_STANDARDS.md`

```markdown
# HIEP Writing Standards

## Purpose

This document defines writing standards for HIEP documentation and AI-generated
content.

## Language

Use clear, professional and direct language.

Prefer short sentences where possible.

Avoid unnecessary marketing language, vague claims and inflated terminology.

## Audience

HIEP content may be read by:

- security architects;
- identity specialists;
- pre-sales consultants;
- system engineers;
- healthcare IT professionals;
- decision makers;
- partners;
- vendors.

Write for the intended audience of the specific document.

## Structure

Use meaningful headings.

Prefer:

1. context;
2. purpose;
3. requirements or problem;
4. design or explanation;
5. implications;
6. risks or considerations;
7. next steps where applicable.

Do not force this structure where it does not fit.

## Terminology

Use terminology consistently.

Prefer terminology defined in the HIEP glossary when available.

Expand uncommon abbreviations on first use.

## Technical Claims

Distinguish clearly between:

- fact;
- requirement;
- recommendation;
- assumption;
- decision;
- example;
- vendor claim;
- open question.

Do not present recommendations as mandatory requirements unless they actually are
requirements.

## Vendor Content

Avoid promotional wording.

Instead of:

> Product X provides the industry's most secure identity platform.

Prefer:

> Product X provides the following identity capabilities relevant to this design.

Where a claim originates from a vendor, make that provenance clear when relevant.

## Security Writing

Security recommendations should explain why a control is relevant.

Prefer:

> Phishing-resistant authentication reduces reliance on reusable authentication
> secrets and should be considered for privileged access.

Avoid unexplained statements such as:

> MFA must always be enabled.

## Architecture Writing

Architecture documentation should identify:

- scope;
- actors;
- systems;
- trust boundaries;
- dependencies;
- data or identity flows;
- security controls;
- assumptions;
- decisions;
- risks.

## Evidence

Use sources for factual or time-sensitive claims where appropriate.

Do not invent references.

If evidence is unavailable, state that validation is required.

## AI-Generated Content

AI-generated drafts require the same quality standards as manually written content.

AI output must not automatically be considered approved HIEP content.

Generated material should be reviewed before its lifecycle status is changed to an
approved state.

## Markdown

Follow `standards/Markdown-Standards.md`.

## Diagrams

Follow `standards/Mermaid-Standards.md` for Mermaid diagrams.

## Tone

HIEP writing should be:

- professional;
- factual;
- pragmatic;
- concise where possible;
- technically precise;
- vendor-neutral by default.

The goal is useful documentation, not impressive-sounding documentation.