# HIEP Project Update Standard

## 1. Purpose

This standard defines how project updates are documented within the Healthcare Identity Eco Platform (HIEP) repository.

Project updates provide a structured, chronological, human-readable, and machine-readable history of the development of HIEP.

They form the canonical editorial source for the HIEP project timeline and may be consumed by HIEP tooling, documentation generators, automation, and the HIEP Project Portal.

The standard is designed to support:

* chronological project history;
* project milestones;
* development updates;
* architecture decisions and changes;
* documentation changes;
* governance activities;
* research activities;
* release information;
* links between project updates and Git history;
* future publication through the HIEP Project Portal.

Project updates MUST be stored as Markdown files and MUST contain machine-readable YAML front matter.

---

## 2. Design Principles

HIEP project updates follow the principles defined in this section.

### 2.1 Git-native

Project history MUST remain part of the HIEP Git repository.

A separate content management system or database MUST NOT be required to maintain the canonical HIEP project history.

Git provides versioning, traceability, reviewability, and historical preservation of project updates.

### 2.2 Human-readable

Every project update MUST be understandable as a standalone Markdown document.

A reader SHOULD be able to understand the significance of an update without having to inspect the associated Git commits.

### 2.3 Machine-readable

Project update metadata MUST be structured so that HIEP tooling can validate, query, sort, filter, transform, and publish updates.

YAML front matter MUST be used for structured metadata.

### 2.4 Traceable

Where applicable, project updates SHOULD reference the repository artifacts associated with the documented event.

These artifacts may include:

* Git commits;
* GitHub issues;
* pull requests;
* releases;
* HIEP documents;
* architecture decisions.

### 2.5 Immutable history

Published project updates SHOULD represent historical events.

Existing updates SHOULD NOT be rewritten merely to reflect the current state of the project.

Corrections MAY be made when information is factually incorrect.

When a previous project decision or update is replaced by another decision, the original update SHOULD remain available and MAY use the `superseded` status.

### 2.6 Separation of project history and implementation history

Git commits represent implementation history.

Project updates represent meaningful project history.

These concepts MUST remain separate.

Not every Git commit requires a project update.

A single project update MAY reference multiple Git commits.

---

## 3. Repository Structure

Project updates MUST be stored below the repository-level `updates` directory.

The required structure is:

```text
updates/
├── README.md
└── YYYY/
    └── YYYY-MM-DD-update-name.md
```

Example:

```text
updates/
├── README.md
└── 2026/
    ├── 2026-07-06-project-start.md
    ├── 2026-09-15-document-framework.md
    └── 2026-09-17-document-id-allocation.md
```

The year directory MUST correspond to the year defined by the update `date` property.

Project updates SHOULD NOT be stored directly in the root of the `updates` directory.

The `updates/README.md` file SHOULD explain the purpose and structure of the project update repository.

---

## 4. File Naming

Project update filenames MUST use the following format:

```text
YYYY-MM-DD-short-description.md
```

Example:

```text
2026-09-17-document-id-allocation.md
```

The following requirements apply:

* the date MUST use ISO 8601 calendar format;
* the description MUST use lowercase characters;
* words MUST be separated using hyphens;
* filenames MUST NOT contain spaces;
* filenames SHOULD remain concise;
* the filename date MUST correspond to the `date` property in the YAML front matter.

A filename SHOULD describe the primary event represented by the update.

---

## 5. Project Update Identifier

Every project update MUST have a unique HIEP Project Update identifier.

The identifier format is:

```text
HIEP-UPD-NNNN
```

Example:

```text
HIEP-UPD-0001
```

Project Update identifiers MUST:

* be unique within the repository;
* contain four numeric digits;
* never be reused;
* remain unchanged after publication.

Identifiers SHOULD be allocated sequentially.

Identifiers MUST NOT be interpreted as authoritative chronological information.

The `date` property is the authoritative value for chronological ordering.

This allows historical project events to be documented retrospectively without changing their actual event date.

---

## 6. YAML Front Matter

Every project update MUST begin with YAML front matter.

The minimum required metadata is:

```yaml
---
id: HIEP-UPD-0001
title: HIEP Document Framework completed
date: 2026-09-15
type: milestone
status: completed
summary: The initial HIEP document framework has been established.
tags:
  - documentation
  - tooling
---
```

The YAML front matter MUST appear at the beginning of the Markdown file.

The opening and closing delimiters MUST consist of three hyphens:

```text
---
```

Additional metadata MAY be included as defined by this standard.

---

## 7. Required Metadata Properties

### 7.1 `id`

Required.

Defines the unique HIEP Project Update identifier.

Example:

```yaml
id: HIEP-UPD-0001
```

The value MUST comply with the identifier format defined in this standard.

---

### 7.2 `title`

Required.

Defines the short human-readable title of the update.

Example:

```yaml
title: HIEP Document Framework completed
```

Titles SHOULD describe the project outcome rather than an individual implementation detail.

Titles SHOULD be suitable for direct display in the HIEP Project Portal.

---

### 7.3 `date`

Required.

Defines the date on which the documented project event occurred.

The value MUST use ISO 8601 calendar format:

```yaml
date: 2026-09-15
```

The date MUST correspond to the date contained in the filename.

The date is the authoritative value used for chronological ordering.

---

### 7.4 `type`

Required.

Defines the primary category of the project update.

Allowed values are:

```text
development
documentation
architecture
governance
research
release
milestone
```

An update MUST have exactly one primary type.

Additional classification MAY be provided through tags.

#### development

Used for meaningful implementation or tooling developments.

#### documentation

Used for significant documentation changes or additions.

#### architecture

Used for architecture developments, changes, or important technical design events.

#### governance

Used for governance, policy, ownership, lifecycle, or organisational developments.

#### research

Used for research activities, findings, investigations, and exploratory work.

#### release

Used for official HIEP releases or release-related events.

#### milestone

Used for significant project achievements or transitions.

---

### 7.5 `status`

Required.

Defines the lifecycle state of the project update.

Allowed values are:

```text
planned
in-progress
completed
cancelled
superseded
```

#### planned

The documented activity or milestone is planned but has not started.

#### in-progress

The documented activity is currently being performed.

#### completed

The documented activity or milestone has been completed.

Historical timeline entries will normally use `completed`.

#### cancelled

The planned activity has been cancelled.

Cancelled updates SHOULD remain in the project history when their existence provides meaningful historical context.

#### superseded

The update or decision has been replaced by a later project development.

The superseding update SHOULD reference the earlier update where appropriate.

---

### 7.6 `summary`

Required.

Provides a concise description of the project event.

Example:

```yaml
summary: The initial HIEP document framework has been established.
```

The summary:

* SHOULD describe the outcome of the update;
* SHOULD be understandable without reading the Markdown body;
* SHOULD be suitable for direct display in a timeline;
* SHOULD remain concise.

---

### 7.7 `tags`

Required.

Provides additional classification for the project update.

Example:

```yaml
tags:
  - documentation
  - powershell
  - automation
```

Tags MUST:

* use lowercase characters;
* use hyphens for multi-word values;
* NOT contain spaces.

Tags SHOULD describe technologies, project areas, components, or concepts associated with the update.

---

## 8. Traceability Metadata

Project updates MAY reference related repository artifacts.

Traceability metadata allows the HIEP Project Portal and supporting tooling to connect project history with technical implementation history.

---

### 8.1 `commits`

Defines Git commits associated with the project update.

Example:

```yaml
commits:
  - 26331ad
  - 47c550d
```

Short Git commit hashes MAY be used when they uniquely identify a commit within the repository.

A project update MAY reference one or multiple commits.

The absence of a commit reference does not invalidate a project update.

---

### 8.2 `issues`

Defines related GitHub issue numbers.

Example:

```yaml
issues:
  - 12
  - 18
```

Issue references MUST contain the numeric GitHub issue number.

---

### 8.3 `pullRequests`

Defines related GitHub pull request numbers.

Example:

```yaml
pullRequests:
  - 21
```

Pull request references MUST contain the numeric GitHub pull request number.

---

### 8.4 `releases`

Defines related HIEP releases or Git tags.

Example:

```yaml
releases:
  - v0.1.0
```

Multiple releases MAY be referenced when appropriate.

---

### 8.5 `documents`

Defines related HIEP document identifiers.

Example:

```yaml
documents:
  - HIEP-ARC-0001
  - HIEP-SEC-0002
```

Document references SHOULD use the canonical HIEP document identifier.

---

### 8.6 `architectureDecisions`

Defines related HIEP Architecture Decision Record identifiers.

Example:

```yaml
architectureDecisions:
  - HIEP-ADR-0003
```

Architecture Decision references SHOULD use the canonical ADR identifier defined by the HIEP architecture documentation framework.

---

## 9. Document Content

After the YAML front matter, a project update SHOULD contain enough context to explain the significance of the event.

The recommended structure is:

```markdown
# Update title

## Summary

Short explanation of what happened.

## Why this matters

Explanation of why the change is relevant to HIEP.

## Changes

Description of the important changes.

## Related work

References or explanation of related project work.

## Next steps

Relevant follow-up work.
```

Not every section is required.

Small project updates MAY contain only a short description.

Major milestones SHOULD provide sufficient context to understand the event without reading the associated Git commits.

---

## 10. Summary Section

The `Summary` section SHOULD explain what happened in plain language.

It SHOULD focus on the project outcome rather than individual implementation steps.

Example:

```markdown
## Summary

The initial HIEP document framework has been established.

The framework provides standards, document templates, metadata parsing,
and document identifier allocation.
```

---

## 11. Why This Matters Section

The `Why this matters` section SHOULD explain the relevance of the update to the wider HIEP project.

This section is particularly useful for:

* architecture changes;
* milestones;
* governance decisions;
* major tooling developments;
* strategic documentation changes.

The section SHOULD answer the question:

> Why is this development important to HIEP?

---

## 12. Changes Section

The `Changes` section MAY describe the concrete work performed.

Example:

```markdown
## Changes

The following capabilities were introduced:

- HIEP document metadata parsing;
- repository configuration helpers;
- document identifier allocation;
- standard document templates.
```

The section SHOULD NOT simply reproduce Git commit messages.

It SHOULD provide useful project-level context.

---

## 13. Related Work Section

The `Related work` section MAY provide additional context about associated work.

This may include references to:

* documents;
* architecture decisions;
* standards;
* source modules;
* previous project updates;
* GitHub issues;
* pull requests;
* releases.

Structured references SHOULD also be included in the YAML metadata where supported.

---

## 14. Next Steps Section

The `Next steps` section MAY describe logical follow-up activities.

Example:

```markdown
## Next steps

The document framework will be used as the foundation for structured
project updates and the HIEP Project Portal.
```

The section is informational and MUST NOT be treated as an authoritative task management system.

GitHub Issues, milestones, or other designated project management mechanisms SHOULD remain authoritative for actionable work.

---

## 15. Timeline Behaviour

The HIEP Project Portal MUST use the `date` property as the primary chronological value.

When multiple updates share the same date, implementations SHOULD use the project update identifier as a stable secondary ordering mechanism.

Timeline consumers SHOULD support filtering by:

* type;
* status;
* tags;
* year.

The `summary` property SHOULD be suitable for display without parsing the Markdown body.

The timeline MAY combine manually maintained project updates with automatically obtained GitHub activity.

Project updates MUST remain distinguishable from automatically generated GitHub activity.

---

## 16. Relationship with Git History

Git history and HIEP project history serve different purposes.

Git commits answer questions such as:

* what source file changed;
* who committed the change;
* when the implementation changed;
* what implementation message was recorded.

Project updates answer questions such as:

* what happened within HIEP;
* why the development matters;
* which project capability was introduced;
* which larger milestone was achieved;
* how the development relates to other HIEP work.

Not every Git commit requires a project update.

A project update SHOULD be created when a change is meaningful to the development, architecture, governance, documentation, research, release, or overall progress of HIEP.

A single project update MAY reference multiple Git commits.

Multiple project updates MAY reference the same commit when that commit contributes to multiple meaningful project events.

---

## 17. Historical Updates

Project updates MAY be created retrospectively.

This is particularly useful when establishing the initial HIEP project timeline from existing Git history.

For retrospective updates:

* the `date` MUST represent the actual historical event date;
* the update identifier MUST use the next available identifier;
* the identifier MUST NOT be altered to simulate historical ordering;
* associated commits SHOULD be referenced where known.

For example, `HIEP-UPD-0010` MAY describe an event that occurred before `HIEP-UPD-0005`.

Chronological ordering MUST therefore always use `date`, not `id`.

---

## 18. Validation

HIEP tooling SHOULD validate project updates before they are committed or published.

Validation SHOULD include at least:

* valid YAML front matter;
* presence of all required metadata properties;
* valid project update identifier;
* valid date format;
* valid type;
* valid status;
* valid tag format;
* valid filename format;
* agreement between filename date and metadata date;
* agreement between directory year and metadata year;
* uniqueness of the project update identifier.

Validation MAY additionally verify:

* referenced Git commits;
* HIEP document identifiers;
* Architecture Decision identifiers;
* GitHub issue references;
* GitHub pull request references;
* release references.

Validation SHOULD return actionable error information when an update does not comply with this standard.

---

## 19. Tooling

HIEP tooling MAY provide functions for creating, retrieving, and validating project updates.

Expected tooling includes:

```text
New-HIEPProjectUpdate
Get-HIEPProjectUpdate
Test-HIEPProjectUpdate
```

### `New-HIEPProjectUpdate`

Creates a new project update using the required structure and metadata.

The function SHOULD:

* determine the next available project update identifier;
* validate supplied metadata;
* determine the correct year directory;
* generate a compliant filename;
* create YAML front matter;
* create the initial Markdown structure.

### `Get-HIEPProjectUpdate`

Reads and returns structured project update information.

The function SHOULD support retrieving updates by:

* identifier;
* date;
* type;
* status;
* tag.

### `Test-HIEPProjectUpdate`

Validates one or more project updates against this standard.

The function SHOULD provide structured validation results suitable for both interactive use and CI/CD automation.

---

## 20. Portal Integration

Project updates are the canonical editorial source for the HIEP Project Portal timeline.

Portal tooling MAY combine project updates with information obtained from GitHub, including:

* commits;
* issues;
* pull requests;
* releases;
* milestones;
* contributors.

Automatically obtained GitHub activity MUST NOT modify the canonical project update Markdown files.

Generated portal data SHOULD be treated as build output and MUST NOT become the authoritative project history.

A future portal build process MAY transform project updates into formats such as JSON for efficient consumption by the web application.

Example:

```text
updates/*.md
      │
      ▼
HIEP validation
      │
      ▼
timeline generator
      │
      ▼
portal/data/timeline.json
      │
      ▼
HIEP Project Portal
```

---

## 21. Source of Truth

The Markdown project update stored in the HIEP repository is the authoritative source for editorial project history.

Generated representations are derived artifacts.

Examples of derived artifacts include:

* JSON timeline files;
* HTML pages;
* RSS or Atom feeds;
* portal search indexes;
* project dashboards;
* timeline visualisations.

Derived artifacts MUST NOT replace the original Markdown project update as the source of truth.

---

## 22. Future Extensions

This standard is intentionally designed to allow future metadata extensions.

Potential future properties include:

```text
authors
contributors
sprint
phase
components
vendors
externalReferences
visibility
featured
```

Future extensions MUST preserve compatibility with existing project updates.

New required properties SHOULD NOT be introduced without considering migration of existing project updates.

Portal-specific presentation metadata SHOULD be kept to a minimum to prevent project history from becoming coupled to a specific frontend implementation.

---

## 23. Complete Example

The following example represents a complete HIEP project update.

```yaml
---
id: HIEP-UPD-0001
title: HIEP Document Framework completed
date: 2026-09-15
type: milestone
status: completed
summary: The initial standards, templates, metadata model, and document tooling for the HIEP document framework have been established.
tags:
  - documentation
  - powershell
  - automation
commits:
  - 26331ad
  - 47c550d
---
```

```markdown
# HIEP Document Framework completed

## Summary

The initial HIEP document framework has been established.

The framework provides standards, document templates, metadata parsing,
repository configuration helpers, and document identifier allocation.

## Why this matters

HIEP now has a consistent foundation for creating and managing project
documentation as the repository grows.

Documentation can be created according to common standards while tooling
can consume the associated metadata programmatically.

This foundation also enables project history to be managed using the same
Git-native principles.

## Changes

The document framework introduced:

- HIEP document standards;
- Markdown standards;
- document lifecycle conventions;
- specialised document templates;
- repository and configuration helpers;
- document metadata parsing;
- automatic document identifier allocation.

## Related work

This milestone forms the foundation for the HIEP Project Update framework
and the future HIEP Project Portal.

## Next steps

Structured HIEP project updates will be introduced.

These updates will provide the canonical editorial data source for the
project timeline and future HIEP Project Portal.
```

---

## 24. Compliance

A project update is compliant with this standard when:

1. it is stored in the required repository location;
2. its filename follows the required naming convention;
3. it contains valid YAML front matter;
4. all required metadata properties are present;
5. metadata values comply with the formats and enumerations defined by this standard;
6. its identifier is unique;
7. its filename date, metadata date, and directory year are consistent.

HIEP automation SHOULD enforce these requirements before project updates are published.
