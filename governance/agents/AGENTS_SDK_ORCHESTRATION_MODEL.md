# Agents SDK Orchestration Model

## Model

The root cabina baseline uses a single local triage agent first. It does not
handoff to remote agents and does not execute live tools.

## Flow

1. Receive sanitized local request metadata.
2. Check forbidden surfaces.
3. Produce structured triage JSON.
4. Record local trace metadata without raw payload persistence.
5. Validate schema and synthetic cases.
6. Escalate any live or cost request to a governed order.

## Expansion Rule

Propagation to other repos may start only after:

- Cabina current state is closed.
- Codex Cloud cabina is ready.
- Agents SDK baseline is ready or blocked with exact reason.
- The target repo has its own branch, validator and readback.

## Non Goals

- No production runtime.
- No live OpenAI API call.
- No Microsoft live action.
- No persistent remote agent.
- No replacement of human or institutional authority.
