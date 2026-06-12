# recipe.sdu_sharepoint_piloto_read_reuse

## Purpose

Reuse the already verified SharePoint SYS-PILOTO live-read packet so agents do
not repeat site discovery, drive listing, list inventory, PnP auth probing, or
bounded sample item reads when the target has not changed.

## Inputs

- `.agents/codex/evals/results/sdu_sharepoint_piloto_live_read_latest.json`
- `tool.sdu_sharepoint_piloto_read_cache`
- exact site URL or library/list name from the operator request

## Steps

1. Read the cache with `tool.sdu_sharepoint_piloto_read_cache`.
2. Confirm the requested site is
   `https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO`.
3. If no refresh was requested, answer from the cache and do not call
   SharePoint, REST, Graph, or PnP live.
4. If a refresh was explicitly requested, run one bounded read-only refresh
   against the exact list or library and update only sanitized evidence.
5. If a write is requested, stop and prepare a governed SharePoint write order
   with target, owner, rollback, postcheck, evidence, and stop condition.

## Gates

- Do not use this cache for another site, tenant, or library base.
- Do not treat SharePoint connector REST list-item denial as a reason to
  rediscover the whole site.
- Do not repeat `Get-PnPList` or first-row reads when the cache answers the
  question.
- Do not write SharePoint, permissions, content types, or tenant settings.

## Validators

- `.agents/codex/tools/local_resolve_sdu_sharepoint_piloto_read_cache.ps1`
- `.agents/codex/tools/local_validate_skill_metadata.ps1` when skill metadata
  changed.
- `git diff --check` when repo files changed.

## Rollback

No live write occurs on cache reuse. Revert repo-local changes with:

```powershell
git restore --staged .agents/skills/sdu-sharepoint-piloto-read-reuse/SKILL.md .agents/codex/recipes/recipe.sdu_sharepoint_piloto_read_reuse.md .agents/codex/tools/local_resolve_sdu_sharepoint_piloto_read_cache.ps1 .agents/codex/evals/results/sdu_sharepoint_piloto_live_read_latest.json .agents/codex/matrices/LOCAL_SKILL_CATALOG.csv .agents/codex/skills/SKILL_USAGE_MATRIX.csv .agents/codex/skills/SKILL_METADATA_QUALITY_MATRIX.csv .agents/codex/recipes/RECIPE_INDEX.csv .agents/codex/tools/TOOL_INDEX.csv
git restore .agents/skills/sdu-sharepoint-piloto-read-reuse/SKILL.md .agents/codex/recipes/recipe.sdu_sharepoint_piloto_read_reuse.md .agents/codex/tools/local_resolve_sdu_sharepoint_piloto_read_cache.ps1 .agents/codex/evals/results/sdu_sharepoint_piloto_live_read_latest.json .agents/codex/matrices/LOCAL_SKILL_CATALOG.csv .agents/codex/skills/SKILL_USAGE_MATRIX.csv .agents/codex/skills/SKILL_METADATA_QUALITY_MATRIX.csv .agents/codex/recipes/RECIPE_INDEX.csv .agents/codex/tools/TOOL_INDEX.csv
```

## Stop Condition

`microsoft_live_requested_without_governed_order`
