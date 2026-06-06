# Recipe: VSI Live Surface Gate Packet

Use when a VS Code Insiders task needs Jira, OpenAI, Microsoft, cloud,
tenant, cost or production access and the agent must prepare the packet without
executing the live action.

## Required Fields

- surface
- target
- owner
- identity
- data_boundary
- allowed_actions
- blocked_actions
- gate
- max_cost when cost can occur
- rollback
- postcheck
- evidence
- validator
- expiration_rule
- stop_condition

## Steps

1. Read the source task row and frontier matrix.
2. Prepare an order packet in `.agents/codex/orders`.
3. Keep unknown target, owner, secret, identity, cost or rollback as the exact
   `PENDING_*_ONLY` state.
4. Do not call the provider, open a tenant write, deploy, send prompts with
   sensitive data or store tokens.
5. Validate the packet with the order-packet validator and `git diff --check`.

## Output

`vsi_live_gate_packet`

## Stop Conditions

- `live_gate_packet_missing_required_fields`
- `target_missing`
- `owner_missing`
- `secret_required`
- `cost_boundary_missing`
- `rollback_missing`
- `postcheck_missing`
- `secret_detected`
