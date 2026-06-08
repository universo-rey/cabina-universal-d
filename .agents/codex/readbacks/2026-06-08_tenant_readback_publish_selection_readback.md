# Tenant Readback Publish Selection Readback

agente: Codex + rey.frontier_guardian + court.sdu_gate
orden: seleccionar el quinto segmento atomico del tenant con target exacto
superficie: Dataverse / Power Platform DEV
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: main
head: 754d3026e52c2e9d8d9c0a91e2212653ec7750df
skill: dataverse-metadata-only-provisioning | no-inference-runtime-write-guard | sdu-ejecutor-gates
recipe: tenant_controlled_segment_selection
tool: pac org who | Azure CLI token non-printed | Dataverse Web API metadata/read probe
estado: NO_OP_LISTO

acciones:
- Se selecciono el quinto segmento atomico sin ejecutar apply.
- Se verifico metadata live de Dataverse para `mon_sdu_readback`.
- Se verifico clave unica activa sobre `mon_canonical_id`.
- Se verifico candidato exacto para el canonical id seleccionado.
- Se dejo orden local preparada en
  `.agents/codex/orders/ORDER_TENANT_READBACK_PUBLISH_20260608.md`.

target:
- environment: HUBDesarrollo
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- environment_url: https://org084965d9.crm.dynamics.com
- table: mon_sdu_readback
- entity_set: mon_sdu_readbacks
- primary_id: mon_sdu_readbackid
- primary_name: mon_display_name
- key_schema: mon_sdu_readback_canonical_id_key
- key_attribute: mon_canonical_id
- key_status: Active
- canonical_id: readback.pr140_tenant_segments_merge_evidence_publish.20260608

payload:
- mon_status: READBACK_PUBLISHED
- mon_source_path: .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_evidence_publish_readback.md
- mon_source_hash: 3d7605ff4fea628d3cd38b98c117c26fdb7470a92d9f1c761bcfc59b6be53c9e
- mon_stop_condition: TENANT_PR140_MERGE_EVIDENCE_PUBLISH_APPLIED_AND_POSTCHECKED
- mon_tenant_scope: escribaniabitsch.sharepoint.com
- mon_owner: SDUCapabilityControlPlane

evidencia:
- `mon_sdu_readback` existe.
- `mon_sdu_readbacks` existe como entity set.
- `mon_sdu_readbackid` es primary id.
- `mon_display_name` es primary name.
- `mon_canonical_id` es ApplicationRequired.
- `mon_sdu_readback_canonical_id_key` esta Active sobre `mon_canonical_id`.
- `candidate_count_before=0` para
  `readback.pr140_tenant_segments_merge_evidence_publish.20260608`.
- `token_printed=false`.

archivos:
- .agents/codex/orders/ORDER_TENANT_READBACK_PUBLISH_20260608.md
- .agents/codex/readbacks/2026-06-08_tenant_readback_publish_selection_readback.md
- .gitignore

validadores:
- NO_EJECUTADO en esta seleccion; ejecutar tras versionar o antes del apply.

checks:
- PR #140 ya mergeado y sincronizado localmente en `main`.
- No se abrio PR nuevo.

riesgo: bajo; seleccion y paquete repo-local, sin apply Dataverse.
gate: GATE_MICROSOFT_LIVE_WRITE=OPEN_ACTIVE | GATE_POWER_PLATFORM_APPLY=OPEN_ACTIVE para apply posterior; no usado en esta seleccion.
rollback: no requerido para seleccion; rollback de apply preparado como patch a `ROLLBACK_SUPERSEDED`.
stop_condition: TENANT_READBACK_PUBLISH_TARGET_SELECTED_NOT_APPLIED
pr: no creado
proximos_carriles: crear primitive local `invoke_readback_publish_dev.ps1`, ejecutar dry-run y apply segmentado, o versionar segmentos 4 y 5 en rama `codex/*`.
