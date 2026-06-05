# SDU_OPEN_FRONTS_CURRENT_BASELINE

## Estado

`CABINA_UNIVERSAL_D_POST_MERGE_BASELINE_READY`

Fecha local: 2026-06-05

## Frente raiz actualizado

Repo:

`universo-rey/cabina-universal-d`

Rol:

`REPO_CABINA_GOBERNADA`

Superficie:

`github_repo_scoped`

Politica live:

`no_external_live` para este gate.

Patron activo:

`recipe.github_pr_lifecycle_governed`

Proximo carril:

`revision_otros_repos`

## Cierre integrado

- PR `#92` integrado primero con merge normal y HEAD fijo `12bbd8fcd9db950b4c86e78bf988497938ffffad`.
- PR `#91` integrado despues, rebaseado sobre `main` endurecido, con merge normal y HEAD fijo `4aa594f460818d1c2dd7ec1725a5d646f923e69c`.
- Merge commits registrados:
  - `#92`: `9bce9f4e87d548a8ee6afe67ff729c66c34d2688`
  - `#91`: `77c957d1ae5de055ab3ef2869e597a2c8be50714`

## Baseline operativo

El frente raiz queda como patron de integracion serial para los demas repos:

- canon o hardening primero;
- PR derivado despues;
- rebase cuando el segundo depende de reglas nuevas;
- merge normal con HEAD fijo;
- sin admin bypass;
- branch eliminada solo con autorizacion explicita;
- postcheck sobre `main`;
- evidencia y rollback por PR.

## Frentes abiertos

| Repo | Estado actual | Proximo carril |
| --- | --- | --- |
| `universo-rey/cabina-universal-d` | baseline post-merge listo | usar como patron |
| `SeshatSgin/torre-gemela-escribania` | en cola | revisar hardening activo repo-native |
| `SeshatSgin/seshat-bootstrap-sdu-cn` | en cola | revisar contrato canonico y validator |
| `SeshatSgin/cdf-soluciones` | en cola | revisar frontera CDF/Dataverse/Power Platform sin live |
| `SeshatSgin/tge-agentic-runtime-control-escribania` | en cola | revisar runtime/SDK local y gates |

## Fronteras vigentes

Este baseline no ejecuta:

- Microsoft live;
- OpenAI API live;
- Responses API live;
- Agents SDK live;
- produccion;
- permisos;
- tenant writes;
- repos anidados;
- borrado de branches no autorizado;
- admin bypass.

## Stop conditions

- `secret_detected`
- `external_live_required`
- `admin_bypass_requested`
- `branch_deletion_without_explicit_authorization`
- `production_requested`
- `permission_change_requested`
- `tenant_ambiguous`
- `nested_repo_write`
- `scope_mixed`
