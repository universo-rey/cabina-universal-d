# VSI Power Platform Local Dry Run Readback - 2026-06-07

- agente: codex.workspace_guardian
- orden: execute_power_platform_local_dry_run
- superficie: VSI/Power Platform local dry-run
- estado: EXECUTED_LOCAL_VALIDATED
- branch: codex/vsi-power-platform-local-dry-run
- head_base: 6c582e7
- packet: .agents/codex/orders/ORDER_VSI_POWER_PLATFORM_DRY_RUN_20260607.md
- task: vsi.agent.task.038
- fixture: .agents/codex/evals/fixtures/power-platform/VsiLocalSolution
- pac_cli: Microsoft PowerPlatform CLI 2.5.1+gab954cf
- executed_local_commands: pac solution init; pac solution pack
- packed_output: .agents/codex/evals/fixtures/power-platform/VsiLocalSolution/out/VsiLocalSolution_unmanaged.zip
- packed_output_versioned: false
- tenant_selected: false
- environment_selected: false
- pac_auth_changed: false
- connector_auth_changed: false
- dataverse_write_executed: false
- solution_import_executed: false
- flow_enable_disable_executed: false
- production_executed: false
- secrets_printed: false

## Evidence

PAC created a synthetic local Dataverse solution project named
`VsiLocalSolution` with publisher `CabinaUniversal` and prefix `cabina`.
PAC then packed the local `src` folder into an unmanaged solution ZIP under the
fixture `out` folder. The ZIP is a build output and is not versioned.

## Validators

- pac solution pack local dry-run: PASS
- .agents/codex/tools/local_validate_order_packets.ps1: PASS
- git diff --check: PASS

## Stop Condition

power_platform_local_solution_pack_executed_validated

## Rollback

Remove the fixture and revert the packet, readback and task queue row. No
tenant rollback is required because no Microsoft live write occurred.
