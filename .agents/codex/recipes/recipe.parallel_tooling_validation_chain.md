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
3. Capability discovery: list available connectors, native Codex tools, repo
   scripts, package scripts, CLIs, MCP servers and shell fallback. Mark absent
   capabilities as `NO_DISPONIBLE`; do not invent connectors.
4. Tool selection: choose the most specific safe tool in this order:
   specialized connector, official project script, specific CLI, simple shell,
   PowerShell only when Windows or the repo requires it. Classify each command
   as read, search, edit, validation, setup, external API, high risk or
   destructive.
5. Tool decision record: for each selected tool, record why it was chosen, the
   alternative considered, risk, exact command/action, expected result and
   validation.
6. Plan: list files to edit, commands to run, rollback and success criteria.
7. Execute: edit only approved instruction, skill, recipe or matrix files.
8. Validate: run targeted validators first, then global validators if shared
   surfaces changed.
9. Report: include tools used, commands, changed files, validator status, risks
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

Use GitHub or CI connectors when available for PRs, issues, checks and recent
workflow status; use `gh` only as fallback or when the connector lacks the
needed field. Use `apply_patch` for manual edits. Use PowerShell scripts when
they are official repo tools or when Windows-specific behavior is the subject
of the task.

## Decision Matrix

- Local file read: file connector if available, then `rg`/bounded read, then
  shell fallback.
- Text or symbol search: semantic search for broad concepts, `rg` for exact
  matches, shell fallback last.
- Git state: Git connector if available, then direct `git status/diff/log`,
  PowerShell wrapper only when needed.
- PR, issue or CI: GitHub/GitLab/CI connector first, then `gh`/`glab`, then
  web or logs.
- Docs: docs connector or browser/web first for current external docs, then
  local docs.
- Edit: `apply_patch`, codemod or project generator; no shell redirection for
  manual edits.
- Validation: official repo validator, package script or test runner, then
  shell wrapper.
- DB/logs: specialized read connector or official read-only CLI; shell fallback
  only after target and risk are classified.
- Deploy or migration: no execution without explicit approval, dry-run,
  rollback and postcheck.

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
- Using PowerShell as the default when a connector, repo script, CLI, parser or
  `rg` would be more specific.
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
