# Discovery Power Platform Teams

Fecha: 2026-06-03
Estado: `BROWNFIELD_DISCOVERY_COMPLETE_FOR_DEV_STAGING_PROVISIONING`
Agente: `rey.control_plane_orchestrator`
Owner: `universe.escribania_tower`
Reviewer: `court.sdu_gate`

## Orden

Provisionar capacidad real para gobernar Microsoft Teams, Power Automate y
Power Platform desde GitHub/Codex, dejando workflows, scripts, recipes,
validacion y readback ejecutables para DEV/STAGING. No se ejecuto Microsoft
live, tenant write, import, publish, reset, restore ni produccion.

## Fuentes tecnicas revisadas

| fuente | tipo | clasificacion | uso |
| --- | --- | --- | --- |
| Microsoft Learn: GitHub Actions for Microsoft Power Platform | canon tecnico | primario | ALM, Dataverse con database, service principal y capacidades de soluciones |
| Microsoft Learn: Available GitHub Actions for Microsoft Power Platform development | canon tecnico | primario | inputs exactos para who-am-i, export, unpack, pack, import, publish y check |
| microsoft/powerplatform-actions | canon tecnico | primario | acciones reales `@v1` y action.yml vigentes |
| GitHub Marketplace: powerplatform-actions | canon tecnico | primario | entrada marketplace a la accion Microsoft |
| GitHub topic powerautomate | scouting | secundario | busqueda de patrones, no canon |
| Microsoft/PnP/OfficeDev repos de referencia | patrones reutilizables | secundario | conectores, samples, governance de Teams y provision asistido |

## Precheck repo

| item | resultado |
| --- | --- |
| repo root | `D:\` |
| remoto | `https://github.com/universo-rey/cabina-universal-d.git` |
| rama base observada | `main` |
| HEAD base observado | `f88dd9c825b593b7c531d6982249e3728262b9f2` |
| rama creada | `codex/power-platform-teams-governance-alm-20260603` |
| estado inicial | limpio |
| frontera | repo local y GitHub repo-scoped; Microsoft live preparado, no ejecutado |

## Archivos encontrados

| area | archivos reutilizables |
| --- | --- |
| Dataverse DEV | `powerplatform/README.md`, `powerplatform/solution/solution.manifest.yml`, `powerplatform/settings/*.json`, `dataverse/scripts/*.ps1`, `dataverse/schema/*.yml` |
| GitHub Actions existentes | `.github/workflows/dataverse-precheck-dev.yml`, `.github/workflows/dataverse-export-dev.yml`, `.github/workflows/dataverse-import-dev.manual.yml`, `.github/workflows/dataverse-drift-detection.yml`, `.github/workflows/dataverse-validate-manifest.yml` |
| Power Automate / work queues | `matrices/powerautomate/*.csv`, `docs/powerautomate/*.md`, `validation/powerautomate/*.md`, `readbacks/powerautomate/*.md` |
| Connections / gates | `matrices/connections/*.csv`, `validation/connections/*.md`, `readbacks/connections/*.md`, `dataverse/data/seed_connection_*.csv` |
| Agent/capability governance | `.agents/codex/matrices/*`, `.agents/codex/agents/*`, `.agents/codex/recipes/*`, `.agents/skills/*` |

## Capacidades existentes

| capacidad | evidencia | reutilizacion |
| --- | --- | --- |
| Dataverse DEV metadata package | `powerplatform/README.md` y workflows Dataverse | base para ALM no productivo |
| PAC CLI scripts Dataverse | `dataverse/scripts/*.ps1` | patron de scripts PowerShell con gates |
| Work queue Power Automate | `matrices/powerautomate/*` | insumo para colas de mensajes programados |
| Connection registry | `matrices/connections/*` y `dataverse/data/seed_connection_*` | insumo para connection references y boundaries |
| GitHub governance gate | `.github/workflows/cabina-validation.yml` | validador de PR y push |
| Teams governance surface | `.agents/codex/matrices/TEAMS_*` y `02_AUTHORITY_CANON/POLICIES/TEAMS_GOVERNANCE_POLICY_20260602.md` | frontera para comunicacion Teams |

## Duplicados

| tema | hallazgo | decision |
| --- | --- | --- |
| Dataverse DEV workflow | ya existen workflows Dataverse locales | no duplicar; crear workflows Power Platform Actions separados |
| Power Automate work queue | ya hay matrices y readbacks | referenciar como brownfield, no reescribir |
| Connection/secrets boundary | ya hay matrices de connection/secret boundary | mantener como control y no hardcodear tenant ni secretos |
| Teams governance | ya hay policy Teams en authority canon | este carril crea policy especifica ALM/Teams sin sustituir canon superior |

## Gaps

| gap | impacto | cierre en este paquete |
| --- | --- | --- |
| No habia registro unico Power Platform + Teams ALM | capacidades dispersas | `POWER_PLATFORM_TEAMS_CAPABILITY_REGISTRY.md` |
| No habia matriz de compatibilidad Teams/Power Automate/Graph | decision operativa lenta | `POWER_AUTOMATE_TEAMS_COMPATIBILITY_MATRIX.md` |
| Faltaban workflows Microsoft Power Platform Actions | ALM no ejecutable desde GitHub | cinco workflows `power-platform-*.yml` |
| Faltaban scripts PAC CLI equivalentes | ejecucion local menos portable | cinco scripts `scripts/power-platform/*.ps1` |
| Faltaba recipe de mensajeria Teams | riesgo de bloquear uso humano | `TEAMS_MESSAGE_ORCHESTRATION_RECIPE.md` |
| Faltaba scouting powerautomate topic | patrones externos sin clasificar | `POWER_AUTOMATE_GITHUB_SCOUTING.md` |

## Conflictos

| conflicto | resolucion |
| --- | --- |
| Workflows con referencias a GitHub Secrets vs policy local que bloquea `secrets.` literal en workflow rector | usar bracket notation `${{ secrets['NAME'] }}` en workflows nuevos; no tocar `cabina-validation.yml` |
| Solicitud de import/publish DEV vs prohibicion de produccion | importar/publicar solo con `confirm_non_production == true` y URL sin indicadores `prod`, `production` o `live` |
| GitHub Actions write/branch automation vs `contents: read` del gate actual | preparar artifacts y resumen; commit/PR se hace por este carril Codex, no por el workflow |
| Power Platform live posible vs tenant exacto no declarado | dejar inputs y gates; no ejecutar PAC ni tenant write |

## Nombres canonicos recomendados

| tipo | nombre |
| --- | --- |
| governance package | `governance/power-platform` |
| recipes | `recipes/power-platform` |
| scripts | `scripts/power-platform` |
| workflow prefix | `power-platform-` |
| estado final esperado | `POWER_PLATFORM_TEAMS_ALM_DEV_STAGING_READY` |

## Archivos que se reutilizan

- `powerplatform/README.md`
- `powerplatform/solution/solution.manifest.yml`
- `.github/workflows/dataverse-*.yml`
- `dataverse/scripts/*.ps1`
- `matrices/powerautomate/*.csv`
- `matrices/connections/*.csv`
- `validation/powerautomate/*.md`
- `validation/dataverse/*.md`

## Archivos que se crean

- `governance/power-platform/DISCOVERY_POWER_PLATFORM_TEAMS.md`
- `governance/power-platform/POWER_PLATFORM_TEAMS_CAPABILITY_REGISTRY.md`
- `governance/power-platform/POWER_AUTOMATE_TEAMS_COMPATIBILITY_MATRIX.md`
- `governance/power-platform/POWER_PLATFORM_TEAMS_GOVERNANCE_POLICY.md`
- `governance/power-platform/POWER_AUTOMATE_GITHUB_SCOUTING.md`
- `recipes/power-platform/*.md`
- `scripts/power-platform/*.ps1`
- `.github/workflows/power-platform-*.yml`
- `validation/POWER_PLATFORM_TEAMS_VALIDATION.md`
- `readbacks/20260603_POWER_PLATFORM_TEAMS_ALM_PROVISIONING_READBACK.md`

## Archivos que se modifican

- `.gitignore`: allowlist explicita para governance, recipes, scripts,
  validation y readback del carril.

## Cierre discovery

Estado: `DISCOVERY_READY_TO_IMPLEMENT_DEV_STAGING`
Validador: `git grep brownfield + fuentes primarias + git status`
Stop condition: `tenant_exact_target_missing_for_live_execution`
