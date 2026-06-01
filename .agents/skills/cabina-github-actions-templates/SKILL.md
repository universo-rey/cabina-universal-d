---
name: cabina-github-actions-templates
description: Use when creating or reviewing GitHub Actions, Copilot instructions, issue forms, PR templates, or workflow templates for cabina-governed repos.
---

# Cabina GitHub Actions Templates

## Core Rule

GitHub automation is repo-scoped validation by default. Workflows must be
read-only unless a separate governed order opens a write surface.

## Workflow

1. Confirm repo id, owner agent and GitHub base policy.
2. Use existing `.github` templates before adding another workflow.
3. Require `contents: read` for validation workflows unless a specific order
   states otherwise.
4. Include operational chain fields in templates: agent, skill, recipe, tool,
   validator, evidence and stop_condition.
5. Run the GitHub automation preflight and operational chain validators.

## Allowed By Default

- local validation commands
- PR and issue templates
- Copilot instructions
- draft PR checks with no secrets

## Stop Conditions

- workflow asks for secrets, write permissions, deployment, production,
  Microsoft live, OpenAI API live, force push, merge or permission changes
  without separate governed order
- workflow omits validator evidence
