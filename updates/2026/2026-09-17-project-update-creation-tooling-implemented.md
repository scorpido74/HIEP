---
id: HIEP-UPD-0007
title: Project Update creation tooling implemented
date: 2026-09-17
type: development
status: completed
summary: HIEP can now create structured Project Updates through its PowerShell tooling.
tags:
  - tooling
  - powershell
  - project-updates
---

# Project Update creation tooling implemented

## Summary

HIEP can now create structured Project Updates through its PowerShell tooling.

## Why this matters

Project Updates previously required authors to create the file structure,
identifier, metadata, and standard sections manually.

That process was consistent with the Project Update Standard but still left
room for naming errors, duplicate identifiers, incorrect year placement, and
invalid metadata.

Automating creation moves these conventions into HIEP tooling and makes the
standard easier to apply consistently.

## Changes

The HIEP PowerShell module introduced `New-HIEPProjectUpdate`.

The command:

- resolves the HIEP repository root;
- obtains the next identifier through `Get-HIEPProjectUpdateId`;
- determines the update date and year;
- creates the required year directory when necessary;
- generates a filename slug from the update title;
- creates the YAML front matter;
- writes the standard Project Update sections;
- optionally records related commit references;
- validates the generated update through `Get-HIEPProjectUpdate`;
- returns the created update file.

Git staging and commits remain explicit operations and are not performed by
the Project Update creation command.

## Related work

This capability builds on the Project Update framework introduced in
`HIEP-UPD-0006`.

It combines the identifier allocation provided by
`Get-HIEPProjectUpdateId` with the metadata parsing and validation provided by
`Get-HIEPProjectUpdate`.

This Project Update was itself created using `New-HIEPProjectUpdate`,
providing the first end-to-end use of the Project Update creation tooling.

## Next steps

The Project Update tooling can be extended with repository-wide validation so
that all updates can be checked for metadata validity, identifier uniqueness,
filename conventions, date placement, and other requirements defined by the
Project Update Standard.

The validated Project Update collection can subsequently become an input for
automatically generated HIEP timelines and portal content.
