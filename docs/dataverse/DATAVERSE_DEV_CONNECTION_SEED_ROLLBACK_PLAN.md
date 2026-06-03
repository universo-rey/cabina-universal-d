# Dataverse DEV Connection Seed Rollback Plan

## Estado
DATAVERSE_DEV_CONNECTION_SEED_ROLLBACK_READY

## Scope
- Environment URL: https://org084965d9.crm.dynamics.com
- Environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Organization ID: f982db28-49e3-f011-aa23-000d3a5ca83f
- Solution: SDUCapabilityControlPlane
- Batch: 20260603_connection_seed_dev_v1
- Scope: DEV sandbox metadata-only rows imported by seed_batch_id.

## Preferred Rollback
1. Reconfirm PAC profile resolves to $profile and the exact DEV sandbox IDs above.
2. Export current snapshots for the same seed_batch_id.
3. Locate rows where mon_seed_batch_id = '20260603_connection_seed_dev_v1' in the seed tables.
4. Prefer non-destructive deactivation/update by batch marker: set status to ollback_deactivated and add rollback note/evidence.
5. Verify counts by table after rollback.
6. Do not touch TEST, PROD, Default, permissions, secrets, flows, connection references, or external systems.

## Destructive Rollback Gate
Physical delete requires a separate governed order naming exact tables, counts, owner, backup snapshot, rollback target, postcheck, and approval. It is not authorized by this closeout.

## Stop Condition
Stop if the active PAC profile, URL, environment ID, organization ID, tenant ID, or environment type differs from the DEV sandbox binding, or if any requested action crosses into TEST, PROD, Default, tenant permissions, secrets, production, or non-metadata payloads.
