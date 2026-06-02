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
      $resolved = Resolve-CabinaPath -Path $token
      if (-not (Test-Path -LiteralPath $resolved)) {
        $Errors.Add("$Context references missing path: $token")
      }
      continue
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

function Check-TokenList {
  param(
    [string]$Value,
    [string[]]$Required,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  $tokens = @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  foreach ($required in $Required) {
    if ($required -notin $tokens) {
      $Errors.Add("$Context missing token: $required")
    }
  }
}

$matrixPath = Join-Path $Root "matrices\CODEX_CLOUD_GOVERNED_LANE_MATRIX.csv"
$discoveryPath = Join-Path $Root "matrices\CODEX_CLOUD_REPO_DISCOVERY_MATRIX_20260602.csv"
$environmentInventoryPath = Join-Path $Root "matrices\CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv"
$mapPath = Join-Path $Root "maps\CODEX_CLOUD_GOVERNED_LANE.md"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @(
  "lane_id",
  "repo_id",
  "repository_full_name",
  "environment_label",
  "environment_id",
  "environment_id_status",
  "branch_policy",
  "allowed_actions",
  "requires_order_for",
  "blocked_actions",
  "data_boundary",
  "lead_agent",
  "owner_agent",
  "reviewer_agent",
  "required_skill",
  "required_recipe",
  "required_tool",
  "evidence",
  "validator",
  "status",
  "stop_condition"
) -Errors $errors

Require-Columns -Path $discoveryPath -Columns @(
  "candidate_id",
  "repository_full_name",
  "default_branch",
  "local_status",
  "remote_status",
  "codex_cloud_evidence",
  "agentic_surface",
  "allowed_next_action",
  "blocked_surface",
  "owner_agent",
  "reviewer_agent",
  "validator",
  "status",
  "stop_condition"
) -Errors $errors

Require-Columns -Path $environmentInventoryPath -Columns @(
  "environment_name",
  "repository_full_name",
  "task_count_snapshot",
  "creator",
  "created_at",
  "source",
  "evidence",
  "status",
  "allowed_next_action",
  "blocked_surface",
  "owner_agent",
  "reviewer_agent",
  "validator",
  "stop_condition"
) -Errors $errors

$rows = Read-CsvRequired -Path $matrixPath
$discoveryRows = Read-CsvRequired -Path $discoveryPath
$environmentRows = Read-CsvRequired -Path $environmentInventoryPath
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })
$recipeIds = @((Read-CsvRequired -Path $recipeIndexPath) | ForEach-Object { $_.recipe_id })
$toolIds = @((Read-CsvRequired -Path $toolIndexPath) | ForEach-Object { $_.tool_id })

if (-not (Test-Path -LiteralPath $mapPath)) {
  $errors.Add("Missing Codex Cloud governed lane map: $mapPath")
} else {
  $mapText = Get-Content -Raw -LiteralPath $mapPath
  foreach ($phrase in @("Codex Cloud Governed Lane", "SeshatSgin/sgin-cloud", "universo-rey/cabina-universal-d", "No secrets", "codex cloud apply")) {
    if (-not $mapText.Contains($phrase)) {
      $errors.Add("Codex Cloud governed lane map missing required phrase: $phrase")
    }
  }
}

$requiredLanes = @(
  "codex_cloud.inventory_cli",
  "codex_cloud.sgin_cloud_remote_ci_smoke",
  "codex_cloud.cabina_root_smoke",
  "codex_cloud.diff_review_gate",
  "codex_cloud.apply_gate",
  "codex_cloud.pr_handoff",
  "codex_cloud.blocked_surfaces"
)

foreach ($requiredLane in $requiredLanes) {
  if ($requiredLane -notin @($rows | ForEach-Object { $_.lane_id })) {
    $errors.Add("Missing Codex Cloud lane: $requiredLane")
  }
}

$allowedStatuses = @(
  "ACTIVE_READONLY_INVENTORY",
  "ACTIVE_CLOUD_ENVIRONMENT_CONFIRMED",
  "ACTIVE_READONLY_SMOKE_PENDING",
  "ACTIVE_READONLY_SMOKE_READY",
  "READY_REMOTE_REPO_CLOUD_CANDIDATE",
  "BLOCKED_PENDING_CLOUD_ENVIRONMENT_REGISTRATION",
  "ACTIVE_REMOTE_REFERENCE",
  "HISTORICAL_ENV_RECHECK_REQUIRED",
  "BLOCKED_PENDING_ENVIRONMENT_ID",
  "ACTIVE_GOVERNED_GATE",
  "ACTIVE_GITHUB_HANDOFF",
  "ACTIVE_BLOCKING_RULE"
)

$seen = @{}
foreach ($row in $rows) {
  foreach ($field in @("lane_id","repo_id","repository_full_name","environment_label","environment_id","environment_id_status","branch_policy","allowed_actions","requires_order_for","blocked_actions","data_boundary","lead_agent","owner_agent","reviewer_agent","required_skill","required_recipe","required_tool","evidence","validator","status","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Codex Cloud lane '$($row.lane_id)' missing $field")
    }
  }
  if ($seen.ContainsKey($row.lane_id)) {
    $errors.Add("Duplicate Codex Cloud lane: $($row.lane_id)")
  } else {
    $seen[$row.lane_id] = $true
  }
  if ($row.status -notin $allowedStatuses) {
    $errors.Add("Codex Cloud lane '$($row.lane_id)' has invalid status: $($row.status)")
  }
  foreach ($agentField in @("lead_agent","owner_agent","reviewer_agent")) {
    if ($row.$agentField -notin $agentIds) {
      $errors.Add("Codex Cloud lane '$($row.lane_id)' references unknown $agentField`: $($row.$agentField)")
    }
  }
  foreach ($recipe in @($row.required_recipe -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($recipe -notin $recipeIds) {
      $errors.Add("Codex Cloud lane '$($row.lane_id)' references unknown recipe: $recipe")
    }
  }
  foreach ($tool in @($row.required_tool -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($tool -notin $toolIds) {
      $errors.Add("Codex Cloud lane '$($row.lane_id)' references unknown tool: $tool")
    }
  }
  foreach ($blocked in @("secrets", "microsoft_live", "production", "permission_change", "openai_api_live", "regulated_data_dump")) {
    if ($row.blocked_actions -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Codex Cloud lane '$($row.lane_id)' blocked_actions missing $blocked")
    }
  }
  foreach ($requires in @("codex_cloud_exec", "codex_cloud_apply", "openai_api_live", "microsoft_live", "production")) {
    if ($row.lane_id -notmatch "blocked_surfaces" -and $row.requires_order_for -notmatch [regex]::Escape($requires)) {
      $errors.Add("Codex Cloud lane '$($row.lane_id)' requires_order_for missing $requires")
    }
  }
  if ($row.lane_id -eq "codex_cloud.cabina_root_smoke" -and $row.environment_id_status -notin @("MISSING_ENVIRONMENT_ID", "CLI_LABEL_ACCEPTED_NO_ID_RETURNED")) {
    $errors.Add("Cabina root smoke lane must be missing id or CLI label accepted")
  }
  if ($row.lane_id -eq "codex_cloud.apply_gate") {
    Check-TokenList -Value $row.allowed_actions -Required @("git_status_clean_required","validators_required") -Errors $errors -Context "Codex Cloud apply gate allowed_actions"
    if ($row.branch_policy -ne "codex_branch_required") {
      $errors.Add("Codex Cloud apply gate must require codex branch")
    }
  }
  if ($row.lane_id -eq "codex_cloud.pr_handoff") {
    Check-TokenList -Value $row.requires_order_for -Required @("merge_without_approved_precheck","force_push") -Errors $errors -Context "Codex Cloud PR handoff requires_order_for"
  }
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Codex Cloud lane '$($row.lane_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Codex Cloud lane '$($row.lane_id)'"
}

$requiredEnvironments = @{
  "SeshatSgin/tcu-control-plane" = "SeshatSgin/tcu-control-plane"
  "Sgin" = "universo-rey/Sgin"
  "SGIN_Canonico_Puro" = "SeshatSgin/SGIN_Canonico_Puro"
  "universo-rey/cabina-universal-d" = "universo-rey/cabina-universal-d"
  "SeshatSgin/sgin-cloud" = "SeshatSgin/sgin-cloud"
}
foreach ($environmentName in $requiredEnvironments.Keys) {
  $environmentRow = @($environmentRows | Where-Object { $_.environment_name -eq $environmentName }) | Select-Object -First 1
  if (-not $environmentRow) {
    $errors.Add("Codex Cloud environment inventory missing environment: $environmentName")
    continue
  }
  if ($environmentRow.repository_full_name -ne $requiredEnvironments[$environmentName]) {
    $errors.Add("Codex Cloud environment '$environmentName' has wrong repository: $($environmentRow.repository_full_name)")
  }
  foreach ($blocked in @("secret_materialization", "microsoft_live", "production", "permission_change", "openai_api_live", "regulated_data_dump")) {
    if ($environmentRow.blocked_surface -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Codex Cloud environment '$environmentName' blocked_surface missing $blocked")
    }
  }
  Check-PathTokens -Value $environmentRow.validator -Errors $errors -Context "Codex Cloud environment '$environmentName' validator"
  Check-StopCondition -Value $environmentRow.stop_condition -KnownStops $knownStops -Errors $errors -Context "Codex Cloud environment '$environmentName'"
}

$sginCloudCandidate = @($discoveryRows | Where-Object { $_.candidate_id -eq "codex_cloud.repo.sgin_cloud" }) | Select-Object -First 1
if (-not $sginCloudCandidate) {
  $errors.Add("Codex Cloud discovery matrix missing sgin-cloud candidate")
} else {
  if ($sginCloudCandidate.repository_full_name -ne "SeshatSgin/sgin-cloud") {
    $errors.Add("sgin-cloud candidate must point to SeshatSgin/sgin-cloud")
  }
  foreach ($blocked in @("secret_materialization", "microsoft_live", "production", "permission_change", "openai_api_live", "regulated_data_dump")) {
    if ($sginCloudCandidate.blocked_surface -notmatch [regex]::Escape($blocked)) {
      $errors.Add("sgin-cloud candidate blocked_surface missing $blocked")
    }
  }
  Check-PathTokens -Value $sginCloudCandidate.validator -Errors $errors -Context "sgin-cloud candidate validator"
  Check-StopCondition -Value $sginCloudCandidate.stop_condition -KnownStops $knownStops -Errors $errors -Context "sgin-cloud candidate"
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  codex_cloud_lane_count = $rows.Count
  codex_cloud_discovery_count = $discoveryRows.Count
  codex_cloud_environment_count = $environmentRows.Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
