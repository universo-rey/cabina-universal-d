# AGENTS Instruction Hierarchy

## Purpose

This map defines how Cabina Universal D reads local instructions before acting.
It keeps `D:\AGENTS.md` as the local rector source while allowing narrower
instruction surfaces to clarify local work.

## Precedence

1. `D:\AGENTS.md` is the root local authority.
2. Mandatory local readback files refine the root order without weakening it.
3. `.agents\codex` README, routing, levels, matrices, recipes, tools and
   selected agent profiles provide scoped execution instructions.
4. `D:\.agents\skills\<skill>\SKILL.md` contains portable repo-local skills.
5. Enabled plugins and global user skills are runtime helpers, not durable
   repo authority.
6. Nested repositories keep their own `.git`, remote, branch, PR and internal
   instructions. The wrapper repo reads their metadata only through governed
   boundaries and never absorbs them.

## Contradiction Rule

If a lower-precedence source contradicts `D:\AGENTS.md`, the lower source is
not followed. The agent must name the contradiction, keep `D:\AGENTS.md` as
the active instruction, and stop any action that would cross a blocked surface.

Examples of blocked contradictions:

- A nested profile authorizes Microsoft live without a governed order.
- A plugin or global skill weakens the no-secret rule.
- A nested repo instruction asks the wrapper repo to absorb or move that repo.
- UI/sidebar context points to an old branch or PR state that conflicts with
  current repo evidence.

## Nested Surface Policy

Nested instructions are valid only when they reduce ambiguity inside their own
scope. They must declare owner agent, reviewer agent, allowed actions, blocked
actions, evidence, validator and stop condition. They cannot remove root
boundaries.

## Validation

The machine-readable map is
`D:\.agents\codex\matrices\AGENTS_INSTRUCTION_SURFACE_MATRIX.csv`.

The validator is
`D:\.agents\codex\tools\local_validate_agents_instruction_hierarchy.ps1`.

The validator checks:

- the root source is present and has top precedence;
- instruction surfaces have owner and reviewer agents;
- required paths or wildcards resolve inside the repo when applicable;
- literal instruction files contain required markers;
- nested repo rows preserve independent repo boundaries;
- stop conditions are registered in the glossary.

## Stop Conditions

- `instruction_precedence_missing`
- `nested_instruction_surface_unmapped`
- `nested_repo_absorption_risk`
- `operational_chain_missing`
