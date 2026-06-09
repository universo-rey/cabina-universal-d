# SDU Tenant Training Activation Readback — cre3c_ReconciliarShe

agente: Codex + court.sdu_gate + rey.frontier_guardian + court.seshat_evidence
orden: ORDER_SDU_AGENTS_NEXT_TASK_ACTIVATION_20260608
superficie: Dataverse / Power Platform DEV
repo: universo-rey/cabina-universal-d
workspace: C:\\Users\\enzo1\\Documents\\GitHub\\cabina-universal-d
branch: codex/sdu-sharepoint-site-backlog
head: 87d0c80
skill: dataverse-metadata-only-provisioning | dataverse-atomic-segment-runner
recipe: tenant_controlled_segmented_write
tool: dataverse/scripts/invoke_readback_publish_dev.ps1 | Azure CLI token non-printed | Dataverse Web API PATCH/POST
estado: EJECUTADO

acciones:
- Preparar y registrar un readback de metadata de activación para la tarea de entrenamiento del Copilot `cre3c_ReconciliarShe` bajo el objetivo SDU DEV, sin crear ni modificar el roster canónico SDU.
- Encadenar ejecución en la secuencia SDU autorizada: seshat-normativa, thot-tecnico, anubis-gate, maat-cumplimiento, horus-riesgo, narrador-normativo.
- Mantener alcance acotado: una sola fila metadata, sin escritura de producción, sin secretos, sin dump regulado.

target:
- environment: HUBDesarrollo
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- environment_url: https://org084965d9.crm.dynamics.com
- table: mon_sdu_readback
- entity_set: mon_sdu_readbacks
- canonical_id: readback.sdu_training_activation_cre3c_reconciliarshe.20260609
- tenant_scope: escribaniabitsch.sharepoint.com
- status_target: READBACK_PUBLISHED
- stop_condition_target: SDU_TRAINING_ACTIVATION_APPLIED_AND_POSTCHECKED
- mon_stop_condition_rollback: ROLLBACK_SUPERSEDED_BY_OPERATOR_OR_READBACK_ROLLBACK

resultado:
- `dataverse/scripts/invoke_readback_publish_dev.ps1` ejecutado dos veces con `-Apply`:
- Primera pasada: `DATAVERSE_READBACK_PUBLISH_APPLY_PASS`, `candidate_count_before: 0 -> after: 1`.
- Segunda pasada de ajuste: `DATAVERSE_READBACK_PUBLISH_APPLY_PASS`, `candidate_count_before: 1 -> after: 1`.
- `mon_status=READBACK_PUBLISHED`.
- `mon_canonical_id=readback.sdu_training_activation_cre3c_reconciliarshe.20260609`.
- `mon_sdu_readbackid=7efbcb6b-3f64-f111-ab0d-00224805fc91`.
- `mon_source_hash=52d6c85aca6a4fa74cf756ff267b7ab4f25ae52eecf80eac654aabb9aeb58dbb`.
- `postcheck_verified=true`, `rollback_ready=true`.
 - `mon_notes final`: `SDU tenant training activation metadata for existing Copilot schema cre3c_ReconciliarShe in tenant DEV.`

stop_condition:
- SDU_TRAINING_ACTIVATION_APPLIED_AND_POSTCHECKED

evidencia:
- seed/source: `.agents/codex/orders/ORDER_SDU_AGENTS_NEXT_TASK_ACTIVATION_20260608.md`
- execution: `dataverse/scripts/invoke_readback_publish_dev.ps1`
- readback de precheck previo: `.agents/codex/readbacks/2026-06-09_sdu_training_preparation_cre3c_reconciliarshe_readback.md`
- snapshots:
  - `dataverse/validation/readback_publish_20260608/before_20260609_171138.json`
  - `dataverse/validation/readback_publish_20260608/after_20260609_171138.json`
  - `dataverse/validation/readback_publish_20260608/before_20260609_171213.json`
  - `dataverse/validation/readback_publish_20260608/after_20260609_171213.json`

notas:
- `pac` y `az` deben coincidir con `efigueroa@registronotarial8tdf.com.ar` y `environment_id=7f65fc04-c27a-ea0d-bd2d-266aa9203c1e` antes de apply.
- Ejecutar apply con:
  `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_readback_publish_dev.ps1 -Apply -CanonicalId readback.sdu_training_activation_cre3c_reconciliarshe.20260609 -SourcePath .agents/codex/readbacks/2026-06-09_sdu_training_activation_cre3c_reconciliarshe_readback.md -DisplayName "SDU tenant training activation - cre3c_ReconciliarShe 20260609" -StopCondition SDU_TRAINING_ACTIVATION_APPLIED_AND_POSTCHECKED -RiskLevel low -Status READBACK_PUBLISHED`
- Rollback: `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_readback_publish_dev.ps1 -CanonicalId readback.sdu_training_activation_cre3c_reconciliarshe.20260609 -Rollback`
