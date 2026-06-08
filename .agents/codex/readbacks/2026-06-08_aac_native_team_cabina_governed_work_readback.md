# Readback: AAC native team y agentes Cabina de trabajo gobernado

agente: `rey.control_plane_orchestrator` con `codex.workspace_guardian`, `court.thot_schema`, `court.seshat_evidence`
orden: corregir jerarquia del tablero VSI: nuestros agentes tambien trabajan sobre Agile Agent Canvas y lo gobiernan; agentes nativos AAC son solo equipo nativo colaborador
superficie: repo-local, VSI Agile Agent Canvas, loopback dashboard local
repo: `universo-rey/cabina-universal-d`
workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
branch: `main`
head: `de7f873`
skill: `tcu-descubridor-capacidades`; `vsi-superficie-viva-task-runner`
recipe: `recipe.parallel_agent_operation`; `recipe.vsi_prepared_agent_task_execution`
tool: `multi_agent_v1.spawn_agent` declarado; `tool.parallel_dispatch_policy_check`; `local-agent-bridge`
estado: `EXECUTED_LOCAL_VALIDATED`

acciones:
- Se cambio `board_relation` de Cabina desde `governance_overlay_not_native_aac_agent` a `cabina_governed_work_agent_not_native_aac_team`.
- Se cambio el uso nativo AAC a `ASSIGNED_AS_AAC_NATIVE_TEAM`.
- Se renombro la columna de uso desde `governance_overlay_agents` a `cabina_governed_work_agents`.
- Se actualizo el dashboard para exponer `ACTIVE_CABINA_GOVERNED_WORK_LAYER`, `cabina_governs_vsi_agile_agent_canvas_board` y `cabina_agents_work_on_board_and_govern_it`.
- Se actualizo la UI para mostrar `agentes cabina`, no `agentes gobierno`.
- Se documento que `AAC_NATIVE_AGENTS` es equipo nativo colaborador y `CABINA_GOVERNANCE_AGENTS_FOR_VSI` son nuestros agentes que trabajan sobre el tablero y lo gobiernan.

evidencia:
- `git rev-parse --show-toplevel` => `C:/Users/enzo1/Documents/GitHub/cabina-universal-d`.
- `git branch --show-current` => `main`.
- `git rev-parse --short HEAD` => `de7f873`.
- `python scripts/validators/local_agent_bridge_validator.py` => `LOCAL_AGENT_BRIDGE_VALIDATOR=PASS`.
- `npm test --prefix local-agent-bridge` => `SDU_LOCAL_AGENT_BRIDGE_MOCK_FLOW_PASS`.
- `Invoke-RestMethod http://127.0.0.1:8787/api/dashboard` => `primary=Agile Agent Canvas`, `native_team_role=native_aac_team_not_cabina_authority`, `cabina_status=ACTIVE_CABINA_GOVERNED_WORK_LAYER`, `cabina_relation=cabina_governed_work_agent_not_native_aac_team`, `queue=Control de Agentes de Cabina`, `website_queue_records=0`.

archivos:
- `.agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv`
- `.agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv`
- `.agents/codex/matrices/MATRIX_INDEX.csv`
- `.agileagentcanvas-context/README.md`
- `.agileagentcanvas-context/planning/epics.json`
- `local-agent-bridge/README.md`
- `local-agent-bridge/src/dashboardData.mjs`
- `local-agent-bridge/public/index.html`
- `local-agent-bridge/tests/mock_bridge_flow.mjs`
- `scripts/validators/local_agent_bridge_validator.py`
- `.agents/codex/readbacks/2026-06-08_aac_native_team_cabina_governed_work_readback.md`

validadores:
- `python scripts/validators/local_agent_bridge_validator.py`: PASS.
- `python scripts/validators/agile_canvas_task_ops_validator.py`: PASS.
- `python scripts/validators/agile_canvas_identity_drift_validator.py`: PASS.
- `python scripts/validators/agile_canvas_extension_schema_validator.py`: PASS.
- `npm test --prefix local-agent-bridge`: PASS.
- `.agents\codex\tools\local_validate_agent_layer.ps1`: PASS.
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`: PASS.
- `.agents\codex\tools\local_validate_parallel_order_governance.ps1`: PASS.
- `.agents\codex\tools\local_validate_operational_chain.ps1`: PASS.
- `git diff --check`: PASS con warnings de normalizacion CRLF/LF, sin errores.

checks: NO_EJECUTADO; no hubo PR ni push remoto.
riesgo: bajo; cambios locales, versionables y reversibles; sin live write, secretos, produccion ni remotos.
gate: ninguno para lectura/escritura repo-local; live/remoto queda fuera de alcance.
rollback: `git restore -- .agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv .agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv .agents/codex/matrices/MATRIX_INDEX.csv .agileagentcanvas-context/README.md .agileagentcanvas-context/planning/epics.json local-agent-bridge/README.md local-agent-bridge/src/dashboardData.mjs local-agent-bridge/public/index.html local-agent-bridge/tests/mock_bridge_flow.mjs scripts/validators/local_agent_bridge_validator.py .agents/codex/readbacks/2026-06-08_aac_native_team_cabina_governed_work_readback.md`
stop_condition: `aac_cabina_governed_work_layer_boundary_drift`
pr: NO_EJECUTADO; no se abrio PR en este subpaso.
proximos_carriles: usar `CABINA_GOVERNANCE_AGENTS_FOR_VSI` como agentes Cabina de trabajo gobernado sobre el tablero madre; usar `AAC_NATIVE_AGENTS` como equipo nativo colaborador de Agile Agent Canvas; mantener `Control de Agentes de Cabina` solo como tablero auxiliar de cola/control.
