---
id: HIEP-UPD-0008
title: HIEP public project portal launched
date: 2026-09-21
type: milestone
status: completed
summary: The HIEP public project portal is now live through GitHub Pages, with automated validation, timeline generation and deployment from the repository.
tags:
  - portal
  - github-pages
  - automation
  - deployment
  - milestone
commits:
  - 134f701
---
# HIEP public project portal launched

## Summary

The HIEP public project portal is now live through GitHub Pages, with automated validation, timeline generation and deployment from the repository.

## Why this matters

This milestone makes the HIEP project publicly accessible through a dedicated project portal. The portal provides a foundation for communicating project progress and makes the Project Update history available outside the repository.

The publication process is repository-driven, keeping the Markdown Project Updates as the source of truth while generating the public timeline automatically.

## Changes

- Added the public HIEP project portal using static HTML, CSS and JavaScript.
- Added GitHub Actions validation for HIEP Project Updates.
- Added automatic generation of `portal/data/timeline.json` from Project Update Markdown files.
- Added GitHub Pages artifact creation and deployment.
- Configured deployment from the `main` branch.
- Published the HIEP repository publicly.
- Verified the deployed portal over HTTPS with an HTTP 200 response.
- Verified that the generated public timeline contains all existing Project Updates.

## Related work

This milestone builds on the HIEP Project Update framework, update validation, timeline generation tooling and the initial public portal implementation.

The initial HIEP platform foundation was merged into `main` through pull request #1 in commit `134f701`.

## Next steps

Continue expanding the public portal with project documentation, roadmap information, architecture content and other HIEP project resources while keeping publication automated through the repository.
