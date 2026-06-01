# Recipe: Parallel Agent Operation

Use when a task needs multiple agents or subagents.

## Sub-recipes

- `subrecipe.parallel-readonly-scouts`: use explorers for independent read-only questions.
- `subrecipe.parallel-disjoint-workers`: use workers only when write sets do not overlap.
- `subrecipe.parallel-verifier`: use a verifier after implementation when it can inspect evidence independently.

## Steps

1. Define the main blocking path and keep it with the lead agent.
2. Split sidecar lanes by owner agent, file set, evidence and validator.
3. Assign `lock_key`, `read_scope`, `write_scope`, `dependency` and
   `max_parallel`.
4. Spawn only lanes that can run without live, secrets, production,
   permissions or cost.
5. Integrate findings through the lead owner.
6. Run local validators and record retrospective evidence.

## Stop Conditions

- lane_scope_overlap
- parallel_lane_without_validator
- live_surface_requested_without_order
- agent_self_approval_detected
