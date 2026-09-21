---
id: HIEP-UPD-0006
title: HIEP Project Update framework introduced
date: 2026-09-17
type: milestone
status: completed
summary: HIEP introduced a structured Project Update framework as the editorial source for chronological project history and future portal timelines.
tags:
  - project-updates
  - timeline
  - documentation
  - tooling
  - metadata
commits:
  - b1804e8
  - 581da1a
  - 25e137b
  - 62b86ec
---

# HIEP Project Update framework introduced

## Summary

HIEP introduced a structured Project Update framework for maintaining a
chronological and machine-readable history of the project.

Project Updates provide an editorial layer above individual Git commits and
are intended to become a primary source for the future HIEP project timeline
and portal.

## Why this matters

Git commits provide detailed implementation history, but they do not by
themselves provide a concise project-level narrative.

A project timeline needs to explain what changed, why it mattered, how the
change relates to previous work, and what comes next.

Project Updates provide this context while remaining fully Git-native.

## Changes

The Project Update framework introduced:

- the HIEP Project Update Standard;
- the `updates/` repository structure;
- year-based organisation of Project Updates;
- the dedicated `HIEP-UPD-NNNN` identifier namespace;
- structured YAML front matter;
- defined update types and statuses;
- optional GitHub and document traceability;
- historical Project Updates for earlier HIEP milestones;
- PowerShell metadata parsing through `Get-HIEPProjectUpdate`;
- automatic Project Update identifier allocation through
  `Get-HIEPProjectUpdateId`.

Project Update identifiers are intentionally independent from managed HIEP
document identifiers.

## Related work

The initial historical Project Updates establish the project narrative from
the repository foundation through the document framework and managed document
system.

The framework complements Git history rather than replacing it. Git commits
remain the implementation-level source of truth, while Project Updates provide
the project-level narrative.

## Next steps

HIEP tooling will be extended with Project Update creation and validation
capabilities.

Future portal tooling can then consume Project Updates together with GitHub
metadata to generate project timelines, status views, roadmap information, and
project news.
