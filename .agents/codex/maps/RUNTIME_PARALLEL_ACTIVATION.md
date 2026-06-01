# Runtime And Parallel Activation

## Purpose

Declare the local activation path for Cabina runtime alignment, Agents SDK
preflight and parallel issue lanes without opening live API, Microsoft,
production, secrets or remote persistent agents.

## Local Runtime Check

Use this command when the goal is to prove runtime alignment without changing
the latest result file:

```powershell
& 'D:\.agents\codex\tools\local_run_repo_alignment_runtime.ps1' -NoWrite
```

Expected result:

- `status: PASS`
- `mode: LOCAL_SYNTHETIC_ALIGNMENT_ONLY`
- `result_written: false`
- blocked surfaces include `openai_api_live`, `microsoft_live`,
  `production`, `permissions`, `secrets`, `force_push` and `merge`

Use the command without `-NoWrite` only when the operator wants to refresh
`D:\.agents\codex\evals\results\repo_alignment_runtime_latest.json`.

## Agents SDK Local Preflight

Use this command to prove the local Agents SDK import boundary:

```powershell
& 'D:\.agents\codex\tools\local_validate_github_automation_preflight.ps1' -CheckLocalSdk
```

Expected result:

- `status: PASS`
- `local_sdk_checked: true`
- `smoke=OK_NO_API_CALL`
- no OpenAI API call is executed

If OpenAI API live, Agents SDK live, Agent Builder, external vector stores,
costs, secrets or remote persistent agents are requested, stop and prepare a
governed order packet.

## Parallel Issue Queue

The active queue is
`D:\.agents\codex\matrices\PARALLEL_ISSUE_LANE_QUEUE.csv`.

It maps each issue or work unit to:

- `base_sha`
- `branch`
- `lane_id`
- `lead_agent`
- `owner_agent`
- `reviewer_agent`
- exact `read_scope` and `write_scope`
- unique `lock_key`
- `dependency`
- `max_parallel`
- rollback, postcheck, evidence, validator and stop condition

Validate it with:

```powershell
& 'D:\.agents\codex\tools\local_validate_parallel_issue_queue.ps1'
```

Issue workers may run in parallel only when their active rows have distinct
`lock_key` values and non-overlapping exact `write_scope` tokens. Shared index
updates must be serialized in an integration row.
