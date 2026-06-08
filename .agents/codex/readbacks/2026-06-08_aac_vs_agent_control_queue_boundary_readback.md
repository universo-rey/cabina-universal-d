# Readback - AAC vs agent control queue boundary

agente: `rey.control_plane_orchestrator`
orden: separar formalmente `AAC_NATIVE_AGENTS` de `CABINA_GOVERNANCE_AGENTS` y evitar confusion entre tablero Agile Agent Canvas y tablero de cola Control de Agentes
superficie: `repo-local`
repo: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
branch: `main`
head: `de7f873`
skill: `tcu-descubridor-capacidades`; `vsi-superficie-viva-task-runner`
recipe: `recipe.parallel_agent_operation`
tool: `multi_agent_v1.spawn_agent`; `tool.parallel_dispatch_policy_check`
estado: `EXECUTED_LOCAL_VALIDATED`

acciones:
- Se reemplazo el roster ambiguo `VSI_BOARD_AGENT_ROSTER_20260608.csv` por dos matrices separadas:
  - `.agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv`
  - `.agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv`
- Se actualizo `MATRIX_INDEX.csv` con ambas matrices.
- Se actualizo `EPIC-6` para declarar `nativeAgentRosterPath` y `governanceAgentRosterPath`.
- Se actualizo `local-agent-bridge/src/dashboardData.mjs` para exponer `primary_board.native_agents` y `primary_board.governance_agents`, no `agent_roster`.
- Se actualizo la frontera de tableros:
  - `Agile Agent Canvas`: `board_kind=agile_agent_canvas_creation_planning_board`
  - `Control de Agentes de Cabina`: `board_kind=agent_control_queue_board`
- Se actualizo UI, README y tests para exigir que ambos tableros no sean equivalentes.

evidencia:
- API `http://127.0.0.1:8787/api/dashboard` retorno:
  - `primary=Agile Agent Canvas`
  - `primary_kind=agile_agent_canvas_creation_planning_board`
  - `primary_not=control_agentes_cabina_queue_board`
  - `queue=Control de Agentes de Cabina`
  - `queue_kind=agent_control_queue_board`
  - `queue_not=vsi_agile_agent_canvas_mother_board`
  - `native_records=21`
  - `governance_records=7`
- Bridge local activo en `127.0.0.1:8787`, PID `2284`.

archivos:
- `.agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv`
- `.agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv`
- `.agents/codex/matrices/MATRIX_INDEX.csv`
- `.agileagentcanvas-context/planning/epics.json`
- `.agileagentcanvas-context/README.md`
- `local-agent-bridge/README.md`
- `local-agent-bridge/src/dashboardData.mjs`
- `local-agent-bridge/public/index.html`
- `local-agent-bridge/tests/mock_bridge_flow.mjs`
- `scripts/validators/local_agent_bridge_validator.py`
- `.agents/codex/readbacks/2026-06-08_aac_vs_agent_control_queue_boundary_readback.md`

validadores:
- `python scripts/validators/local_agent_bridge_validator.py`: PASS
- `python scripts/validators/agile_canvas_task_ops_validator.py`: PASS
- `python scripts/validators/agile_canvas_identity_drift_validator.py`: PASS
- `python scripts/validators/agile_canvas_extension_schema_validator.py`: PASS
- `npm test --prefix local-agent-bridge`: PASS
- `.agents/codex/tools/local_validate_agent_layer.ps1`: PASS
- `git diff --check`: PASS con avisos CRLF/LF, sin errores.

checks:
- `NO_EJECUTADO`: sin PR ni checks remotos.

riesgo: bajo
gate: ninguno para repo-local; ejecucion de agentes sigue bajo `humanAuthorization`
rollback: `git restore -- .agents/codex/matrices/MATRIX_INDEX.csv .agileagentcanvas-context/planning/epics.json .agileagentcanvas-context/README.md local-agent-bridge/README.md local-agent-bridge/src/dashboardData.mjs local-agent-bridge/public/index.html local-agent-bridge/tests/mock_bridge_flow.mjs scripts/validators/local_agent_bridge_validator.py` y borrar las dos matrices nuevas mas este readback si se revierte completo.
stop_condition: `aac_vs_agent_control_queue_boundary_validated`
pr: `NO_APLICA`
proximos_carriles: usar `AAC_NATIVE_AGENTS` solo para agentes nativos del tablero Agile Agent Canvas y `CABINA_GOVERNANCE_AGENTS_FOR_VSI` solo para gobierno de tarjetas/cola.
