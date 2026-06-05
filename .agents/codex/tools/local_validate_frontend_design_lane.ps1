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
    if ($token -match '^https://') { continue }
    if ($token -match '^manual:') { continue }
    $resolved = Resolve-CabinaPath -Path $token
    if (Test-Path -LiteralPath $resolved) {
      continue
    }
    if ($token -match '^[A-Za-z]:[\\/]') {
      $Errors.Add("$Context references missing path: $token")
      continue
    }
    $Errors.Add("$Context has unsupported or missing locator token: $token")
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

$matrixPath = Join-Path $Root "matrices\FRONTEND_DESIGN_LANE_MATRIX.csv"
$mapPath = Join-Path $Root "maps\FRONTEND_DESIGN_LANE.md"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @(
  "lane_id",
  "source_locator",
  "ui_task_type",
  "design_standard",
  "applies_to",
  "required_skill",
  "required_recipe",
  "required_tool",
  "lead_agent",
  "owner_agent",
  "reviewer_agent",
  "asset_policy",
  "verification_required",
  "allowed_scope",
  "requires_order_for",
  "blocked_scope",
  "evidence",
  "validator",
  "stop_condition",
  "status"
) -Errors $errors

$rows = Read-CsvRequired -Path $matrixPath
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })
$recipeIds = @((Read-CsvRequired -Path $recipeIndexPath) | ForEach-Object { $_.recipe_id })
$toolIds = @((Read-CsvRequired -Path $toolIndexPath) | ForEach-Object { $_.tool_id })

if (-not (Test-Path -LiteralPath $mapPath)) {
  $errors.Add("Missing frontend design map: $mapPath")
} else {
  $mapText = Get-Content -Raw -LiteralPath $mapPath
  foreach ($phrase in @("Frontend Design Lane", "Verificacion", "Fronteras", "production_requested_without_explicit_authorization")) {
    if (-not $mapText.Contains($phrase)) {
      $errors.Add("Frontend design map missing required phrase: $phrase")
    }
  }
}

$requiredLanes = @(
  "frontend.intake_scope",
  "frontend.visual_assets",
  "frontend.responsive_fit",
  "frontend.interaction_states",
  "frontend.browser_screenshot_verification",
  "frontend.production_boundary"
)

foreach ($requiredLane in $requiredLanes) {
  if ($requiredLane -notin @($rows | ForEach-Object { $_.lane_id })) {
    $errors.Add("Missing frontend design lane: $requiredLane")
  }
}

$seen = @{}
foreach ($row in $rows) {
  foreach ($field in @("lane_id","source_locator","ui_task_type","design_standard","applies_to","required_skill","required_recipe","required_tool","lead_agent","owner_agent","reviewer_agent","asset_policy","verification_required","allowed_scope","requires_order_for","blocked_scope","evidence","validator","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Frontend design lane '$($row.lane_id)' missing $field")
    }
  }
  if ($seen.ContainsKey($row.lane_id)) {
    $errors.Add("Duplicate frontend design lane: $($row.lane_id)")
  } else {
    $seen[$row.lane_id] = $true
  }
  foreach ($agentField in @("lead_agent","owner_agent","reviewer_agent")) {
    if ($row.$agentField -notin $agentIds) {
      $errors.Add("Frontend design lane '$($row.lane_id)' references unknown $agentField`: $($row.$agentField)")
    }
  }
  foreach ($recipe in @($row.required_recipe -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($recipe -notin $recipeIds) {
      $errors.Add("Frontend design lane '$($row.lane_id)' references unknown recipe: $recipe")
    }
  }
  foreach ($tool in @($row.required_tool -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($tool -notin $toolIds) {
      $errors.Add("Frontend design lane '$($row.lane_id)' references unknown tool: $tool")
    }
  }
  foreach ($requiredOrder in @("production", "microsoft_live", "openai_api_live", "permission_change")) {
    if ($row.requires_order_for -notmatch [regex]::Escape($requiredOrder)) {
      $errors.Add("Frontend design lane '$($row.lane_id)' requires_order_for missing $requiredOrder")
    }
  }
  foreach ($blocked in @("production", "microsoft_live", "openai_api_live", "permission_change", "secrets")) {
    if ($row.blocked_scope -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Frontend design lane '$($row.lane_id)' blocked_scope missing $blocked")
    }
  }
  if ($row.lane_id -eq "frontend.browser_screenshot_verification" -and $row.verification_required -notmatch "screenshot") {
    $errors.Add("Browser verification lane must require screenshot evidence")
  }
  if ($row.lane_id -eq "frontend.responsive_fit" -and $row.verification_required -notmatch "no_overlap") {
    $errors.Add("Responsive fit lane must require no_overlap evidence")
  }
  if ($row.status -ne "ACTIVE_LOCAL_ONLY") {
    $errors.Add("Frontend design lane '$($row.lane_id)' must remain ACTIVE_LOCAL_ONLY")
  }
  Check-PathTokens -Value $row.source_locator -Errors $errors -Context "Frontend design lane '$($row.lane_id)' source_locator"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Frontend design lane '$($row.lane_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Frontend design lane '$($row.lane_id)'"
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  frontend_lane_count = $rows.Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
