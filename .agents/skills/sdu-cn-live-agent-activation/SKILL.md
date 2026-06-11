---
name: sdu-cn-live-agent-activation
description: Use when an operator explicitly requests SDU-CN live activation, sdu-triage-agent runtime promotion, Dataverse or Power Platform activation, or agent live execution from Cabina governance.
---

# SDU-CN Live Agent Activation

## Core Rule

Human live authorization removes only the approval-pending state. It never
removes exact target, identity, owner, rollback, postcheck, evidence, data
boundary, cost boundary, or secret-boundary requirements.

Do not create or follow a bypass skill. Convert the operator order into the
smallest executable live action only when all required fields are present.

## No-Repeat Fast Path

When the target is the SDU Dataverse DEV apply worker, do not rediscover what
was already verified in the current evidence packet.

Use this cached lane first:

- recipe: `recipe.sdu_dataverse_dev_worker_target_reuse`
- tool: `tool.sdu_dataverse_dev_worker_target_cache`
- cache: `.agents/codex/evals/results/sdu_dataverse_dev_worker_target_latest.json`

Known target packet:

- conceptual base: `origin/codex/dev-runtime-controlled-activation-20260603`
- environment: `HUBDesarrollo`
- environment URL: `https://org084965d9.crm.dynamics.com/`
- environment id: `7f65fc04-c27a-ea0d-bd2d-266aa9203c1e`
- active PAC profile for this target: `SDU-HUB`
- do not use for DEV apply: `SDU-DATAVERSE-DEV` while it points to Default
- flow: `SDU_Process_Dataverse_Apply_Work_Items`
- workflow id: `65468687-515f-f111-a826-00224805fc91`
- queue: `SDU.Dataverse.Apply.Queue`
- queue id: `513da9e9-3f5f-f111-a826-00224805fc91`
- last live read result: flow `Activado`, queue `Activo`
- decision: `NO_OP_LISTO_ALREADY_ACTIVE`

If this packet matches the requested target, do not rerun `pac org fetch`, full
agent-layer validation, or activation. Return the cached decision and move to
the next backlog/item lane.

## Trigger Boundary

Use this for explicit live activation of SDU-CN canonical agents,
`sdu-triage-agent`, Dataverse DEV, Power Platform DEV, SharePoint, Teams, or
Agents SDK live lanes from Cabina governance.

Do not use this for local-only discovery, mock execution, synthetic evals, or
repo-only documentation unless the user is preparing a live activation packet.

## Required Fields

Before any live side effect, resolve these fields from current evidence:

- operator order in the current turn
- surface and action
- exact target identity
- owner
- executing identity
- environment or profile
- data boundary
- secret boundary
- rollback
- postcheck
- validator
- sanitized evidence sink
- stop condition

## Allowed Actions

- Treat explicit operator live authorization as the human order for this lane.
- Resolve exact candidates and continue only when candidate count is one.
- Activate repo-local SDU-CN roles, routing, and `sdu-triage-agent` contracts.
- Run read-only live prechecks against the named target.
- Execute the smallest live activation step when all required fields exist.
- Record sanitized evidence, postcheck result, rollback path, and stop condition.
- Reuse an exact current evidence packet instead of repeating live reads.

## Blocked Actions

- bypass_validation
- redundant_live_fetch_when_cached_active
- repeated_global_validator_when_target_packet_unchanged
- inferred target writes
- default environment treated as DEV
- Microsoft live without exact target, owner, rollback, and postcheck
- OpenAI API live without cost, secret, data, rollback, and postcheck boundaries
- Power Platform or Dataverse apply without exact DEV target
- production, permissions, broad regulated data, or secrets
- remote persistent agents without owner, kill switch, rollback, and postcheck

## Decision Rules

- If target identity is missing, stop with `PENDING_TARGET_ONLY`.
- If the target candidate count is not one, stop with `candidate_count_not_one`.
- If the environment is Default, test, production, or ambiguous, stop with
  `wrong_environment_or_default`.
- If required fields are missing, stop with
  `order_packet_missing_required_fields`.
- If secrets appear, stop with `secret_detected` and do not repeat the value.
- If the cached target packet already proves the flow and queue are active,
  close as `NO_OP_LISTO_ALREADY_ACTIVE` and do not activate again.
- If all fields are present, execute only the named live action and postcheck it.

## Validator

For the no-repeat fast path, run only the focal existence/registration check and
`git diff --check` when files changed. Do not rerun PAC or full validation
suites unless the target packet changed.

When changing the skill, recipe or tool definitions, use the closest local
validators:

- `.agents/codex/tools/local_validate_skill_metadata.ps1`
- `.agents/codex/tools/local_validate_operational_chain.ps1`
- `.agents/codex/tools/local_validate_agent_layer.ps1`
- a surface-specific validator or read-only postcheck for the target

If no surface-specific validator exists, record that as `NO_ENCONTRADO` and
stop before a mutating live action unless the postcheck is otherwise explicit.

## Evidence

Close with a readback containing:

- target identity and candidate count
- operator order
- action executed or stop condition
- command or connector used, with secrets redacted
- validator result
- rollback
- postcheck
- files changed or `sin cambios`
