# recipe.powershell_runtime_friction_guard

## Purpose
Reduce recurring Windows PowerShell friction in Cabina Universal work by making shell-sensitive patterns explicit and locally validated.

## Preconditions
- The task runs under `D:\` or a Windows PowerShell shell.
- No global profile, machine PATH, tenant, production, secret, or live connector change is required.

## Steps
1. Prefer structured tools over ad hoc shell text parsing.
2. For GitHub data, save `gh --json` output once and parse it with `ConvertFrom-Json` or Node.
3. Avoid Bash heredoc syntax (`<<`) in PowerShell. Use a PowerShell here-string, a checked-in script, or `node -e`.
4. Avoid repo writes through shell redirection. Use `apply_patch` for manual edits.
5. Parse `.ps1` files with `System.Management.Automation.Language.Parser`.
6. Run `D:\.agents\codex\tools\local_validate_powershell_runtime_friction.ps1`.

## Validators
- `local_validate_powershell_runtime_friction.ps1`
- `git diff --check`

## Rollback
Remove the guardrail artifacts and index rows added by the carril.

## Stop Condition
`powershell_runtime_friction_guard_failed`
