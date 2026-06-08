# Dataverse Target Architecture

## Layers

- GitHub: technical canon and versioned schema/scripts/workflows.
- Dataverse DEV: queryable metadata registry, target resolver and apply log.
- SharePoint/readbacks: documentary evidence repository.
- GitHub Actions: validation and manual apply gates.

## Resolution Precedence

Before each atomic tenant or live segment, Codex must query Dataverse for the
segment metadata. If a matching `mon_sdu_*` row exists, that row is the
operational resolver for target, owner, gate, rollback, postcheck, evidence and
stop condition. Repo-local files remain technical canon and lineage, but they do
not override an exact Dataverse metadata row for live execution.

If Dataverse returns zero candidates or more than one candidate for the segment,
the write must stop with `PENDING_TARGET_ONLY` or `target_identity_ambiguous`.
No repo-local inference, fuzzy match, historical memory or nearby name can
complete the write target.

## Tables

V1 includes matrix, version, capability, mapping, recipe, skill, agent, tool,
propagation, reconciliation, validation gate, evidence, environment, apply log
and readback tables.

All tables require auditing and change tracking.
