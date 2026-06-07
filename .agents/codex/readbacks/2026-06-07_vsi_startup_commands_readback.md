# VSI startup commands readback

- agente: rey.control_plane_orchestrator
- orden: fijar comando de inicio VSI sin volver a estados de preparacion para carriles ya implementados
- superficie: VSI/local dashboard/Agile Agent Canvas/VS Code Insiders
- repo: universo-rey/cabina-universal-d
- branch: codex/vsi-startup-command-canon
- estado: EXECUTED_LOCAL_VALIDATED

## Acciones

- Se agrega `.agents/codex/tools/local_start_vsi_cabina.ps1` como comando canonico de inicio local.
- El comando inicia o reutiliza el dashboard loopback en `http://127.0.0.1:8795`.
- El comando verifica `code-insiders.cmd`, la extension `msayedshokry.agileagentcanvas` y el user catalogue path absoluto hacia `.agents\skills`.
- El comando abre Agile Agent Canvas salvo que se use `-NoOpenVsi`.
- El comando lee `/api/dashboard` y falla si tareas completadas hasta `vsi.agent.task.039` dejan de ser `EXECUTED_*`.

## Evidencia esperada

```powershell
powershell -ExecutionPolicy Bypass -File .agents\codex\tools\local_start_vsi_cabina.ps1
```

Salida esperada:

- `status=PASS`
- `dashboard_url=http://127.0.0.1:8795`
- `queued_agent_tasks=0`
- `executed_agent_tasks>=39`
- `no_completed_task_downgrade=true`
- `live_executed=false`

## Evidencia ejecutada

- Startup command: PASS
- Dashboard: `http://127.0.0.1:8795`
- Agile Agent Canvas extension: `msayedshokry.agileagentcanvas@0.5.2`
- Canvas window found: `true`
- Canvas status: `ACTIVE_LOCAL_WORKBENCH`
- Active lane: `ACTIVE_LOCAL_GOVERNED_USE`
- Local actions ready: `21`
- Agent task queue records: `39`
- Executed agent tasks: `39`
- Queued agent tasks: `0`
- No completed task downgrade: `true`
- `npm test --prefix local-agent-bridge`: PASS
- `python scripts\validators\local_agent_bridge_validator.py`: PASS
- `.agents\codex\tools\local_validate_order_packets.ps1`: PASS
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`: PASS
- `.agents\codex\tools\local_validate_agent_layer.ps1`: PASS
- `.agents\codex\tools\local_validate_operational_chain.ps1`: PASS
- `.agents\codex\tools\local_validate_parallel_order_governance.ps1`: PASS
- `git diff --check`: PASS

## Rollback

```powershell
git restore -- .agents/codex/tools/local_start_vsi_cabina.ps1 .agents/codex/maps/VSI_STARTUP_COMMANDS_20260607.md .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv .agents/codex/tools/TOOL_INDEX.csv .agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv .agents/codex/matrices/MATRIX_INDEX.csv .agents/codex/matrices/STOP_CONDITION_GLOSSARY.csv
git clean -f -- .agents/codex/readbacks/2026-06-07_vsi_startup_commands_readback.md
```

Si se necesita revertir el setting local de usuario de VS Code Insiders, quitar
la clave `agileagentcanvas.userCataloguePath` de
`%APPDATA%\Code - Insiders\User\settings.json`.

## Stop condition

`vsi_startup_state_regression_detected`
