param(
  [string]$Root = ".agents\codex",
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d"
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
  if ($normalized.StartsWith(".agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $Root ($normalized.Substring(".agents\codex".Length).TrimStart("\"))
  }
  if ($normalized.StartsWith("C:\Users\enzo1\Documents\GitHub\cabina-universal-d", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $RepoRoot ($normalized.Substring("C:\Users\enzo1\Documents\GitHub\cabina-universal-d".Length).TrimStart("\"))
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
    if ($token -match '^[A-Za-z]:[\\/]') {
      $resolved = Resolve-CabinaPath -Path $token
      if (-not (Test-Path -LiteralPath $resolved)) {
        $Errors.Add("$Context references missing path: $token")
      }
    }
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

$matrixPath = Join-Path $Root "matrices\DOCUMENT_SKILL_LANE_MATRIX.csv"
$skillUsagePath = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @(
  "lane_id",
  "document_type",
  "extensions",
  "skill_id",
  "skill_source",
  "intake_agent",
  "owner_agent",
  "reviewer_agent",
  "allowed_scope",
  "requires_order_for",
  "blocked_scope",
  "template_storage",
  "evidence_storage",
  "redline_storage",
  "sanitized_output_storage",
  "required_recipe",
  "required_tool",
  "validator",
  "evidence",
  "stop_condition",
  "status"
) -Errors $errors

$rows = Read-CsvRequired -Path $matrixPath
$skillIds = @((Read-CsvRequired -Path $skillUsagePath) | ForEach-Object { $_.skill_id })
$recipeIds = @((Read-CsvRequired -Path $recipeIndexPath) | ForEach-Object { $_.recipe_id })
$toolIds = @((Read-CsvRequired -Path $toolIndexPath) | ForEach-Object { $_.tool_id })
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })

$requiredLanes = @("document.docx", "document.spreadsheet", "document.presentation", "document.pdf")
foreach ($requiredLane in $requiredLanes) {
  if ($requiredLane -notin @($rows | ForEach-Object { $_.lane_id })) {
    $errors.Add("Missing document skill lane: $requiredLane")
  }
}

foreach ($row in $rows) {
  foreach ($field in @("lane_id","document_type","extensions","skill_id","intake_agent","owner_agent","reviewer_agent","allowed_scope","requires_order_for","blocked_scope","required_recipe","required_tool","validator","evidence","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Document lane '$($row.lane_id)' missing $field")
    }
  }
  if ($row.skill_id -notin $skillIds) {
    $errors.Add("Document lane '$($row.lane_id)' references unknown skill: $($row.skill_id)")
  }
  foreach ($agentField in @("intake_agent","owner_agent","reviewer_agent")) {
    if ($row.$agentField -notin $agentIds) {
      $errors.Add("Document lane '$($row.lane_id)' references unknown $agentField`: $($row.$agentField)")
    }
  }
  foreach ($recipe in @($row.required_recipe -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($recipe -notin $recipeIds) {
      $errors.Add("Document lane '$($row.lane_id)' references unknown recipe: $recipe")
    }
  }
  foreach ($tool in @($row.required_tool -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($tool -notin $toolIds) {
      $errors.Add("Document lane '$($row.lane_id)' references unknown tool: $tool")
    }
  }
  foreach ($requiredToken in @("broad_regulated_read", "secret_bearing")) {
    if ($row.requires_order_for -notmatch [regex]::Escape($requiredToken)) {
      $errors.Add("Document lane '$($row.lane_id)' requires_order_for missing $requiredToken")
    }
  }
  foreach ($blocked in @("secret", "regulated_data_dump", "microsoft_live", "production")) {
    if ($row.blocked_scope -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Document lane '$($row.lane_id)' blocked_scope missing $blocked")
    }
  }
  Check-PathTokens -Value $row.template_storage -Errors $errors -Context "Document lane '$($row.lane_id)' template_storage"
  Check-PathTokens -Value $row.evidence_storage -Errors $errors -Context "Document lane '$($row.lane_id)' evidence_storage"
  Check-PathTokens -Value $row.redline_storage -Errors $errors -Context "Document lane '$($row.lane_id)' redline_storage"
  Check-PathTokens -Value $row.sanitized_output_storage -Errors $errors -Context "Document lane '$($row.lane_id)' sanitized_output_storage"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Document lane '$($row.lane_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Document lane '$($row.lane_id)'"
  if ($row.status -ne "ACTIVE_LOCAL_ONLY") {
    $errors.Add("Document lane '$($row.lane_id)' must remain ACTIVE_LOCAL_ONLY")
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  document_lane_count = $rows.Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
