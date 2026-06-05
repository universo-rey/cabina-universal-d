# MERGE_SERIAL_GOVERNED_PATTERN

## Estado

`MERGE_SERIAL_GOVERNED_PATTERN_CANONIZED_FOR_REPLICATION`

## Cuando aplicar

Aplicar merge serial gobernado cuando dos o mas PRs comparten canon, politica,
validadores o superficie de autoridad y el resultado del primero modifica la
base que el segundo debe respetar.

Casos tipicos:

- hardening de politica antes de colas o contratos derivados;
- canon raiz antes de contratos repo-native;
- runtime o validadores antes de readbacks que los consumen;
- cambios con dependencia semantica aunque los archivos no se solapen.

## Como ordenar PRs

1. Primero el PR que cambia autoridad, politica, validador o gate.
2. Despues el PR que consume esa autoridad.
3. Si hay duda, ordenar por dependencia: canon, matriz, validador, artefacto derivado, readback.
4. No hacer merge masivo. Cada PR se verifica con su propio HEAD fijo.

## Cuando rebasear

Rebasear el PR dependiente cuando:

- el PR base ya fue mergeado y cambio reglas activas;
- el PR dependiente fue preparado sobre una politica anterior;
- hay riesgo de reintroducir estados, rutas o comandos obsoletos;
- los validadores nuevos deben evaluar el contenido del PR dependiente.

Si el rebase cambia el HEAD remoto, solo actualizar la rama con alcance exacto
del PR y con autorizacion del carril. No usar cambios fuera de scope.

## Cuando conservar branch

Conservar la branch remota por defecto cuando:

- no exista autorizacion explicita de eliminacion;
- el PR requiere auditoria posterior;
- el carril queda como evidencia de trabajo;
- hay posibilidad de follow-up sobre la misma rama.

## Cuando eliminar branch

Eliminar la branch remota solo cuando:

- el PR esta mergeado;
- la orden humana autorizo explicitamente esa eliminacion;
- no hay carriles posteriores que dependan de esa rama;
- el postcheck confirma que `main` contiene el HEAD esperado.

## Validadores requeridos

Para cambios documentales o de matriz:

- validador especifico del carril;
- validador canon activo cuando la politica de ejecucion aplica;
- `git diff --check`.

Para runtime, SDK local o CI:

- suite runtime proporcional;
- preflight local de Agents SDK sin llamada live cuando aplique;
- check remoto verde si el PR tiene workflow.

Para este patron base:

- `scripts/validators/active_governed_execution_policy_validator.py`
- `scripts/validators/active_execution_capability_matrix_validator.py`
- `scripts/validators/canon_active_execution_validator.py`
- `scripts/validators/dev_execution_attempt_validator.py`
- `scripts/validators/no_passive_blocking_language_validator.py`
- `scripts/validators/rey_guia_active_execution_queue_validator.py`
- `scripts/validators/cabina_universal_d_post_merge_validator.py`

## Postcheck exigido

Todo merge serial debe dejar evidencia de:

- PR abierto/no draft antes del merge;
- base `main`;
- HEAD fijo confirmado;
- checks verdes;
- sin `REQUEST_CHANGES`;
- merge normal con `gh pr merge <PR> --merge --match-head-commit <HEAD>`;
- confirmacion de merge commit;
- `origin/main` sincronizado o verificado;
- validadores proporcionales PASS;
- branch eliminada solo con autorizacion explicita;
- branch conservada cuando no exista autorizacion de eliminacion.

## Evidencia minima

- URL del PR;
- branch;
- head integrado;
- merge commit;
- decision sobre branch;
- validadores ejecutados;
- runtime tests si aplica;
- rollback por commit o PR;
- stop conditions.

## Rollback

El rollback es repo-scoped y PR-scoped:

- crear rama `codex/rollback-<pr>-<front>-<yyyymmdd>`;
- revertir el merge commit correspondiente;
- correr validadores proporcionales;
- abrir PR de rollback contra `main`;
- no mezclar rollback de dos repos o dos frentes salvo gate explicito.

## Stop conditions

- `secret_detected`
- `head_changed_after_precheck`
- `checks_not_green`
- `request_changes_present`
- `admin_bypass_requested`
- `branch_deletion_without_explicit_authorization`
- `external_live_required`
- `microsoft_live_required`
- `openai_api_live_required`
- `production_requested`
- `permission_change_requested`
- `nested_repo_write`
- `scope_mixed`
