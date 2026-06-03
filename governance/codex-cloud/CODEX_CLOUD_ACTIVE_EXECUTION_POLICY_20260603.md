# CODEX_CLOUD_ACTIVE_EXECUTION_POLICY_20260603

Estado: `CODEX_CLOUD_ACTIVE_EXECUTION_POLICY_READY`

## Regla

Codex Cloud smoke no-diff se ejecuta por defecto cuando existe environment visible o label aceptado por CLI. `codex cloud apply` no se ejecuta por defecto: requiere task id, diff revisado, rollback, postcheck y aprobacion de apply.

## Ejecutar ahora

- Listar tareas y confirmar environment label: `codex cloud list --limit 20 --json`.
- Ejecutar smoke no-diff: `codex cloud exec --env "universo-rey/cabina-universal-d" --branch main "Read-only governed smoke..."`.
- Postcheck: `codex cloud status <task_id>` y `codex cloud diff <task_id>` para confirmar `files_changed=0` o diff revisable.

## Gate de apply

`codex cloud apply <task_id>` solo procede con `EXECUTE_LIVE_WRITE_GATED_NOW` si el diff fue revisado, no contiene secretos, no toca produccion ni tenant, y existe rollback/postcheck.

## Evidencia

La evidencia minima es task id, URL o status local del task, diff check y
registro explicito de que no se ejecuto apply.

## Stop conditions

stop_condition:

`CODEX_CLOUD_ENVIRONMENT_MISSING`, `CODEX_CLOUD_APPLY_WITHOUT_REVIEW`, `SECRET_DETECTED`, `PRODUCTION_MUTATION_ATTEMPTED`.
