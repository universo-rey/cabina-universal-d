---
name: parallel-order-governance
description: Use when coordinating parallel agents, subagents, order preparation, OpenAI-local design, or post-merge retrospective work in D:\.agents\codex.
---

# Parallel Order Governance

## Core Rule

Parallel work is allowed only when each lane has a named owner, disjoint write
scope, declared evidence, validator and stop condition. Any live, production,
permission, secret, cost or broad regulated-data surface becomes an order
preparation task, not an execution task.

## Subskills

- `subskill.parallel-intake`: classify lanes as blocking, sidecar or forbidden before spawning agents.
- `subskill.disjoint-scope`: assign one owner per file set; never let two agents write the same file family.
- `subskill.order-preflight`: prepare orders with surface, identity, owner, data boundary, rollback, postcheck, evidence and stop condition.
- `subskill.openai-local-design`: use OpenAI as local design, prompts, docs and synthetic evals; OpenAI API live remains outside scope until a complete order exists.
- `subskill.retrospective-loop`: after merge, record what changed, what failed, what was fixed and what the next validator must catch.

## Required Sequence

1. Read `PARALLEL_OPERATION_CRITERIA_MATRIX.csv`.
2. Read `ORDER_PREPARATION_ASSIGNMENT_MATRIX.csv`.
3. Declare `lead_agent`, `owner_agent`, `reviewer_agent`, `read_scope`,
   `write_scope`, `lock_key`, `dependency`, `max_parallel`, evidence,
   validator and stop condition.
4. Select recipe: parallel operation, governed order preparation or OpenAI
   local design.
5. Dispatch only sidecar lanes that can finish without blocking the main path.
6. Integrate results through the owner agent and validate before closeout.

## Quick Reference

| Surface | Allowed | Required stop |
| --- | --- | --- |
| Read-only scouting | independent questions | `parallel_lane_without_validator` |
| Shared file family | serialize by `lock_key` | `lane_scope_overlap` |
| Live, API, cost, permission or production | prepare order packet | `order_packet_missing_required_fields` |
| OpenAI design | local prompts, docs and synthetic evals | `openai_api_live_requested_without_order` |

## Red Flags

- Same files assigned to multiple workers.
- Agent can approve its own live, production or permission action.
- Order lacks rollback or postcheck.
- OpenAI API, Microsoft live, production or cost is treated as already open.
- Parallel lane has no validator or stop condition.

## Closeout

Close with: agente, orden, superficie, estado, evidencia, validador,
stop_condition and proximos_carriles.
