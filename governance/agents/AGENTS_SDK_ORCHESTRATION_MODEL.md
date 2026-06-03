# Agents SDK Orchestration Model

## Model

The root cabina baseline uses a single local triage agent first and a governed
live OpenAI smoke gate second. The cabina state is
`FULL_LIVE_GOVERNED_READY` for PR #56, with no propagation and no automatic
production or Microsoft write execution.

## Flow

1. Receive sanitized local request metadata.
2. Check forbidden surfaces.
3. Produce structured triage JSON.
4. Record local trace metadata without raw payload persistence.
5. Validate schema and synthetic cases.
6. Run governed OpenAI API live smoke only when the operator opens the gate.
7. Run governed Responses API live smoke with synthetic non-sensitive input.
8. Run governed Agents SDK `Agent` + `Runner` live smoke with synthetic
   non-sensitive input.
9. Keep Microsoft live and production as gated surfaces unless exact object,
   owner, rollback and postcheck are declared.
10. Keep propagation prepared but not executed until cabina closes.

## Expansion Rule

Propagation to other repos may start only after:

- Cabina current state is closed.
- Codex Cloud cabina is ready by prior smoke evidence, with stable environment
  ID recorded when exposed.
- Full live governed OpenAI gate is ready or blocked with exact reason.
- The target repo has its own branch, validator and readback.
- The operator opens the next repo-native lane after cabina closeout.

## Non Goals

- No blind production runtime.
- No body dump from OpenAI live responses.
- No SDK tools, SDK handoffs, SDK tracing or persistent remote agents in this
  gate.
- No Microsoft live write without exact target, owner, rollback and postcheck.
- No persistent remote agent.
- No automatic propagation to other repos.
- No replacement of human or institutional authority.
