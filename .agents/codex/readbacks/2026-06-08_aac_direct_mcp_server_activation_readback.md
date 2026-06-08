# Readback: herramienta MCP directa AAC

agente: `rey.control_plane_orchestrator` con `court.thot_schema`
orden: activar o crear una herramienta MCP directa para Agile Agent Canvas
superficie: repo-local; MCP stdio; VS Code workspace config; Agile Agent Canvas
repo: `universo-rey/cabina-universal-d`
workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
branch: `codex/aac-direct-mcp-20260608`
head: `a4930fb`
skill: `tcu-descubridor-capacidades`; `mcp-builder`
recipe: `recipe.openai_local_agent_design`; `recipe.vsi_prepared_agent_task_execution`
tool: `tool.aac_mcp_server_direct`
estado: `EXECUTED_LOCAL_VALIDATED`

acciones:
- Se confirmo que no existia MCP directo AAC repo-local versionable.
- Se creo `aac-mcp-server` como servidor MCP stdio local sin dependencias externas.
- Se registro el servidor en `.vscode/mcp.json` como `aac-direct`.
- Se allowlisteo `.vscode/mcp.json` y `aac-mcp-server` en `.gitignore`.
- Se agrego `tool.aac_mcp_server_direct` en `TOOL_INDEX.csv` y `TOOL_GOVERNANCE_MATRIX.csv`.
- Se agrego entrada `aac_mcp_server` en `MATRIX_INDEX.csv`.
- Se agrego validador `scripts/validators/aac_mcp_server_validator.py`.
- Se abrio/reuso VS Code Insiders sobre el workspace para que la config MCP repo-local quede disponible para el cliente.
- Se probo el servidor por JSON-RPC local con `initialize`, `tools/list`,
  `aac_get_board_context` y `aac_prepare_native_invocation`.

herramientas MCP:
- `aac_list_native_agents`: lista los agentes nativos AAC gobernados.
- `aac_get_board_context`: lee tablero madre, tablero auxiliar y capa Cabina.
- `aac_get_extension_capabilities`: lee comandos, language model tools y manifiesto de la extension local.
- `aac_prepare_native_invocation`: prepara paquete de invocacion nativa gobernada sin ejecutar live ni afirmar invocacion directa.

evidencia:
- `npm test --prefix aac-mcp-server` => `AAC_MCP_SERVER_MOCK_FLOW_PASS`.
- `python scripts/validators/aac_mcp_server_validator.py` => `AAC_MCP_SERVER_VALIDATOR=PASS`.
- JSON-RPC local directo => server `aac-mcp-server`, `tool_count=5`,
  primary board `Agile Agent Canvas`, native status
  `ACTIVE_AAC_NATIVE_TEAM_GOVERNED`, S-6.1 `PREPARED_NOT_EXECUTED`,
  `direct_invocation_from_codex=false`, `live_executed=false`.
- `python scripts/validators/local_agent_bridge_validator.py` => `LOCAL_AGENT_BRIDGE_VALIDATOR=PASS`.
- `.agents\codex\tools\local_validate_agent_layer.ps1` => PASS con `matrix_count=200`, `tool_count=63`.
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1` => PASS con `tools=63`.
- `.agents\codex\tools\local_validate_operational_chain.ps1` => PASS con `tools=63`.
- `git check-ignore -v aac-mcp-server/src/index.mjs` => allowlist `.gitignore:196`.
- `git check-ignore -v .vscode/mcp.json` => allowlist `.gitignore:178`.

archivos:
- `aac-mcp-server/package.json`
- `aac-mcp-server/README.md`
- `aac-mcp-server/src/index.mjs`
- `aac-mcp-server/tests/mock_mcp_flow.mjs`
- `.vscode/mcp.json`
- `.gitignore`
- `.agents/codex/tools/TOOL_INDEX.csv`
- `.agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv`
- `.agents/codex/matrices/MATRIX_INDEX.csv`
- `scripts/validators/aac_mcp_server_validator.py`
- `.agents/codex/readbacks/2026-06-08_aac_direct_mcp_server_activation_readback.md`

validadores:
- `npm test --prefix aac-mcp-server`: PASS.
- `python scripts/validators/aac_mcp_server_validator.py`: PASS.
- `python scripts/validators/local_agent_bridge_validator.py`: PASS.
- `python scripts/validators/agile_canvas_task_ops_validator.py`: PASS.
- `python scripts/validators/agile_canvas_identity_drift_validator.py`: PASS.
- `python scripts/validators/agile_canvas_extension_schema_validator.py`: PASS.
- `npm test --prefix local-agent-bridge`: PASS.
- `.agents\codex\tools\local_validate_agent_layer.ps1`: PASS.
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`: PASS.
- `.agents\codex\tools\local_validate_parallel_order_governance.ps1`: PASS.
- `.agents\codex\tools\local_validate_operational_chain.ps1`: PASS.
- `git diff --check`: PASS con warnings CRLF/LF, sin errores.

checks: PENDING_PR; no hubo merge ni live.
riesgo: bajo; MCP local stdio, sin secretos, sin red, sin proveedores live y sin mutacion remota.
gate: ninguno para MCP local; `GATE_OPENAI_LIVE`, `GATE_MICROSOFT_LIVE_WRITE`, `GATE_SECRET_USE`, `GATE_REMOTE_GIT_MUTATION` si se agregan herramientas live o escritura externa.
rollback: `git restore -- .gitignore .vscode/mcp.json .agents/codex/tools/TOOL_INDEX.csv .agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv .agents/codex/matrices/MATRIX_INDEX.csv scripts/validators/aac_mcp_server_validator.py .agents/codex/readbacks/2026-06-08_aac_direct_mcp_server_activation_readback.md; git clean -fd -- aac-mcp-server`
stop_condition: `aac_mcp_direct_tool_live_boundary_missing`
pr: PENDING_PR_CREATE.
proximos_carriles: abrir PR repo-local para versionar `aac-direct`; ampliar con herramientas write solo con target, owner, rollback, postcheck, validator y gate explicito.
