---
name: cabina-agent-md-refactor
description: Use when AGENTS.md, Codex UI prompts, project instructions, or local governance instructions in D:\ need pruning, normalization, or drift review without weakening canon.
---

# Cabina Agent MD Refactor

## Core Rule

Never simplify authority. Reduce repetition only after preserving the local
canon, blocked surfaces, required reads and closeout fields.

## Required Reads

1. `D:\AGENTS.md`
2. `D:\MANIFEST.yaml`
3. `D:\.agents\codex\README.md`
4. Any prompt or instruction file being edited

## Workflow

1. Classify each instruction as canon, workflow, reminder, duplicate or stale.
2. Preserve canon verbatim when it changes authority, gates or blocked actions.
3. Move repeated workflow detail into a referenced matrix, recipe or skill when
   the repo already has that artifact.
4. Keep the UI prompt short enough to be actionable at chat start.
5. Validate the operational chain before claiming the prompt is aligned.

## Stop Conditions

- A change would remove GitHub branch, validation, explicit stage, commit, push
  or PR requirements.
- A change would blur nested repo boundaries.
- A change would authorize live, production, permission, secret, cost or broad
  regulated-data surfaces.
- The instruction source conflicts with `D:\AGENTS.md`.
