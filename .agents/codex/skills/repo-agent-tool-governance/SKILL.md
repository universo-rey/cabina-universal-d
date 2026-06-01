---
name: repo-agent-tool-governance
description: Use when D:\.agents\codex must assign, audit, or enforce governance over local repos, local agents, tools, recipes, or execution surfaces.
---

# Repo Agent Tool Governance

## Core Rule

Repos, agents and tools are governed assets. None should be treated as loose folders, free-form assistants, or generic commands.

## Governance Contract

Every governed asset needs:

- `owner_agent`
- `authority_level`
- `surface`
- `allowed_actions`
- `blocked_actions`
- `required_recipe`
- `required_tool`
- `evidence`
- `validator`
- `stop_condition`

## Required Reads

1. `D:\.agents\codex\matrices\REPO_AGENT_TOOL_GOVERNANCE_MATRIX.csv`
2. `D:\.agents\codex\matrices\REPO_GOVERNANCE_ASSIGNMENT_MATRIX.csv`
3. `D:\.agents\codex\matrices\AGENT_GOVERNANCE_MATRIX.csv`
4. `D:\.agents\codex\matrices\TOOL_GOVERNANCE_MATRIX.csv`
5. `D:\.agents\codex\maps\SURFACE_BOUNDARY_MAP.csv`

## Workflow

1. Classify the asset as repo, agent, tool, recipe, skill, matrix, map, eval, or external surface.
2. Find its owner agent and authority level.
3. Confirm allowed and blocked actions before using it.
4. Select the required recipe and tool.
5. Record evidence locally.
6. Run the governance validator before closeout.

## Stop Conditions

- Asset has no owner agent.
- Tool has no allowed and blocked surface.
- Repo has no universe or tower assignment.
- Agent has no authority level or escalation target.
- Any write, cost, live, secret, production, permission, or tenant action lacks governed order fields.
