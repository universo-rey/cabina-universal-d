# Governed Order Packet - Power Platform / Dataverse

- order_class: `microsoft_live_or_permission`
- preparer_agent: `universe.escribania_tower`
- reviewer_agent: `rey.frontier_guardian`
- approver_role: `operator`
- canon_as_of: `2026-06-12`
- source_authority: `AGENTS.md`, `CURRENT_STATE.md`, `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- surface: `power_platform_dataverse`
- identity: `PENDING_IDENTITY_CONFIRMATION_SDU_DATAVERSE_DEV_OBSERVED_NOT_SELECTED_FOR_WRITE`
- owner: `operator|court.sdu_gate`
- data_boundary: metadata-only DEV/Sandbox evidence; no business data import; no queue processing
- cost_boundary: `NO_COST_OPENED`
- secret_boundary: `NEVER_PRINT_NEVER_PERSIST`
- allowed_actions: prepare order packet, metadata review, candidate recheck read-only only if separately ordered
- blocked_actions: Dataverse mutation, flow activation, queue item processing, connection change, permission change, production, secret materialization
- rollback: no live mutation to revert; discard packet or supersede by newer packet
- postcheck: exact environment, owner, target table/queue, candidate_count=1, rollback and postcheck must exist before any execution
- evidence: `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- validator: `local_validate_order_packets.ps1`, `local_validate_capability_use_hardening.ps1`
- expiration_rule: expires when environment, identity or target changes
- stop_condition: `write_without_order|candidate_count_not_one|wrong_environment_or_default`

## Blueprint Agents

`order-intake`, `context-router`, `authority-resolver`, `capability-selector`,
`dependency-checker`, `evidence-writer`, `trace-collector`, `readback-miner`,
`pattern-detector`, `failure-classifier`, `decision-memory-writer`,
`gap-detector`, `improvement-hypothesis-builder`, `fixture-builder`,
`synthetic-eval-runner`, `skill-gap-proposer`, `registry-normalizer`,
`versioning-advisor`.

## Estado

`PREPARED_NOT_EXECUTED`

This packet prepares an order. It does not execute Microsoft live, Dataverse
write, Power Platform apply, flow activation, production, permissions, secrets
or broad regulated reads.
