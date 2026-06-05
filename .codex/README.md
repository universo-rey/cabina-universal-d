# Codex Environment - Cabina Universal D

This folder is the repo-visible Codex app configuration for the
`C:\Users\enzo1\Documents\GitHub\cabina-universal-d` root wrapper project.

It governs local and worktree execution only. It does not create Codex Cloud
environments, OpenAI API keys, Microsoft live sessions, production resources,
permissions, secrets, or remote persistent agents.

## Scope

- Project root: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
- Environment file: `.codex/environments/environment.toml`
- Primary use: Codex app local and worktree setup/actions.
- Canon: `AGENTS.md`

## Boundaries

Allowed:

- local governance validators
- worktree-safe setup preflight
- no-write runtime checks
- Git status and diff checks

Blocked:

- secrets
- Microsoft live
- OpenAI API live
- production
- permission changes
- tenant writes
- dependency installation without a repo-native order
- absorbing nested repos into the root wrapper repo

Cloud environments are tracked in:

- `.agents\codex\matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv`
- `.agents\codex\orders\ORDER_CODEX_ENVIRONMENT_CREATION_20260602.md`

If a Codex Cloud environment is not visible and no real creation tool is
available, it stays `NEEDS_CODEX_CLOUD_UI_CREATE`.
