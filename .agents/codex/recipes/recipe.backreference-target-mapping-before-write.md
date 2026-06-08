# recipe.backreference-target-mapping-before-write

## Purpose
Require exact target mapping before any Work Queue back-reference target update.

## Preconditions
- Processed item has canonical id, correlation id, idempotency key and batch id.
- Dataverse metadata has been queried first for the atomic segment when
  available.
- Target tables or mapping sources are declared.
- Rollback and postcheck are available.

## Steps
1. Extract deterministic item keys.
2. Query Dataverse `mon_sdu_*` metadata rows for the segment resolver before
   reading repo-local fallback files.
3. If a Dataverse row exists, use it as the operational target resolver and do
   not infer from repo-local filenames, nearby records or historical memory.
4. Search target candidates by exact keys only.
5. Count candidates.
6. Permit target update only if candidate count equals 1.
7. If candidate count is 0 or greater than 1, block target write and record evidence.

## Gates
- Fuzzy, partial, nearest-row or guessed target writes are blocked.
- Repo-local inference is blocked when a Dataverse metadata row exists.

## Validators
- Back-reference target exactness validator when available.
- `local_validate_backreference_runtime_closure.ps1` for PR68 evidence.

## Rollback
No target write occurs unless exact identity exists. If a future exact write occurs, rollback must target that exact record.

## Stop Condition
`candidate_count_not_one`
