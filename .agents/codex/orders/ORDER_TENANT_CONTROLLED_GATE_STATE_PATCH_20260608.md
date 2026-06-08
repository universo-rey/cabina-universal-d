# Governed Order Preparation Packet

- order_class: microsoft_live_or_permission
- preparer_agent: Codex
- reviewer_agent: court.sdu_gate
- approver_role: operator
- canon_as_of: 2026-06-08T10:54:06-03:00
- source_authority: AGENTS.md|operator_gate_OPEN_ACTIVE|existing_inventory_only
- surface: Dataverse / Power Platform DEV
- identity: pac_active_identity_confirmed_sanitized
- owner: SDUCapabilityControlPlane
- tenant: escribaniabitsch.sharepoint.com
- selected_data: mon_sdu_connection_gate rows keyed by mon_canonical_id
- data_boundary: two existing gate metadata rows only; no production; no modoe; no discovery runtime
- cost_boundary: no external cost; no OpenAI call; no production promotion
- secret_boundary: never_print_never_persist
- allowed_actions: tenant_controlled_segmented_patch_prepare|exact_target_precheck|rollback_prepare|postcheck_prepare
- blocked_actions: free_write|global_tenant_rewrite|runtime_discovery|production|default_environment|modoe_scope|secret_materialization|flow_activation
- rollback: patch the same two rows back to seed_connection_gates.csv prior values; no physical delete
- postcheck: read both rows by mon_canonical_id; verify mon_status and controlled fields; verify no other mon_sdu_connection_gate rows changed
- evidence: powerplatform/solution/solution.manifest.yml|dataverse/data/seed_connection_gates.csv|matrices/dataverse/DATAVERSE_APPLIED_KEY_MODEL_DEV.csv|matrices/dataverse/DATAVERSE_APPLIED_FIELD_MODEL_DEV.csv|matrices/powerautomate/WORK_QUEUE_ENVIRONMENT_BINDING_MATRIX.csv|powerplatform/workqueues/workqueue.manifest.yml|powerplatform/flows/dev-disabled-flow-manifest.yml
- validator: .agents/codex/tools/local_validate_order_packets.ps1|.agents/codex/tools/local_validate_operational_chain.ps1|scripts/validators/mcp_connection_registry_validator.py|dataverse/scripts/validate_dataverse_manifest.ps1
- expiration_rule: expires_when_environment_identity_table_key_or_operator_gate_changes
- stop_condition: microsoft_live_requested_without_governed_order|candidate_count_not_one|missing_keys_or_target_guess|wrong_environment_or_default

## MODE

TENANT_CONTROLLED_WRITE

## ACTION_TYPE

TENANT_WRITE

## Runtime Guards

- WRITE_MODE: TENANT_CONTROLLED
- INFERENCE: OFF
- AUTO_DISCOVERY: DISABLED
- GATE_MICROSOFT_LIVE_WRITE: OPEN_ACTIVE
- GATE_POWER_PLATFORM_APPLY: OPEN_ACTIVE
- RULE: one atomic logical target; exact ids only; no free write

## Scope

- surface: Dataverse / Power Platform DEV
- target: mon_sdu_connection_gate
- segment_id: tenant_gate_state_patch_20260608
- environment_name: HUBDesarrollo
- environment_url: https://org084965d9.crm.dynamics.com
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- organization_id: f982db28-49e3-f011-aa23-000d3a5ca83f
- solution_unique_name: SDUCapabilityControlPlane
- table_logical_name: mon_sdu_connection_gate
- key_schema_name: mon_sdu_connection_gate_canonical_id_key
- key_attribute: mon_canonical_id

## Alias Resolution

The operator labels are mapped only to exact existing inventory rows. If either
candidate count is not exactly one, apply must abort.

| operator_gate | existing_canonical_id | exact_candidate_rule |
| --- | --- | --- |
| GATE_MICROSOFT_LIVE_WRITE | GATE_MICROSOFT_LIVE_GOVERNED_ORDER | provider=Microsoft and required_for=any_live_or_write_use |
| GATE_POWER_PLATFORM_APPLY | GATE_POWER_PLATFORM_DEV_TARGET_EXPLICIT | provider=Microsoft and surface=Power Platform Admin |

PAC live-read verification on `HUBDesarrollo` returned exactly one row per
canonical id:

| existing_canonical_id | mon_status | mon_sdu_connection_gateid |
| --- | --- | --- |
| GATE_MICROSOFT_LIVE_GOVERNED_ORDER | seed_now | 39046688-375f-f111-a826-00224805fcc4 |
| GATE_POWER_PLATFORM_DEV_TARGET_EXPLICIT | seed_now | 3b046688-375f-f111-a826-00224805fcc4 |

## Delta Real

The current inventory rows remain in seed status while the operator already
opened Microsoft live and Power Platform gates for controlled segmented writes.
The delta is to record the new controlled gate posture in the existing
Dataverse gate control table.

- current_status: seed_now
- target_status: OPEN_ACTIVE_CONTROLLED
- row_count: 2
- impact: lote_controlado

## Patch Payload

Apply exactly to:

1. mon_canonical_id = GATE_MICROSOFT_LIVE_GOVERNED_ORDER
2. mon_canonical_id = GATE_POWER_PLATFORM_DEV_TARGET_EXPLICIT

Fields:

| field | value |
| --- | --- |
| mon_status | OPEN_ACTIVE_CONTROLLED |
| mon_allowed_actions | local_inventory\|order_preparation\|dry_run_validation\|tenant_controlled_segmented_write |
| mon_blocked_actions | write_free\|unsegmented_global_write\|production\|secret_materialization\|default_as_dev\|runtime_discovery\|modoe_scope\|flow_activation |
| mon_stop_condition | target_identity_missing\|rollback_missing\|postcheck_missing\|inference_required\|segment_not_in_inventory\|modoe_scope_detected |
| mon_last_reconciled_at | 2026-06-08T10:54:06-03:00 |
| mon_notes | Operator authorized Microsoft live and Power Platform gates; gates remain controlled, segmented, reversible and postchecked. |

Do not set mon_gate_required to false.

## Precheck

| check | expected |
| --- | --- |
| belongs_to_inventory | TRUE |
| table_key_active | TRUE |
| id_resolved | TRUE |
| candidate_count | VERIFIED: 1 per canonical id |
| impact_delimited | TRUE |
| environment_not_default | TRUE |
| environment_not_prod | TRUE |
| environment_not_test | TRUE |
| rollback_defined | TRUE |
| postcheck_defined | TRUE |

## Apply Boundary

- execution_status: DELTA_APLICADO
- selected_primitive: dataverse/scripts/invoke_gate_state_patch_dev.ps1
- primitive_contract: precheck/read-current/apply/postcheck/rollback
- apply_result: DATAVERSE_GATE_STATE_PATCH_APPLY_PASS
- independent_postcheck: PAC org fetch confirmed both rows OPEN_ACTIVE_CONTROLLED

## Postcheck

1. Read `mon_sdu_connection_gate` by each `mon_canonical_id`.
2. Confirm `mon_status=OPEN_ACTIVE_CONTROLLED`.
3. Confirm `mon_allowed_actions` includes `tenant_controlled_segmented_write`.
4. Confirm blocked actions still prohibit free/global/production/default/modoe/flow activation.
5. Confirm no other `mon_sdu_connection_gate` row changed.

## Rollback

Rollback is required because impact is greater than one row.

Patch the same two rows back to the prior values from
`dataverse/data/seed_connection_gates.csv`:

| field | rollback_value |
| --- | --- |
| mon_status | seed_now |
| mon_allowed_actions | local_inventory\|order_preparation\|dry_run_validation |
| mon_blocked_actions | live_auth\|live_write\|production\|secret_materialization\|default_as_dev |
| mon_stop_condition | microsoft_live_requested_without_governed_order |

Physical delete is prohibited.

## Decision Engine

- if exact patch primitive is available and precheck passes: AUTHORIZED_LIVE_WRITE_READY_FOR_APPLY
- if candidate count is not one: BLOCKED_WITH_EVIDENCE
- if environment resolves to Default, Test, Prod, or modoe: BLOCKED_WITH_EVIDENCE
- if rollback or postcheck cannot be emitted: BLOCKED_WITH_EVIDENCE
- current outcome: DELTA_APLICADO

## Trace

This packet executed a controlled Dataverse DEV metadata patch only. It did not
execute production, permission changes, flow activation, discovery runtime,
secrets, or broad regulated reads.
