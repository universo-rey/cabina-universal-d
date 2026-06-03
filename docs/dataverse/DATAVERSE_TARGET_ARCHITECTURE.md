# Dataverse Target Architecture

## Layers

- GitHub: technical canon and versioned schema/scripts/workflows.
- Dataverse DEV: queryable metadata registry and apply log.
- SharePoint/readbacks: documentary evidence repository.
- GitHub Actions: validation and manual apply gates.

## Tables

V1 includes matrix, version, capability, mapping, recipe, skill, agent, tool,
propagation, reconciliation, validation gate, evidence, environment, apply log
and readback tables.

All tables require auditing and change tracking.
