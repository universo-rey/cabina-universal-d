# Governed Order Packet - Codex App Environment

- order_class: `codex_workspace_config`
- preparer_agent: `codex.workspace_guardian`
- reviewer_agent: `rey.frontier_guardian`
- approver_role: `operator`
- canon_as_of: `2026-06-12`
- source_authority: `AGENTS.md`, `CURRENT_STATE.md`, `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- surface: `codex_app_environment`
- identity: `LOCAL_CODEX_APP_CONTEXT_ONLY`
- owner: `operator|codex.workspace_guardian`
- data_boundary: local Codex/worktree metadata only; no global config; no D legacy write
- cost_boundary: `NO_COST_OPENED`
- secret_boundary: `NEVER_PRINT_NEVER_PERSIST`
- allowed_actions: prepare local environment review packet, metadata diff review
- blocked_actions: global config write, D legacy write, worktree metadata change without target, remote agent persistence, secrets
- rollback: discard packet; no local environment change performed
- postcheck: verify exact target path, no nested repo absorption and no global config mutation before execution
- evidence: `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- validator: `local_validate_agents_instruction_hierarchy.ps1`, `local_validate_codex_app_environments.ps1`
- expiration_rule: expires when workspace root or environment target changes
- stop_condition: `write_without_order|PENDING_TARGET_ONLY|remote_agent_persistence_without_order`

## Blueprint Agents

`local-executor`.

## Estado

`PREPARED_NOT_EXECUTED`

This packet prepares a local environment review only. It does not change
global Codex settings, worktree metadata, D legacy state or remote agents.
