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
- El comando valida que el bridge reutilizado pertenezca a este repo antes de tocar el setting de VS Code Insiders.
- El comando verifica `code-insiders.cmd`, la extension `msayedshokry.agileagentcanvas` y el user catalogue path absoluto hacia `.agents\skills`.
- El comando abre Agile Agent Canvas salvo que se use `-NoOpenVsi`.
- El comando lee `/api/dashboard` y falla si tareas completadas hasta `vsi.agent.task.039` dejan de ser `EXECUTED_*`.

## Evidencia esperada

```powershell
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .agents\codex\tools\local_start_vsi_cabina.ps1
```

Salida esperada:

- `status=PASS`
- `dashboard_url=http://127.0.0.1:8795`
- `bridge_repo_root_verified=true`
- `queued_agent_tasks=0`
- `executed_agent_tasks>=39`
- `no_completed_task_downgrade=true`
- `live_executed=false`

## Evidencia ejecutada

- Startup command: PASS
- Dashboard: `http://127.0.0.1:8795`
- Bridge repo root verified: `true`
- Agile Agent Canvas extension: `msayedshokry.agileagentcanvas@0.5.2`
- Canvas window found: `true`
- Canvas status: `ACTIVE_LOCAL_WORKBENCH`
- Active lane: `ACTIVE_LOCAL_GOVERNED_USE`
- Local actions ready: `21`
- Agent task queue records: `39`
- Executed agent tasks: `39`
- Queued agent tasks: `0`
- No completed task downgrade: `true`
- Bridge launch path: direct `node.exe src/server.mjs`, no nested `powershell.exe -Command`
- `npm test --prefix local-agent-bridge`: PASS
- `python scripts\validators\local_agent_bridge_validator.py`: PASS
- `.agents\codex\tools\local_validate_order_packets.ps1`: PASS
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`: PASS
- `.agents\codex\tools\local_validate_agent_layer.ps1`: PASS
- `.agents\codex\tools\local_validate_operational_chain.ps1`: PASS
- `.agents\codex\tools\local_validate_parallel_order_governance.ps1`: PASS
- `.agents\codex\tools\local_validate_powershell_runtime_friction.ps1`: PASS
- `git diff --check`: PASS

## Evidencia adicional de friccion PowerShell e ignorados

- `pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .agents\codex\tools\local_start_vsi_cabina.ps1 -Port 8796 -NoOpenVsi`: PASS
- `bridge_started=true`
- `bridge_process_id=21068`
- Proceso temporal `8796` cerrado despues del smoke.
- El bridge se levanto con `node.exe src/server.mjs`, sin `powershell.exe -Command`.
- `.agents\codex\tools\local_validate_powershell_runtime_friction.ps1`: `POWERSHELL_RUNTIME_FRICTION_PASS warnings=0 truncated=False`
- `git check-ignore -v readbacks\EXAMPLE.md`: permitido por `!/readbacks/*.md`
- `git check-ignore -v .agents\codex\readbacks\EXAMPLE.md`: permitido por `!/.agents/codex/readbacks/*.md`
- `git check-ignore -v .agents\codex\readbacks\example.json`: sigue ignorado por `/.agents/codex/readbacks/*`
- `git check-ignore -v .agents\codex\orders\ORDER_EXAMPLE.md`: sigue ignorado por `/.agents/codex/orders/*`
- Readbacks markdown saneados que quedaron visibles al corregir politica y se versionan en este carril:
  `.agents\codex\readbacks\2026-06-05_agents_global_improvement_readback.md` y
  `.agents\codex\readbacks\2026-06-05_local_tooling_continuity_handoff.md`.

## Evidencia de comentario PR

- Comentario revisado: PR #122 discussion `r3370077888`.
- Hallazgo: el startup confiaba en `/health` cuando el puerto `8795` ya estaba ocupado.
- Correccion: se agrego validacion temprana de `/api/dashboard.repo_root` contra el repo efectivo antes de tocar el setting de VS Code Insiders.
- Stop condition agregada: `vsi_startup_bridge_repo_mismatch`.
- Smoke bridge reutilizado `8795`: PASS con `bridge_repo_root_verified=true`.
- Smoke bridge nuevo `8797`: PASS con `bridge_started=true`, `bridge_process_id=31452`, proceso temporal cerrado.
- Validadores posteriores al comentario: npm test PASS, bridge validator PASS, PowerShell friction PASS, order packets PASS, agent layer PASS, capability PASS, operational chain PASS, parallel governance PASS, `git diff --check` PASS.

## Rollback

```powershell
git restore -- .agents/codex/tools/local_start_vsi_cabina.ps1 .agents/codex/maps/VSI_STARTUP_COMMANDS_20260607.md .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv .agents/codex/tools/TOOL_INDEX.csv .agents/codex/matrices/TOOL_GOVERNANCE_MATRIX.csv .agents/codex/matrices/MATRIX_INDEX.csv .agents/codex/matrices/STOP_CONDITION_GLOSSARY.csv
git restore -- .agents/codex/readbacks/2026-06-07_vsi_startup_commands_readback.md
```

Si se necesita revertir el setting local de usuario de VS Code Insiders, quitar
la clave `agileagentcanvas.userCataloguePath` de
`%APPDATA%\Code - Insiders\User\settings.json`.

## Stop condition

`vsi_startup_state_regression_detected`
`vsi_startup_bridge_repo_mismatch`
