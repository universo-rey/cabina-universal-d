---
name: cabina-commit-work
description: Use when durable work in D:\ or registered repos must move through branch, explicit staging, commit, push, and draft PR under cabina governance.
---

# Cabina Commit Work

## Core Rule

Every durable change must be small, intentional and reviewable in GitHub. Do
not use `git add .` in `D:\`.

## Workflow

1. Confirm current repo, branch, remote and clean or classified worktree.
2. Start from the base branch required by the repo policy, normally `main`.
3. Create a `codex/*` branch for new work.
4. Stage only explicit files in scope.
5. Run local validators before commit and again before final closeout when the
   commit changes governance, agents, skills, recipes, tools or workflows.
6. Commit with a narrow message.
7. Push the branch and open a draft PR.
8. Stop before merge unless the operator gives a separate explicit merge order.

## Required Evidence

- branch name
- explicit staged file list
- commit id
- push target
- PR URL
- validator result

## Stop Conditions

- unclassified dirty worktree
- unrelated file in stage
- missing validator
- merge, force push, permission, production, Microsoft live, OpenAI API live,
  secret or regulated-data request without separate order
