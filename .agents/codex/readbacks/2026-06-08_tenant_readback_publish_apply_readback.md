# Tenant Readback Publish Apply Readback

agente: Codex + rey.frontier_guardian + court.sdu_gate
orden: crear primitive local invoke_readback_publish_dev.ps1 y ejecutar dry-run/apply
superficie: Dataverse / Power Platform DEV
repo: universo-rey/cabina-universal-d
workspace: C:\Users\enzo1\Documents\GitHub\cabina-universal-d
branch: main
head: 754d3026e52c2e9d8d9c0a91e2212653ec7750df
skill: dataverse-metadata-only-provisioning | no-inference-runtime-write-guard | sdu-ejecutor-gates
recipe: tenant_controlled_segmented_write
tool: dataverse/scripts/invoke_readback_publish_dev.ps1 | Azure CLI token non-printed | Dataverse Web API POST/PATCH
estado: DELTA_APLICADO

acciones:
- Se creo el primitive local `dataverse/scripts/invoke_readback_publish_dev.ps1`.
- Se ejecuto dry-run del quinto segmento atomico.
- Se ejecuto apply DEV contra `mon_sdu_readback`.
- Se ejecuto postcheck independiente por Dataverse Web API read-only.

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
- row_id: fdd4c391-4963-f111-ab0d-00224805f8f9

resultado:
- dry_run: DATAVERSE_READBACK_PUBLISH_DRY_RUN_PASS
- apply: DATAVERSE_READBACK_PUBLISH_APPLY_PASS
- candidate_count_before: 0
- candidate_count_after: 1
- mon_status: READBACK_PUBLISHED
- mon_source_hash: 3d7605ff4fea628d3cd38b98c117c26fdb7470a92d9f1c761bcfc59b6be53c9e
- mon_source_path: .agents/codex/readbacks/2026-06-08_pr140_tenant_segments_merge_evidence_publish_readback.md
- mon_stop_condition: TENANT_PR140_MERGE_EVIDENCE_PUBLISH_APPLIED_AND_POSTCHECKED

evidencia:
- dataverse/validation/readback_publish_20260608/summary_20260608_115125.json
- dataverse/validation/readback_publish_20260608/after_20260608_115146.json
- dataverse/validation/readback_publish_20260608/summary_20260608_115146.json
- independent Web API postcheck: candidate_count=1, row_id=fdd4c391-4963-f111-ab0d-00224805f8f9, token_printed=false

nota_pac:
- `pac org fetch` autentico contra HUBDesarrollo, pero fallo por parsing XML del CLI. No se uso como evidencia de fila.

validadores:
- local_validate_order_packets.ps1: PASS
- local_validate_operational_chain.ps1: PASS
- mcp_connection_registry_validator.py: PASS
- validate_dataverse_manifest.ps1: PASS
- git diff --check: PASS con warnings CRLF solamente
- secret scan: PASS sin patrones de token

riesgo: bajo; write acotado a 1 fila metadata DEV, reversible por marca de rollback, sin prod, sin Default, sin modoe, sin secretos impresos.
gate: GATE_MICROSOFT_LIVE_WRITE=OPEN_ACTIVE | GATE_POWER_PLATFORM_APPLY=OPEN_ACTIVE
rollback: `powershell -NoProfile -ExecutionPolicy Bypass -File dataverse\scripts\invoke_readback_publish_dev.ps1 -Rollback`
stop_condition: TENANT_READBACK_PUBLISH_APPLIED_AND_POSTCHECKED
pr: no creado
proximos_carriles: validar y versionar segmentos 4 y 5 repo-locales en rama `codex/*`, o seleccionar sexto segmento atomico.
