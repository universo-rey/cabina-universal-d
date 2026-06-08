# Governed Order Preparation Packet

- order_class: microsoft_live_or_permission
- preparer_agent: Codex
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-08T11:10:37-03:00
- source_authority: AGENTS.md|operator_gate_OPEN_ACTIVE|existing_inventory_only
- surface: Dataverse / Power Platform DEV
- identity: pac_and_azure_identity_confirmed_sanitized
- owner: SDUCapabilityControlPlane
- tenant: escribaniabitsch.sharepoint.com
- selected_data: mon_sdu_apply_log row keyed by mon_canonical_id
- data_boundary: one apply-log metadata row only; no production; no modoe; no discovery runtime
- cost_boundary: no external cost; no OpenAI call; no production promotion
- secret_boundary: never_print_never_persist
- allowed_actions: tenant_controlled_segmented_create_or_update|exact_target_precheck|rollback_marker_prepare|postcheck_prepare
- blocked_actions: free_write|global_tenant_rewrite|runtime_discovery|production|default_environment|modoe_scope|secret_materialization|flow_activation|physical_delete
- rollback: patch the same row to ROLLBACK_SUPERSEDED; evidence retained; no physical delete
- postcheck: read row by mon_canonical_id; verify APPLIED_POSTCHECKED and source hash
- evidence: .agents/codex/readbacks/2026-06-08_tenant_controlled_gate_state_patch_readback.md|dataverse/scripts/invoke_apply_log_publish_dev.ps1|dataverse/validation/apply_log_publish_20260608
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_operational_chain.ps1|scripts/validators/mcp_connection_registry_validator.py|dataverse/scripts/validate_dataverse_manifest.ps1
- expiration_rule: expires_when_environment_identity_table_key_or_operator_gate_changes
- stop_condition: microsoft_live_requested_without_governed_order|candidate_count_not_one|missing_keys_or_target_guess|wrong_environment_or_default

## MODE

TENANT_CONTROLLED_WRITE

## ACTION_TYPE

TENANT_WRITE

## Scope

- surface: Dataverse / Power Platform DEV
- target: mon_sdu_apply_log
- segment_id: tenant_apply_log_publish_20260608
- environment_name: HUBDesarrollo
- environment_url: https://org084965d9.crm.dynamics.com
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- table_logical_name: mon_sdu_apply_log
- entity_set_name: mon_sdu_apply_logs
- key_attribute: mon_canonical_id
- canonical_id: apply.tenant_controlled_gate_state_patch.20260608

## Delta Real

The tenant gate-state patch was applied and postchecked. The apply-log table had
no row for this event, so the real delta was to publish one sanitized metadata
record in `mon_sdu_apply_log`.

- candidate_count_before: 0
- candidate_count_after: 1
- impact: acotado

## Apply Result

- selected_primitive: dataverse/scripts/invoke_apply_log_publish_dev.ps1
- dry_run: DATAVERSE_APPLY_LOG_PUBLISH_DRY_RUN_PASS
- apply: DATAVERSE_APPLY_LOG_PUBLISH_APPLY_PASS
- independent_postcheck: PAC org fetch confirmed APPLIED_POSTCHECKED
- mon_sdu_apply_logid: 9910b1d0-4363-f111-ab0d-00224805f8f9

## Payload Summary

| field | value |
| --- | --- |
| mon_canonical_id | apply.tenant_controlled_gate_state_patch.20260608 |
| mon_status | APPLIED_POSTCHECKED |
| mon_source_path | .agents/codex/readbacks/2026-06-08_tenant_controlled_gate_state_patch_readback.md |
| mon_source_hash | a72a08f4f58fc6d95dcb58127136a118b0d6ee7125df22148bc270a1718a2ca1 |
| mon_stop_condition | TENANT_CONTROLLED_GATE_STATE_PATCH_APPLIED_AND_POSTCHECKED |

## Rollback

Rollback command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_apply_log_publish_dev.ps1 -Rollback
```

Rollback marks the row `ROLLBACK_SUPERSEDED` and retains evidence. Physical
delete is prohibited.
