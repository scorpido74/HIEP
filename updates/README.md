# HIEP Project Updates

This directory contains the structured project history of the Healthcare Identity Eco Platform (HIEP).

Project updates document meaningful events in the development of HIEP and provide the canonical editorial source for the HIEP project timeline.

## Purpose

Project updates explain not only what changed, but also why a development matters to the wider HIEP project.

Updates may describe:

* project milestones;
* development activities;
* architecture changes;
* documentation developments;
* governance activities;
* research;
* releases.

Individual Git commits remain the authoritative implementation history.

Project updates provide the higher-level project history.

## Structure

Updates are organised by year:

```text
updates/
├── README.md
├── 2026/
│   ├── 2026-07-06-project-start.md
│   └── 2026-09-15-document-framework.md
└── 2027/
```

Each project update is stored as a Markdown file containing YAML front matter.

## File Naming

Project update files use the following naming convention:

```text
YYYY-MM-DD-short-description.md
```

Example:

```text
2026-09-15-document-framework.md
```

## Project Update Identifiers

Every project update receives a permanent identifier using the dedicated Project Update namespace:

```text
HIEP-UPD-NNNN
```

Example:

```text
HIEP-UPD-0001
```

Project Update identifiers are separate from managed HIEP document identifiers.

The `UPD` namespace MUST NOT be treated as a managed HIEP document type.

## Chronology

The date stored in project update metadata determines its chronological position.

Project Update identifiers provide stable identity and MUST NOT be used to determine chronological order.

This allows historical events to be documented retrospectively.

## Source of Truth

Markdown files in this directory are the canonical editorial source for HIEP project history.

Generated representations such as:

* portal pages;
* timeline JSON;
* RSS or Atom feeds;
* dashboards;
* search indexes;

are derived artifacts and are not authoritative.

## GitHub Integration

The future HIEP Project Portal may enrich project updates with information obtained from GitHub, including:

* commits;
* issues;
* pull requests;
* releases;
* milestones;
* contributors.

Automatically obtained GitHub activity does not replace manually maintained project updates.

## Standard

All project updates MUST comply with:

```text
standards/Project-Update-Standard.md
```

Future HIEP tooling will provide commands for creating, retrieving, and validating project updates.
