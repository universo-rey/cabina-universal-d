# Readback: Monitoreo diario de colas SDU en Dataverse - 2026-06-11

## Contexto
- Fecha: 2026-06-11
- Hora snapshot: `2026-06-11T09:34:49.9309929-03:00`
- Entorno: `https://org993e120d.crm2.dynamics.com`
- Ambiente: `ESCRIBANIA BITSCH (default)` (tenant `858a0852-44a1-413e-a0fe-f053949797d6`)
- Superficie: Dataverse DEV live read only
- Repo: `universo-rey/cabina-universal-d`
- Workspace: `C:\Users\enzo1\Documents\GitHub\cabina-universal-d`
- Branch: `codex/sdu-workqueue-daily-monitor`
- Head: `e79decc`

## Resultado del snapshot
- `queues`: 8
- `drift_queues`: 0
- `total_backlog_items`: 0
- `live_write_executed`: false
- `microsoft_live_target_missing`: true

## Colas confirmadas
- `SDU.Matrix.Intake.Queue` `573521e6-4964-f111-ab0d-002248df1063`
- `SDU.Connection.Seed.Queue` `383721e6-4964-f111-ab0d-002248df1063`
- `SDU.Agent.Dispatch.Queue` `3c3721e6-4964-f111-ab0d-002248df1063`
- `SDU.Gate.Review.Queue` `403721e6-4964-f111-ab0d-002248df1063`
- `SDU.Evidence.Publish.Queue` `443721e6-4964-f111-ab0d-002248df1063`
- `SDU.Dataverse.Apply.Queue` `483721e6-4964-f111-ab0d-002248df1063`
- `SDU.Exception.Remediation.Queue` `4c3721e6-4964-f111-ab0d-002248df1063`
- `SDU.Drift.Detection.Queue` `503721e6-4964-f111-ab0d-002248df1063`

## Script operativo
- Script: [dataverse/scripts/monitor-sdu-workqueue-daily.ps1](/C:/Users/enzo1/Documents/GitHub/cabina-universal-d/dataverse/scripts/monitor-sdu-workqueue-daily.ps1)
- Parametros usados:
  - `-Json`
  - `-SummaryOnly`
- Salida local generada:
  - `dataverse/scripts/monitoring/20260611_093449/sdu_workqueue_snapshot_summary_20260611_093449.json`

## Validacion local
- `python -m unittest discover -s apps/sdu-agent-runtime/tests`: PASS, 5 tests.
- `python tests/sdu-agent-runtime/test_dev_activation_contract.py`: PASS.
- `python tests/sdu-agent-runtime/simulate_sdu_agent_chat_to_tool_to_readback.py`: PASS.
- `python scripts/validators/sdu_dev_activation_secret_contract_validator.py`: PASS.
- `python scripts/validators/sdu_dev_live_smoke_readback_validator.py`: PASS.
- `python scripts/validators/sdu_codex_cloud_dev_activation_validator.py`: PASS.
- `python scripts/validators/sdu_agent_runtime_evidence_validator.py`: PASS.

## Riesgos y pendientes
- El runtime local y los contratos de activacion estan sanos.
- El monitor live confirma cero backlog hoy.
- Microsoft live write sigue gated: falta target exacto, owner, rollback y postcheck para cualquier aplicacion.

## Stop condition
- `PENDING_TARGET_ONLY` para cualquier escritura Microsoft live.
- No se ejecuto escritura live en esta pasada.
