# Governed Order Preparation Packet

- order_class: openai_api_or_remote_agent
- preparer_agent: court.openai_dispatcher
- reviewer_agent: court.sdu_gate
- approver_role: operador
- canon_as_of: 2026-06-01
- source_authority: D:/AGENTS.md; operador aprueba Agents SDK y mejora del flujo GitHub
- surface: D:/ cabina root; universo-rey/cabina-universal-d; GitHub automation preflight; Agents SDK local
- identity: Codex local + GitHub CLI/App context; no secrets in repo; no OpenAI API key persisted
- owner: operador
- data_boundary: repo metadata, matrices, templates, readbacks and synthetic eval metadata only; no broad regulated data
- cost_boundary: no OpenAI API cost; GitHub Actions read-only validation only
- secret_boundary: no secret materialization; OPENAI_API_KEY may only come from approved local or secret-store context outside repo
- allowed_actions: validate GitHub templates; validate order packets; run local Agents SDK import smoke; prepare prompts and synthetic eval plans; branch/commit/push/PR only under governed GitHub order
- blocked_actions: openai_api_live|agents_sdk_live|agent_builder_live|external_vector_store|cost|secret_materialization|production|microsoft_live|permissions|merge_without_approved_precheck|force_push|delete_remote_branch|moving_clones
- rollback: revert this order packet plus preflight matrix/tool/workflow/template changes on the same branch before merge
- postcheck: local_validate_github_automation_preflight.ps1 PASS; local_validate_agent_layer.ps1 PASS; GitHub Actions cabina validation PASS
- evidence: D:/.agents/codex/matrices/GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv; D:/.agents/codex/tools/local_validate_github_automation_preflight.ps1; PR checks
- validator: D:/.agents/codex/tools/local_validate_github_automation_preflight.ps1
- expiration_rule: expires when repo, identity, branch, model, data boundary, cost boundary, secret boundary or live surface changes
- stop_condition: openai_api_live_requested_without_order|github_order_missing_checks

## Execution Boundary

This packet prepares GitHub automation readiness and local Agents SDK
preflight. It does not execute OpenAI API live, Agents SDK live, Agent Builder,
Microsoft live, production, permissions, secrets, costs, merges without
approved precheck, force pushes,
remote persistent agents or regulated broad reads.
