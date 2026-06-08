# Governed Order Preparation Packet

- order_class: microsoft_live_or_permission
- preparer_agent: Codex
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-08T12:00:00-03:00
- source_authority: AGENTS.md|PR140_MERGED_REMOTE_CONFIRMED|existing_inventory_only|dataverse_live_metadata_read
- surface: Dataverse / Power Platform DEV
- identity: pac_and_azure_identity_confirmed_sanitized
- owner: SDUCapabilityControlPlane
- tenant: escribaniabitsch.sharepoint.com
- selected_data: mon_sdu_readback row keyed by mon_canonical_id
- data_boundary: one readback metadata row only; no production; no modoe; no discovery runtime
- cost_boundary: no external cost; no OpenAI call; no production promotion
- secret_boundary: never_print_never_persist
- allowed_actions: tenant_controlled_segmented_create_or_update|exact_target_precheck|rollback_marker_prepare|postcheck_prepare
- blocked_actions: free_write|global_tenant_rewrite|runtime_discovery|production|default_environment|modoe_scope|secret_materialization|flow_activation|physical_delete
- rollback: patch the same row to ROLLBACK_SUPERSEDED; readback retained; no physical delete
- postcheck: read row by mon_canonical_id; verify READBACK_PUBLISHED and source hash
- evidence: .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_evidence_publish_readback.md|live_metadata_probe_mon_sdu_readback|live_candidate_probe_mon_canonical_id
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_operational_chain.ps1|scripts/validators/mcp_connection_registry_validator.py|dataverse/scripts/validate_dataverse_manifest.ps1
- expiration_rule: expires_when_environment_identity_table_key_or_operator_gate_changes
- stop_condition: microsoft_live_requested_without_governed_order|candidate_count_gt_one|missing_keys_or_target_guess|wrong_environment_or_default

## MODE

TENANT_CONTROLLED_WRITE

## ACTION_TYPE

TENANT_WRITE

## Scope

- surface: Dataverse / Power Platform DEV
- target: mon_sdu_readback
- segment_id: tenant_readback_publish_20260608
- environment_name: HUBDesarrollo
- environment_url: https://org084965d9.crm.dynamics.com
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- table_logical_name: mon_sdu_readback
- entity_set_name: mon_sdu_readbacks
- primary_id_attribute: mon_sdu_readbackid
- primary_name_attribute: mon_display_name
- key_schema_name: mon_sdu_readback_canonical_id_key
- key_attribute: mon_canonical_id
- key_status: Active
- canonical_id: readback.pr140_tenant_segments_merge_evidence_publish.20260608

## Delta Real

PR #140 was merged to `main` with merge commit
`754d3026e52c2e9d8d9c0a91e2212653ec7750df`. The fourth tenant segment already
published sanitized evidence in `mon_sdu_evidence`. The next atomic tenant
delta is to publish the corresponding readback metadata pointer in
`mon_sdu_readback`.

- candidate_count_before: 0
- expected_candidate_count_after: 1
- impact: acotado
- inference: OFF

## Payload Summary

| field | value |
| --- | --- |
| mon_canonical_id | readback.pr140_tenant_segments_merge_evidence_publish.20260608 |
| mon_display_name | PR140 tenant segments merge evidence publish readback 20260608 |
| mon_status | READBACK_PUBLISHED |
| mon_seed_batch_id | 20260608_tenant_readback_publish_v1 |
| mon_source_system | cabina-universal-d |
| mon_source_path | .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_evidence_publish_readback.md |
| mon_source_hash | 3d7605ff4fea628d3cd38b98c117c26fdb7470a92d9f1c761bcfc59b6be53c9e |
| mon_environment_scope | HUBDesarrollo\|7f65fc04-c27a-ea0d-bd2d-266aa9203c1e |
| mon_gate_required | true |
| mon_owner | SDUCapabilityControlPlane |
| mon_risk_level | low |
| mon_tenant_scope | escribaniabitsch.sharepoint.com |
| mon_stop_condition | TENANT_PR140_MERGE_EVIDENCE_PUBLISH_APPLIED_AND_POSTCHECKED |
| mon_notes | Sanitized metadata readback row for PR #140 tenant-controlled segment closure. No flow activation, no SharePoint write, no production. |

## Precheck Evidence

- `mon_sdu_readback` exists in `HUBDesarrollo`.
- `entity_set_name`: `mon_sdu_readbacks`.
- `primary_id_attribute`: `mon_sdu_readbackid`.
- `primary_name_attribute`: `mon_display_name`.
- `mon_canonical_id` is `ApplicationRequired`.
- Alternate key `mon_sdu_readback_canonical_id_key` is `Active` on
  `mon_canonical_id`.
- Candidate probe for
  `readback.pr140_tenant_segments_merge_evidence_publish.20260608` returned
  `candidate_count=0`.
- Source readback hash:
  `3d7605ff4fea628d3cd38b98c117c26fdb7470a92d9f1c761bcfc59b6be53c9e`.

## Apply Primitive

Use a Dataverse Web API create-or-update primitive equivalent to the existing
tenant scripts:

1. Confirm PAC identity is `efigueroa@registronotarial8tdf.com.ar`.
2. Confirm PAC environment id is `7f65fc04-c27a-ea0d-bd2d-266aa9203c1e`.
3. Confirm Azure user is `efigueroa@registronotarial8tdf.com.ar`.
4. Read `mon_sdu_readback` metadata and active alternate key.
5. Query by `mon_canonical_id`.
6. If candidate count is `0`, POST one row to `mon_sdu_readbacks`.
7. If candidate count is `1`, PATCH only that `mon_sdu_readbackid`.
8. If candidate count is greater than `1`, abort with `candidate_count_not_one`.

## Postcheck

Read back by `mon_canonical_id` and verify:

- candidate_count_after = 1
- `mon_status = READBACK_PUBLISHED`
- `mon_source_hash =
  3d7605ff4fea628d3cd38b98c117c26fdb7470a92d9f1c761bcfc59b6be53c9e`
- `mon_source_path =
  .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_evidence_publish_readback.md`

## Rollback

Rollback marks the row as superseded and retains evidence:

- target: same `mon_canonical_id`
- patch: `mon_status = ROLLBACK_SUPERSEDED`
- patch: `mon_stop_condition = ROLLBACK_SUPERSEDED_BY_OPERATOR_OR_READBACK_ROLLBACK`
- physical delete: prohibited

## Apply Result

- selected_primitive: dataverse/scripts/invoke_readback_publish_dev.ps1
- dry_run: DATAVERSE_READBACK_PUBLISH_DRY_RUN_PASS
- apply: DATAVERSE_READBACK_PUBLISH_APPLY_PASS
- independent_postcheck: Dataverse Web API read confirmed READBACK_PUBLISHED
- candidate_count_before: 0
- candidate_count_after: 1
- mon_sdu_readbackid: fdd4c391-4963-f111-ab0d-00224805f8f9

Rollback command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_readback_publish_dev.ps1 -Rollback
```
