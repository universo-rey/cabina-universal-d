param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'precheck_dataverse_environment.ps1') -Root $Root -RequireDevReady:$Apply | Out-Host

$seedFiles = @(
  'dataverse/data/seed_matrices.csv',
  'dataverse/data/seed_capabilities.csv',
  'dataverse/data/seed_validation_gates.csv',
  'dataverse/data/seed_environments.csv'
)
foreach ($file in $seedFiles) {
  if (-not (Test-Path -LiteralPath (Join-Path $Root $file))) { throw "SEED_FILE_MISSING $file" }
}

if (-not $Apply) {
  Write-Host 'DRY_RUN_IMPORT_SEED_DATA_DEV_READY'
  exit 0
}

Write-Host 'IMPORT_SEED_DATA_DEV_BLOCKED_BY_IMPLEMENTATION_GAP'
Write-Host 'Use Dataverse data import or Web API loader after table creation postcheck.'
exit 30
