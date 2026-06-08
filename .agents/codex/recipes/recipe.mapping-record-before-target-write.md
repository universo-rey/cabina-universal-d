# recipe.mapping-record-before-target-write

## Purpose
Create metadata-only mapping evidence before any final target write when a Work Queue item is processed but target identity is unresolved.

## Preconditions
- Queue item keys are deterministic.
- Dataverse has been queried for an existing metadata resolver row before any
  repo-local fallback is considered.
- Mapping table exists or a schema plan is separately approved.
- Target candidate count is not exactly one.

## Steps
1. Validate required item keys.
2. Query Dataverse `mon_sdu_*` resolver metadata for the atomic segment.
3. If a Dataverse resolver row exists, use it; do not complete missing target
   fields from repo-local inference.
4. Confirm target update is blocked when candidate count is not exactly one.
5. Create or record a metadata-only mapping record only when authorized.
6. Verify idempotency uniqueness.
7. Keep final target update pending.

## Gates
- Mapping evidence cannot pretend the target was updated.
- Mapping evidence cannot justify an inferred write.
- Repo-local evidence cannot override an existing Dataverse resolver row.

## Validators
- Mapping record before target write validator when available.
- `local_validate_backreference_runtime_closure.ps1` for current evidence.

## Rollback
Invalidate the mapping record under a governed DEV order.

## Stop Condition
`missing_keys_or_target_guess`
