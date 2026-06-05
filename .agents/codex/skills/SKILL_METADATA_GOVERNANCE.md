# Skill Metadata Governance

## Purpose

This document governs repo-local skill metadata for
`universo-rey/cabina-universal-d`.

The durable source for portable cabina skills is `.agents\skills`. Runtime
installs under user-global Codex folders can be used locally, but they are not
the durable source of truth for this repo.

## Source Signals

The issue #10 source review uses these external references as non-canonical
technical guidance:

- https://www.webreactiva.com/blog/buenas-practicas-skills#1-el-campo-description-es-mas-importante-de-lo-que-crees
- https://www.webreactiva.com/blog/como-organiza-claude-skills#1-referencia-de-librerias-y-api

Local canon still comes from `AGENTS.md`.

## Metadata Contract

Every repo-local skill under `.agents\skills\<skill>\SKILL.md` must have:

- YAML frontmatter with `name` and `description`.
- A description that starts with a concrete activation phrase such as
  `Use when`, names what the skill does, states when to use it, and includes
  task keywords that a model can match before loading the body.
- A single primary purpose. If a skill starts covering multiple unrelated
  categories, split it or route one purpose to another skill.
- Explicit `Trigger Boundary`, `Allowed Actions`, `Blocked Actions`, and
  `Validator` sections in the body.
- A row in `SKILL_USAGE_MATRIX.csv`, `LOCAL_SKILL_CATALOG.csv`, and
  `SKILL_METADATA_QUALITY_MATRIX.csv`.

## Progressive Disclosure

Keep the `SKILL.md` body short and operational. If a skill needs examples,
reference material, scripts, or templates, place them in folders under the
skill package and name when to load them. Do not add broad README-style
documentation to a skill package unless the validator or workflow needs it.

## Validation

Run `.agents\codex\tools\local_validate_skill_metadata.ps1` when any
repo-local `SKILL.md`, skill catalog, subskill matrix, or default skill
assignment changes.

The validator checks frontmatter, description trigger keywords, explicit
boundary sections, catalog agreement, matrix coverage, validator references and
stop conditions.

## Stop Condition

Stop with `skill_metadata_missing_or_ambiguous` when a repo-local skill lacks a
clear activation description, boundary, allowed/blocked action set, validator
reference, or catalog row.
