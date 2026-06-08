# Recipe: Parallel Tooling Validation Chain

Use when a repo-wide or multi-file task needs tool selection, reusable commands,
validation planning or recipe extraction before shared edits.

## Trigger

- The task mentions `AGENTS.md`, skills, tools, recipes, workflows or validators.
- The change can be split into structure, history, workflows, tools, recipes,
  standards and validation lanes.
- The requested output must be reusable for future Codex executions.

## Steps

1. Intake: restate objective, affected areas, restrictions, likely tools and
   whether fan-out is safe.
2. Parallel recon: run read-only lanes for repo map, execution history,
   workflows, tool registry, recipe registry, standards and validation.
3. Tool selection: prefer project scripts, package scripts and validators over
   ad hoc commands; classify each command as read, write, validation or high
   risk.
4. Plan: list files to edit, commands to run, rollback and success criteria.
5. Execute: edit only approved instruction, skill, recipe or matrix files.
6. Validate: run targeted validators first, then global validators if shared
   surfaces changed.
7. Report: include tools used, commands, changed files, validator status, risks
   and pending gates.

## Commands

```powershell
rg --files
git status -sb
git log --oneline --decorate -n 30
gh pr list --state open --json number,title,headRefName,baseRefName,isDraft,mergeStateStatus,url
.agents\codex\tools\local_validate_skill_metadata.ps1
.agents\codex\tools\local_validate_operational_chain.ps1
.agents\codex\tools\local_validate_capability_use_hardening.ps1
```

Use module package scripts when present, for example `npm test --prefix
local-agent-bridge` or `npm test --prefix teams-app/sdu-agent-chat/bot`.

## Validation

- `git diff --check`
- `.agents\codex\tools\local_validate_parallel_order_governance.ps1`
- `.agents\codex\tools\local_validate_skill_metadata.ps1`
- `.agents\codex\tools\local_validate_agents_instruction_hierarchy.ps1`
- `.agents\codex\tools\local_validate_operational_chain.ps1`
- `.agents\codex\tools\local_validate_capability_use_hardening.ps1`

## Rollback

Use `git restore -- <explicit paths>` before commit, or `git revert <commit>`
after commit. For PR updates, keep rollback in the PR body.

## Common Errors

- Inventing tools or commands instead of checking project files.
- Treating a plugin as available without current evidence.
- Running package-manager commands from the wrong module root.
- Retrying a failed command without classifying the failure.
- Editing shared matrices before fan-in.
- Running live, production, secret, permission, cost or destructive commands
  without gate.

## Stop Conditions

- `parallel_lane_without_validator`
- `skill_metadata_missing_or_ambiguous`
- `capability_use_preflight_missing`
- `secret_detected`
