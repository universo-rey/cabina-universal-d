# SDU Local Agent Bridge DEV

Local mock bridge for SDU agent runtime connection tests. It accepts synthetic
Teams-like activity, resolves the route, checks the MCP registry mode and emits
sanitized evidence.

It also serves a local read-only agent control dashboard from the existing
governance matrices.

The local shell connector is status-only. It reports the governed shell surface
and blocks command execution through the bridge unless a separate task scope or
gate opens that action.

## Boundary

- Bind to `127.0.0.1` only.
- Dashboard and shell status data are blocked when the bridge is bound to a
  non-loopback host such as `0.0.0.0`.
- Synthetic payloads only.
- Dashboard reads local CSV matrices only.
- No external writes.
- No Teams live message.
- No Graph write.
- No OpenAI live.
- No Codex Cloud apply.

## Commands

Run the mock flow:

```bash
npm test --prefix local-agent-bridge
```

Run the local bridge manually:

```bash
npm start --prefix local-agent-bridge
```

Open the dashboard:

```text
http://127.0.0.1:8787/
```

Check the governed shell connector:

```text
http://127.0.0.1:8787/api/shell/status
```

Run the guided local validation postcheck from the dashboard:

```text
POST http://127.0.0.1:8787/api/local-actions/run
```

`local.action.inspect_canvas_lane` runs a structured no-shell review of Agile
Agent Canvas artifacts, write allowlist and validators. `local.action.review_task_queue`
runs a structured no-shell review of the repo task queue.
`local.action.review_live_gate_packets` reviews local gate packets for Jira,
OpenAI, Microsoft and Power Platform without calling providers.
`local.action.review_bridge_contract` reviews the loopback contract, local action
allowlist and route matrix without exposing shell execution.
`local.action.review_dashboard_integrity` checks task counts, canvas artifacts,
local action readiness and the no-live boundary as one structured dashboard
review. `local.action.review_action_boundary` checks every local action plan for
stop conditions, shell exposure and live execution. `local.action.review_readiness_bundle`
aggregates the queue, canvas, live-gate packet, contract, dashboard integrity and
action boundary reviews into one local no-shell readiness result.
`local.action.review_ui_translation_integrity` checks that human dashboard labels
and result renderers cover the local action surface. `local.action.review_task_lineage`
checks task dependencies, locks, branches and validation status.
`local.action.review_canvas_story_sync` checks Agile Canvas story counts,
functional references and recent task queue rows.
`local.action.review_route_contract_sync` checks contract allowed routes against
the route matrix. `local.action.review_server_endpoint_guards` checks loopback,
dev-auth and no-live endpoint guards in the local server.
`local.action.review_validator_coverage` checks that contract, validator, test,
README and human UI cover every local action and structured result key.
`local.action.review_error_response_shape` checks blocked and not-found responses
for safe status, no-live evidence and bounded request bodies.
`local.action.review_postcheck_allowlist` checks that the guided postcheck stays
on the fixed local command allowlist. `local.action.review_shell_block_consistency`
checks that the shell connector, contract and route matrix all keep arbitrary
shell execution blocked. `local.action.review_dashboard_summary_consistency`
checks summary counts for local actions, executed queue rows and the active
Agile Canvas lane. `local.action.review_local_action_status_consistency` checks
local action statuses, execution modes and required fields.
`local.action.review_readiness_component_coverage` checks the readiness bundle
component set for expected coverage and uniqueness.
`local.action.prepare_local_validation` runs a fixed postcheck allowlist. The
bridge still does not expose arbitrary shell commands.
