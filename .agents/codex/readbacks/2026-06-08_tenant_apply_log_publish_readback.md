# Tenant Apply Log Publish Readback

agente: Codex + court.sdu_gate
orden: avanzar al siguiente segmento atomico del tenant
superficie: Dataverse / Power Platform DEV
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: main
head: ffea373
skill: tcu-descubridor-capacidades | dataverse-metadata-only-provisioning | no-inference-runtime-write-guard | sdu-ejecutor-gates
recipe: tenant_controlled_segmented_write
tool: dataverse/scripts/invoke_apply_log_publish_dev.ps1 | pac org fetch | Azure CLI token non-printed | Dataverse Web API POST/PATCH
estado: DELTA_APLICADO

acciones:
- Segmento seleccionado: publicar apply-log saneado en `mon_sdu_apply_log`.
- Dry-run ejecutado: `DATAVERSE_APPLY_LOG_PUBLISH_DRY_RUN_PASS`.
- Apply ejecutado: `DATAVERSE_APPLY_LOG_PUBLISH_APPLY_PASS`.
- Postcheck independiente ejecutado con `pac org fetch`.

target:
- environment: HUBDesarrollo
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- table: mon_sdu_apply_log
- entity_set: mon_sdu_apply_logs
- key: mon_canonical_id
- canonical_id: apply.tenant_controlled_gate_state_patch.20260608
- row_id: 9910b1d0-4363-f111-ab0d-00224805f8f9

resultado:
- candidate_count_before: 0
- candidate_count_after: 1
- mon_status: APPLIED_POSTCHECKED
- mon_source_hash: a72a08f4f58fc6d95dcb58127136a118b0d6ee7125df22148bc270a1718a2ca1
- mon_stop_condition: TENANT_CONTROLLED_GATE_STATE_PATCH_APPLIED_AND_POSTCHECKED

evidencia:
- dataverse/validation/apply_log_publish_20260608/before_20260608_111012.json
- dataverse/validation/apply_log_publish_20260608/after_20260608_111012.json
- dataverse/validation/apply_log_publish_20260608/summary_20260608_111012.json
- dataverse/validation/apply_log_publish_20260608/before_20260608_111037.json
- dataverse/validation/apply_log_publish_20260608/after_20260608_111037.json
- dataverse/validation/apply_log_publish_20260608/summary_20260608_111037.json

validadores:
- local_validate_order_packets.ps1: PASS
- local_validate_operational_chain.ps1: PASS
- mcp_connection_registry_validator.py: PASS
- validate_dataverse_manifest.ps1: PASS
- git diff --check: PASS

riesgo: bajo-medio; write acotado a 1 fila metadata DEV, reversible por marca de rollback, sin prod, sin Default, sin modoe, sin secretos impresos.
gate: GATE_MICROSOFT_LIVE_WRITE=OPEN_ACTIVE | GATE_POWER_PLATFORM_APPLY=OPEN_ACTIVE
rollback: `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_apply_log_publish_dev.ps1 -Rollback`
stop_condition: TENANT_APPLY_LOG_PUBLISH_APPLIED_AND_POSTCHECKED
pr: no creado
proximos_carriles: seleccionar siguiente segmento atomico o versionar los cambios repo-locales.
