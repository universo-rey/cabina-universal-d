---
name: matrix-recipe-skill-sync
description: Use when a D:\.agents\codex matrix, recipe, skill, tool, map, eval, or agent assignment changes and local indexes must stay aligned.
---

# Matrix Recipe Skill Sync

## Core Rule

No local capability is real unless the artifact, its index row, its assigned agent, and its validator path agree.

## Sync Checklist

For a skill change:

- Update `skills\SKILL_USAGE_MATRIX.csv`.
- Ensure the skill folder has `SKILL.md`.
- Link the skill from `matrices\AGENT_TOOL_RECIPE_SKILL_MATRIX.csv` when an agent uses it.

For a recipe change:

- Update `recipes\RECIPE_INDEX.csv`.
- Ensure the recipe file exists.
- Link the recipe from `matrices\AGENT_TOOL_RECIPE_SKILL_MATRIX.csv`.

For a matrix or map change:

- Update `matrices\MATRIX_INDEX.csv` or the appropriate map index.
- Add validation coverage in `matrices\EVIDENCE_AND_VALIDATION_MATRIX.csv` when it affects closeout.

For a tool change:

- Update `tools\TOOL_INDEX.csv`.
- Declare allowed and blocked surfaces.
- Keep command paths local unless a governed order opens a live surface.

## Validation

Run:

```powershell
D:\.agents\codex\tools\local_validate_agent_layer.ps1
```

If the full validator is unavailable, run `local_validate_agent_levels.ps1` and record the gap as `NO_CONSTA_FULL_LAYER_VALIDATOR`.

## Stop Conditions

- An index points to a missing local file.
- A skill, recipe, or tool is assigned to an agent without a level.
- A live/cost/remote surface appears without governed order fields.
- A closeout lacks readback evidence.
