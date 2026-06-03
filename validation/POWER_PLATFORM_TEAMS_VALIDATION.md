# Power Platform Teams Validation

Estado: `POWER_PLATFORM_TEAMS_VALIDATION_READY_WITH_EXPLICIT_NONPROD_ALLOWLIST_GATE`
Fecha: 2026-06-03

## 1. Repo

| validacion | criterio | evidencia esperada |
| --- | --- | --- |
| estructura creada | governance, recipes, scripts, workflows, validation y readback existen | `git ls-files` |
| workflows validos | YAML parseable, `workflow_dispatch`, `permissions: contents: read` | parser YAML o GitHub Actions |
| scripts validos | PowerShell parseable | `System.Management.Automation.Language.Parser` |
| markdown links | si existe tooling, ejecutar link check; si no, revisar fuentes principales | reporte local |
| no duplicados | no reemplazar Dataverse DEV brownfield | discovery doc |

## 2. Secrets

| validacion | criterio |
| --- | --- |
| no secretos hardcodeados | no client secret, password, token o tenant productivo en texto |
| placeholders seguros | solo nombres de GitHub Secrets y variables de entorno |
| GitHub Secrets | workflows referencian `POWERPLATFORM_APP_ID`, `POWERPLATFORM_CLIENT_SECRET`, `POWERPLATFORM_TENANT_ID` |
| no impresion | scripts declaran que no imprimen el valor secreto |

## 3. Power Platform

| validacion | criterio |
| --- | --- |
| Dataverse con database | requisito previo documentado |
| service principal | `who-am-i` antes de export/import/check |
| connection references | requeridas para flows solution-aware |
| environment variables | requeridas para parametros por ambiente |
| flows dentro de Solution | requerido para ALM serio |
| PAC CLI | comandos locales equivalentes disponibles |

## 4. GitHub Actions

| validacion | criterio |
| --- | --- |
| workflow_dispatch | todos los workflows Power Platform son manuales |
| inputs obligatorios | environment URL y solution inputs requeridos |
| DEV/STAGING gates | import/publish requieren `environment_stage` DEV/STAGING, `confirm_non_production == true` y match exacto contra `POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS` tras normalizacion URL |
| produccion bloqueada | no hay workflow productivo en este paquete |
| import gated | `import_to_dev`, `confirm_non_production`, stage DEV/STAGING y allowlist explicita requeridos |
| publish gated | `publish_after_import`, `confirm_non_production`, stage DEV/STAGING y allowlist explicita requeridos |
| permissions | `contents: read` |

## 5. Teams

| validacion | criterio |
| --- | --- |
| no bloqueo humano | policy indica que Teams humano sigue operativo |
| separacion humano/bot/Graph | matriz y recipe lo declaran |
| cola programada | recipe define SharePoint/Dataverse queue |
| evidencia | SYS/SharePoint/Dataverse como evidencia |
| Graph gated | permisos `[POR DEFINIR]` hasta app real |

## 6. Seguridad

| validacion | criterio |
| --- | --- |
| no tenant hardcodeado | tenant llega por GitHub Secret o parametro |
| no usuario hardcodeado | service principal via input/secret |
| no password hardcodeado | secret externo o variable de entorno |
| no ambiente productivo por defecto | defaults apuntan a carpetas y DEV/STAGING generico |
| no delete/reset/restore | workflows y scripts no llaman delete, reset ni restore |
| no datos regulados amplios | docs y scripts solo metadata/solution artifacts |

## Comandos locales recomendados

```powershell
git diff --check

$files = @(
  ".github/workflows/power-platform-whoami.yml",
  ".github/workflows/power-platform-export-unpack.yml",
  ".github/workflows/power-platform-check-solution.yml",
  ".github/workflows/power-platform-pack-import-dev.yml",
  ".github/workflows/power-platform-alm-full-dev.yml"
)
foreach ($file in $files) {
  $text = Get-Content -LiteralPath $file -Raw
  if ($text -notmatch "workflow_dispatch") { throw "$file missing workflow_dispatch" }
  if ($text -notmatch "contents:\s*read") { throw "$file missing contents read" }
}

.\scripts\power-platform\validate-power-platform-alm-gates.ps1

Get-ChildItem scripts/power-platform/*.ps1 | ForEach-Object {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
  if ($errors.Count -gt 0) { throw "$($_.FullName) has parse errors" }
}
```

## Stop condition

`power_platform_teams_explicit_nonprod_allowlist_gate_failed`
