# Recipe: OpenAI Review Repair Validate Loop

## Purpose

Adopt official OpenAI technical references by running a local loop:
`review -> classify -> repair -> validate -> readback`.

This recipe is a local governance pattern. It does not call the OpenAI API,
deploy Agents SDK, create remote agents, write to Microsoft, change production
or persist secrets.

## Inputs

- Official source locator, preferably `https://github.com/openai/<repo>` or
  official OpenAI developer documentation.
- Target surface: cabina root, TCU, SDU, TGE, CDF, Jara, Modo ON or another
  registered repo.
- Owner agent, reviewer agent, allowed action, blocked action, validator,
  evidence path and stop condition.

## Loop

1. Review source freshness, license, latest release or pushed date and whether
   the source is reference-only or executable.
2. Classify the source as technical reference, local design input, synthetic
   eval input, CI candidate or governed-order-only runtime.
3. Repair the local artifact that is actually stale: matrix row, recipe,
   validator, workpaper, readback or repo-native plan.
4. Validate locally with the declared validator and `git diff --check`.
5. Record readback with agent, order, surface, skill, recipe, tool, evidence,
   validator, risk, rollback, stop condition and next lanes.

## Allowed Actions

- GitHub read-only metadata checks.
- Local matrix, recipe, tool, workpaper and readback updates.
- Local synthetic eval planning and deterministic validator design.
- Repo-native branch or PR preparation when separately routed by repo.

## Blocked Actions

- OpenAI API live, Agents SDK live, Agent Builder live, vector stores,
  external costs or remote persistent agents without governed order.
- Microsoft live, Teams live, SharePoint live, tenant writes or production
  without governed order and explicit production authorization where required.
- Secrets in repo, prompts, matrices, readbacks or logs.
- Treating openai/* as authority canon. OpenAI upstream is technical
  reference unless the cabina canon separately adopts a rule.
- Bulk copying upstream docs or examples without license and scope review.

## Evidence

- `D:/.agents/codex/matrices/OPENAI_UPSTREAM_REFERENCE_MATRIX.csv`
- `D:/.agents/codex/matrices/OPENAI_TWO_WAVE_ADOPTION_MATRIX_20260602.csv`
- `D:/.agents/codex/readbacks/2026-06-02_openai_two_wave_adoption_readback.md`
- Repo-native readback when Wave 2 is executed inside a nested repo.

## Validator

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\.agents\codex\tools\local_validate_openai_upstream_adoption.ps1
```

Stop with `operational_chain_missing` if any lane lacks agent, skill, recipe,
tool, validator, evidence or stop condition.
