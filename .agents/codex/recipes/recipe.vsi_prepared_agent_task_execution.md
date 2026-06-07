# Recipe: VSI Prepared Agent Task Execution

Use when an agent executes one prepared local task from
`.agents/codex/matrices/VSCODE_INSIDERS_AGENT_TASK_QUEUE_20260606.csv`.

## Inputs

- `task_id`
- `branch`
- `lead_agent`
- `owner_agent`
- `reviewer_agent`
- `read_scope`
- `write_scope`
- `lock_key`
- `dependency`
- `allowed_actions`
- `blocked_actions`
- `rollback`
- `postcheck`
- `evidence`
- `validator`
- `stop_condition`

## Steps

1. Read the exact queue row and dependency row.
2. Confirm the row is local or repo-scoped and has an exact write scope.
3. Execute only the declared local write scope.
4. Preserve agent-facing ids, status values, API contracts and lock keys.
5. For Spanish human view work, write only UI copy or existing display fields.
6. Run the row validator and `git diff --check`.
7. Record evidence and update the queue row status only after validation.

## Blocked

- live provider calls
- external writes
- secrets
- production
- tenant or permission changes
- destructive VS Code Insiders cleanup
- Git metadata mutation
- edits outside the row write scope

## Output

`vsi_task_execution_readback`

## Stop Conditions

- `vsi_task_row_missing`
- `vsi_task_dependency_not_ready`
- `vsi_task_write_scope_missing`
- `vsi_task_validator_missing`
- `human_translation_affects_agent_contract`
- `queued_task_rendered_as_executed`
- `live_gate_packet_missing_required_fields`
