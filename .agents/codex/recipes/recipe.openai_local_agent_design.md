# Recipe: OpenAI Local Agent Design

Use when OpenAI should help design agents, prompts, evals or runtime packets
without executing OpenAI API live.

## Sub-recipes

- `subrecipe.prompt-pack`: prepare prompts and response contracts.
- `subrecipe.synthetic-eval`: prepare local dry-run cases and expected outputs.
- `subrecipe.api-order-packet`: prepare a governed order before API, cost, vector store or remote persistence.

## Boundaries

Allowed: local docs, local prompts, synthetic evals, repo files and GitHub PRs.

Blocked until governed order: OpenAI API live, Agents SDK live, Agent Builder,
external vector stores, costs, secrets and regulated payloads.

If any blocked surface is needed, switch to `subrecipe.openai-order` and stop
at a governed order packet.

## Evidence

Record prompt path, eval path, owner agent, validator and stop condition.
