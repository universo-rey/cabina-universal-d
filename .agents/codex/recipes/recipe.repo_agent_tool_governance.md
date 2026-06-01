# recipe.repo_agent_tool_governance

## Purpose

Route every repo, agent and tool through an explicit governance owner before execution.

## Steps

1. Identify the asset class: repo, agent, tool, recipe, skill, matrix, map or eval.
2. Read the matching governance matrix.
3. Confirm owner, surface, authority, allowed actions, blocked actions and stop condition.
4. If the action is local/read-only, proceed with evidence.
5. If the action is Git write, remote, cost, live, tenant, production or secret-bearing, prepare a governed order instead.
6. Validate with `tool.local_validate_agent_layer`.
7. Close with `recipe.governed_readback_closeout`.

## Output

`governance_decision` with owner, route, allowed action, blocked action, evidence and validator.

## Stop Condition

Stop if the asset is not registered or if the requested action exceeds its authority.
