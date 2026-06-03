# LOCAL_PACKAGE_COMMIT_PLAN

## Estado
LOCAL_PACKAGE_REVIEW_AND_VERSIONING_READY

## Alcance
- Workspace: D:\
- Rama local: codex/dataverse-dev-provisioning-20260603
- Propuesta solamente: no stage, no commit, no push, no PR, no merge.
- Superficies live ejecutadas en este carril de versionado: ninguna.
- `.env.local`: ignorado por Git; no se lee ni se versiona.
- Archivos clasificados: 166
- Archivos sin carril: 0

## Evidencia base congelada
- Estado de entrada: POWER_AUTOMATE_WORK_QUEUE_DEV_BOUND_AND_VALIDATED_OPENAI_ASSISTED.
- Dataverse DEV metadata-only: evidencia local existente, sin nueva mutacion.
- Power Automate DEV work queues: evidencia local existente, sin nueva mutacion.
- OpenAI asistido metadata-only: evidencia local existente, sin nueva llamada API.
- PROD/TEST/Default: no incluidos como target de ejecucion en este carril.

## Grupos propuestos

### feat(dataverse): add governed DEV metadata-only registry seed
- Archivos clasificados actualmente: 66
- Alcance sugerido: dataverse/; matrices/dataverse/; validation/dataverse/; docs/dataverse/; relevant Dataverse workflows
- Revision requerida: yes
- Bloqueador conocido: none_known
- Nota: DEV metadata-only registry seed, schema snapshots, drift/postcheck evidence. No PROD/TEST/Default mutation in this commit proposal.

### feat(connections): add canonical connection registry dedup and seed prep
- Archivos clasificados actualmente: 26
- Alcance sugerido: dataverse/data/seed_connection_*.csv; matrices/connections/; validation/connections/; readbacks/connections/
- Revision requerida: yes
- Bloqueador conocido: none_known
- Nota: Canonical connection registry deduplication and metadata-only seed prep. No secret values included.

### feat(powerautomate): bind seeded registry to DEV work queues
- Archivos clasificados actualmente: 42
- Alcance sugerido: powerplatform/workqueues/; powerplatform/flows/; matrices/powerautomate/; validation/powerautomate/; docs/powerautomate/; readbacks/powerautomate/
- Revision requerida: yes
- Bloqueador conocido: none_known
- Nota: DEV work queue manifests, pilot results, flow design metadata and rollback evidence. No new flow execution now.

### feat(openai): add metadata-only assisted classification artifacts
- Archivos clasificados actualmente: 11
- Alcance sugerido: openai/; validation/openai/; matrices/powerautomate/OPENAI_ASSISTED_*.csv
- Revision requerida: yes
- Bloqueador conocido: none_known
- Nota: Sanitized metadata-only OpenAI assisted outputs and schema/log summaries. No API call or key material now.

### docs(governance): add readbacks, gates, rollback and validation evidence
- Archivos clasificados actualmente: 20
- Alcance sugerido: readbacks/; validation/; docs/; matrices/versioning/; .agents/codex/matrices/MATRIX_INDEX.csv; .github/workflows/dataverse-*.yml
- Revision requerida: yes
- Bloqueador conocido: none_known
- Nota: Evidence, gate, rollback, versioning classification and validator reports.

### chore(gitignore): protect local secrets and runtime files
- Archivos clasificados actualmente: 1
- Alcance sugerido: .gitignore
- Revision requerida: yes
- Bloqueador conocido: none_known
- Nota: Protects .env and local/runtime secret-bearing files from accidental versioning.

## Orden sugerido
1. `chore(gitignore): protect local secrets and runtime files`
2. `feat(connections): add canonical connection registry dedup and seed prep`
3. `feat(dataverse): add governed DEV metadata-only registry seed`
4. `feat(powerautomate): bind seeded registry to DEV work queues`
5. `feat(openai): add metadata-only assisted classification artifacts`
6. `docs(governance): add readbacks, gates, rollback and validation evidence`

## Condiciones para versionar en carril posterior
- `LOCAL_PACKAGE_SECRET_SCAN_PASS` vigente.
- `LOCAL_PACKAGE_VERSIONING_VALIDATION_REPORT.md` sin bloqueadores criticos.
- Stage explicito por grupo; prohibido `git add .`.
- No incluir `.env.local`, caches, tokens, dumps amplios ni secretos.
- No ejecutar Dataverse, Power Automate, OpenAI API, Batch API, Microsoft live, produccion ni propagacion durante el versionado.

## Rollback
- Antes de versionar: eliminar los artefactos locales no deseados o restaurar archivos especificos con revision humana.
- Despues de versionar: revertir commits individuales por grupo, manteniendo trazabilidad.
