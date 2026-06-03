param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
)

$ErrorActionPreference = 'Stop'
$errors = New-Object System.Collections.Generic.List[string]

function Require-File {
  param([string]$RelativePath)
  $path = Join-Path $Root $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    $errors.Add("Missing required file: $RelativePath")
  }
}

function Check-NoBlockedText {
  param([string]$RelativePath)
  $path = Join-Path $Root $RelativePath
  if (-not (Test-Path -LiteralPath $path)) { return }
  $content = Get-Content -LiteralPath $path -Raw
  if ($content -match '(?i)clientSecret|password\s*[:=]|token\s*[:=]|connectionString\s*[:=]') {
    $errors.Add("Potential secret-bearing key in $RelativePath")
  }
  if ($RelativePath -match 'deployment-settings\.dev\.json' -and $content -match '(?i)\bprod\b|production|default') {
    $errors.Add("DEV deployment settings contain PROD/default marker")
  }
}

$schemaFiles = @(
  'dataverse/schema/sdu_matrix.yml',
  'dataverse/schema/sdu_matrix_version.yml',
  'dataverse/schema/sdu_capability.yml',
  'dataverse/schema/sdu_capability_mapping.yml',
  'dataverse/schema/sdu_recipe.yml',
  'dataverse/schema/sdu_skill.yml',
  'dataverse/schema/sdu_agent.yml',
  'dataverse/schema/sdu_tool.yml',
  'dataverse/schema/sdu_propagation_rule.yml',
  'dataverse/schema/sdu_reconciliation_item.yml',
  'dataverse/schema/sdu_validation_gate.yml',
  'dataverse/schema/sdu_evidence.yml',
  'dataverse/schema/sdu_environment.yml',
  'dataverse/schema/sdu_apply_log.yml',
  'dataverse/schema/sdu_readback.yml'
)

$required = @(
  'powerplatform/solution/solution.manifest.yml',
  'powerplatform/settings/deployment-settings.dev.json',
  'powerplatform/settings/deployment-settings.test.template.json',
  'powerplatform/settings/deployment-settings.prod.template.json',
  'matrices/dataverse/MATRIX_INVENTORY.csv',
  'matrices/dataverse/MATRIX_MIGRABILITY_ASSESSMENT.csv',
  'matrices/dataverse/MATRIX_DUPLICATES_AND_OVERLAPS.csv',
  'matrices/dataverse/SOURCE_OF_TRUTH_MATRIX.csv',
  'matrices/dataverse/DATAVERSE_DRIFT_DETECTION_MATRIX.csv',
  'dataverse/data/seed_matrices.csv',
  'dataverse/data/seed_capabilities.csv',
  'dataverse/data/seed_validation_gates.csv',
  'dataverse/data/seed_environments.csv'
) + $schemaFiles

foreach ($file in $required) { Require-File $file; Check-NoBlockedText $file }

foreach ($schema in $schemaFiles) {
  $text = Get-Content -LiteralPath (Join-Path $Root $schema) -Raw
  foreach ($needle in @('logical_name:', 'change_tracking: true', 'auditing: true', 'policy:')) {
    if ($text -notmatch [regex]::Escape($needle)) {
      $errors.Add("$schema missing $needle")
    }
  }
}

foreach ($csv in @(
  'matrices/dataverse/MATRIX_INVENTORY.csv',
  'matrices/dataverse/MATRIX_MIGRABILITY_ASSESSMENT.csv',
  'matrices/dataverse/MATRIX_DUPLICATES_AND_OVERLAPS.csv',
  'matrices/dataverse/SOURCE_OF_TRUTH_MATRIX.csv',
  'dataverse/data/seed_matrices.csv',
  'dataverse/data/seed_capabilities.csv',
  'dataverse/data/seed_validation_gates.csv',
  'dataverse/data/seed_environments.csv'
)) {
  try {
    $rows = Import-Csv -LiteralPath (Join-Path $Root $csv)
    if (@($rows).Count -lt 1) { $errors.Add("$csv has no rows") }
  } catch {
    $errors.Add("$csv cannot be parsed: $($_.Exception.Message)")
  }
}

$result = [pscustomobject]@{
  manifest_valid = $errors.Count -eq 0
  checked_at = '2026-06-03'
  errors = $errors
}
$outPath = Join-Path $Root 'dataverse/validation/dataverse_manifest_validation_latest.json'
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $outPath -Encoding UTF8

if ($errors.Count -gt 0) {
  $errors | ForEach-Object { Write-Error $_ }
  exit 10
}

Write-Host 'DATAVERSE_MANIFEST_VALID'
