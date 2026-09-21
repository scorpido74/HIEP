# HIEP Markdown Standards

## Purpose

This standard defines Markdown conventions for HIEP documentation.

It applies to manually authored, generated and AI-assisted Markdown content
stored in the HIEP repository.

Document metadata requirements are defined in
`standards/HIEP-Document-Standard.md`.

## Document Structure

Managed HIEP documents may begin with YAML front matter as defined by
`standards/HIEP-Document-Standard.md`.

After optional YAML front matter, use one level-one heading for the document
title.

Example:

```markdown
---
document:
  id: HIEP-ARC-001
  title: Identity Architecture
  type: ARC
  version: 0.1.0
  status: Draft
---

# Identity Architecture
```

Do not use multiple level-one headings in the same document.

## Headings

Use hierarchical headings without skipping levels.

Preferred:

```text
# Title

## Section

### Subsection
```

Avoid:

```text
# Title

#### Subsection
```

Do not use bold formatting as a substitute for headings.

Preferred:

```markdown
## Architecture
```

Avoid:

```markdown
**## Architecture**
```

## Paragraphs

Separate paragraphs with a blank line.

Avoid manual line breaks solely for visual formatting unless required.

Prefer natural Markdown wrapping and allow the renderer to control presentation.

## Lists

Use `-` for unordered lists.

Example:

```markdown
- first item;
- second item;
- third item.
```

Use numbered lists where order matters.

Example:

```markdown
1. create the document;
2. validate the metadata;
3. submit the document for review.
```

Keep list structures simple and readable.

Avoid unnecessary nesting.

## Tables

Use Markdown tables for compact structured information.

Example:

```markdown
| Code | Type |
|---|---|
| `ARC` | Architecture |
| `SEC` | Security |
```

Avoid very wide tables when prose or separate sections are easier to read.

Keep table content concise.

## Code

Use fenced code blocks for multi-line code, configuration and command examples.

Specify the language where practical.

PowerShell example:

```powershell
Get-Item .
```

JSON example:

```json
{
  "enabled": true
}
```

YAML example:

```yaml
document:
  id: HIEP-ARC-001
  status: Draft
```

Use `text` when the content does not have a more appropriate language.

Example:

```text
Draft -> Review -> Approved
```

All fenced code blocks must be correctly closed.

## Inline Code

Use inline code for:

- commands;
- filenames;
- repository paths;
- configuration keys;
- document identifiers;
- metadata values when appropriate;
- technical terms that represent literal values.

Examples:

```text
`New-HIEPDocument`
`HIEP-ARC-001`
`standards/Markdown-Standards.md`
`status`
```

Do not use inline code solely for visual emphasis.

## File Paths

Use inline code formatting for repository paths.

Example:

```text
`standards/HIEP-Document-Standard.md`
```

Managed document filenames should follow the conventions defined in
`standards/HIEP-Document-Standard.md`.

Example:

```text
`HIEP-ARC-001-identity-architecture.md`
```

Use `/` as the repository path separator in documentation, including when
commands are executed from Windows environments.

Preferred:

```text
`standards/Markdown-Standards.md`
```

Avoid:

```text
`standards\Markdown-Standards.md`
```

## Commands

Use inline code for short commands.

Example:

```text
Run `git status` before committing.
```

Use fenced code blocks for command sequences.

Example:

```powershell
git status
git diff --cached --check
git diff --cached
```

Do not include PowerShell prompt text such as `PS C:\>` in reusable command
examples unless the prompt itself is relevant to the explanation.

## Links

Use descriptive link text.

Avoid generic descriptions such as:

```text
click here
```

Repository-relative links should be preferred for documentation that resides
within the same repository when practical.

## Emphasis

Use bold text sparingly for important concepts.

Use italic text only when it improves readability or conveys conventional
emphasis.

Do not use excessive emphasis as a substitute for document structure.

Headings should provide the primary document hierarchy.

## Diagrams

Use Mermaid where appropriate for diagrams that can be maintained effectively
as text.

Mermaid diagrams must follow:

`standards/Mermaid-Standards.md`

Complex diagrams may use Draw.io when Mermaid does not provide sufficient
clarity.

Do not duplicate Mermaid-specific conventions in this standard.

## HTML

Avoid embedded HTML unless Markdown cannot reasonably express the requirement.

When HTML is necessary, keep its use minimal and portable.

## Generated Content

Generated Markdown must follow the same standards as manually authored content.

This includes content produced by:

- PowerShell automation;
- templates;
- CI/CD processes;
- AI-assisted workflows;
- other document generation tooling.

Generated content must not depend on formatting that violates this standard.

## Portability

Prefer Markdown that renders correctly in common Git-based repository platforms
and editors.

Avoid tool-specific Markdown extensions unless there is a defined HIEP
requirement.

Markdown source should remain understandable when read as plain text.

## Validation

Markdown validation may eventually be integrated into `Test-HIEPDocument` and
CI/CD workflows.

Automated validation may check requirements such as:

- exactly one level-one heading after optional front matter;
- hierarchical heading levels;
- correctly closed fenced code blocks;
- valid repository path conventions;
- prohibited or unsupported Markdown constructs.

Formatting validation should complement, not replace, document metadata and
lifecycle validation.

## Related Standards

This standard should be used together with:

- `standards/HIEP-Document-Standard.md`;
- `standards/Document-Lifecycle.md`;
- `standards/Mermaid-Standards.md`.

When requirements overlap, the specialized standard governs its respective
subject.
