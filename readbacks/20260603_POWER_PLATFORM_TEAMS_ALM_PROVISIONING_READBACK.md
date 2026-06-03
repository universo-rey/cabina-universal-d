# Power Platform Teams ALM Provisioning Readback

Fecha: 2026-06-03
Estado final esperado: `POWER_PLATFORM_TEAMS_ALM_DEV_STAGING_READY`
Estado actual del readback: `LOCAL_VALIDATION_PASS_PENDING_GIT_PR`

## Cadena

| item | valor |
| --- | --- |
| agente | `rey.control_plane_orchestrator` |
| delegado | `court.openai_dispatcher` |
| runtime | `sdu-triage-agent` |
| gate | `court.sdu_gate` |
| evidencia | `court.seshat_evidence` |
| skill | `D:\.agents\skills\tcu-descubridor-capacidades\SKILL.md` |
| receta | `POWER_PLATFORM_ALM_DEV_STAGING_RECIPE` |
| tool | filesystem local, GitHub Actions, PAC CLI scripts, GitHub CLI pending |
| superficie | `D:\` repo root, GitHub repo-scoped, Power Platform DEV/STAGING prepared |
| stop_condition | `tenant_exact_target_missing_for_live_execution` |

## Precheck

| item | resultado |
| --- | --- |
| repo root | `D:\` |
| remoto | `https://github.com/universo-rey/cabina-universal-d.git` |
| base | `origin/main` |
| rama creada | `codex/power-platform-teams-governance-alm-20260603` |
| estado inicial | limpio |
| Microsoft live | no ejecutado |
| produccion | no ejecutada |
| secretos | no materializados |

## Archivos creados

- `governance/power-platform/DISCOVERY_POWER_PLATFORM_TEAMS.md`
- `governance/power-platform/POWER_PLATFORM_TEAMS_CAPABILITY_REGISTRY.md`
- `governance/power-platform/POWER_AUTOMATE_TEAMS_COMPATIBILITY_MATRIX.md`
- `governance/power-platform/POWER_PLATFORM_TEAMS_GOVERNANCE_POLICY.md`
- `governance/power-platform/POWER_AUTOMATE_GITHUB_SCOUTING.md`
- `recipes/power-platform/TEAMS_MESSAGE_ORCHESTRATION_RECIPE.md`
- `recipes/power-platform/POWER_PLATFORM_ALM_DEV_STAGING_RECIPE.md`
- `recipes/power-platform/POWER_PLATFORM_SOLUTION_GOVERNANCE_RECIPE.md`
- `recipes/power-platform/POWER_AUTOMATE_FLOW_INVENTORY_RECIPE.md`
- `validation/POWER_PLATFORM_TEAMS_VALIDATION.md`
- `.github/workflows/power-platform-whoami.yml`
- `.github/workflows/power-platform-export-unpack.yml`
- `.github/workflows/power-platform-check-solution.yml`
- `.github/workflows/power-platform-pack-import-dev.yml`
- `.github/workflows/power-platform-alm-full-dev.yml`
- `scripts/power-platform/pp-whoami.ps1`
- `scripts/power-platform/pp-export-unpack.ps1`
- `scripts/power-platform/pp-pack-check.ps1`
- `scripts/power-platform/pp-import-dev.ps1`
- `scripts/power-platform/pp-validate-env.ps1`
- `readbacks/20260603_POWER_PLATFORM_TEAMS_ALM_PROVISIONING_READBACK.md`

## Archivos modificados

- `.gitignore`: allowlist explicita para el paquete Power Platform / Teams.

## Workflows creados

| workflow | objetivo | gate |
| --- | --- | --- |
| `power-platform-whoami.yml` | validar conexion Dataverse/Power Platform | `environment_url` DEV/STAGING, service principal |
| `power-platform-export-unpack.yml` | exportar solucion y desempaquetar | no produccion, artifact only |
| `power-platform-check-solution.yml` | ejecutar solution checker | fail on analysis error, override documentado |
| `power-platform-pack-import-dev.yml` | pack e import DEV opcional | `import_to_dev` + `confirm_non_production` |
| `power-platform-alm-full-dev.yml` | ALM completo DEV/STAGING | import/publish opcional con gates |

## Scripts creados

| script | objetivo |
| --- | --- |
| `pp-whoami.ps1` | auth service principal y `pac org who` |
| `pp-export-unpack.ps1` | export y unpack local |
| `pp-pack-check.ps1` | pack y solution checker |
| `pp-import-dev.ps1` | import/publish DEV/STAGING gated |
| `pp-validate-env.ps1` | precheck local de entorno, PAC y secret env var |

## Fuentes leidas

- Microsoft Learn: GitHub Actions for Microsoft Power Platform.
- Microsoft Learn: Available GitHub Actions for Microsoft Power Platform.
- `microsoft/powerplatform-actions` action.yml para who-am-i, export,
  unpack, pack, import, publish y check.
- GitHub Marketplace: Power Platform Actions.
- GitHub topic `powerautomate`.
- Repos scouting: Microsoft PowerPlatformConnectors, PnP samples/snippets,
  Provision Assist y OfficeDev Request-a-Team.

## Capacidades detectadas

- Dataverse DEV package existente.
- Workflows Dataverse existentes.
- PAC CLI local disponible.
- Work queue Power Automate existente.
- Matrices de connections y secret boundaries existentes.
- Gobernanza Teams y agentes existentes.

## Duplicados

- No se duplicaron workflows Dataverse existentes.
- No se reescribieron matrices de Power Automate brownfield.
- No se sustituyo la policy Teams rector superior.

## Conflictos resueltos

- `contents: read` se mantiene en workflows nuevos.
- Secrets se referencian por GitHub Secrets y variable local, sin valores.
- Import/publish quedan restringidos a DEV/STAGING.
- Produccion queda fuera de este paquete.

## Riesgos

| riesgo | estado |
| --- | --- |
| Tenant exacto no declarado | gated, no ejecutado |
| Service principal no configurado | pendiente de GitHub Secrets |
| Graph messaging | `order_required` |
| Import/publish DEV | preparado, no ejecutado |
| Produccion | fuera de alcance, requiere workflow protegido separado |

## Gates pendientes

- Configurar GitHub Secrets: `POWERPLATFORM_APP_ID`,
  `POWERPLATFORM_CLIENT_SECRET`, `POWERPLATFORM_TENANT_ID`.
- Definir `environment_url` DEV/STAGING exacto.
- Confirmar solution unique name.
- Ejecutar `power-platform-whoami.yml`.
- Ejecutar export/check/import solo con target no productivo.

## Que puede ejecutarse ya

- Validaciones locales de estructura, workflow y scripts.
- Workflows manuales si los GitHub Secrets y el ambiente DEV/STAGING existen.
- Scripts locales si existe variable de entorno `POWERPLATFORM_CLIENT_SECRET`
  y parametros de service principal.

## Que requiere secrets

- Todos los workflows Power Platform Actions.
- Scripts que autentican con service principal.

## Que requiere tenant

- `who-am-i`.
- Export/import/publish/check contra Dataverse.
- Cualquier mensaje Teams/Graph/Planner/SharePoint live.

## Que requiere ambiente DEV/STAGING

- Export de solucion.
- Solution checker con environment.
- Import/publish no productivo.

## Validacion local preliminar

| validador | resultado |
| --- | --- |
| PowerShell parser scripts | `PASS`, 5 scripts, 0 errores |
| Workflow policy ad hoc | `PASS`, 5 workflows con `workflow_dispatch`, `contents: read`, sin `secrets.`, sin write permissions |
| YAML parser | `PASS`, 5 workflows parseables |
| `git diff --check` | `PASS` con warning de CRLF esperado en `.gitignore` |
| Change-aware full coverage orchestrator | `PASS`, 19 tests requeridos, `coverage_equivalence=true`, `blocked_surfaces_clear=true`, 0 errores |

## Proximo paso exacto

1. Ejecutar validadores de cabina.
2. Stage explicito de archivos del paquete.
3. Commit local con mensaje:
   `feat(power-platform): provision Teams and Power Platform ALM governance`
4. Push de rama.
5. Abrir PR:
   `gh pr create --title "Power Platform / Teams ALM Governance Provisioning" --body-file <body>`

## Cierre

Estado: `LOCAL_VALIDATION_PASS_PENDING_GIT_PR`
Rollback: revertir commit/PR; no hubo Microsoft live write.
Stop condition: `tenant_exact_target_missing_for_live_execution`
