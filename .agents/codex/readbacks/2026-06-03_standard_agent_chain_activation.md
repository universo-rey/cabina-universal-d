# Standard Agent Chain Activation

## Dictamen

`STANDARD_AGENT_CHAIN_ACTIVE`

## Nota de Supersedencia
Este readback queda superado por
[`2026-06-10_full_live_governed_runtime_default_closeout.md`](C:/Users/enzo1/Documents/GitHub/cabina-universal-d/.agents/codex/readbacks/2026-06-10_full_live_governed_runtime_default_closeout.md),
que formaliza `full_live_governed` como default runtime. La evidencia de esta
cadena queda intacta.

La Cabina Universal del Rey declara activa la cadena operativa estándar bajo
`CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON`, sin crear agentes duplicados y sin
propagar a otros repos.

## Cadena Activada

1. `rey.control_plane_orchestrator` - agente rector y entrada.
2. `court.openai_dispatcher` - agente delegado para dispatch OpenAI.
3. `sdu-triage-agent` - agente runtime Agents SDK funcional.
4. `court.sdu_gate` - gate y validacion de frontera.
5. `court.seshat_evidence` - evidencia y readback de cierre.

## Runtime

- OpenAI API live: `ENABLED_GOVERNED`
- Responses API live: `ENABLED_GOVERNED`
- Agents SDK Runner: `ENABLED_GOVERNED`
- Codex Cloud task-scoped: `ENABLED_GOVERNED`
- GitHub repo-scoped: `ENABLED_GOVERNED`

## Superficies Gated Not Executed

- Microsoft live write: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- SharePoint write: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- Teams write: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- Planner write: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- Graph mutation: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- Power Platform mutation: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- Produccion: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`
- Propagacion multi-repo: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`

## Archivos Modificados

- `AGENTS.md`
- `MANIFEST.yaml`
- `governance/agents/AGENTS_SDK_AGENT_REGISTRY.md`
- `governance/agents/AGENTS_SDK_ORCHESTRATION_MODEL.md`
- `.agents/codex/matrices/STANDARD_AGENT_CHAIN_20260603.csv`
- `.agents/codex/matrices/AGENT_CAPABILITY_GRAPH_20260603.csv`
- `.agents/codex/matrices/OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv`
- `.agents/codex/matrices/CAPABILITY_USE_HARDENING_MATRIX.csv`
- `.agents/codex/matrices/MATRIX_INDEX.csv`
- `.agents/codex/readbacks/2026-06-03_standard_agent_chain_activation.md`

## Validaciones

- `python -m unittest discover -s apps/sdu-agent-runtime/tests`: PASS, 5 tests.
- `python -m py_compile .agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py`: PASS.
- `git diff --check`: PASS.
- `bash -n .agents/codex/scripts/codex_cloud_full_live_governed_setup.sh`: PASS.
- `bash -n .agents/codex/scripts/codex_cloud_full_live_governed_maintenance.sh`: PASS.
- `python .agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py`: PASS.
- `local_validate_operational_chain.ps1`: PASS.
- `local_validate_capability_use_hardening.ps1`: PASS.
- `local_validate_change_aware_full_coverage_orchestrator.ps1`: PASS, 19/19 planned required tests.

## Live Evidence

- OpenAI `models.list`: PASS.
- Responses API: PASS.
- Agents SDK `Agent + Runner`: PASS.
- Modelo usado: `gpt-5.5`.
- `openai` version: 2.40.0.
- `openai-agents` version: 0.17.4.
- Response bodies printed: false.
- Agent output printed: false.
- Secrets printed: false.
- Credential source: local ignored env file.

## Riesgos

- El agente runtime base conserva implementacion `local_no_live`; la validacion
  live se ejecuta mediante smoke externo gobernado.
- Microsoft, produccion y propagacion quedan habilitados por canon, pero no se
  ejecutan sin target exacto, owner, rollback, postcheck y evidencia.
- La disponibilidad live depende de OpenAI API y del modelo `gpt-5.5`.

## Stop Conditions

- `secret_detected`
- `capability_use_preflight_missing`
- `operational_chain_missing`
- `openai_api_live_requested_without_order`
- `microsoft_live_requested_without_governed_order`
- `production_requested_without_explicit_authorization`
- `automated_merge_precheck_failed`

## Proximo Gate Recomendado

Preparar, solo cuando el operador lo ordene, un gate Microsoft o produccion con
objeto exacto, owner, identidad, rollback, postcheck y evidencia. Hasta ese
momento: `ENABLED_GOVERNED_GATED_NOT_EXECUTED`.
