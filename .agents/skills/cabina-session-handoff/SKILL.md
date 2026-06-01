---
name: cabina-session-handoff
description: Use when a Cabina Universal session, PR, agent lane, or interrupted task needs a compact handoff with evidence, risks, next lanes, and stop conditions.
---

# Cabina Session Handoff

## Core Rule

A handoff is operational memory, not a story. It must let the next agent resume
without guessing authority, state or risk.

## Handoff Shape

Include:

- agente
- orden
- superficie
- branch or PR when relevant
- files changed or read
- validators run
- evidence
- risks and blocked surfaces
- stop_condition
- next lanes

## Workflow

1. Read current Git state when the surface is a repo.
2. Separate verified state from assumptions.
3. Record exact branch, PR, commit or validator evidence when present.
4. Name what was not touched: Microsoft live, OpenAI API live, production,
   permissions, secrets, regulated data, merge or force push.
5. Keep it short enough to paste into the next session.

## Stop Conditions

- The handoff lacks branch, PR or validator evidence for repo work.
- The handoff presents assumptions as verified.
- A live/API/production surface is implied as open without order.
