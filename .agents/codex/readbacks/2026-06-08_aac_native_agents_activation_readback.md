# Readback: activacion gobernada de agentes nativos AAC

agente: `rey.control_plane_orchestrator` con despacho lateral `Laplace` (`019ea5d8-a40b-7c01-95e8-173dfa3773c2`)
orden: activar agentes nativos AAC sobre el tablero madre VSI bajo gobierno Cabina
superficie: repo-local; VS Code Insiders; Agile Agent Canvas; loopback dashboard local
repo: `universo-rey/cabina-universal-d`
workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
branch: `main`
head: `de7f873`
skill: `tcu-descubridor-capacidades`; `vsi-superficie-viva-task-runner`
recipe: `recipe.parallel_agent_operation`; `recipe.vsi_prepared_agent_task_execution`
tool: `multi_agent_v1.spawn_agent`; `code-insiders`; `local-agent-bridge`
estado: `EXECUTED_LOCAL_VALIDATED`

acciones:
- Se despacho subagente lateral read-only para verificar si existia invocacion directa real de AAC desde Codex.
- Se leyo el manifiesto local real de Agile Agent Canvas `package.json` y `agent-manifest.csv` por estar referenciado en la matriz.
- Se confirmaron 21 agentes nativos AAC en el manifiesto de la extension.
- Se activo el roster AAC en modo repo-local con `activation_status=ACTIVE_AAC_NATIVE_TEAM_GOVERNED`.
- Se activo la matriz de uso nativo EPIC-6/S-6.* con `status=ACTIVE_AAC_NATIVE_TEAM_GOVERNED`.
- Se mantuvo `direct_invocation_from_codex=false` y `callable_from_codex_now=NO_DISPONIBLE_DIRECT_EXTENSION_CALL` para no declarar ejecucion nativa inexistente.
- Se abrio/reuso VS Code Insiders sobre el workspace para activar la superficie extension-local por `activationEvents: onStartupFinished`.
- Se reinicio `local-agent-bridge` y se verifico `/api/dashboard`.

evidencia:
- `multi_agent_v1.spawn_agent` => subagente `019ea5d8-a40b-7c01-95e8-173dfa3773c2` completo con `NO_CHANGES_REQUIRED_VALIDATED`.
- `C:\Users\enzo1\.vscode-insiders\extensions\msayedshokry.agileagentcanvas-0.5.2\package.json` declara `activationEvents: onStartupFinished`, comandos `agileagentcanvas.*`, chat participant y language model tools AAC.
- `agent-manifest.csv` declara los 21 agentes nativos AAC esperados.
- `code-insiders --reuse-window "C:\Users\enzo1\Documents\GitHub\cabina-universal-d"` => exit code 0.
- `Invoke-RestMethod http://127.0.0.1:8787/api/dashboard` => `primary=Agile Agent Canvas`, `native_status=ACTIVE_AAC_NATIVE_TEAM_GOVERNED`, `native_records=21`, `native_active=21`, `direct_invocation_from_codex=false`, `cabina_status=ACTIVE_CABINA_GOVERNED_WORK_LAYER`, `queue=Control de Agentes de Cabina`.

archivos:
- `.agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv`
- `.agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv`
- `.agileagentcanvas-context/planning/epics.json`
- `.agileagentcanvas-context/README.md`
- `local-agent-bridge/README.md`
- `local-agent-bridge/src/dashboardData.mjs`
- `local-agent-bridge/tests/mock_bridge_flow.mjs`
- `scripts/validators/local_agent_bridge_validator.py`
- `.agents/codex/readbacks/2026-06-08_aac_native_agents_activation_readback.md`

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
- `git diff --check`: PASS con warnings CRLF/LF, sin errores.

checks: NO_EJECUTADO; no hubo PR ni push remoto.
riesgo: bajo para activacion local declarativa y apertura de superficie; medio si alguien interpreta esto como ejecucion nativa directa desde Codex.
gate: ninguno para repo-local/VS Code local; `GATE_OPENAI_LIVE`, `GATE_LIVE_WRITE`, `GATE_SECRET_USE`, `GATE_REMOTE_GIT_MUTATION` si se pretende invocar proveedores, tokens, Jira/OpenAI/Microsoft o remoto.
rollback: `git restore -- .agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv .agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv .agileagentcanvas-context/planning/epics.json .agileagentcanvas-context/README.md local-agent-bridge/README.md local-agent-bridge/src/dashboardData.mjs local-agent-bridge/tests/mock_bridge_flow.mjs scripts/validators/local_agent_bridge_validator.py .agents/codex/readbacks/2026-06-08_aac_native_agents_activation_readback.md`
stop_condition: `aac_direct_codex_invocation_not_available`
pr: NO_EJECUTADO; no se abrio PR en este subpaso.
proximos_carriles: ejecutar tarjetas con agentes Cabina mediante `multi_agent_v1.spawn_agent`; usar el equipo nativo AAC en el tablero cuando la superficie VS Code/Agile Agent Canvas este disponible; no declarar despacho nativo directo desde Codex hasta que exista tool callable con evidencia.
