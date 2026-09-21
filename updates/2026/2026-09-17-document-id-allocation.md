---
id: HIEP-UPD-0005
title: HIEP document ID allocation implemented
date: 2026-09-17
type: development
status: completed
summary: HIEP introduced automatic identifier allocation for managed documents based on configured document types and existing repository content.
tags:
  - documentation
  - tooling
  - powershell
  - identifiers
commits:
  - 47c550d
---

# HIEP document ID allocation implemented

## Summary

HIEP introduced automatic identifier allocation for managed documents.

The PowerShell tooling can determine the next available identifier for a
configured HIEP document type by inspecting the existing managed documents
within the repository.

## Why this matters

Managed HIEP documents require stable and unique identifiers.

Manually selecting identifiers introduces unnecessary coordination and creates
a risk of duplicate or inconsistent document identities.

Automatic allocation makes identifier assignment deterministic and integrates
document creation more closely with the repository configuration.

## Changes

The HIEP PowerShell module introduced `Get-HIEPDocumentId`.

The command:

- resolves the HIEP repository root;
- uses the configured managed document types;
- identifies the applicable document location;
- scans existing document identifiers;
- determines the highest allocated sequence;
- returns the next available identifier.

Managed document identifiers use the established `HIEP-{TYPE}-{NNN}` format.

## Related work

This capability extends the managed document system described in
`HIEP-UPD-0004`.

Project Update identifiers use a separate `HIEP-UPD-NNNN` namespace and are
not allocated through `Get-HIEPDocumentId`.

## Next steps

The repository will introduce a dedicated Project Update framework with its
own metadata model, parser, and identifier allocation mechanism.
