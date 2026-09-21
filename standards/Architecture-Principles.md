# HIEP Architecture Principles

## Purpose

These principles guide architecture decisions within the Healthcare Identity Eco
Platform.

They are intended to support consistent decision making rather than prescribe a
single technology stack.

## 1. Identity Is a Security Boundary

Identity must be treated as a security control plane rather than only an
authentication mechanism.

Architecture should consider authentication, authorization, lifecycle, governance,
privilege and auditability together.

## 2. Verify Explicitly

Access decisions should be based on explicit and relevant signals.

Authentication alone should not automatically imply unrestricted authorization.

## 3. Least Privilege

Access should be limited to what an identity requires for its intended function.

This applies to:

- users;
- administrators;
- service accounts;
- workloads;
- applications;
- APIs.

## 4. Prefer Phishing-Resistant Authentication

Where risk and platform capabilities justify it, prefer authentication mechanisms
that reduce dependence on reusable secrets and resistance to phishing attacks.

## 5. Separate Authentication and Authorization

Successful authentication establishes identity confidence.

Authorization determines what that identity may access.

Architectures should model these as related but separate decisions.

## 6. Minimize Permanent Privilege

Prefer temporary, just-in-time or otherwise constrained privilege where practical.

Privileged access should be identifiable, controlled and auditable.

## 7. Design for Identity Lifecycle

Identity architecture must consider:

- joiner;
- mover;
- leaver;
- suspension;
- reactivation;
- privilege changes;
- exceptional access.

Provisioning without deprovisioning is incomplete lifecycle management.

## 8. Use Open Standards Where Practical

Prefer interoperable standards where they meet the requirement.

Relevant examples may include:

- OAuth 2.0;
- OpenID Connect;
- SAML;
- SCIM;
- FIDO2;
- WebAuthn.

Use of a standard does not by itself guarantee secure implementation.

## 9. Minimize Trust

Trust relationships should be explicit and documented.

Avoid unnecessary transitive trust and implicit dependencies.

## 10. Design for Failure

Identity services can become critical dependencies.

Architecture should consider:

- service outages;
- network failures;
- federation failures;
- credential loss;
- recovery;
- emergency access;
- degraded operation.

## 11. Make Security Observable

Important identity and access events should be suitable for logging, monitoring,
investigation and audit.

## 12. Protect Sensitive Data

Identity data can contain personal and security-sensitive information.

Collect, expose and retain only what is required for the intended purpose.

## 13. Separate Logical and Physical Architecture

Describe the required capabilities and relationships before binding the design to
specific products where practical.

This supports vendor-neutral analysis and clearer technology decisions.

## 14. Automate Repeatable Controls

Repeatable identity processes should be automated where automation improves
consistency, security and operational efficiency.

Automation must remain observable and controllable.

## 15. Document Decisions and Assumptions

Important architecture decisions should capture:

- context;
- decision;
- rationale;
- alternatives;
- consequences;
- assumptions.

Undocumented assumptions create hidden dependencies.