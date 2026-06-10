# PR140 Tenant Segments Merge Evidence Publish Readback

agente: Codex + court.sdu_gate
orden: continuar con el siguiente segmento atomico del tenant
superficie: Dataverse / Power Platform DEV
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: main
head: 754d3026e52c2e9d8d9c0a91e2212653ec7750df
skill: dataverse-metadata-only-provisioning | no-inference-runtime-write-guard | sdu-ejecutor-gates
recipe: tenant_controlled_segmented_write
tool: dataverse/scripts/invoke_evidence_publish_dev.ps1 | pac org fetch | Azure CLI token non-printed | Dataverse Web API POST/PATCH
estado: DELTA_APLICADO

acciones:
- Segmento seleccionado: publicar evidencia saneada del merge de PR #140 en `mon_sdu_evidence`.
- Dry-run ejecutado: `DATAVERSE_EVIDENCE_PUBLISH_DRY_RUN_PASS`.
- Apply ejecutado: `DATAVERSE_EVIDENCE_PUBLISH_APPLY_PASS`.
- Postcheck independiente ejecutado con `pac org fetch`.

target:
- environment: HUBDesarrollo
- environment_id: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- table: mon_sdu_evidence
- entity_set: mon_sdu_evidences
- key: mon_canonical_id
- canonical_id: evidence.pr140_tenant_segments_merge.20260608
- row_id: 640c3437-4763-f111-ab0d-00224805f8f9

resultado:
- candidate_count_before: 0
- candidate_count_after: 1
- mon_status: EVIDENCE_PUBLISHED
- mon_evidence_type: metadata_pointer_only
- mon_evidence_hash: d0ea8feac5099b296f3ac15c217b037b17bc7e2c66b20c75f855e54f0b12bbdf
- mon_stop_condition: PR140_TENANT_SEGMENTS_MERGED_REMOTE_CONFIRMED

evidencia:
- dataverse/validation/pr140_merge_evidence_publish_20260608/before_20260608_113430.json
- dataverse/validation/pr140_merge_evidence_publish_20260608/after_20260608_113430.json
- dataverse/validation/pr140_merge_evidence_publish_20260608/summary_20260608_113430.json
- dataverse/validation/pr140_merge_evidence_publish_20260608/before_20260608_113452.json
- dataverse/validation/pr140_merge_evidence_publish_20260608/after_20260608_113452.json
- dataverse/validation/pr140_merge_evidence_publish_20260608/summary_20260608_113452.json

nota_hash:
- No editar `.agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_readback.md` sin emitir nueva evidencia, porque ese archivo es la fuente hasheada registrada en Dataverse.

validadores:
- local_validate_order_packets.ps1: PASS
- local_validate_operational_chain.ps1: PASS
- mcp_connection_registry_validator.py: PASS
- validate_dataverse_manifest.ps1: PASS
- git diff --check: PASS

riesgo: bajo; write acotado a 1 fila metadata DEV, reversible por marca de rollback, sin prod, sin Default, sin modoe, sin secretos impresos.
gate: GATE_MICROSOFT_LIVE_WRITE=OPEN_ACTIVE | GATE_POWER_PLATFORM_APPLY=OPEN_ACTIVE
rollback: `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_evidence_publish_dev.ps1 -CanonicalId evidence.pr140_tenant_segments_merge.20260608 -SourcePath .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_readback.md -Rollback`
stop_condition: TENANT_PR140_MERGE_EVIDENCE_PUBLISH_APPLIED_AND_POSTCHECKED
pr: no creado
proximos_carriles: versionar cuarto segmento repo-local o seleccionar quinto segmento atomico.
