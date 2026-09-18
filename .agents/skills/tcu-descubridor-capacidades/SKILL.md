---
name: tcu-descubridor-capacidades
description: Use when skill discovery is needed only because a required capability is missing or an existing capability assignment has been invalidated. Reuse unchanged assignments and query only missing or changed information.
---

# TCU Descubridor Capacidades

## Core Rule

Resume the order with its resolved administrative context and assigned capability.
Discovery applies only to a missing capability or an invalidated assignment.
Use the prepared global metadata and the assigned source to resolve that delta;
do not rebuild catalogs or repeat discovery for an unchanged assignment.
A named capability must resolve to an available runtime, connector or registered
implementation. If it cannot resolve, report the exact missing capability.

## Continuity First

Before discovery, consume any matching CURRENT_WORKPAPER, execution receipt,
continuation readback, lane state, task_id, correlation_id, next_agent or
next_workpacket. If that pointer resolves the next consumer, return it and resume
execution. Do not redispatch an existing task or rebuild its capability chain.

Discovery is a repair path only when the continuation/capability pointer is
missing, invalidated or materially contradicted.

## Trigger Boundary

Use this skill only for `missing_or_invalidated_capability_assignment` after existing continuity pointers have been consumed.
Intake, handoff, dispatch, execution and closeout do not themselves trigger it.
An existing assignment remains usable until a relevant change or failure
invalidates it. Permissions and live boundaries follow the assigned operation.

## Allowed Actions

- inspect available skills, recipes, tools, plugins, and agent assignments
- select the smallest real capability chain for the task
- map capability gaps as `NO_DISPONIBLE`
- update local governance matrices and readbacks when capability assignments
  change
- route to Codex Cloud only when the repo, branch, data boundary, owner,
  rollback, validator, and stop condition are declared

## Blocked Actions

- inventing unavailable skills, recipes, plugins, tools, or validators
- using Codex Cloud for secrets, broad regulated data, Microsoft live,
  production, OpenAI API live, permission changes, or tenant writes
- activating persistent remote agents without a governed order
- replacing human or institutional authority

## Workflow

1. Reuse the order, purpose, process, object, state, owner and expected result.
2. If the assignment is resolved and unchanged, return it and resume execution.
3. Otherwise query only the missing or changed capability in the prepared
   global metadata, assigned connector or exact registry.
4. Resolve that dependency with its owner and return the updated assignment.
5. If unavailable, mark `NO_DISPONIBLE` for that substep and continue independent
   work. Apply the operation's own permissions and authorization protocol.
6. Check the result with the operation's mechanism; formal readback is required
   only when that operation requires it.

## Validator

Primary:
`.agents\codex\tools\local_validate_capability_use_hardening.ps1`.

Companion:
`.agents\codex\tools\local_validate_autonomous_agent_execution.ps1`.

## Stop Conditions

- `capability_use_preflight_missing`
- `default_skill_missing`
- `codex_cloud_environment_missing`
- `autonomous_agent_order_missing`
- `secret_detected`
