# SDU Tenant Training Preparation Readback — cre3c_ReconciliarShe

agente: Codex + court.sdu_gate + court.openai_dispatcher + rey.frontier_guardian
orden: ORDER_SDU_TENANT_TRAINING_PREPARATION_20260609
superficie: Dataverse / Power Platform DEV
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: codex/sdu-sharepoint-site-backlog
head: 87d0c80
skill: dataverse-metadata-only-provisioning | sdu-ejecutor-gates
recipe: tenant_controlled_segmented_write
tool: dataverse/scripts/invoke_readback_publish_dev.ps1 | Azure CLI token non-printed | Dataverse Web API POST/PATCH
estado: EXECUTADO

acciones:
- Preparar objeto de metadatos de preentrenamiento SDU para el Copilot `cre3c_ReconciliarShe` en tenant DEV `HUBDesarrollo` (`org084965d9.crm.dynamics.com`).
- Registrar intención de entrenamiento y postcheck/rollback en `mon_sdu_readback` como fila metadata-only.
- Mantener alcance acotado: una sola fila, sin secretos, sin exportes de datos regulados, sin escritura de producción.

target:
- environment: HUBDesarrollo
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- environment_url: https://org084965d9.crm.dynamics.com
- table: mon_sdu_readback
- entity_set: mon_sdu_readbacks
- canonical_id: readback.sdu_training_preparation_cre3c_reconciliarshe.20260609
- tenant_scope: escribaniabitsch.sharepoint.com
- status_target: READBACK_PUBLISHED
- stop_condition_target: SDU_TRAINING_PREPARATION_APPLIED_AND_POSTCHECKED
- mon_stop_condition_rollback: ROLLBACK_SUPERSEDED_BY_OPERATOR_OR_READBACK_ROLLBACK

resultado:
- `dataverse/scripts/invoke_readback_publish_dev.ps1` ejecutado con `-Apply`, `GATE_CONFIRMATION='GATE_DATAVERSE_APPLY'`.
- Resultado: `DATAVERSE_READBACK_PUBLISH_APPLY_PASS`, `candidate_count_before: 0 -> after: 1`.
- `mon_status=READBACK_PUBLISHED`.
- `mon_source_hash=7304a16384541f1bc4a911dc42257d7c3b29aa6a5ca79441a4175a5c5916848f`.
- `mon_canonical_id=readback.sdu_training_preparation_cre3c_reconciliarshe.20260609`.
- `mon_sdu_readbackid=4f2d98fb-3e64-f111-ab0d-00224805fc91`.
- Segunda pasada de `-Apply` para ajuste de `mon_notes`; `candidate_count_before: 1 -> after: 1`, `source_hash` sin cambios, `postcheck_verified=true`.
- Re-aplicado con `mon_notes`: `SDU tenant training preparation metadata for existing Copilot schema cre3c_ReconciliarShe in tenant DEV.`.

evidencia:
- seed/source: `.agents/codex/orders/ORDER_SDU_TENANT_TRAINING_PREPARATION_20260609.md`
- execution: `dataverse/scripts/invoke_readback_publish_dev.ps1`
- payload: script calcula `mon_source_hash` sobre este archivo local.
- precheck/postcheck: `dataverse/validation/readback_publish_20260608/before_20260609_170833.json` y `before_20260609_170937.json`.
- post snapshot: `dataverse/validation/readback_publish_20260608/after_20260609_170833.json` y `after_20260609_170937.json`.

stop_condition:
- `SDU_TRAINING_PREPARATION_APPLIED_AND_POSTCHECKED`
- `rollback_ready=true`

notas:
- `pac` y `az` deben coincidir con `efigueroa@registronotarial8tdf.com.ar` y `environment_id=7f65fc04-c27a-ea0d-bd2d-266aa9203c1e`.
- rollback: `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_readback_publish_dev.ps1 -CanonicalId readback.sdu_training_preparation_cre3c_reconciliarshe.20260609 -Rollback`
