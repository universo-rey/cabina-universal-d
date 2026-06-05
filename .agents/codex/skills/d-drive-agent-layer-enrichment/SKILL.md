---
name: d-drive-agent-layer-enrichment
description: Use when enriching .agents\codex with local matrices, recipes, skills, tools, validators, readbacks, or agent routing overlays.
---

# D Drive Agent Layer Enrichment

## Core Rule

Enrich the existing D-drive agent layer by reconciling first, then adding the smallest missing local artifact. Do not replace source registries or create remote agents.

## Required Reads

1. `.agents\codex\README.md`
2. `.agents\codex\matrices\MATRIX_INDEX.csv`
3. `.agents\codex\recipes\RECIPE_INDEX.csv`
4. `.agents\codex\skills\SKILL_USAGE_MATRIX.csv`
5. `.agents\codex\tools\TOOL_INDEX.csv`

## Workflow

1. Classify the requested enrichment: matrix, recipe, skill, tool, eval, map, agent profile, or readback.
2. Check existing `SOURCE_*` files and indexes before creating a new local overlay.
3. Add or update the primary artifact.
4. Update every affected index or crosswalk.
5. Run the local validator.
6. Close with a readback that states systems touched, systems not touched, risk, validator result, and next lanes.

## Stop Conditions

- Secret, token, credential, or raw regulated-data access is required.
- A remote API, Microsoft live surface, Git write, or production surface is needed.
- An artifact would duplicate an existing source without adding a local routing or validation purpose.
- The validator fails and the failure is not explained.

## Output Contract

Every closeout must include:

- `HECHO_VERIFICADO`
- `RIESGO`
- `NO_TOCADO`
- `VALIDADOR`
- `PROXIMOS_CARRILES`
