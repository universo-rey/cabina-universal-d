# recipe.github_pr_lifecycle_governed

## Purpose

Run GitHub repo-scoped work as the active published lifecycle. The current
human request is present authority for its exact repo and scope; do not request
a future approval at every substep. The same lifecycle covers branch creation,
explicit staging, commit, push, PR creation or update, check monitoring,
comments, review-response updates and merge when the current order includes it
and the fixed-HEAD precheck passes.

## Scope

Allowed inside the lifecycle:

1. Resolve repo, remote, base branch, work branch and current PR.
2. Create or switch to a `codex/*` branch from the declared base.
3. Edit only files inside the approved scope.
4. Run local validators and GitHub preflight when the change touches workflow,
   agent, skill, recipe, tool, matrix or template surfaces.
5. Stage explicit paths only.
6. Commit, push and create or update a draft PR.
7. Read checks, runs, PR comments, review threads and issue context.
8. Apply in-scope review fixes, push updates and refresh PR evidence.
9. Mark ready or merge only when the operator approves the lifecycle or merge
   and the merge precheck passes.

Blocked inside the lifecycle unless a separate order says otherwise:

- `git add .`
- force push
- remote branch deletion
- permission or visibility changes
- workflow write permissions or secrets
- production
- Microsoft live
- OpenAI API live or remote persistent agents
- regulated data or secret materialization
- merge without approval, fixed HEAD, green checks and postcheck evidence

## Steps

1. Read `AGENTS.md`, the exact repo object and this recipe.
2. Consume current repo, base, branch, HEAD, scope and authority from GitHub
   live; do not rebuild unrelated local history.
3. Resolve only fields material to the requested action: target, operation,
   rollback and postcheck.
4. Run the minimal repo/remote precheck needed for the write.
5. Create or update the `codex/*` branch from the base branch.
6. Perform the bounded local edit.
7. Run required validators.
8. Stage only explicit files.
9. Commit with a narrow message.
10. Push branch to the declared remote.
11. Create or update the draft PR and include operational chain fields.
12. Monitor GitHub checks and comments.
13. If review feedback is in scope, address it on the same branch and repeat
    validation, stage, commit and push.
14. Before merge, verify: PR is not draft, base is `main`, branch is `codex/*`,
    merge state is clean, checks are green, HEAD equals the validated commit,
    no blocked surfaces are crossed and rollback/postcheck evidence is present.
15. Merge with `gh pr merge --match-head-commit <validated-head>` only after
    the precheck passes.
16. Close with branch, commit, PR URL, checks, validator result, evidence,
    rollback and stop condition.

## Output

`github_pr_lifecycle_readback` with repo, branch, commit, push target, PR URL,
checks, changed files, validators and remaining blocked surfaces.

## Stop Condition

Stop with `github_exact_object_unresolved` only if repo, target branch or
requested operation cannot be resolved. Missing non-applicable ceremony is not
a blocker.
Stop with `merge_or_force_push_or_actions_write_permission_without_order` when
the requested action crosses merge without approval/precheck, force push,
remote branch delete, permission, workflow write permission, production,
Microsoft live, OpenAI API live, secrets or regulated data. Stop with
`automated_merge_precheck_failed` when any merge precheck fails.
