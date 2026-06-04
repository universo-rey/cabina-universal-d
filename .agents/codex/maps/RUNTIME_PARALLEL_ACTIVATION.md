# Runtime And Parallel Activation

## Purpose

Declare the local activation path for Cabina runtime alignment, Agents SDK
preflight and parallel issue lanes without opening live API, Microsoft,
production, secrets or remote persistent agents.

## Work Dispatch And SDK Activation

When the operator asks to send work to Codex Cloud, GitHub automation, OpenAI,
Responses API or Agents SDK, the cabina must activate the standard agent chain
before dispatch:

`rey.control_plane_orchestrator -> court.openai_dispatcher -> sdu-triage-agent -> court.sdu_gate -> court.seshat_evidence`.

The dispatch packet must name the exact repo or environment, branch or surface,
prompt or payload boundary, rollback, postcheck, evidence, validator and stop
condition. `codex cloud exec` is treated as remote task-scoped dispatch.

Agents SDK is activated when the sent work needs agentic triage, structured
runtime validation, response-contract checks or synthetic runtime evidence.
Default evidence remains synthetic or sanitized. Live body output, secrets,
Microsoft writes, production, permission changes, broad regulated data and
remote persistent agents still require a separate governed order.

`codex cloud apply` is not part of initial dispatch. It remains blocked until
the diff is reviewed, the local branch/worktree is classified, rollback is
available and local validators pass.

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
  `production`, `permissions`, `secrets`, `force_push` and
  `merge_without_approved_precheck`

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
