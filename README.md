# Healthcare Identity Eco Platform (HIEP)

HIEP is an open, documentation-as-code project for developing structured knowledge, architecture, security guidance, and reusable patterns for identity and access management in healthcare environments.

The project brings business, architecture, security, vendor, integration, demonstration, workshop, and governance knowledge together in a version-controlled and traceable repository.

> HIEP is under active development. Not every repository area represents a completed capability or approved architecture.

## About HIEP

Healthcare identity environments combine complex requirements around authentication, authorization, identity lifecycle, privileged access, interoperability, security, auditability, and operational resilience.

HIEP provides a structured environment in which these subjects can be documented, related, reviewed, and developed over time.

## Why HIEP

Identity is a fundamental security boundary in modern healthcare environments.

Healthcare organizations need to support different users, systems, devices, trust relationships, and access scenarios while maintaining appropriate security, usability, traceability, and resilience.

HIEP provides a place to develop and maintain this knowledge as structured, reviewable documentation rather than disconnected presentations, diagrams, notes, and implementation-specific guidance.

## Project status

HIEP is currently in active development.

The technical project foundation is operational. This includes:

- repository and bootstrap structure;
- documentation standards and templates;
- document metadata parsing and ID allocation;
- a PowerShell automation module;
- a structured Project Update framework;
- Project Update validation and creation tooling;
- automated project timeline generation;
- a public project portal;
- GitHub Actions validation and deployment;
- GitHub Pages publication.

The next phase focuses on developing the public project content, architecture, security documentation, roadmap, and documentation experience.

Project maturity should always be determined from the actual repository content. Empty, draft, or planned areas do not represent completed HIEP capabilities.

## Architecture principles

HIEP maintains explicit architecture principles to guide future designs and documentation.

Current principles include:

- treat identity as a security boundary;
- verify explicitly;
- apply least privilege;
- prefer phishing-resistant authentication;
- separate authentication and authorization;
- minimize permanent privilege;
- design for the complete identity lifecycle;
- use open standards where practical;
- minimize trust;
- design for failure;
- make security observable;
- protect sensitive data;
- separate logical and physical architecture;
- automate repeatable controls;
- document decisions and assumptions.

See [`standards/Architecture-Principles.md`](standards/Architecture-Principles.md) for the complete set of architecture principles.

## Repository structure

The HIEP repository separates project content, standards, automation, templates, and publication components.

| Area | Purpose |
| --- | --- |
| `docs/00-reference/` | Project-wide reference material and foundational documentation |
| `docs/01-business/` | Business context, requirements and use cases |
| `docs/02-architecture/` | Logical, physical and solution architecture documentation |
| `docs/03-security/` | Security requirements, controls, patterns and risks |
| `docs/04-vendors/` | Vendor and product knowledge |
| `docs/05-integrations/` | Integration patterns, protocols and implementation guidance |
| `docs/06-demo-platform/` | Demonstration and lab documentation |
| `docs/07-workshops/` | Workshop methods, preparation and supporting material |
| `docs/08-marketing/` | Reusable market-facing supporting content |
| `docs/09-governance/` | Repository and project governance |
| `docs/10-roadmap/` | Detailed roadmap material |
| `docs/glossary/` | Canonical terminology and definitions |
| `standards/` | HIEP project and documentation standards |
| `templates/` | Reusable HIEP content templates |
| `updates/` | Structured Project Updates and project history |
| `diagrams/` | Architecture and technical diagrams |
| `src/HIEP.Tools/` | HIEP PowerShell automation |
| `portal/` | Public HIEP project portal |

Some repository areas are intentionally prepared for future development and may currently be empty.

## Project updates

HIEP maintains its project history through structured Project Updates.

Project Updates are Markdown documents stored under `updates/YYYY/`.

Each update has a stable `HIEP-UPD-NNNN` identifier and structured metadata for traceability.

These updates are the source of truth for the public project timeline. Timeline data is generated automatically from the repository rather than maintained separately.

See [`updates/README.md`](updates/README.md) for the Project Update model and [`standards/Project-Update-Standard.md`](standards/Project-Update-Standard.md) for the complete standard.

## Documentation

HIEP follows a documentation-as-code approach.

Documentation is intended to be:

- version controlled;
- reviewable;
- reproducible;
- structured;
- traceable;
- suitable for collaborative maintenance.

Reusable document templates are maintained under [`templates/documents/`](templates/documents/).

Repository-wide documentation rules are maintained under [`standards/`](standards/).

Content documentation under `docs/` is being developed incrementally. The presence of a document or directory does not by itself indicate that its content is complete or approved.

## Roadmap

The HIEP roadmap is under active development.

The technical foundation, Project Update framework, automated timeline, public portal, and deployment pipeline are operational.

Current development is moving toward richer public project content, architecture and security documentation, roadmap publication, and a clearer documentation experience.

The repository [`ROADMAP.md`](ROADMAP.md) will become the primary high-level roadmap source as this part of the project is developed.

## Public project portal

The public HIEP portal provides a project-facing view of HIEP, its current status, and its development history.

Structured Project Updates are transformed into timeline data during the build process. GitHub Actions validates the project, builds the portal artifact, and publishes the production portal from the `main` branch through GitHub Pages.

The public portal is available at:

https://scorpido74.github.io/HIEP/

## Contributing

HIEP is being developed in a public repository while its documentation, governance, and contribution model continue to mature.

Changes should follow the repository standards and remain reviewable, traceable, and reproducible.

Formal contribution guidance will be added as the project governance model develops.

## Repository

The HIEP source repository is available at:

https://github.com/scorpido74/HIEP
