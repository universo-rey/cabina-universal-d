# Prompt Improvement Pack

## Estado
PROMPT_IMPROVEMENT_PACK_READY

## Dataverse DEV Apply
Use exact DEV environment URL, environment id, organization id and solution name. Freeze state first, validate manifest, apply only metadata-only changes, write postcheck, and stop on PROD, TEST, Default, secret, missing rollback or drift.

## Work Queue Binding
Bind only synthetic metadata-only payloads with idempotency keys. Declare queue names, batch id, max item count, duplicate policy, rollback and postcheck. Do not activate flows in the binding prompt.

## OpenAI Metadata-Only Classification
Use only sanitized metadata, hashes and synthetic descriptors. Do not send raw paths, documents, personal data, SharePoint items, Planner tasks or Graph dumps. Mark output `AI_ASSISTED_NOT_CANON_UNTIL_VALIDATED`.

## PR Grouped Versioning
Require a commit group matrix, explicit stage list, no `git add .`, local validators after each group, push to `codex/*`, PR against `main`, and no merge without later fixed-head order.

## Post-Merge Expansion
Start with a freeze. Execute the smallest exact post-merge action. Store rollback and postcheck before claiming closure. Keep follow-up evidence in a new PR.

## Runtime Controlled Activation
Authorize exactly one flow and exactly one item. Record flow id, item id, payload boundary, rollback, postcheck and safe-state restore. Stop if more than one item can be processed.

## Back-Reference Exact Mapping
Search exact target candidates by canonical id, correlation id, idempotency key and batch id. If candidate count is 0 or greater than 1, do not update target. Create only metadata mapping evidence when keys are deterministic and rollback is declared.

## Retrospective Learning
After a governed chain closes, extract timeline, operational lessons, skill candidates, recipe candidates, agent deltas, validator candidates, prompt improvements and readback. Do not execute new live surfaces during retrospective.
