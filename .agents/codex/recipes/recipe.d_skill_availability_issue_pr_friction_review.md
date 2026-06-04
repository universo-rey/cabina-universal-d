# recipe.d_skill_availability_issue_pr_friction_review

## Purpose
Separate durable D repo-local skills from plugin, installed, system, or runtime skills, then apply the PowerShell runtime friction guard to GitHub issues and PRs.

## Preconditions
- `D:\AGENTS.md` remains the local governing source.
- GitHub use is read-only unless a separate governed order authorizes writes.
- External skills are not treated as missing if they are explicitly cataloged as plugin, installed, or system skills.

## Steps
1. Read `D:\.agents\codex\matrices\LOCAL_SKILL_CATALOG.csv`.
2. Verify every `d_drive_repo_local` skill has a matching directory under `D:\.agents\skills`.
3. Mark plugin, installed, and system skills as runtime capabilities, not durable D canon.
4. Read GitHub issues and PRs in read-only mode.
5. Apply the PowerShell runtime friction patterns to issue and PR text.
6. Write local JSON evidence only when requested.

## Validators
- `local_validate_d_skill_availability_and_issue_pr_friction.ps1`
- `local_validate_powershell_runtime_friction.ps1`
- `local_validate_agent_layer.ps1`

## Rollback
Remove the validator, matrix, recipe, result JSON, and index rows added for this carril.

## Stop Condition
`d_skill_availability_or_issue_pr_friction_guard_failed`
