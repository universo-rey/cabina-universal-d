# READBACK REPO OPERATING CONTRACT - CABINA - 2026-06-04

## Estado

HECHO_VERIFICADO: contrato repo-native de Cabina preparado y matriz central
creada para los cinco repos foco del frente `CABINA_FOCUS_5_REPOS_20260604`.

## Sistemas tocados

- Git repo `universo-rey/cabina-universal-d`.
- GitHub repo-scoped via branch y PR.
- Issues GitHub #87 y #88 solo como referencia hasta fan-in final.

## Sistemas no tocados

- Microsoft live.
- OpenAI live.
- Responses API live.
- Agents SDK live.
- Produccion.
- Permisos.
- Tenant writes.
- Propagacion.
- Secretos.

## Cambios

- Contrato raiz en `02_AUTHORITY_CANON/REPO_OPERATING_CONTRACT_CABINA_UNIVERSAL_D_20260604.md`.
- Matriz central en `02_AUTHORITY_CANON/FOCUS_5_REPOS_OPERATING_CONTRACT_MATRIX_20260604.csv`.
- Validador raiz en `scripts/validators/repo_native_operating_contracts_validator.py`.
- Readback postmerge #89 versionado en `readbacks/versioning/READBACK_SDU_CN_CANONICAL_AGENTS_POSTMERGE_20260604.md`.

## Validacion

- `python scripts/validators/repo_native_operating_contracts_validator.py`
- `python scripts/validators/sdu_cn_canonical_agent_pantheon_validator.py`
- `python scripts/validators/focus_5_repo_contracts_validator.py`
- `python scripts/validators/cabina_startup_contract_validator.py`
- `git diff --check`

## Riesgos

Riesgo bajo: cambio documental, matriz y validador local. El riesgo central es
mezclar scopes de repos, por eso cada repo conserva PR propio y Cabina solo
mantiene fan-in.

## Rollback

Revertir el commit o cerrar el PR raiz sin merge. Si ya estuviera mergeado,
revertir el merge commit repo-scoped.

## Proximos carriles

Revisar y mergear los PRs de contratos operativos repo-native si mantienen
checks verdes, sin live, sin secretos y sin produccion.
