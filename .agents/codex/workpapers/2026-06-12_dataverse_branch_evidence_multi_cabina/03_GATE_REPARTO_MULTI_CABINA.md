# Gate de reparto multi-cabina

## Estado

`PENDING_TARGET_ONLY`

## Permitido ahora

- Mantener papeles de trabajo en `C:\Users\enzo1\.codex`.
- Usar estos papeles como paquete de decision.
- Preparar comandos de comparacion por destino.
- Preparar PRs o cambios por cabina solo despues de seleccionar target exacto.

## Bloqueado hasta gate

- Escribir en otros repos/cabinas.
- Hacer checkout, cherry-pick, rebase o merge para traer evidencia.
- Hacer commit, push, PR o issue.
- Ejecutar Microsoft live, SharePoint, Teams, Graph, Power Platform o Dataverse live write.
- Cambiar permisos, owners, conexiones, flows, work queues o environments.

## Campos requeridos para ejecutar reparto

Por cada destino:

- `target_repository`
- `target_local_path`
- `base_branch`
- `work_branch`
- `files_to_create_or_update`
- `owner_agent`
- `reviewer_agent`
- `write_scope`
- `rollback`
- `postcheck`
- `validator`
- `evidence_file`
- `stop_condition`

## Orden segura recomendada

1. Confirmar target list final.
2. Para cada cabina, leer estado Git local y branch actual.
3. Comparar si ya tiene evidencia equivalente.
4. Si ya existe, registrar `NO_WRITE_ALREADY_PRESENT`.
5. Si falta, preparar patch minimo en rama `codex/*`.
6. Validar sin live.
7. Stage explicito solo de archivos permitidos.
8. Commit/PR solo si la orden abre ese ciclo.

## Rollback

Rollback por destino:

- revertir solo los archivos creados/actualizados por el reparto;
- no tocar clones anidados;
- no usar `git reset --hard`;
- no usar `git clean -xfd`;
- si hubo PR, cerrar o revertir por commit explicito.

## Postcheck

Postcheck minimo:

- `git status --short --branch`
- presencia del dictamen en ruta destino exacta;
- ausencia de secretos;
- ausencia de cambios live;
- validador repo-local si existe.

## Stop condition

`no_cross_cabina_write_without_target_matrix`
