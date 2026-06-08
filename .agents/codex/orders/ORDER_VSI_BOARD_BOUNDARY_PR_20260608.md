# Governed Order Preparation Packet: VSI Board Boundary PR

Status: `PENDING_REMOTE_GIT_GATE_ONLY`

- order_class: github_merge_or_pr
- preparer_agent: rey.repo_cartographer
- reviewer_agent: court.seshat_evidence
- approver_role: operator
- canon_as_of: 2026-06-08
- source_authority: AGENTS.md|EPIC-6|S-6.4|VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv
- surface: repo-local GitHub lifecycle for VSI mother board and Control de Agentes de Cabina boundary artifacts
- identity: local Codex workspace on C:/Users/enzo1/Documents/GitHub/cabina-universal-d; remote Git identity not used in this carril
- owner: rey.repo_cartographer
- data_boundary: repo metadata and local artifacts only; no Microsoft live, no OpenAI live payload, no production, no secrets
- cost_boundary: no external cost approved
- secret_boundary: no secret use, no secret print, no secret persistence
- repo: universo-rey/cabina-universal-d
- base_branch: main
- work_branch: codex/vsi-board-boundary-pr-20260608 only after GATE_REMOTE_GIT_MUTATION
- pr: create or update PR only after GATE_REMOTE_GIT_MUTATION
- checks: local validators first; GitHub checks only after PR exists
- merge_method: no merge in this packet; merge requires GATE_MERGE_MAIN and green checks
- allowed_actions: keep local package ready; create codex branch, stage explicit paths, commit, push, draft PR, update PR and monitor checks only after remote Git gate
- blocked_actions: force push, delete remote branch, change remotes, change core.worktree, merge main, permissions, secrets, production, Microsoft live, OpenAI API live
- rollback: local package rollback is `git restore -- .agents/codex/orders/ORDER_VSI_BOARD_BOUNDARY_PR_20260608.md .agileagentcanvas-context .agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv`; remote rollback requires the later PR/branch SHA if executed
- postcheck: run `git diff --check`, `npm test --prefix local-agent-bridge`, `python scripts/validators/local_agent_bridge_validator.py`, `.agents/codex/tools/local_validate_order_packets.ps1`, `.agents/codex/tools/local_validate_agent_layer.ps1`
- evidence: S-6.4 subagent readback; local preflight root branch head remote; no branch, stage, commit, push or PR executed in this carril
- validator: .agents/codex/tools/local_validate_order_packets.ps1|git diff --check
- expiration_rule: expires_when_head_branch_scope_or_remote_authorization_changes
- stop_condition: github_order_missing_checks

## Execution Boundary

This packet prepares the PR boundary only. It does not create a branch, stage,
commit, push, open PR, merge, force push, change remotes, touch Git metadata,
execute Microsoft live, execute OpenAI API live, use secrets or touch
production.
