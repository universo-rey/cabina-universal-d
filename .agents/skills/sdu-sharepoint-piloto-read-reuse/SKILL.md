---
name: sdu-sharepoint-piloto-read-reuse
description: Use when reading SharePoint SYS-GobiernoOperativo-PILOTO lists, libraries, SD_BacklogEstrategico, LIB_GobiernoSistemas, or PnP.PowerShell evidence and cached live read evidence may prevent repeated discovery.
---

# SDU SharePoint Piloto Read Reuse

## Core Rule

Use the cached live-read packet before touching SharePoint or PnP again. Do not
repeat site discovery, drive listing, `Get-PnPList`, or sample item reads unless
the operator asks for a refresh or the cache is missing, stale, mismatched, or
contradictory.

## No-Repeat Fast Path

Use this cached lane first:

- recipe: `recipe.sdu_sharepoint_piloto_read_reuse`
- tool: `tool.sdu_sharepoint_piloto_read_cache`
- cache: `.agents/codex/evals/results/sdu_sharepoint_piloto_live_read_latest.json`

Known target packet:

- site: `https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO`
- site display name: `Soporte de Sistemas - Gobierno Declarativo`
- connector capability: site and document-library metadata read
- connector limitation: native SharePoint list REST item reads returned access denied
- PnP capability: list/library metadata and bounded first-row reads
- PnP working auth lane: `Connect-PnPOnline -Interactive -ValidateConnection -ReturnConnection`
- PnP non-working auth lane in this session: `Connect-PnPOnline -OSLogin`
- live evidence date: `2026-06-11`

If the request targets the same site, lists, or libraries and does not ask for a
refresh, return the cached packet and move to the next backlog or agent lane.

## Trigger Boundary

Use this for read-only SharePoint SYS-PILOTO work involving libraries, native
lists, `SD_BacklogEstrategico`, `LIB_GobiernoSistemas`, connector limitations,
PnP.PowerShell auth, or "do not repeat work" continuity.

Do not use this for SharePoint writes, permission changes, content type changes,
tenant admin actions, production changes, broad regulated data export, or any
site other than the exact SYS-PILOTO target.

## Allowed Actions

- Resolve the current request against the cached SYS-PILOTO packet.
- Read the local sanitized JSON cache.
- Report known libraries, list counts, and bounded first-row examples from the
  cache.
- Run the local cache validator.
- Perform one bounded live refresh only when the operator asks for current data
  or the cache is missing, stale, mismatched, or contradictory.
- Record a new sanitized cache after a governed bounded live refresh.

## Blocked Actions

- repeated_live_fetch_when_cached
- full_site_rediscovery_without_refresh_request
- sharepoint_write
- permission_change
- content_type_change
- tenant_admin_action
- broad_regulated_data_export
- microsoft_live
- openai_api_live
- production
- secrets

## Decision Rules

- If the request matches SYS-PILOTO and no refresh was requested, use the cache.
- If the user asks "actual", "refresh", "hoy", "current", or gives a new URL,
  run only a bounded read-only refresh against the exact target.
- If the URL or site title differs, stop with `microsoft_live_requested_without_governed_order`.
- If auth is missing, stop at read-only boundary and record `microsoft_live_requested_without_governed_order`.
- If native list items are needed and the connector denies REST access, use PnP
  if already authenticated; otherwise stop with the exact auth boundary.
- If secrets appear in any output, stop with `secret_detected`.

## Validator

Run:

```powershell
.agents\codex\tools\local_resolve_sdu_sharepoint_piloto_read_cache.ps1
.agents\codex\tools\local_validate_skill_metadata.ps1
git diff --check
```

For unchanged cache reuse, the focal cache resolver is enough. Do not rerun
SharePoint/PnP live reads or global validator suites just to restate the cached
packet.

## Evidence

Close with:

- site URL and cache date
- whether live refresh was skipped or executed
- cache validator result
- requested list/library name
- bounded rows returned from cache, if requested
- files changed or `sin cambios`
- rollback path if the skill/cache changed
- stop condition
