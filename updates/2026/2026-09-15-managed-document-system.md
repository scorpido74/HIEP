---
id: HIEP-UPD-0004
title: HIEP managed document system established
date: 2026-09-15
type: milestone
status: completed
summary: HIEP established its managed document system with document type configuration, standardized templates, repository helpers, and metadata parsing.
tags:
  - documentation
  - configuration
  - templates
  - tooling
  - metadata
commits:
  - 2ecab77
  - 75e6793
  - 82518bf
  - fa24407
  - 6c2977b
  - 68b9cc5
  - 11723be
  - 342983b
  - d32d94a
  - ce77e19
  - 6ea07cd
---

# HIEP managed document system established

## Summary

HIEP established the initial managed document system for creating,
organising, and processing structured project documentation.

The system introduced configured document types, standardized document
templates, repository and configuration helpers, and metadata parsing
capabilities.

Together, these components provide the foundation for managing HIEP
documents consistently through both repository conventions and PowerShell
tooling.

## Why this matters

HIEP documentation spans multiple areas including architecture, business,
security, vendors, governance, and terminology.

Managing these documents consistently requires more than Markdown formatting
conventions alone.

Documents need stable structures, recognizable types, reusable templates,
machine-readable metadata, and tooling capable of discovering and processing
them.

The managed document system establishes this technical foundation.

It also creates a clear separation between managed HIEP documents and other
repository content such as Project Updates.

## Changes

The managed document system introduced:

- configuration for supported HIEP document types;
- a generic HIEP document template;
- architecture document templates;
- business document templates;
- security document templates;
- vendor document templates;
- governance document templates;
- glossary document templates;
- repository discovery helpers;
- configuration loading helpers;
- document metadata parsing.

The generic document template was also refined to remain neutral so that
document-type-specific conventions could be implemented by dedicated
templates.

## Related work

This update builds on the HIEP document framework documented by
`HIEP-UPD-0003`.

The document framework defines the standards and conventions, while the
managed document system implements the structures and tooling required to
apply those conventions within the repository.

Document identifier allocation was introduced subsequently as a separate
capability.

## Next steps

The managed document system will be extended with automatic document
identifier allocation.

This will allow HIEP tooling to determine the next available identifier for a
managed document type while preserving the stable HIEP document identity
model.
