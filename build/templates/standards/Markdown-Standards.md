# HIEP Markdown Standards

## Purpose

This standard defines Markdown conventions for HIEP documentation.

## Headings

Use one level-one heading per document.

Use hierarchical headings without skipping levels.

Preferred:

```text
# Title
## Section
### Subsection
```

## Paragraphs

Separate paragraphs with a blank line.

Avoid manual line breaks solely for visual formatting unless required.

## Lists

Use `-` for unordered lists.

Use numbered lists where order matters.

Keep list structures simple and readable.

## Tables

Use Markdown tables for compact structured information.

Avoid very wide tables when prose or separate sections are easier to read.

## Code

Use fenced code blocks and specify the language where practical.

Example:

```powershell
Get-Item .
```

For JSON:

```json
{
  "enabled": true
}
```

## File Paths

Use inline code formatting for repository paths.

Example:

`docs/02-architecture/HIEP-ARC-001.md`

## Commands

Use inline code for short commands and fenced code blocks for command sequences.

## Links

Use descriptive link text.

Avoid generic descriptions such as `click here`.

## Emphasis

Use bold text sparingly for important concepts.

Do not use excessive emphasis as a substitute for document structure.

## Diagrams

Use Mermaid where appropriate.

Complex diagrams may use Draw.io when Mermaid does not provide sufficient clarity.

## HTML

Avoid embedded HTML unless Markdown cannot reasonably express the requirement.

## Generated Content

Generated Markdown must follow the same standards as manually authored content.

## Portability

Prefer Markdown that renders correctly in common Git-based repository platforms and
editors.

Avoid tool-specific Markdown extensions unless there is a defined HIEP requirement.