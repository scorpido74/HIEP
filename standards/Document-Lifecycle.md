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
```

A document may return from Review to Draft when substantial changes are required.

An Approved document may return to Draft or Review when a new revision is developed.

## Metadata

Managed documents should include sufficient metadata to identify:

- document identifier;
- title;
- version;
- status;
- owner;
- last updated date;
- reviewers where applicable.

The common metadata contract for managed HIEP documents is defined in
`standards/HIEP-Document-Standard.md`.

## Versioning

Document versioning should reflect meaningful content changes.

Repository Git history remains the detailed change record.

Do not duplicate complete Git history inside every document.

Version format and version semantics are defined in
`standards/HIEP-Document-Standard.md`.

## Review

Review depth should be appropriate to the document.

Examples include:

- technical review;
- architecture review;
- security review;
- business review;
- vendor validation.

## Approval

Approval means the document is accepted for its stated scope.

Approval does not mean that information can never change.

## Deprecation

Deprecated documents should identify the preferred replacement when one exists.

## Archiving

Archived documents should not be silently deleted when historical context remains
valuable.

## AI-Generated Content

AI-generated content begins as Draft unless explicitly reviewed and approved through
the applicable HIEP process.

AI generation alone must not change document lifecycle state.
