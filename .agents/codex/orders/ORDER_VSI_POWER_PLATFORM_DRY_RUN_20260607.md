# Governed Order Preparation Packet: VSI Power Platform Dry Run

Status: `EXECUTED_LOCAL_VALIDATED`

- order_class: microsoft_live_or_permission
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-07
- source_authority: AGENTS.md|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv|VSCODE_INSIDERS_AGILE_AGENT_CANVAS_GOVERNANCE_20260606.csv
- surface: VS Code Insiders Power Platform dry-run or mock lane
- identity: local unauthenticated PAC CLI only; no Microsoft account, tenant or environment selected
- owner: codex.workspace_guardian
- data_boundary: local synthetic solution fixture only at `.agents/codex/evals/fixtures/power-platform/VsiLocalSolution`
- cost_boundary: no external checker, premium connector, capacity impact or paid service executed
- secret_boundary: no PAC auth token, connection reference, client secret or certificate read, stored or printed
- allowed_actions: execute `pac solution init` on local synthetic fixture; execute `pac solution pack` locally; record sanitized evidence; validate packet locally
- blocked_actions: pac_auth_change; power_platform_apply; solution_import; flow_enable_disable; connector_auth; dataverse_write; tenant_permission_change; production
- rollback: remove local fixture/readback and revert this packet plus task queue row; no tenant rollback required because no live write occurred
- postcheck: confirm PAC pack output exists locally, no Power Platform auth changed, no environment was selected, no connector auth changed and no Dataverse write occurred
- evidence: PAC CLI 2.5.1 local scaffold created; `pac solution pack --zipfile .\out\VsiLocalSolution_unmanaged.zip --folder .\src --packagetype Unmanaged` completed; no tenant, auth, Dataverse or production call executed
- validator: pac solution pack local dry-run|.agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_tenant_environment_solution_flow_connector_or_identity_changes
- stop_condition: power_platform_local_solution_pack_executed_validated

## Execution Boundary

This packet records a local unauthenticated PAC dry-run. It called PAC only for
local scaffold and local solution pack operations. It did not authenticate
Power Platform, did not select an environment, did not import a solution, did
not enable or disable flows, did not write Dataverse and did not touch
production.
