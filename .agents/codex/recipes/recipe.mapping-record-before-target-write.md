# recipe.mapping-record-before-target-write

## Purpose
Create metadata-only mapping evidence before any final target write when a Work Queue item is processed but target identity is unresolved.

## Preconditions
- Queue item keys are deterministic.
- Mapping table exists or a schema plan is separately approved.
- Target candidate count is not exactly one.

## Steps
1. Validate required item keys.
2. Confirm target update is blocked.
3. Create or record a metadata-only mapping record only when authorized.
4. Verify idempotency uniqueness.
5. Keep final target update pending.

## Gates
- Mapping evidence cannot pretend the target was updated.
- Mapping evidence cannot justify an inferred write.

## Validators
- Mapping record before target write validator when available.
- `local_validate_backreference_runtime_closure.ps1` for current evidence.

## Rollback
Invalidate the mapping record under a governed DEV order.

## Stop Condition
`missing_keys_or_target_guess`
