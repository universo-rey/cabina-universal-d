# Agents SDK Next Task Live Activation Readback - 2026-06-08

- agente: court.openai_dispatcher + rey.frontier_guardian + court.sdu_gate + court.seshat_evidence
- orden: activate_agents_sdk_for_next_task_with_openai_live_usd_2_and_microsoft_live_gate
- superficie: OpenAI Agents SDK live governed runtime; Microsoft live gated companion surface
- repo: universo-rey/cabina-universal-d
- workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
- branch: main
- head: de7f873
- skill: tcu-descubridor-capacidades|openai-developers:agents-sdk|openai-developers:openai-platform-api-key|no-inference-runtime-write-guard
- recipe: recipe.openai_local_agent_design|recipe.governed_order_preparation
- tool: .agents/codex/scripts/agents_sdk_functional_lifecycle_smoke.py|tool.governed_order_packet_builder|microsoft Teams/SharePoint connectors discovered but not invoked
- estado: SUPERSEDED_BY_SDU_AGENTS_NEXT_TASK_NO_MORE_SMOKE

Operator correction after this smoke: activate SDU agents for the next task and
do not run more smoke tests. This readback remains as evidence of the single
already-executed smoke only.

## Actions

- Read mandatory cabina canon files and existing Agents SDK/Microsoft order packets.
- Confirmed local SDK import readiness without API call.
- Confirmed OpenAI key presence from the approved ignored local source without printing the value.
- Executed a minimal governed OpenAI live smoke using `gpt-4.1-mini`.
- Created the next-task governed order packet for Agents SDK live with a USD 2.00 ceiling.
- Registered the order in `02_AUTHORITY_CANON/GOVERNED_ORDERS_INDEX.csv`.
- Did not execute Microsoft live because no exact Microsoft target was selected.

## Evidence

- `git rev-parse --show-toplevel`: `C:/Users/enzo1/Documents/GitHub/cabina-universal-d`.
- `git config --get core.worktree`: unset.
- `git branch --show-current`: `main`.
- `git rev-parse --short HEAD`: `de7f873`.
- `local_validate_github_automation_preflight.ps1 -CheckLocalSdk`: PASS, `openai-agents=0.17.0`, `openai=2.36.0`, `smoke=OK_NO_API_CALL`.
- Python import check: `openai: AVAILABLE`, `agents: AVAILABLE`.
- Agents SDK live smoke: PASS, model `gpt-4.1-mini`, Responses API PASS, Agents SDK runner PASS, synthetic payload only, secrets printed false, response bodies printed false, Microsoft live executed false, production executed false.

## Gates

- OpenAI live: authorized for the next task with `MAX_USD=2.00`.
- Agents SDK live: activated for next task, governed by exact task, data boundary and postcheck.
- Microsoft live: authorized only as gated next-task surface; execution remains `PENDING_TARGET_ONLY` until tenant/object target, owner, rollback, postcheck and validator are declared.
- Production: not authorized.
- Secrets: never print, persist or commit.

## Rollback

- Stop further live calls for this order.
- Revert `.agents/codex/orders/ORDER_AGENTS_SDK_NEXT_TASK_LIVE_AUTH_20260608.md`, this readback, `.gitignore`, and `02_AUTHORITY_CANON/GOVERNED_ORDERS_INDEX.csv` if the recorded activation should be withdrawn.
- Rotate or revoke the OpenAI key externally if exposure is suspected.
- For any future Microsoft write, use the object-specific rollback declared in that future target packet.

## Stop Condition

`PENDING_TARGET_ONLY`: the live OpenAI lane is activated and smoke-validated, but the next task still must provide the concrete task target. Microsoft live cannot execute until its exact object target is named.
