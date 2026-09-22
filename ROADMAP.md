# HIEP Roadmap

The HIEP roadmap describes the development direction of the Healthcare Identity Eco Platform.

It provides a high-level view of capabilities that have been established, the areas currently being developed, and the capabilities planned for later phases.

The roadmap is repository-driven. Completed work should be supported by the actual repository and Project Update history. Planned items describe direction and do not represent completed or approved HIEP capabilities.

## Roadmap principles

The HIEP roadmap follows these principles:

- completed capabilities must be traceable to repository history;
- current work should reflect the active project focus;
- planned capabilities describe direction rather than commitments to delivery dates;
- roadmap status should be updated when project state changes;
- detailed technical decisions belong in the relevant HIEP documentation rather than in this roadmap.

## Completed

### Repository foundation

The foundational HIEP repository structure, bootstrap configuration, project templates, standards areas, automation structure, and documentation model have been established.

### Documentation framework

HIEP has established documentation standards, lifecycle rules, architecture principles, reusable document templates, metadata conventions, and supporting automation.

### Managed document tooling

The HIEP PowerShell module supports managed document metadata parsing and stable document identifier allocation.

### Project Update framework

HIEP maintains structured Project Updates with stable identifiers, metadata, validation, creation tooling, and traceability to repository development.

### Automated project timeline

Validated Project Updates can be transformed automatically into timeline data for publication.

### Public project portal

The first public HIEP project portal is operational and presents the generated project timeline through a lightweight HTML, CSS, and JavaScript frontend.

### Automated publication

GitHub Actions validates the project, generates portal data, builds the GitHub Pages artifact, and deploys the public portal from the `main` branch.

## Current focus

### Public project content

HIEP is expanding the repository content needed to explain the project clearly to both technical and non-technical audiences.

This includes the project overview, roadmap, current status, project direction, and links to the underlying repository documentation.

### Portal information architecture

The public portal is being developed from its initial timeline-focused implementation into a broader project entry point.

The goal is to make the project purpose, current status, completed work, roadmap, architecture, security documentation, and Project Updates easier to discover without creating a separate source of truth outside the repository.

### Architecture documentation

The existing HIEP Architecture Principles provide the foundation for further architecture documentation.

The next stage is to develop the repository architecture content while keeping architecture decisions, assumptions, trust relationships, security considerations, and implementation guidance explicit and traceable.

### Security documentation

HIEP is preparing its security documentation around the existing security-oriented architecture principles and managed document structure.

Future security content will document security objectives, trust boundaries, threats, requirements, controls, authentication, authorization, identity lifecycle, auditability, resilience, and residual risks as those areas are developed.

## Planned

The following areas are part of the intended HIEP development direction. Their scope and implementation will be refined as the project matures.

### Business and use-case documentation

Develop structured business context, requirements, stakeholders, healthcare identity use cases, value, constraints, and success criteria.

### Vendor and integration knowledge

Develop structured vendor knowledge and integration guidance that can relate products, capabilities, protocols, identity patterns, security considerations, dependencies, and limitations to HIEP architecture.

### Demonstration and proof-of-concept guidance

Develop reusable documentation for demonstration and lab environments that can support validation of HIEP concepts and patterns.

### Workshops and enablement

Develop reusable workshop methods and supporting material for architecture discussions, technical discovery, demonstrations, and customer engagements.

### Governance and collaboration

Further develop project governance, contribution guidance, review processes, and collaboration mechanisms as public participation in HIEP evolves.

### Documentation automation

Continue improving repository-driven validation, generation, navigation, and publication where automation provides repeatable value without introducing unnecessary complexity.

## Roadmap maintenance

This roadmap represents the current high-level direction of HIEP.

Detailed implementation work should remain traceable through Project Updates, repository history, and the relevant HIEP documentation.

When roadmap items change state, this document should be updated so that the repository remains the source of truth for project direction.
