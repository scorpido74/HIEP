# HIEP Project Context

## Project

**Name:** Healthcare Identity Eco Platform  
**Abbreviation:** HIEP  
**Owner:** Infinigate Nederland  
**Repository:** HIEP

## Purpose

HIEP provides a structured knowledge and enablement platform for healthcare identity
and access management.

The repository combines business, architecture, security, vendor, integration,
demonstration, workshop and governance knowledge in a documentation-as-code model.

## Primary Goals

HIEP aims to:

1. create a reusable healthcare identity knowledge base;
2. provide reference architectures and design guidance;
3. document identity and security patterns;
4. structure vendor and integration knowledge;
5. support demonstrations and proof-of-concept environments;
6. support workshops and customer engagements;
7. improve consistency across technical and commercial activities;
8. make project knowledge usable by humans and AI assistants.

## Repository Areas

### Reference

`docs/00-reference`

Contains project-wide reference material and foundational documentation.

### Business

`docs/01-business`

Contains business context, requirements, use cases and value propositions.

### Architecture

`docs/02-architecture`

Contains logical, physical and solution architecture documentation.

### Security

`docs/03-security`

Contains security requirements, controls, patterns, risks and security architecture.

### Vendors

`docs/04-vendors`

Contains structured vendor and product knowledge.

### Integrations

`docs/05-integrations`

Contains integration patterns, protocols and implementation guidance.

### Demo Platform

`docs/06-demo-platform`

Contains documentation for demonstration and lab environments.

### Workshops

`docs/07-workshops`

Contains workshop methods, preparation and supporting material.

### Marketing

`docs/08-marketing`

Contains reusable market-facing supporting content.

### Governance

`docs/09-governance`

Contains repository and project governance.

### Roadmap

`docs/10-roadmap`

Contains planned HIEP development and future capabilities.

### Glossary

`docs/glossary`

Contains canonical terminology and definitions.

## Architecture Assets

Architecture and technical diagrams are maintained under `diagrams/`.

Preferred diagram-as-code format is Mermaid.

Draw.io may be used where Mermaid is not suitable.

## Templates

Reusable HIEP content templates are stored under `templates/`.

These are different from the internal bootstrap templates under `build/templates/`.

## Automation

Repository bootstrap and automation are maintained under `build/`, `scripts/` and
`src/HIEP.Tools/`.

## AI

Shared AI context is maintained under `ai/shared/`.

Tool-specific AI configuration belongs in:

- `ai/chatgpt/`
- `ai/claude/`
- `ai/copilot/`
- `ai/cursor/`

## MCP

Model Context Protocol capabilities may be maintained under `mcp/`.

MCP integration is optional and must not be assumed to be enabled.

## Working Method

HIEP follows a documentation-as-code approach.

Changes should therefore be:

- version controlled;
- reviewable;
- reproducible;
- structured;
- traceable;
- suitable for collaborative maintenance.

## Development Principles

HIEP favors:

- simple solutions over unnecessary complexity;
- declarative configuration;
- automation where it provides repeatable value;
- open and portable formats;
- explicit architecture decisions;
- reusable patterns;
- separation between configuration, content and execution logic.

## Current Maturity

HIEP is an evolving platform.

Not every directory or document represents a completed capability.

Empty, draft or planned areas must not automatically be interpreted as approved
architecture or finalized project direction.