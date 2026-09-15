# HIEP AI Context

## Purpose

This document defines the shared AI context for the Healthcare Identity Eco Platform
(HIEP).

AI assistants working with this repository must use this context together with the
project context, naming conventions, writing standards, architecture principles and
other applicable repository standards.

## Platform

HIEP stands for:

**Healthcare Identity Eco Platform**

HIEP is a healthcare identity knowledge platform powered by Infinigate Nederland.

The platform brings together knowledge, architecture, security, vendors, integrations,
demonstrations, workshops and supporting material related to identity and access
management within healthcare environments.

## Objectives

AI assistance within HIEP should help:

- structure healthcare identity knowledge;
- document architectures and integrations;
- describe security controls and identity flows;
- compare relevant technologies and vendors;
- develop demonstrations and workshops;
- maintain consistent technical documentation;
- create diagrams and architecture models;
- support repeatable pre-sales and advisory activities;
- identify assumptions, dependencies, risks and open questions.

## AI Principles

AI-generated content must be:

- technically accurate;
- traceable where factual claims require evidence;
- explicit about assumptions;
- vendor-neutral unless vendor-specific content is requested;
- understandable by both technical and business audiences;
- consistent with HIEP terminology;
- reusable;
- maintainable as documentation-as-code.

AI must not present assumptions as established facts.

When information is uncertain, incomplete or time-sensitive, this must be stated
explicitly.

## Healthcare Context

Healthcare identity environments can involve:

- healthcare professionals;
- employees;
- contractors;
- patients;
- partners;
- suppliers;
- service accounts;
- workloads;
- devices;
- applications;
- APIs;
- privileged identities.

Identity should therefore not automatically be interpreted as workforce identity.

## Security Context

Security content should consider, where applicable:

- authentication;
- authorization;
- identity lifecycle management;
- privileged access;
- passwordless authentication;
- phishing resistance;
- federation;
- single sign-on;
- identity governance;
- least privilege;
- zero trust;
- auditability;
- monitoring;
- resilience;
- recovery;
- privacy;
- regulatory requirements.

## Architecture

Architecture descriptions should distinguish between:

- business requirements;
- functional requirements;
- security requirements;
- logical architecture;
- physical architecture;
- integrations;
- trust relationships;
- identity flows;
- operational dependencies.

Architecture decisions should describe relevant trade-offs.

## Vendors

Vendor-specific documentation must distinguish between:

- product capabilities;
- architectural recommendations;
- assumptions;
- licensing considerations;
- integration requirements;
- limitations;
- HIEP interpretation.

Marketing claims must not automatically be treated as technical facts.

## AI Tools

HIEP may be used with multiple AI assistants, including:

- ChatGPT;
- Claude;
- GitHub Copilot;
- Cursor.

Shared repository context should remain tool-independent whenever possible.

Tool-specific instructions belong in the corresponding directory under `ai/`.

## Repository Sources

AI assistants should prefer repository-controlled information where available.

Important shared context includes:

- `ai/shared/PROJECT_CONTEXT.md`
- `ai/shared/NAMING_CONVENTIONS.md`
- `ai/shared/WRITING_STANDARDS.md`
- `standards/Architecture-Principles.md`
- `standards/Document-Lifecycle.md`
- `standards/Markdown-Standards.md`
- `standards/Mermaid-Standards.md`
- `standards/PowerShell-Standards.md`

## Rule

HIEP repository content is the project source of truth.

When generated content conflicts with an approved HIEP document or standard, the
approved repository content takes precedence.