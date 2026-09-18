---
name: cabina-sharepoint-plugin-adapter
description: Use when SharePoint plugin work in D:\ needs site, library, list, document, metadata, or evidence handling under Microsoft live gates.
---

# Cabina SharePoint Plugin Adapter

## Core Rule

SharePoint is governed live infrastructure. READ executes directly with an
authenticated capability, current binding, exact site/library/list/item,
data minimization and evidence; it needs no new order. Known bounded writes
without a positive HIGH trigger are LOW by default and need target, precheck,
rollback or compensation, postcheck and evidence.

## Trigger Boundary

Use when work mentions SharePoint sites, lists, libraries, files, metadata,
evidence publication, site discovery, or Microsoft 365 document surfaces.

## Allowed Actions

- classify site/library/list targets before connector use
- draft local evidence or metadata plans
- execute bounded connector reads directly with current binding and target
- execute LOW writes without order, allowlist or receipt when all execution
  prerequisites are resolved

## Blocked Actions

- tenant-wide or unbounded sweeps
- permission changes
- content type or InternalName changes without exact gate
- secrets
- OpenAI API live
- production
- HIGH writes without explicit authorization

## Validator

Use `D:\.agents\codex\tools\local_validate_order_packets.ps1`,
`D:\.agents\codex\tools\local_validate_teams_cross_repo_lane_audit.ps1`, and
`D:\.agents\codex\tools\local_validate_skill_metadata.ps1`.

## Evidence

Site URL, target object, identity, data limit, rollback, postcheck, validator
output, and readback.

## Stop Conditions

- `binding_or_target_resolution_required`
- `low_write_prerequisite_missing`
- `regulated_data_boundary_unclear`
- `secret_detected`
