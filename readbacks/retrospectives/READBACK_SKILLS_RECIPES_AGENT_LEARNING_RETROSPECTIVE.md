# READBACK_SKILLS_RECIPES_AGENT_LEARNING_RETROSPECTIVE

## Estado
RETROSPECTIVE_SKILLS_RECIPES_AGENT_LEARNING_READY_FOR_REVIEW

## Fuentes Leidas
- `D:/readbacks/dataverse/*`
- `D:/readbacks/powerautomate/*`
- `D:/readbacks/openai/*`
- `D:/readbacks/postmerge/*`
- `D:/readbacks/versioning/*`
- `D:/readbacks/runtime/*`
- `D:/validation/dataverse/*`
- `D:/validation/powerautomate/*`
- `D:/validation/openai/*`
- `D:/validation/postmerge/*`
- `D:/validation/versioning/*`
- `D:/validation/runtime/*`
- `D:/matrices/dataverse/*`
- `D:/matrices/powerautomate/*`
- `D:/matrices/connections/*`
- `D:/matrices/versioning/*`
- `D:/matrices/runtime/*`
- `D:/docs/dataverse/*`
- `D:/docs/powerautomate/*`
- `D:/docs/runtime/*`
- `.agents/codex` skills, recipes, tools and matrices
- `.agents/skills`
- `D:/AGENTS.md`
- `D:/MANIFEST.yaml`
- `.github/workflows/*`
- PR metadata for #64, #65, #66, #67 and #68

## Aprendizajes Clave
- DEV live work must be bounded by exact environment, exact object, rollback and postcheck.
- OpenAI advisory metadata must remain non-canon until locally validated.
- One-flow/one-item runtime activation is a reusable maximum safe frontier.
- Back-reference target writes require exactly one deterministic candidate.
- Mapping records can preserve traceability when target final remains unresolved.
- `0 exact candidates = no inferred write`.

## Skills Candidatas
- 12 skill candidates were evaluated in `retrospectives/skills/LEARNED_SKILL_CANDIDATES_MATRIX.csv`.
- Four repo-local skills were canonized for review:
  - `dataverse-metadata-only-provisioning`
  - `agent-retrospective-learning`
  - `dataverse-workqueue-backreference-mapping`
  - `no-inference-runtime-write-guard`

## Recipes Candidatas
- 12 recipe candidates were evaluated in `retrospectives/recipes/LEARNED_RECIPE_CANDIDATES_MATRIX.csv`.
- Four recipes were canonized for review:
  - `recipe.one-flow-one-item-runtime-test`
  - `recipe.retrospective-to-skill-propagation`
  - `recipe.backreference-target-mapping-before-write`
  - `recipe.mapping-record-before-target-write`

## Agentes Afectados
- `rey.control_plane_orchestrator`
- `rey.frontier_guardian`
- `court.sdu_gate`
- `court.seshat_evidence`
- `court.openai_dispatcher`
- `codex.workspace_guardian`
- Candidate future agents: `dataverse.provisioning.engineer`, `powerautomate.workqueue.operator`, `github.pr.operator`, `openai.metadata.classifier`, `retrospective.learning.engine`, `runtime.activation.operator`, `backreference.mapping.operator`

## Validadores Propuestos
- 10 validator candidates were recorded.
- Implemented now: `D:/.agents/codex/tools/local_validate_skill_recipe_agent_learning.ps1`.
- Live-dependent or broader validators remain design-only.

## Matrices Actualizadas
- `D:/.agents/codex/matrices/MATRIX_INDEX.csv`
- `D:/.agents/codex/matrices/OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv`
- `D:/.agents/codex/matrices/CAPABILITY_USE_HARDENING_MATRIX.csv`
- `D:/.agents/codex/skills/SKILL_METADATA_QUALITY_MATRIX.csv`
- `D:/.agents/codex/skills/SKILL_USAGE_MATRIX.csv`
- `D:/.agents/codex/recipes/RECIPE_INDEX.csv`
- `D:/.agents/codex/recipes/SUBRECIPE_INDEX.csv`
- `D:/.agents/codex/tools/TOOL_INDEX.csv`
- `D:/.agents/codex/matrices/LOCAL_SKILL_CATALOG.csv`
- `D:/.agents/codex/matrices/STOP_CONDITION_GLOSSARY.csv`
- `D:/.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv`

## Matrices No Actualizadas
- `AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv`: deferred to avoid changing default agent behavior without separate review.
- `SUBAGENT_CAPABILITY_ASSIGNMENT_MATRIX.csv`: deferred because new specialist agents are candidates, not canonized profiles.

## Sistemas No Ejecutados
- Dataverse live after PR #68 merge
- Power Automate live after PR #68 merge
- OpenAI API
- Batch API
- PROD
- TEST
- Default
- SharePoint
- Planner
- Broad Graph
- Secret read or print

## Riesgos
- Some root retrospective paths are outside the default allowlist and require explicit staging.
- Candidate specialist agents are not created yet.
- Some validators remain design-only until owners approve implementation.

## Rollback
- Revert this retrospective PR.
- Remove newly added skill, recipe, validator and index rows in the same revert.
- No live rollback is needed because this branch performs no new live action.

## Proximos Pasos
- Human review of the retrospective PR.
- If accepted, later dedicated PRs can implement the deferred validators and specialist agent profiles.

## Stop Condition
Stop if any live surface is requested, a secret appears, a duplicate skill is canonized without reconciliation, or validation fails.
