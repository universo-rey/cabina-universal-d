# recipe.retrospective-to-skill-propagation

## Purpose
Convert a closed governed frontier into reusable skills, recipes, agent deltas, validators and prompts.

## Preconditions
- The frontier is closed or ready for review.
- Evidence exists in readbacks, validations, matrices or PR metadata.
- No new live execution is required.

## Steps
1. Read scoped evidence.
2. Build a timeline and operational retrospective.
3. Extract skill and recipe candidates.
4. Canonize only non-duplicative local skills or recipes.
5. Record agent deltas and validator candidates.
6. Write prompt improvements and readback.
7. Validate and open PR.

## Gates
- No Dataverse live, Power Automate live, OpenAI API, Batch API, PROD, TEST, Default, SharePoint, Planner, broad Graph or secrets.

## Validators
- `local_validate_skill_recipe_agent_learning.ps1`
- Change-Aware Full-Coverage Orchestrator

## Rollback
Revert the retrospective PR.

## Stop Condition
`retrospective_source_missing_or_secret`
