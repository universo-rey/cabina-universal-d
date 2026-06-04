# Codex Cloud Setup Maintenance Tolerance Readback

Fecha: 2026-06-04

## Orden

Durabilizar el arreglo de Codex Cloud despues del smoke `READY_NO_DIFF`.

## Superficie

- Repo: `universo-rey/cabina-universal-d`.
- Branch: `codex/cloud-setup-maintenance-tolerant-20260604`.
- Cloud environment: `universo-rey/cabina-universal-d`.

## Cambios

- Setup: tolera `origin` vacio en Codex Cloud y conserva fallo si el remoto
  existe pero apunta a otro repo.
- Maintenance: corre unittest y `git diff --check`; si falta `pwsh`, registra
  skip de validadores PowerShell y no bloquea el arranque del agente salvo que
  `CABINA_REQUIRE_PWSH_VALIDATORS=true`.

## Evidencia

- Setup UI temporal fallo con `ERROR:unexpected_origin=`.
- Smoke Cloud posterior al no-op temporal:
  `task_e_6a21afcc26c0832ea3442ad89f6a6b8b`, estado `READY`, `files_changed=0`.

## Fronteras

No se ejecuto `codex cloud apply`.
No se ejecuto Microsoft live.
No se ejecuto OpenAI API live.
No se ejecuto Agents SDK live.
No se ejecuto produccion.
No se cambiaron permisos.
No se imprimieron secretos.

## Rollback

Revertir este commit o volver a los scripts anteriores.

## Stop Condition

`codex_cloud_setup_origin_missing|pwsh_missing_for_cloud_maintenance`
