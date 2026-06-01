# recipe.matrix_recipe_skill_sync

## Purpose

Keep D-drive skills, recipes, tools, matrices, maps, evals and agent assignments aligned.

## Steps

1. For every changed artifact, update its index.
2. For every new capability, update `CAPABILITY_MATRIX.csv`.
3. For every agent assignment, update `AGENT_TOOL_RECIPE_SKILL_MATRIX.csv`.
4. For every validation impact, update `EVIDENCE_AND_VALIDATION_MATRIX.csv`.
5. For every new tool, declare allowed and blocked surfaces in `TOOL_INDEX.csv`.
6. Run `local_validate_agent_layer.ps1`.

## Output

`sync_delta` with changed files and validator status.

## Stop Condition

Stop if an index points to a missing file or a live surface lacks governed order fields.
