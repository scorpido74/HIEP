---
document:
  id: HIEP-ARC-001
  title: HIEP Architectural Context and Actors
  type: ARC
  version: 0.1.0
  status: Draft
  owner: Architecture
  authors:
    - Remco de Kievit
  created: 2026-09-24
  updated: 2026-09-24
  classification: Internal
  reviewers: []
  approvers: []
  tags:
    - architecture
    - identity
    - healthcare
    - actors
    - context
---

# HIEP Architectural Context and Actors

## Purpose

This document establishes the initial architectural context for the Healthcare Identity Eco Platform (HIEP).

It defines the actors, identity concepts, organizational relationships, care contexts, trust relationships, and architectural boundaries that provide the foundation for further HIEP architecture and security design.

HIEP architecture is developed from the perspective of healthcare delivery rather than from the perspective of individual identity technologies or products.

The primary human perspective is the healthcare professional performing work within a care process.

Identity, authentication, authorization, trust, lifecycle management, interoperability, and security controls exist to enable healthcare professionals to perform their work securely, reliably, and with appropriate access to healthcare services and information.

This document intentionally remains vendor-neutral and does not prescribe specific products, platforms, deployment models, or implementation technologies.

## Scope

This document covers the high-level architectural context of HIEP, including:

- healthcare professionals and other relevant human actors;
- healthcare organizations and care settings;
- roles and organizational relationships;
- care and work processes;
- human and non-human identities;
- identity sources and identity services;
- applications, APIs, and healthcare services;
- high-level authentication and authorization relationships;
- identity lifecycle considerations;
- trust relationships and trust boundaries;
- interoperability considerations;
- resilience and failure considerations;
- observability and audit considerations;
- architectural assumptions and open questions.

Detailed logical capabilities will be developed after the architectural context and actor model have been sufficiently established.

Detailed security requirements, threats, attack scenarios, and security controls are outside the primary scope of this document and belong in the HIEP security documentation.

Detailed product selection, vendor architecture, and physical deployment architecture are also outside the current scope.

## Context

Healthcare delivery involves people, organizations, applications, services, devices, and information operating across organizational and technical boundaries.

The HIEP architecture therefore starts with the healthcare professional and the care process that the professional is trying to perform.

The basic architectural reasoning follows this sequence:

```text
Healthcare Professional
        |
        v
Assigned Role
        |
        v
Care / Work Process
        |
        v
Current Context
        |
        v
Identity and Trust
        |
        v
Authentication
        |
        v
Authorization
        |
        v
Healthcare Resource or Service
        |
        v
Audit and Accountability
```

This sequence is a conceptual reasoning model. It does not imply that HIEP implements every capability shown in the model.

### Healthcare-professional-centered architecture

HIEP considers identity and access requirements from the perspective of the healthcare professional performing work.

Architecture decisions should therefore consider questions such as:

- What is the healthcare professional trying to accomplish?
- In which role is the professional acting?
- For which healthcare organization is the professional acting?
- Within which care or work process is the action performed?
- Which application, API, information, or healthcare service is required?
- Which identity information is required?
- Which trust relationships are required?
- Which authentication assurance is appropriate?
- Which authorization decision is required?
- How is accountability established?
- What happens to the care process when an identity or access capability is unavailable?

This approach does not reduce security requirements in favor of usability.

Instead, HIEP should seek architectures in which appropriate security controls support healthcare delivery while avoiding unnecessary identity and access friction.

### Roles rather than job titles

HIEP distinguishes professional qualifications, organizational functions, roles, and permissions.

A job title or professional qualification does not by itself determine access.

For example, a nurse may perform different roles depending on the healthcare organization, care setting, assignment, responsibility, and care process.

Conceptually:

```text
Human Identity
    |
    +-- Professional Qualification
    |
    +-- Organizational Relationship
    |
    +-- Assigned Role
    |
    +-- Care / Work Context
    |
    +-- Applicable Policy
            |
            v
    Authorization Decision
```

The precise attributes that contribute to authorization decisions are not established by this document.

HIEP must therefore avoid architectural models in which static job titles are directly translated into permissions without consideration of role and context.

### Multiple healthcare settings

HIEP is not limited to a single type of healthcare organization or care setting.

Home care is used as an initial reference context because it provides a useful environment for testing identity, mobility, organizational relationships, changing care contexts, and access requirements.

The architecture must, however, remain applicable to other healthcare settings, including hospitals and other healthcare organizations.

Care processes and roles may differ significantly between healthcare settings while using common HIEP identity, trust, lifecycle, and interoperability concepts.

## Requirements

The architectural context establishes the following initial requirements:

1. HIEP architecture must distinguish human identities from non-human identities.
2. HIEP architecture must distinguish identity from role.
3. HIEP architecture must distinguish professional qualification from authorization.
4. HIEP architecture must separate authentication from authorization.
5. HIEP architecture must support the concept of multiple roles for a single human identity.
6. HIEP architecture must allow roles to vary by organization, care setting, assignment, and care process.
7. HIEP architecture must not assume that a professional title directly determines permissions.
8. HIEP architecture must allow healthcare organizations to maintain their own organizational and trust context.
9. HIEP architecture must account for external and partner organizations.
10. HIEP architecture must account for service and workload identities where non-human actors participate in identity or access relationships.
11. HIEP architecture must consider identity lifecycle from creation or onboarding through change and eventual removal or termination.
12. HIEP architecture must support explicit trust relationships rather than relying on implicit trust.
13. HIEP architecture must consider failure of identity-related dependencies and the effect of such failure on healthcare delivery.
14. HIEP architecture must support sufficient observability and auditability to establish accountability for identity and access events.
15. HIEP architecture must remain vendor-neutral at the logical architecture level.
16. HIEP architecture must allow different healthcare settings to participate without requiring the core architecture to be redesigned for each setting.

## Assumptions

The following assumptions are used during this stage of architecture development and require validation as HIEP evolves.

### Healthcare organizations

It is assumed that HIEP may be used in an ecosystem containing multiple healthcare organizations.

This does not establish a specific multi-tenant, federation, or deployment architecture.

### Healthcare professionals

Healthcare professionals are assumed to be the primary human perspective for the initial HIEP architecture.

Other human actors may be relevant but must be evaluated based on their relationship to HIEP.

### Home care

Home care is used as the first reference care setting for evaluating the architecture.

This does not make home care an architectural boundary or restrict HIEP to home-care organizations.

### Multiple roles

A healthcare professional may have multiple roles over time and may potentially have relationships with more than one organization.

The mechanism through which these roles and relationships are established, validated, distributed, or revoked has not yet been determined.

### External identity capabilities

HIEP may interact with external identity sources and identity services.

This document does not assume that HIEP itself is the authoritative identity source, Identity Provider, authorization service, or lifecycle system.

Those responsibilities must be established through later architectural decisions.

## Architecture

### Logical Architecture

The initial logical context is centered on the relationship between healthcare work, identity, trust, and consuming services.

```text
Healthcare Ecosystem
        |
        +-- Healthcare Organization
        |       |
        |       +-- Care Setting
        |       |
        |       +-- Healthcare Professional
        |               |
        |               +-- Professional Qualification
        |               +-- Organizational Relationship
        |               +-- Assigned Role
        |               +-- Care / Work Context
        |
        +-- Partner / External Organization
        |
        +-- Identity Sources and Services
        |
        +-- HIEP
        |
        +-- Applications / APIs / Healthcare Services
```

This model represents architectural relationships and must not be interpreted as a final component architecture.

Further logical architecture will be developed after actor responsibilities and system boundaries have been validated.

#### Actor model

##### Healthcare Professional

**Status:** Proposed

A human actor who performs healthcare-related work and requires access to healthcare information, applications, APIs, or services.

The healthcare professional is the primary human perspective for the initial HIEP architecture.

A healthcare professional may have:

- one or more professional qualifications;
- one or more organizational relationships;
- one or more assigned roles;
- different roles in different care settings;
- different access requirements depending on the current care or work process.

##### Healthcare Organization

**Status:** Proposed

An organization responsible for delivering or supporting healthcare and participating in identity, trust, lifecycle, or access relationships.

A healthcare organization may employ, contract, assign, sponsor, or otherwise establish a relationship with healthcare professionals.

The exact authority of an organization over identity, roles, attributes, and access decisions remains to be established.

##### Partner or External Organization

**Status:** Proposed

An organization outside the immediate healthcare organization that participates in a relevant identity, trust, service, or care relationship.

Whether HIEP directly manages identities from external organizations or relies on external identity authorities remains an open question.

##### Administrative User

**Status:** Proposed

A human actor performing administrative activities relevant to HIEP or connected healthcare services.

Administrative responsibilities must remain distinct from clinical or care roles where appropriate.

##### Privileged Administrative User

**Status:** Proposed

An administrative actor whose activities have elevated impact on identity, security, trust, configuration, or platform operation.

Privileged access must be considered separately from normal workforce access.

The existence of this actor does not prescribe a specific privileged access management technology.

##### Patient

**Status:** Open question

Patients may become architecturally relevant where HIEP supports patient-facing identity, access, delegation, consent, or healthcare-service interactions.

The current architectural context does not provide sufficient evidence to establish the patient as a primary HIEP actor.

##### Service Identity

**Status:** Proposed

A non-human identity used by a service to participate in authenticated or trusted interactions.

Service identities require lifecycle, trust, authentication, and accountability considerations independent from human identities.

##### Workload Identity

**Status:** Proposed

A non-human identity associated with a workload, runtime, automation process, or similar technical actor.

The exact distinction between service identities, workload identities, and application identities remains to be refined.

##### Application

**Status:** Proposed

A software system that consumes or participates in identity-related HIEP relationships.

An application may act on behalf of a human actor, operate using its own non-human identity, or use both models depending on the interaction.

##### API

**Status:** Proposed

An interface through which applications, workloads, or services interact.

An API is not automatically an identity actor.

The identity of an API client and the protected API resource must be distinguished.

##### Identity Source

**Status:** Proposed

A source providing identity, organizational, professional, role, or lifecycle information relevant to HIEP.

The authoritative source for each identity attribute has not yet been established.

##### Identity Service

**Status:** Proposed

A logical or external service providing identity-related capabilities such as authentication, identity information, federation, or related functionality.

The presence of this actor does not imply that a particular Identity Provider or identity technology has been selected.

##### Consuming Healthcare Service

**Status:** Proposed

An application, API, digital service, or healthcare capability that relies on identity, trust, authentication, or authorization information within the HIEP context.

##### Governance Function

**Status:** Proposed

A function responsible for establishing or maintaining policies, trust rules, governance requirements, or other organizational agreements relevant to HIEP.

The distinction between governance functions, administrative actors, and technical enforcement capabilities requires further development.

#### Role model

HIEP treats roles as contextual relationships rather than permanent identity properties.

A conceptual role model is:

```text
Person
  |
  +-- Identity
  |
  +-- Professional Qualification
  |
  +-- Organizational Relationship
          |
          +-- Assigned Role
                  |
                  +-- Care Setting
                  +-- Work Process
                  +-- Responsibility
                  +-- Assignment
                  +-- Applicable Context
```

A role may influence an authorization decision, but a role is not itself equivalent to a permission.

This distinction allows HIEP to support healthcare professionals whose responsibilities change between organizations, departments, care settings, assignments, or processes.

#### Reference care setting: home care

Home care is the initial reference setting used to test the HIEP architecture.

A healthcare professional working in home care may move between patients, locations, processes, applications, and connectivity conditions during a working period.

This makes home care useful for evaluating:

- mobile healthcare work;
- changing care context;
- role-based responsibilities;
- identity assurance;
- access to multiple healthcare services;
- lifecycle changes;
- external dependencies;
- intermittent or unavailable services;
- audit and accountability.

Architecture developed using the home-care reference setting must subsequently be tested against other settings.

A hospital is an important secondary validation setting because it introduces different organizational structures, workflows, locations, systems, and role relationships.

HIEP must preserve the common identity and trust model while allowing care-setting-specific roles and processes to differ.

### Physical Architecture

No physical HIEP architecture is established by this document.

Deployment models, hosting locations, network topology, product placement, tenant models, and vendor-specific components must not be inferred from the logical context described above.

Physical architecture will be documented when sufficient logical architecture and implementation requirements have been established.

## Security Considerations

Identity is treated as a security boundary within HIEP.

The architecture must apply the HIEP Architecture Principles, including explicit verification, least privilege, phishing-resistant authentication where appropriate, separation of authentication and authorization, minimization of permanent privilege, lifecycle-aware identity design, minimization of trust, failure-aware design, observability, and protection of sensitive information.

Security controls must account for the operational reality of healthcare delivery.

Security mechanisms should not introduce unnecessary friction that causes healthcare professionals to bypass intended processes, while operational requirements must not be used to justify uncontrolled or implicit trust.

Detailed threats, attack scenarios, security requirements, and controls will be developed in the HIEP security documentation.

## Identity Lifecycle

Identity lifecycle is relevant to both human and non-human identities.

For healthcare professionals, lifecycle considerations may include:

```text
Join
  |
  v
Establish Identity
  |
  v
Establish Organizational Relationship
  |
  v
Assign Role
  |
  v
Perform Care / Work Processes
  |
  v
Change Role / Context / Organization
  |
  v
Remove Role or Relationship
  |
  v
Terminate or Retain Identity as Required
```

The lifecycle of a person must be distinguished from the lifecycle of:

- an organizational relationship;
- a professional qualification;
- a role;
- an assignment;
- a credential;
- an authorization;
- a service or workload identity.

A change in one lifecycle object does not necessarily imply termination of the others.

The authoritative systems and processes responsible for lifecycle events remain to be established.

## Trust Relationships

HIEP must make trust relationships explicit.

Potential trust relationships include those between:

- healthcare professionals and healthcare organizations;
- healthcare organizations and partner organizations;
- identities and identity sources;
- HIEP and identity services;
- applications and HIEP-related capabilities;
- applications and APIs;
- healthcare organizations and consuming healthcare services;
- human actors and the devices or services through which they work.

The existence of a relationship does not automatically establish trust.

Trust must be justified by the identity, organizational, technical, and care context relevant to the interaction.

Cross-organizational trust and federation require further architectural development.

## Resilience and Failure Scenarios

Identity and access capabilities may become dependencies for healthcare delivery.

HIEP architecture must therefore consider the effect of failure on the care process.

Relevant failure scenarios include:

- an identity source is unavailable;
- an identity service is unavailable;
- authentication cannot be completed;
- authorization information cannot be obtained;
- connectivity is unavailable or degraded;
- an external organization cannot be reached;
- identity or role information is stale or conflicting;
- a healthcare service is available while a required identity dependency is not;
- trust cannot be established with sufficient assurance.

The appropriate behavior for these scenarios has not yet been determined.

Future architecture must balance continuity of healthcare delivery with the requirement to prevent inappropriate access.

Emergency access, break-glass mechanisms, offline operation, cached authorization information, or similar mechanisms must not be assumed until their requirements and security implications have been evaluated.

## Observability and Audit

HIEP architecture must support accountability for identity and access-related events.

Relevant events may include:

- authentication attempts;
- authorization decisions;
- role assignment and removal;
- identity lifecycle changes;
- privileged activities;
- trust establishment and failure;
- access to protected services;
- administrative changes;
- exceptional or emergency access.

Observability must support investigation and accountability without unnecessarily exposing sensitive healthcare or identity information.

Detailed logging requirements, retention requirements, monitoring controls, and security-event handling will be developed separately.

## Decisions

### Decision

HIEP uses the healthcare professional and healthcare work process as the primary human perspective for architecture development.

### Rationale

Identity and access capabilities exist to support healthcare delivery.

Starting from healthcare work reduces the risk of designing HIEP around individual technologies rather than the operational requirements of healthcare professionals.

### Alternatives

A technology-centered or identity-provider-centered architecture could be used.

This would make technical components the starting point for the architecture.

### Consequences

Architecture decisions must be evaluated against healthcare workflows as well as technical and security requirements.

Roles must remain distinct from job titles, professional qualifications, and permissions.

Home care is used as the initial reference setting, but the architecture must remain applicable to hospitals and other healthcare settings.

Logical architecture must be established before HIEP is mapped to specific products or deployment components.

## Open Questions

The following questions require further architectural work:

1. What is the precise architectural responsibility of HIEP: platform, integration layer, control plane, trust framework, collection of identity capabilities, or a combination of these?
2. Which systems are authoritative for human identity information?
3. Which systems are authoritative for professional qualifications?
4. Which systems are authoritative for organizational relationships?
5. Where are roles created, approved, maintained, and revoked?
6. Which context attributes are relevant to authorization decisions?
7. Does HIEP provide authentication capabilities or integrate with external authentication services?
8. Does HIEP provide authorization capabilities or provide context to external authorization services?
9. How are trust relationships established between healthcare organizations?
10. How are external and partner identities handled?
11. How are service, workload, application, and API-client identities distinguished?
12. Is patient identity within the architectural scope of HIEP?
13. Which healthcare services and resources form the primary protected resources?
14. Which lifecycle events must be exchanged between organizations and HIEP-related capabilities?
15. How should healthcare delivery continue when identity or authorization dependencies are unavailable?
16. Which parts of the architecture are common across home care, hospitals, and other healthcare settings?
17. Which requirements are care-setting-specific rather than part of the generic HIEP architecture?

## References

- `standards/Architecture-Principles.md`
- `standards/HIEP-Document-Standard.md`
- `standards/Markdown-Standards.md`
- `standards/Mermaid-Standards.md`
- `standards/Document-Lifecycle.md`
- `templates/documents/HIEP-ARC.md`
- `docs/03-security/HIEP-SEC-001.md`
- `ai/shared/PROJECT_CONTEXT.md`
- `ai/shared/AI_CONTEXT.md`
