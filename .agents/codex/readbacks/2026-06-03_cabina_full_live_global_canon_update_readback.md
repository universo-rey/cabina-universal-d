# Cabina Full Live Global Canon Update Readback

## Dictamen
HECHO_EN_RAMA: la cabina queda canonizada como
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON` para revision por PR.

## Estado anterior
La cabina venia de `FULL_LIVE_GOVERNED_READY` por PR #56, con OpenAI API,
Responses API y Agents SDK runtime validados por smokes gobernados. Microsoft,
produccion y propagacion estaban preparados pero no ejecutados.

## Estado nuevo
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`.

GitHub sigue siendo canon tecnico para versionado y revision, pero el control
plane ya no queda limitado a repo-only. La cabina puede gobernar runtime live,
OpenAI, Codex Cloud, Agents SDK, Microsoft 365, produccion y propagacion
multi-repo bajo gates explicitos.

## Que significa no repo-only
La cabina no queda restringida a cambios documentales o repo-scoped. Puede
preparar y ejecutar carriles live gobernados cuando exista target exacto,
owner, identidad, alcance, rollback, postcheck, evidencia, stop condition y
readback.

## Que significa si a todo
Significa posibilidad gobernada, no ejecucion ciega. Si falta target, owner,
rollback o postcheck, la superficie queda `ENABLED_GOVERNED_GATED` y no se
ejecuta.

## Superficies enabled governed
- OpenAI API.
- Responses API.
- Agents SDK Runtime.
- Codex Cloud.
- GitHub.

## Superficies enabled governed gated
- Microsoft Graph.
- SharePoint.
- Teams.
- Planner.
- Power Platform.
- Produccion.
- Propagacion multi-repo.

## Que no se ejecuto todavia
- No se ejecuto propagacion.
- No se ejecuto Microsoft write.
- No se ejecuto produccion.
- No se ejecuto OpenAI live smoke nuevo.
- No se hicieron dumps de tenant.
- No se leyeron datos regulados masivos.
- No se absorbieron repos anidados.

## Politica de secretos
Nunca imprimir secretos y nunca persistir claves en repo, logs, matrices,
readbacks o prompts.

## Politica de writes
Ningun write live puede ser ciego. Todo write requiere target exacto, owner,
identidad, alcance, rollback, postcheck, evidencia, stop condition y readback.

## Politica de propagacion
La propagacion queda habilitada como `ENABLED_GOVERNED_GATED` y no ejecutada.
Debe avanzar repo por repo, con branch `codex/*`, file set exacto, owner,
rollback, postcheck, validadores y PR propio.

## Archivos modificados
- `AGENTS.md`.
- `MANIFEST.yaml`.
- `README.md`.
- `.agents/codex/matrices/CABINA_FULL_LIVE_GLOBAL_CANON_MATRIX_20260603.csv`.
- `.agents/codex/matrices/AGENTS_SDK_BASELINE_GATE_20260603.csv`.
- `.agents/codex/matrices/CODEX_CLOUD_CABINA_ACTIVATION_GATE_20260603.csv`.
- `.agents/codex/matrices/REPO_PROPAGATION_SEQUENCE_AFTER_CABINA_20260603.csv`.
- `.agents/codex/matrices/MATRIX_INDEX.csv`.
- `.agents/codex/readbacks/2026-06-03_cabina_full_live_global_canon_update_readback.md`.
- `.gitignore`.

## Validaciones ejecutadas
- `git diff --check`: PASS.
- `python -m unittest discover -s apps/sdu-agent-runtime/tests`: PASS, 5 tests.
- Git Bash `bash -n .agents/codex/scripts/codex_cloud_full_live_governed_setup.sh`: PASS.
- Git Bash `bash -n .agents/codex/scripts/codex_cloud_full_live_governed_maintenance.sh`: PASS.
- `local_validate_operational_chain.ps1`: PASS.
- `local_validate_capability_use_hardening.ps1`: PASS.
- `local_validate_change_aware_full_coverage_orchestrator.ps1`: PASS,
  `manifest_valid=true`, `graph_valid=true`,
  `coverage_equivalence_planned=true`, `required_test_count=19`,
  `planned_test_count=19`.
- CSV parse local para matrices tocadas: PASS.

## Proximo gate exacto
Abrir PR contra `main` y dejar que el Change-Aware Full-Coverage Orchestrator
de CI valide el canon. La siguiente accion live posterior requiere orden con
target exacto, owner, rollback, postcheck y evidencia.

## Riesgos
- El canon habilita superficies live, pero la ejecucion sigue bloqueada si
  falta target exacto, rollback o postcheck.
- La propagacion multi-repo puede generar drift si se ejecuta sin carril repo
  nativo.

## Rollback
Revertir el commit del branch
`codex/cabina-full-live-global-canon-20260603`. No se ejecutaron writes live.

## Stop condition
`stop_if_target_or_rollback_or_postcheck_missing`.
