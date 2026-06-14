# Governed Order Packet - GitHub Repo-Scoped

- order_class: `github_merge_or_pr`
- preparer_agent: `rey.repo_cartographer`
- reviewer_agent: `court.seshat_evidence`
- approver_role: `operator`
- canon_as_of: `2026-06-12`
- source_authority: `AGENTS.md`, `CURRENT_STATE.md`, `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- surface: `github_repo_scoped`
- identity: `PENDING_GITHUB_IDENTITY_CONFIRMATION`
- owner: `operator|rey.repo_cartographer`
- data_boundary: repo-scoped governance files only; no nested repos; no secrets
- cost_boundary: `NO_COST_OPENED`
- secret_boundary: `NEVER_PRINT_NEVER_PERSIST`
- allowed_actions: prepare branch plan, explicit stage plan, draft PR plan, validator plan
- blocked_actions: `git add .`, force push, remote branch delete, merge without precheck, permissions, production, Microsoft live, OpenAI API live, secrets
- rollback: close draft plan; revert prepared local files if versioned later
- postcheck: git status, explicit staged file list, validators green, PR/checks only after separate lifecycle order
- evidence: `14_CODEX_EVOLUTIONARY_BLUEPRINT_AGENT_RECONCILIATION_V4_CANONICALIZED.csv`
- validator: `local_validate_order_packets.ps1`, `local_validate_github_automation_preflight.ps1`
- expiration_rule: expires when branch, HEAD or scope changes
- stop_condition: `github_order_missing_checks|merge_without_approved_precheck|write_without_order`

## Blueprint Agents

`intent-classifier`, `task-graph-builder`, `workspace-router`,
`parallel-agent-dispatcher`, `validator`, `closure-judge`,
`repair-loop-planner`, `validator-orchestrator`, `regression-checker`,
`promotion-advisor`, `capability-expansion-planner`, `agent-factory-planner`,
`promotion-gate-resolver`, `rollback-planner`.

## Estado

`PREPARED_NOT_EXECUTED`

This packet prepares GitHub repo-scoped order language only. It does not stage,
commit, push, create PRs, merge or mutate GitHub state.
