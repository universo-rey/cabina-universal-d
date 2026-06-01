# Agent Operating Map

This map keeps the agent folder lightweight.

## Read Path

1. `D:\AGENTS.md`
2. `D:\.agents\codex\README.md`
3. `D:\.agents\codex\agents\LEVELS.yaml`
4. `D:\.agents\codex\routing.json`
5. Selected sublevel README
6. Selected agent profile
7. Only the matrix, recipe or tool index required by the order
8. Applicable `SOURCE_*` copied file before creating or changing local overlays

## Dispatch Rule

The router assigns one primary agent. Secondary agents are only read when the handoff map requires them. Copied source files have precedence over local overlays when both describe the same capability.

## Closure Rule

Every non-trivial action leaves evidence under `D:\.agents\codex\readbacks` and must pass the local validator before being reported as closed.
