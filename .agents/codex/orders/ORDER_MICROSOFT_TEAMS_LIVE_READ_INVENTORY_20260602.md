# Governed Order Preparation Packet

- order_class: microsoft_teams_live_read_inventory
- preparer_agent: rey.frontier_guardian
- reviewer_agent: court.sdu_gate
- approver_role: operador
- canon_as_of: 2026-06-02
- source_authority: operador_aprueba_live_microsoft_2026-06-02
- surface: Microsoft Teams connector; Microsoft Graph read surfaces exposed by Teams plugin; repo-local cabina evidence only
- identity: efigueroa@registronotarial8tdf.com.ar as operator-declared governed user target; connector signed-in identity must not be assumed unless tool output confirms it
- owner: universe.escribania_tower for ESCRIBANIA Teams governance; universe.modo_on_tower for MODO_ON Teams governance; court.seshat_evidence for sanitized evidence; rey.frontier_guardian for boundary
- data_boundary: minimal metadata and non-sensitive summaries only; allowed user resolution, joined teams list, chat/thread metadata, channel metadata when a team is selected, and query terms tied to governance lanes; no raw transcript archival; no broad regulated data dump
- cost_boundary: no external cost; use existing Teams connector only
- secret_boundary: no tokens, cookies, credentials, Graph secrets, OAuth artifacts, or message bodies that look secret-bearing may be persisted
- allowed_actions: resolve_user; list_teams; list_chats; list_recent_threads; search non-sensitive governance terms; fetch only a selected path if needed for lane classification; write sanitized readback and matrix
- blocked_actions: send_chat_message; send_channel_message; reply_to_message; reply_to_channel_message; create_channel; create_chat; create_update_delete_planner_task; permission_change; tenant_admin_change; production; raw_message_export; regulated_broad_read; secret_materialization
- rollback: no Microsoft mutation is authorized; if evidence is overbroad, delete or redact local artifact before commit; discard raw connector payloads after sanitized matrix/readback
- postcheck: confirm no Teams write tools were called; confirm only sanitized counts and lane classifications are versioned; run local Teams lane validator and secret scan
- evidence: D:/.agents/codex/matrices/TEAMS_CROSS_REPO_LANE_AUDIT_MATRIX_20260602.csv; D:/.agents/codex/readbacks/2026-06-02_teams_cross_repo_lane_audit_readback.md; Teams connector live-read status summarized without raw transcript persistence
- validator: D:/.agents/codex/tools/local_validate_teams_cross_repo_lane_audit.ps1
- expiration_rule: expires_at_2026-06-03T00:00:00-03:00_or_when_PR_closes_first
- stop_condition: microsoft_live_requested_without_governed_order|regulated_data_boundary_unclear|production_requested_without_explicit_authorization|secret_detected

## Execution Boundary

This packet authorizes only a governed live-read inventory for Teams lane
classification. It does not authorize Teams posts, replies, channel creation,
Planner writes, tenant writes, permission changes, production execution,
secret handling, or broad regulated data reads.
