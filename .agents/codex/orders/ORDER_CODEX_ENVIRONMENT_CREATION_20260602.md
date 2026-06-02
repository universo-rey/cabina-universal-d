# Order: Codex Environments

## Estado

PREPARADA_GOBERNADA.

## Objetivo

Crear y gobernar entornos Codex para la Cabina Universal:

1. Entorno Codex app local/worktree versionado en `D:\.codex`.
2. Cola de environments Codex Cloud por repo, separando visibles, pendientes y
   candidatos fuera de base.

## Identidad

- Operador: Enzo / Cabina Universal del Rey.
- Cuenta observada: Codex local autenticado en esta maquina.
- GitHub: repo-scoped, sin permisos ni secretos nuevos.

## Superficie

- Local: `D:\.codex\environments\environment.toml`.
- Cloud: Codex settings / Codex Cloud environments.
- CLI disponible: `codex cloud list`, `codex cloud exec`, `codex cloud status`,
  `codex cloud diff`, `codex cloud apply`.

## Tool Real

Disponible:

- `codex cloud list`
- `codex cloud exec`
- `codex cloud status`
- `codex cloud diff`
- `codex cloud apply`

NO_DISPONIBLE en esta sesion:

- tool/API directa para crear Codex Cloud environment.
- tool/API directa para editar environment settings, secrets o internet access.

## Acciones Permitidas

- Versionar `.codex` local/worktree para `D:\`.
- Registrar cola de environments Codex por repo.
- Marcar Cloud environments faltantes como `NEEDS_CODEX_CLOUD_UI_CREATE`.
- Ejecutar validadores locales sin escribir en servicios externos.
- Ejecutar smokes Cloud read-only solo con environment visible y repo/branch
  exactos.

## Acciones Bloqueadas

- Secrets en `.codex`, matrices, orders o readbacks.
- OpenAI API live.
- Microsoft live.
- Produccion.
- Tenant writes.
- Permission changes.
- Codex Cloud apply sin revision.
- Crear o borrar environments Cloud por UI sin postcheck y rollback declarados.
- Absorber repos anidados en `D:\`.

## Rollback

- Local: revertir PR/commit que introduce `.codex` y matrices.
- Cloud si se crea manualmente en UI: eliminar el environment desde Codex
  settings y registrar evidencia de postcheck.

## Postcheck

- `D:\.agents\codex\tools\local_validate_codex_app_environments.ps1`
- `D:\.agents\codex\tools\local_validate_codex_cloud_governed_lane.ps1`
- `git diff --check`
- `codex cloud list --json` cuando se agregue un environment Cloud real.

## Evidencia

- `.codex/environments/environment.toml`
- `D:\.agents\codex\matrices\CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv`
- `D:\.agents\codex\matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv`
- `D:\.agents\codex\readbacks\2026-06-02_codex_environments_readback.md`

## Stop Conditions

- `codex_app_environment_missing`
- `codex_cloud_environment_missing`
- `codex_environment_creation_tool_unavailable`
- `secret_detected`
- `capability_use_preflight_missing`

## Proximos Carriles Paralelos

- `codex_env_repo_native_sdu`: crear `.codex` repo-nativo para
  `seshat-bootstrap-sdu-cn`, `sdu-canon` y `tcu-agentic-runtime-control`.
- `codex_env_repo_native_tge`: crear `.codex` repo-nativo para TGE y runtime
  TGE sin datos regulados amplios.
- `codex_env_repo_native_modo_on`: crear `.codex` repo-nativo para CDF, Jara y
  Modo ON.
- `codex_cloud_ui_creation`: crear environments Cloud faltantes desde Codex
  settings con repo exacto, setup sin secretos, internet agent off y postcheck.
