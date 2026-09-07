---
name: tcu-descubridor-capacidades
description: Use when an unknown, ambiguous, materially changed or newly proposed Cabina capability needs skill discovery or capability assignment. Reuse current known bindings without repeating discovery for routine tasks.
---

# TCU Descubridor Capacidades

## Core Rule

Consume known capabilities and current bindings directly. A skill,
recipe, plugin, or tool is not available just because its name appears in text.
It must exist in the active runtime, repo-local catalog, plugin list, or
governed matrix. If it does not resolve, mark it `NO_DISPONIBLE`.

## Trigger Boundary

Use this skill when the required capability is unknown, ambiguous, materially
changed, or a new capability is proposed. Intake, handoff, execution and closeout
do not trigger discovery by themselves. Existing assignments are references;
having this skill in a default catalog does not require invoking it every time.

## Allowed Actions

- inspect available skills, recipes, tools, plugins, and agent assignments
- select the smallest real capability chain for the task
- map capability gaps as `NO_DISPONIBLE`
- update local governance matrices and readbacks when capability assignments
  change
- route to the available execution environment with the exact target and binding;
  apply write controls only to writes and explicit authorization only to HIGH

## Blocked Actions

- inventing unavailable skills, recipes, plugins, tools, or validators
- exposing secrets or transferring unnecessary regulated data
- executing without the capability, identity or exact binding actually needed
- executing HIGH effects without scoped explicit authorization, including
  production, permission/identity changes, destructive effects and open-ended cost
- replacing human or institutional authority

Normal authentication through an existing binding does not constitute secret
exposure or trigger HIGH. `secret_detected` concerns material in artifacts or
outputs, not legitimate credential use that keeps it out of those surfaces.

## Workflow

1. Consume the known current assignment and binding. Read the capability-use
   matrix only when resolution is needed; do not rebuild a global inventory.
2. Resolve the missing or ambiguous component against its existing catalog or
   advertised runtime. A catalog declaration alone does not establish live access.
3. Select only the components applicable to the requested effect. READ/LOW can
   use a minimal chain; optional skills, recipes, plugins or validators may be
   omitted or marked NO_APLICA. Keep ownership when the operation needs it.
4. If the task can run autonomously, classify it as local task-scoped,
   GitHub task-scoped, or Codex Cloud task-scoped.
5. A missing material capability produces `RESOLUTION_REQUIRED` only for the
   affected operation, retaining READ/LOW/HIGH. Continue independent work. Missing
   capability is not a reason to prepare an order; only a positive HIGH effect is.
6. Close with the operation result or exact limitation and relevant validation.
   READ does not require rollback. LOW writes need precheck, reversibility or
   compensation and postcheck. Do not require a global evidence package or audit
   for ordinary technical work. Microsoft/OpenAI live is classified by effect,
   with no blanket prohibition based on provider or Cloud environment.

## Validator

When changing the capability catalog or contract, primary:
`.agents\codex\tools\local_validate_capability_use_hardening.ps1`.

When changing autonomous execution configuration, companion:
`.agents\codex\tools\local_validate_autonomous_agent_execution.ps1`.

## Stop Conditions

- `operation_requirement_unresolved` for the affected operation only
- `codex_cloud_environment_missing`
- HIGH effect without scoped explicit authorization
- `secret_detected`
