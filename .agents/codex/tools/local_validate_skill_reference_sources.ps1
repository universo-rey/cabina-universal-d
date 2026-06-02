param(
  [string]$Root = "D:\.agents\codex",
  [string]$RepoRoot = "D:\"
)

$ErrorActionPreference = "Stop"

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required CSV: $Path"
  }
  @(Import-Csv -LiteralPath $Path)
}

function Resolve-CabinaPath {
  param([string]$Path)
  if ([string]::IsNullOrWhiteSpace($Path)) { return $Path }
  $normalized = $Path -replace "/", "\"
  if ($normalized.StartsWith("D:\.agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $Root ($normalized.Substring("D:\.agents\codex".Length).TrimStart("\"))
  }
  if ($normalized.StartsWith("D:\", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $RepoRoot ($normalized.Substring("D:\".Length).TrimStart("\"))
  }
  return Join-Path $RepoRoot $normalized
}

function Require-Columns {
  param(
    [string]$Path,
    [string[]]$Columns,
    [System.Collections.Generic.List[string]]$Errors
  )
  $rows = Read-CsvRequired -Path $Path
  $actual = @()
  if ($rows.Count -gt 0) {
    $actual = @($rows[0].PSObject.Properties.Name)
  } else {
    $header = Get-Content -LiteralPath $Path -TotalCount 1
    if ($header) { $actual = @($header -split ",") }
  }
  foreach ($column in $Columns) {
    if ($column -notin $actual) {
      $Errors.Add("Missing column '$column' in $Path")
    }
  }
}

function Check-PathTokens {
  param(
    [string]$Value,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($token in @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($token -match '^https://') { continue }
    if ($token -match '^manual:') { continue }
    if ($token -match '^plugin:') { continue }
    if ($token -match '^[A-Za-z]:[\\/]') {
      if (-not $token.StartsWith("D:", [System.StringComparison]::OrdinalIgnoreCase)) {
        continue
      }
      $resolved = Resolve-CabinaPath -Path $token
      if (-not (Test-Path -LiteralPath $resolved)) {
        $Errors.Add("$Context references missing path: $token")
      }
      continue
    }
    $Errors.Add("$Context has unsupported locator token: $token")
  }
}

function Check-StopCondition {
  param(
    [string]$Value,
    [string[]]$KnownStops,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($token in @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($token -notin $KnownStops) {
      $Errors.Add("$Context references unknown stop_condition: $token")
    }
  }
}

$matrixPath = Join-Path $Root "matrices\SKILL_REFERENCE_SOURCE_MATRIX.csv"
$policyPath = Join-Path $Root "skills\SKILL_REFERENCE_LIBRARY_POLICY.md"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @(
  "source_id",
  "source_locator",
  "source_type",
  "authority_class",
  "retrieval_date",
  "storage_policy",
  "scope",
  "license_note",
  "freshness_risk",
  "review_cadence",
  "owner_agent",
  "reviewer_agent",
  "skill_or_recipe_target",
  "allowed_use",
  "blocked_use",
  "validator",
  "evidence",
  "stop_condition",
  "status"
) -Errors $errors

$rows = Read-CsvRequired -Path $matrixPath
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })

if (-not (Test-Path -LiteralPath $policyPath)) {
  $errors.Add("Missing policy document: $policyPath")
} else {
  $policyText = Get-Content -Raw -LiteralPath $policyPath
  foreach ($phrase in @("D:\AGENTS.md", "technical reference", "not authority canon", "freshness")) {
    if (-not $policyText.Contains($phrase)) {
      $errors.Add("Policy missing required phrase: $phrase")
    }
  }
}

$requiredSources = @(
  "webreactiva_skill_reference_library_20260601",
  "d_drive_repo_local_skill_root_20260601",
  "d_drive_codex_skill_catalog_20260601",
  "codex_runtime_skill_roots_20260601",
  "vendor_api_docs_selected_per_task"
)

$seen = @{}
foreach ($requiredSource in $requiredSources) {
  if ($requiredSource -notin @($rows | ForEach-Object { $_.source_id })) {
    $errors.Add("Missing required source row: $requiredSource")
  }
}

foreach ($row in $rows) {
  foreach ($field in @("source_id","source_locator","source_type","authority_class","retrieval_date","storage_policy","scope","license_note","freshness_risk","review_cadence","owner_agent","reviewer_agent","skill_or_recipe_target","allowed_use","blocked_use","validator","evidence","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Skill reference source '$($row.source_id)' missing $field")
    }
  }
  if ($seen.ContainsKey($row.source_id)) {
    $errors.Add("Duplicate source_id: $($row.source_id)")
  } else {
    $seen[$row.source_id] = $true
  }
  foreach ($agentField in @("owner_agent","reviewer_agent")) {
    if ($row.$agentField -notin $agentIds) {
      $errors.Add("Skill reference source '$($row.source_id)' references unknown $agentField`: $($row.$agentField)")
    }
  }
  if ($row.authority_class -match "canon") {
    $errors.Add("Skill reference source '$($row.source_id)' must not be authority canon")
  }
  if ($row.allowed_use -notmatch "technical_reference|skill_storage|source_registry|availability_hint|current_api_lookup") {
    $errors.Add("Skill reference source '$($row.source_id)' lacks an allowed technical use")
  }
  foreach ($blocked in @("treat_as_canon", "secret", "microsoft_live", "openai_api_live", "production", "permission_change")) {
    if ($row.blocked_use -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Skill reference source '$($row.source_id)' blocked_use missing $blocked")
    }
  }
  if ($row.retrieval_date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    $errors.Add("Skill reference source '$($row.source_id)' retrieval_date must be YYYY-MM-DD")
  }
  if ($row.status -notin @("ACTIVE_REFERENCE_POLICY", "ACTIVE_LOCAL_ROOT", "ACTIVE_LOCAL_CATALOG", "ACTIVE_RUNTIME_REFERENCE", "REVIEW_REQUIRED_BEFORE_USE")) {
    $errors.Add("Skill reference source '$($row.source_id)' has invalid status: $($row.status)")
  }
  Check-PathTokens -Value $row.source_locator -Errors $errors -Context "Skill reference source '$($row.source_id)' source_locator"
  Check-PathTokens -Value $row.storage_policy -Errors $errors -Context "Skill reference source '$($row.source_id)' storage_policy"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Skill reference source '$($row.source_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Skill reference source '$($row.source_id)'"
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  source_count = $rows.Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
