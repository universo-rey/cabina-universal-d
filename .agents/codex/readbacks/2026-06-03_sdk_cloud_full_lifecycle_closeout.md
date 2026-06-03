# SDK + Codex Cloud Full Lifecycle Closeout

## Estado
SDK_CLOUD_FULL_LIFECYCLE_READY_FOR_GITHUB_MERGE

## Orden
Ejecutar en una sola operacion `AGENTS_SDK_FUNCTIONAL_LIFECYCLE` y `CODEX_CLOUD_FULL_ENVIRONMENT_LIFECYCLE` con evidencia versionada, PR, checks, merge con `--match-head-commit` y sync de `main`.

## Superficie
- OpenAI API live: executed governed
- Responses API live: executed governed
- Agents SDK runtime live: executed governed
- Codex Cloud setup: executed governed
- Codex Cloud maintenance: executed governed
- GitHub branch/commit/push/PR/checks/merge/sync: prepared in this lifecycle
- Microsoft live write: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Produccion: ENABLED_GOVERNED_GATED_NOT_EXECUTED
- Propagacion: ENABLED_GOVERNED_GATED_NOT_EXECUTED

## Archivos Versionados
- `.agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py`
- `.agents/codex/readbacks/2026-06-03_agents_sdk_functional_lifecycle_smoke.md`
- `.agents/codex/readbacks/2026-06-03_codex_cloud_full_environment_lifecycle.md`
- `.agents/codex/readbacks/2026-06-03_sdk_cloud_full_lifecycle_closeout.md`

## Evidencia
- Setup no-live oficial: PASS
- Setup live oficial: PASS
- Functional script live: PASS
- Maintenance oficial: PASS
- OpenAI `models.list`: PASS
- Responses API: PASS
- Agents SDK `Agent + Runner`: PASS
- Modelo usado: `gpt-5.5`
- `openai` version: 2.40.0
- `openai-agents` version: 0.17.4
- Unit tests: PASS, 5 tests
- `git diff --check`: PASS
- `pwsh` precheck: PASS
- Operational chain validator: PASS
- Capability hardening validator: PASS
- Change-aware static validator: PASS, 19/19 planned required tests

## Criterio De Cierre
El ciclo queda cerrado cuando el PR se mergea a `main` con `--match-head-commit`, `main` local queda sincronizado con `origin/main`, el worktree queda limpio y no se ejecutan Microsoft write, produccion ni propagacion.

## Riesgo
- Riesgo real restante: la evidencia versionada no contiene cuerpos de respuesta ni secretos; la validacion live depende de disponibilidad de OpenAI API y modelo `gpt-5.5`.
- Microsoft, produccion y propagacion quedan habilitados por canon pero no ejecutados por falta de target exacto, owner, rollback y postcheck.

## Rollback
Revert del PR/merge commit. No hay writes externos que revertir.

## Stop Condition
Detener con bloqueo exacto si cambian HEAD/checks antes del merge, si falla una validacion, si aparece secreto, si hay cambio fuera de los cuatro archivos autorizados o si se solicita una superficie gated sin target/owner/rollback/postcheck.
