# Codex Environment - Cabina Universal D

This folder is the repo-visible Codex app configuration for the `D:\` root
wrapper project.

It governs local and worktree execution only. It does not create Codex Cloud
environments, OpenAI API keys, Microsoft live sessions, production resources,
permissions, secrets, or remote persistent agents.

## Scope

- Project root: `D:\`
- Environment file: `.codex/environments/environment.toml`
- Primary use: Codex app local and worktree setup/actions.
- Canon: `D:\AGENTS.md`

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

- `D:\.agents\codex\matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv`
- `D:\.agents\codex\orders\ORDER_CODEX_ENVIRONMENT_CREATION_20260602.md`

If a Codex Cloud environment is not visible and no real creation tool is
available, it stays `NEEDS_CODEX_CLOUD_UI_CREATE`.
