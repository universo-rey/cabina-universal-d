---
name: cabina-naming-analyzer
description: Use when agent ids, repo ids, matrix ids, skill ids, recipe ids, tool ids, aliases, folders, or stop conditions need canonical naming in D:\.
---

# Cabina Naming Analyzer

## Core Rule

Names are contracts. A rename is only valid when every index, matrix, recipe,
tool, agent profile and validator reference continues to resolve.

## Workflow

1. Identify the object class: repo, agent, subagent, skill, subskill, recipe,
   subrecipe, tool, matrix, plugin, stop condition or folder.
2. Prefer existing canonical ids over new aliases.
3. If an alias is needed, register it instead of replacing history.
4. Check the matching index first, then all crosswalk matrices.
5. Validate with the local agent layer validator.

## Naming Rules

- Skill ids: lowercase kebab case.
- Agent ids: namespace plus role, such as `court.thot_schema`.
- Repo ids: uppercase snake case.
- Recipe ids: `recipe.<purpose>`.
- Tool ids: `tool.<purpose>`.
- Subskills and subrecipes: `subskill.<purpose>` and `subrecipe.<purpose>`.

## Stop Conditions

- The rename would orphan evidence, PR history, workpapers or source lineage.
- Two ids would refer to the same authority without an alias map.
- A stop condition is not in the glossary.
