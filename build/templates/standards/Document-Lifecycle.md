# HIEP Document Lifecycle

## Purpose

This standard defines the lifecycle of managed HIEP documentation.

## States

HIEP documents may use the following lifecycle states.

### Draft

The document is under development.

Content may be incomplete and has not been formally reviewed.

### Review

The document is ready for peer or stakeholder review.

Material changes may still be required.

### Approved

The document has completed the required review and is considered an approved HIEP
reference for its defined scope.

### Deprecated

The document remains available for historical or transitional purposes but should not
be used as the preferred current reference.

### Archived

The document is retained for historical purposes and is no longer actively maintained.

## Lifecycle

The normal lifecycle is:

```text
Draft -> Review -> Approved -> Deprecated -> Archived

A document may return from Review to Draft when substantial changes are required.

An Approved document may return to Draft or Review when a new revision is developed.

Metadata

Managed documents should include sufficient metadata to identify:

document identifier;
title;
version;
status;
owner;
last updated date;
reviewers where applicable.
Versioning

Document versioning should reflect meaningful content changes.

Repository Git history remains the detailed change record.

Do not duplicate complete Git history inside every document.

Review

Review depth should be appropriate to the document.

Examples include:

technical review;
architecture review;
security review;
business review;
vendor validation.
Approval

Approval means the document is accepted for its stated scope.

Approval does not mean that information can never change.

Deprecation

Deprecated documents should identify the preferred replacement when one exists.

Archiving

Archived documents should not be silently deleted when historical context remains
valuable.

AI-Generated Content

AI-generated content begins as Draft unless explicitly reviewed and approved through
the applicable HIEP process.

AI generation alone must not change document lifecycle state.


## 14. `build/templates/standards/Markdown-Standards.md`

```markdown
# HIEP Markdown Standards

## Purpose

This standard defines Markdown conventions for HIEP documentation.

## Headings

Use one level-one heading per document.

Example:

```text
# Document Title

Use hierarchical headings without skipping levels.

Prefer:

# Title
## Section
### Subsection

Avoid:

# Title
#### Subsection
Paragraphs

Separate paragraphs with a blank line.

Avoid manual line breaks solely for visual formatting unless required.

Lists

Use - for unordered lists.

Use numbered lists where order matters.

Tables

Use Markdown tables for compact structured information.

Avoid very wide tables when prose or separate sections are easier to read.

Code

Use fenced code blocks and specify the language where practical.

Examples:

```powershell
Get-Item .

and:

```text
```json
{
  "enabled": true
}

## File Paths

Use inline code formatting for repository paths.

Example:

`docs/02-architecture/HIEP-ARC-001.md`

## Commands

Use inline code for short commands and fenced code blocks for command sequences.

## Links

Use descriptive link text.

Avoid generic text such as:

`click here`

## Emphasis

Use bold text sparingly for important concepts.

Do not use excessive emphasis as a substitute for document structure.

## Diagrams

Use Mermaid where appropriate.

Complex diagrams may use Draw.io when Mermaid does not provide sufficient clarity.

## HTML

Avoid embedded HTML unless Markdown cannot reasonably express the requirement.

## Generated Content

Generated Markdown should follow the same standards as manually authored content.

## Portability

Prefer Markdown that renders correctly in common Git-based repository platforms and
editors.

Avoid tool-specific Markdown extensions unless there is a clear HIEP requirement.