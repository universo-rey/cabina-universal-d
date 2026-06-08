# Governed Order Preparation Packet

- order_class: microsoft_live_or_permission
- preparer_agent: Codex
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-08T11:34:52-03:00
- source_authority: AGENTS.md|PR140_MERGED_REMOTE_CONFIRMED|existing_inventory_only
- surface: Dataverse / Power Platform DEV
- identity: pac_and_azure_identity_confirmed_sanitized
- owner: SDUCapabilityControlPlane
- tenant: escribaniabitsch.sharepoint.com
- selected_data: mon_sdu_evidence row keyed by mon_canonical_id
- data_boundary: one evidence metadata row only; no production; no modoe; no discovery runtime
- cost_boundary: no external cost; no OpenAI call; no production promotion
- secret_boundary: never_print_never_persist
- allowed_actions: tenant_controlled_segmented_create_or_update|exact_target_precheck|rollback_marker_prepare|postcheck_prepare
- blocked_actions: free_write|global_tenant_rewrite|runtime_discovery|production|default_environment|modoe_scope|secret_materialization|flow_activation|physical_delete
- rollback: patch the same row to ROLLBACK_SUPERSEDED; evidence retained; no physical delete
- postcheck: read row by mon_canonical_id; verify EVIDENCE_PUBLISHED and evidence hash
- evidence: .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_readback.md|dataverse/scripts/invoke_evidence_publish_dev.ps1|dataverse/validation/pr140_merge_evidence_publish_20260608
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_operational_chain.ps1|scripts/validators/mcp_connection_registry_validator.py|dataverse/scripts/validate_dataverse_manifest.ps1
- expiration_rule: expires_when_environment_identity_table_key_or_operator_gate_changes
- stop_condition: microsoft_live_requested_without_governed_order|candidate_count_not_one|missing_keys_or_target_guess|wrong_environment_or_default

## MODE

TENANT_CONTROLLED_WRITE

## ACTION_TYPE

TENANT_WRITE

## Scope

- surface: Dataverse / Power Platform DEV
- target: mon_sdu_evidence
- segment_id: tenant_pr140_merge_evidence_publish_20260608
- environment_name: HUBDesarrollo
- environment_url: https://org084965d9.crm.dynamics.com
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- table_logical_name: mon_sdu_evidence
- entity_set_name: mon_sdu_evidences
- key_attribute: mon_canonical_id
- canonical_id: evidence.pr140_tenant_segments_merge.20260608

## Delta Real

PR #140 was merged to `main` with merge commit
`754d3026e52c2e9d8d9c0a91e2212653ec7750df`. The evidence table had no row for
this post-merge event, so the real delta was to publish one sanitized metadata
pointer in `mon_sdu_evidence`.

- candidate_count_before: 0
- candidate_count_after: 1
- impact: acotado

## Apply Result

- selected_primitive: dataverse/scripts/invoke_evidence_publish_dev.ps1
- dry_run: DATAVERSE_EVIDENCE_PUBLISH_DRY_RUN_PASS
- apply: DATAVERSE_EVIDENCE_PUBLISH_APPLY_PASS
- independent_postcheck: PAC org fetch confirmed EVIDENCE_PUBLISHED
- mon_sdu_evidenceid: 640c3437-4763-f111-ab0d-00224805f8f9

## Payload Summary

| field | value |
| --- | --- |
| mon_canonical_id | evidence.pr140_tenant_segments_merge.20260608 |
| mon_status | EVIDENCE_PUBLISHED |
| mon_evidence_type | metadata_pointer_only |
| mon_source_path | .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_readback.md |
| mon_evidence_hash | d0ea8feac5099b296f3ac15c217b037b17bc7e2c66b20c75f855e54f0b12bbdf |
| mon_stop_condition | PR140_TENANT_SEGMENTS_MERGED_REMOTE_CONFIRMED |

## Rollback

Rollback command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_evidence_publish_dev.ps1 -CanonicalId evidence.pr140_tenant_segments_merge.20260608 -SourcePath .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_readback.md -Rollback
```

Rollback marks the row `ROLLBACK_SUPERSEDED` and retains evidence. Physical
delete is prohibited.
