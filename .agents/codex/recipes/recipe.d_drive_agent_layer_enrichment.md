# recipe.d_drive_agent_layer_enrichment

## Purpose

Enrich `D:\.agents\codex` without creating remote agents, touching secrets, or widening into live surfaces.

## Steps

1. Read `README.md`, `MATRIX_INDEX.csv`, `RECIPE_INDEX.csv`, `SKILL_USAGE_MATRIX.csv`, and `TOOL_INDEX.csv`.
2. Identify the missing local overlay: matrix, recipe, skill, tool, eval, map, or readback.
3. Prefer `SOURCE_*` material before writing a new overlay.
4. Apply the change locally.
5. Synchronize indexes with `recipe.matrix_recipe_skill_sync`.
6. Validate with `tool.local_validate_agent_layer`.
7. Close with `recipe.governed_readback_closeout`.

## Output

`enrichment_delta` plus `readback`.

## Stop Condition

Stop before Git write, remote agent creation, API call, tenant action, live write, or secret access.
