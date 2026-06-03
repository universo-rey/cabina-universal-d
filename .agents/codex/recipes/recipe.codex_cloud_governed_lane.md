# Recipe: Codex Cloud Governed Lane

Use when Codex Cloud should inspect, validate, propose, or produce a
repo-scoped diff without secrets, without ungated Microsoft live write,
without ungated production, without permission changes and without broad
regulated data.

## Flow

1. Confirm `D:\AGENTS.md`, selected repo, branch, remote and data boundary.
2. Inventory Cloud tasks with `codex cloud list --json`.
3. Inspect existing work with `codex cloud status <task_id>`.
4. Review changes with `codex cloud diff <task_id>` and stop before apply.
5. For a new Cloud task, require repo or environment identity, branch, prompt,
   data boundary, rollback, evidence and stop condition.
6. Prefer read-only or CI-smoke tasks first. For `SeshatSgin/sgin-cloud`, first
   create or connect the Codex Cloud environment; the repo is recognized but no
   environment is visible yet. Once the environment exists, the safe first task
   is: read `AGENTS.md`, `README.md`, `runtime-local`, `skills`, `tests` and
   `validate-runtime-local.yml`; report expected checks; do not edit files.
7. For `universo-rey/cabina-universal-d`, the first read-only smoke task is
   `task_e_6a1f119843d4832e9ed821834222c003`; inspect status and diff, never
   apply unless a later reviewed diff exists on a `codex/*` branch.
8. For `codex cloud apply`, require a `codex/*` branch, clean worktree,
   reviewed diff, local validators and Git rollback evidence.
9. Version accepted work through the normal GitHub branch, commit, push and PR
   lifecycle.

## Allowed

- `codex cloud list --json`
- `codex cloud status <task_id>`
- `codex cloud diff <task_id>`
- read-only smoke prompt execution when repo and branch are fixed
- CI-smoke prompt preparation for `SeshatSgin/sgin-cloud`
- local apply only after governed review and clean branch

## Blocked Until Separate Order

- `codex cloud exec` with ambiguous environment or repo identity
- `codex cloud apply` on `main` or dirty worktree
- secrets or secret environment variables
- Microsoft live write, tenant write, SharePoint write, Teams write, Outlook
  write, Graph mutation, Planner write, Dataverse write or Power Platform
  mutation without target, owner, rollback, postcheck and evidence
- production without exact target, rollback, postcheck and evidence
- propagation without repo target, compatibility matrix, rollback, postcheck
  and evidence
- permission changes
- OpenAI API live sin gate
- Agents SDK live sin gate
- Agent Builder, vector stores or costs without separate governed order
- remote persistent agents
- broad regulated data
- `sgin-cloud` SharePoint connector real mode without Microsoft live order
- secrets must never be printed or persisted

## Evidence

Record task id or `NO_APLICA`, environment label/id status, repo, branch, diff
status, validator output, rollback and stop condition.
