# Workpaper: OpenAI Upstream Reference

agente: `tech.reference_librarian`
orden: registrar fuentes oficiales `openai/*`
superficie: GitHub `openai/*` read-only y `D:/.agents/codex/matrices`
skill: `openai-docs|github:github`
receta: `recipe.workspace_reference_audit|recipe.openai_review_repair_validate_loop`
tool: `tool.gh_remote_readonly|tool.local_validate_openai_upstream_adoption`

## Evidencia

Se revisaron repos oficiales OpenAI con metadata read-only:

- `openai/codex`
- `openai/skills`
- `openai/openai-cookbook`
- `openai/openai-agents-python`
- `openai/openai-agents-js`
- `openai/openai-openapi`
- `openai/codex-action`
- `openai/evals`
- `openai/openai-guardrails-python`
- `openai/openai-guardrails-js`
- `openai/privacy-filter`
- `openai/model_spec`
- `openai/model_spec_dataset`
- SDKs oficiales y referencias relacionadas.

## Decision

Adoptar como referencia tecnica versionada en
`OPENAI_UPSTREAM_REFERENCE_MATRIX.csv`. No promover a canon rector y no copiar
material masivamente.

## Riesgo y Rollback

Riesgo: fuente oficial tratada como canon institucional o como permiso de live
runtime. Rollback: revertir la rama antes de merge o retirar filas nuevas y
readback.

stop_condition: `source_reference_treated_as_canon|source_uncertain|secret_detected`
