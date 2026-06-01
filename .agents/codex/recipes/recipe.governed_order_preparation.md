# Recipe: Governed Order Preparation

Use when an action is not executable yet and an agent must prepare the order.

## Sub-recipes

- `subrecipe.git-order`: branch, commit, push, PR, Actions, merge or issue order.
- `subrecipe.live-order`: Microsoft, tenant, connector, production or permission order.
- `subrecipe.openai-order`: OpenAI API, Agents SDK live, vector store, cost or remote agent order.

## Required Fields

- surface
- owner
- identity
- canon_as_of
- source_authority
- data_boundary
- allowed_actions
- blocked_actions
- rollback
- postcheck
- evidence
- validator
- expiration_rule
- stop_condition

## Agent Roles

`rey.frontier_guardian` classifies the frontier, `rey.authority_canonist`
checks authority, `court.sdu_gate` reviews gates, and the tower or court agent
prepares the domain packet.
