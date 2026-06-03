# recipe.backreference-target-mapping-before-write

## Purpose
Require exact target mapping before any Work Queue back-reference target update.

## Preconditions
- Processed item has canonical id, correlation id, idempotency key and batch id.
- Target tables or mapping sources are declared.
- Rollback and postcheck are available.

## Steps
1. Extract deterministic item keys.
2. Search target candidates by exact keys only.
3. Count candidates.
4. Permit target update only if candidate count equals 1.
5. If candidate count is 0 or greater than 1, block target write and record evidence.

## Gates
- Fuzzy, partial, nearest-row or guessed target writes are blocked.

## Validators
- Back-reference target exactness validator when available.
- `local_validate_backreference_runtime_closure.ps1` for PR68 evidence.

## Rollback
No target write occurs unless exact identity exists. If a future exact write occurs, rollback must target that exact record.

## Stop Condition
`candidate_count_not_one`
