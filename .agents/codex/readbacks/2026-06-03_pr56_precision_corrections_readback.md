# PR56 Precision Corrections Readback

## Nota De Vigencia
Este readback registra la correccion anterior de precision local/no-live. Queda
superado para estado actual por
`2026-06-03_full_live_governed_activation_readback.md`, que abre OpenAI live
gobernado para PR #56 y mantiene Microsoft, produccion y propagacion gateados.

## Dictamen
`PR56_PRECISION_CORRECTIONS_READY_KEEP_DRAFT`.

## Archivos Leidos
- `AGENTS.md`
- `MANIFEST.yaml`
- `README.md`
- PR #56 body
- `apps/sdu-agent-runtime/README.md`
- `apps/sdu-agent-runtime/src/agents/sdu_triage_agent.py`
- `apps/sdu-agent-runtime/src/guardrails/policies.py`
- `apps/sdu-agent-runtime/src/schemas/triage_schema.py`
- `apps/sdu-agent-runtime/tests/test_sdu_triage_agent.py`
- `governance/agents/AGENTS_SDK_BASELINE_POLICY.md`
- `governance/agents/AGENTS_SDK_AGENT_REGISTRY.md`
- `governance/agents/AGENTS_SDK_SECURITY_POLICY.md`
- `governance/agents/AGENTS_SDK_ORCHESTRATION_MODEL.md`
- `.agents/codex/matrices/AGENTS_SDK_BASELINE_GATE_20260603.csv`
- `.agents/codex/matrices/CODEX_CLOUD_CABINA_ACTIVATION_GATE_20260603.csv`
- `.agents/codex/matrices/REPO_PROPAGATION_SEQUENCE_AFTER_CABINA_20260603.csv`
- `.agents/codex/readbacks/2026-06-03_agents_sdk_baseline_gate.md`
- `.agents/codex/readbacks/2026-06-03_codex_cloud_cabina_activation_gate.md`

## Archivos Modificados
- `.gitignore`
- `apps/sdu-agent-runtime/README.md`
- `apps/sdu-agent-runtime/src/guardrails/policies.py`
- `apps/sdu-agent-runtime/tests/test_sdu_triage_agent.py`
- `governance/agents/AGENTS_SDK_BASELINE_POLICY.md`
- `governance/agents/AGENTS_SDK_AGENT_REGISTRY.md`
- `governance/agents/AGENTS_SDK_SECURITY_POLICY.md`
- `governance/agents/AGENTS_SDK_ORCHESTRATION_MODEL.md`
- `.agents/codex/matrices/AGENTS_SDK_BASELINE_GATE_20260603.csv`
- `.agents/codex/matrices/CODEX_CLOUD_CABINA_ACTIVATION_GATE_20260603.csv`
- `.agents/codex/matrices/REPO_PROPAGATION_SEQUENCE_AFTER_CABINA_20260603.csv`
- `.agents/codex/readbacks/2026-06-03_agents_sdk_baseline_gate.md`
- `.agents/codex/readbacks/2026-06-03_codex_cloud_cabina_activation_gate.md`
- `.agents/codex/readbacks/2026-06-03_repo_propagation_after_cabina_gate.md`
- `.agents/codex/evals/results/change_aware_full_coverage_audit_latest.json`

## Correcciones
- Reemplazada la etiqueta ambigua anterior por
  `AGENTS_SDK_LOCAL_NO_LIVE_BASELINE_READY`.
- Explicitado que el skeleton es local/no-live, contractual y pre-runtime.
- Explicitado que no importa `openai-agents`, no usa `Agent`, `Runner`,
  `OpenAIResponsesModel`, SDK tools, SDK handoffs ni SDK tracing.
- Cambiada la etiqueta CLI sin ID estable por `PENDING_REAL_ENVIRONMENT_ID` en
  el gate de activacion cabina.
- Agregados `environment_id_status=PENDING_REAL_ID` y
  `environment_evidence=prior_smoke_ready_no_diff`.
- Cambiado estado Codex Cloud a
  `CODEX_CLOUD_CABINA_READY_BY_PRIOR_SMOKE_WITH_ENV_ID_GAP`.
- Ajustado guardrail de produccion para bloquear `producción` y evitar falso
  positivo por `producto`.

## Validaciones
- `python -m unittest discover -s apps/sdu-agent-runtime/tests`: PASS, 5 tests.
- `git diff --check`: PASS.
- `local_validate_codex_cloud_governed_lane.ps1`: PASS.
- `local_validate_codex_app_environments.ps1`: PASS.
- `local_validate_autonomous_agent_execution.ps1`: PASS.
- `local_validate_operational_chain.ps1`: PASS.
- `local_validate_capability_use_hardening.ps1`: PASS.
- `local_validate_change_aware_full_coverage_orchestrator.ps1`: PASS.
- `local_validate_github_automation_preflight.ps1 -CheckLocalSdk`: PASS,
  `smoke=OK_NO_API_CALL`.
- `local_run_change_aware_full_coverage_orchestrator.ps1 -BuildPlan -ExecutePlan -VerifyCoverageEquivalence -EmitAuditArtifact -UseWorkingTreeChanges`: PASS.

Change-aware audit:
- `all_required_passed=true`.
- `coverage_equivalence=true`.
- `manifest_valid=true`.
- `graph_valid=true`.
- `no_hidden_flaky=true`.
- `blocked_surfaces_clear=true`.
- Required tests: 19/19 executed and passed.
- Audit artifact:
  `.agents/codex/evals/results/change_aware_full_coverage_audit_latest.json`.

## Codex Cloud
Estado: `CODEX_CLOUD_CABINA_READY_BY_PRIOR_SMOKE_WITH_ENV_ID_GAP`.

El smoke previo `task_e_6a1f119843d4832e9ed821834222c003` queda como evidencia
no-diff. No se creo environment duplicado. El ID estable real queda pendiente
de registro cuando la herramienta o UI lo exponga.

## Agents SDK
Estado: `AGENTS_SDK_LOCAL_NO_LIVE_BASELINE_READY`.

`sdu-triage-agent` permanece local/no-live. No hay import real de
`openai-agents`, runtime SDK, API live, Microsoft live, produccion, secretos ni
costos.

## Bloqueos Restantes
- PR #56 debe permanecer draft.
- El ID estable de Codex Cloud queda pendiente de registro.
- Cualquier paso a runtime real de Agents SDK requiere orden gobernada separada.

## Riesgos
- La baseline no prueba ejecucion real de Agents SDK; esto es intencional para
  no abrir live/API/costos.
- Propagacion a otros repos sigue bloqueada hasta cierre explicito de cabina y
  carriles repo-native.

## Rollback
Revertir este commit del branch `codex/cabina-cloud-agents-sdk-baseline-20260603`.

## Proximo Paso Exacto
Hacer stage explicito, commit, push y actualizar el body de PR #56 sin sacarlo
de draft.
