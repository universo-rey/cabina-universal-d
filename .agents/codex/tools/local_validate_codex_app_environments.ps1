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

function Split-Tokens {
  param([string]$Value)
  @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function Check-PathTokens {
  param(
    [string]$Value,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($item in (Split-Tokens -Value $Value)) {
    if ($item -match '^[A-Za-z]:[\\/]') {
      $resolved = Resolve-CabinaPath -Path $item
      if (-not (Test-Path -LiteralPath $resolved)) {
        $Errors.Add("$Context references missing path: $item")
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
  foreach ($token in (Split-Tokens -Value $Value)) {
    if ($token -notin $KnownStops) {
      $Errors.Add("$Context references unknown stop_condition: $token")
    }
  }
}

$localMatrixPath = Join-Path $Root "matrices\CODEX_APP_LOCAL_ENVIRONMENT_MATRIX_20260602.csv"
$queuePath = Join-Path $Root "matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv"
$githubMatrixPath = Join-Path $RepoRoot "01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv"
$cloudInventoryPath = Join-Path $Root "matrices\CODEX_CLOUD_ENVIRONMENT_INVENTORY_20260602.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$mandatorySkillPath = Join-Path $RepoRoot ".agents\skills\tcu-descubridor-capacidades\SKILL.md"
$rootEnvironmentPath = Join-Path $RepoRoot ".codex\environments\environment.toml"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$isGitHubActions = $env:GITHUB_ACTIONS -eq "true"
$resolvedRepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path.TrimEnd("\")
$isAuxiliaryWrapperCheckout = -not $resolvedRepoRoot.Equals("D:", [System.StringComparison]::OrdinalIgnoreCase)

Require-Columns -Path $localMatrixPath -Columns @(
  "environment_id",
  "project_root",
  "codex_environment_path",
  "environment_name",
  "environment_kind",
  "setup_platforms",
  "actions",
  "owner_agent",
  "reviewer_agent",
  "required_skill",
  "required_recipe",
  "required_tool",
  "allowed_actions",
  "blocked_actions",
  "evidence",
  "validator",
  "status",
  "stop_condition"
) -Errors $errors

Require-Columns -Path $queuePath -Columns @(
  "environment_queue_id",
  "repo_id",
  "repository_full_name",
  "local_path",
  "codex_app_scope",
  "codex_app_environment_path",
  "codex_app_status",
  "codex_cloud_environment_label",
  "codex_cloud_status",
  "creation_tool_status",
  "owner_agent",
  "reviewer_agent",
  "required_skill",
  "required_recipe",
  "required_tool",
  "evidence",
  "validator",
  "blocked_actions",
  "rollback",
  "stop_condition"
) -Errors $errors

$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$registeredRepos = Read-CsvRequired -Path $githubMatrixPath
$queueRows = Read-CsvRequired -Path $queuePath
$localRows = Read-CsvRequired -Path $localMatrixPath
$cloudRows = Read-CsvRequired -Path $cloudInventoryPath

if (-not (Test-Path -LiteralPath $mandatorySkillPath)) {
  $errors.Add("Mandatory skill missing: $mandatorySkillPath")
}

if (-not (Test-Path -LiteralPath $rootEnvironmentPath)) {
  $errors.Add("Root Codex local environment missing: $rootEnvironmentPath")
} else {
  $envText = Get-Content -Raw -LiteralPath $rootEnvironmentPath
  foreach ($phrase in @(
    'version = 1',
    'name = "cabina-universal-d"',
    '[setup.win32]',
    'local_validate_codex_app_environments.ps1',
    'local_validate_codex_cloud_governed_lane.ps1',
    'local_run_repo_alignment_runtime.ps1',
    'git diff --check'
  )) {
    if ($envText -notmatch [regex]::Escape($phrase)) {
      $errors.Add("Root Codex local environment missing required phrase: $phrase")
    }
  }
  $privateKeyMarker = "BEGIN PRIVATE" + " KEY"
  foreach ($forbidden in @("OPENAI_API_KEY", "client_secret", "password", $privateKeyMarker, "Bearer ")) {
    if ($envText -match [regex]::Escape($forbidden)) {
      $errors.Add("Root Codex local environment contains forbidden token: $forbidden")
    }
  }
}

foreach ($row in $localRows) {
  foreach ($field in @("environment_id","project_root","codex_environment_path","environment_name","environment_kind","setup_platforms","actions","owner_agent","reviewer_agent","required_skill","required_recipe","required_tool","allowed_actions","blocked_actions","evidence","validator","status","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Local Codex environment row '$($row.environment_id)' missing $field")
    }
  }
  if ($row.owner_agent -eq $row.reviewer_agent) {
    $errors.Add("Local Codex environment row '$($row.environment_id)' owner and reviewer must differ")
  }
  if ($row.status -ne "ACTIVE_CODEX_APP_LOCAL_ENV_CREATED") {
    $errors.Add("Local Codex environment row '$($row.environment_id)' has invalid status: $($row.status)")
  }
  foreach ($blocked in @("secrets","microsoft_live","openai_api_live","production","permission_change","tenant_write","dependency_install_without_order","nested_repo_absorption")) {
    if ($row.blocked_actions -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Local Codex environment row '$($row.environment_id)' blocked_actions missing $blocked")
    }
  }
  Check-PathTokens -Value $row.codex_environment_path -Errors $errors -Context "Local Codex environment '$($row.environment_id)' path"
  Check-PathTokens -Value $row.evidence -Errors $warnings -Context "Local Codex environment '$($row.environment_id)' evidence"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Local Codex environment '$($row.environment_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Local Codex environment '$($row.environment_id)'"
}

$queueIds = New-Object System.Collections.Generic.HashSet[string]
$allowedAppStatus = @(
  "CODEX_APP_LOCAL_ENV_CREATED",
  "REPO_NATIVE_CODEX_APP_ENV_REQUIRED",
  "CODEX_APP_ENV_NOT_APPLICABLE_CLOUD_REFERENCE"
)
$allowedCloudStatus = @(
  "CODEX_CLOUD_ENV_VISIBLE",
  "CODEX_CLOUD_ENV_VISIBLE_OUT_OF_BASE",
  "NEEDS_CODEX_CLOUD_UI_CREATE"
)
$visibleCloudNames = @($cloudRows | ForEach-Object { $_.environment_name })

foreach ($repo in $registeredRepos) {
  if ($repo.repo_id -notin @($queueRows | ForEach-Object { $_.repo_id })) {
    $errors.Add("Codex environment queue missing registered repo: $($repo.repo_id)")
  }
}

foreach ($row in $queueRows) {
  foreach ($field in @("environment_queue_id","repo_id","repository_full_name","local_path","codex_app_scope","codex_app_environment_path","codex_app_status","codex_cloud_environment_label","codex_cloud_status","creation_tool_status","owner_agent","reviewer_agent","required_skill","required_recipe","required_tool","evidence","validator","blocked_actions","rollback","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Codex environment queue row '$($row.environment_queue_id)' missing $field")
    }
  }
  if (-not $queueIds.Add($row.environment_queue_id)) {
    $errors.Add("Duplicate Codex environment queue id: $($row.environment_queue_id)")
  }
  if ($row.owner_agent -eq $row.reviewer_agent) {
    $errors.Add("Codex environment queue row '$($row.environment_queue_id)' owner and reviewer must differ")
  }
  if ($row.codex_app_status -notin $allowedAppStatus) {
    $errors.Add("Codex environment queue row '$($row.environment_queue_id)' has invalid codex_app_status: $($row.codex_app_status)")
  }
  if ($row.codex_cloud_status -notin $allowedCloudStatus) {
    $errors.Add("Codex environment queue row '$($row.environment_queue_id)' has invalid codex_cloud_status: $($row.codex_cloud_status)")
  }
  foreach ($blocked in @("secrets","microsoft_live","openai_api_live","production","permission_change","tenant_write","codex_cloud_apply_without_review")) {
    if ($row.blocked_actions -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Codex environment queue row '$($row.environment_queue_id)' blocked_actions missing $blocked")
    }
  }
  if ($row.codex_cloud_status -eq "NEEDS_CODEX_CLOUD_UI_CREATE" -and $row.creation_tool_status -ne "NO_DISPONIBLE_CLI_CREATE_ENV") {
    $errors.Add("Codex environment queue row '$($row.environment_queue_id)' must mark missing create tool as NO_DISPONIBLE_CLI_CREATE_ENV")
  }
  if ($row.codex_cloud_status -match "VISIBLE" -and $row.codex_cloud_environment_label -notin $visibleCloudNames) {
    $warnings.Add("Codex environment queue row '$($row.environment_queue_id)' visible label is not present in inventory by exact name: $($row.codex_cloud_environment_label)")
  }
  if ($row.local_path -notmatch "NO_APLICA" -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.local_path))) {
    $message = "Codex environment queue row '$($row.environment_queue_id)' local_path missing: $($row.local_path)"
    if (($isGitHubActions -or $isAuxiliaryWrapperCheckout) -and $row.codex_app_scope -eq "repo_native") {
      $warnings.Add("$message (expected in wrapper-repo CI or auxiliary worktree without nested clones)")
    } else {
      $errors.Add($message)
    }
  }
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Codex environment queue '$($row.environment_queue_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Codex environment queue '$($row.environment_queue_id)'"
}

$envFiles = @()
$codexRoot = Join-Path $RepoRoot ".codex"
if (Test-Path -LiteralPath $codexRoot) {
  $envFiles = @(Get-ChildItem -LiteralPath $codexRoot -Recurse -Force -File | Where-Object {
    $_.Name -match '^\.env($|\.)'
  })
}
if ($envFiles.Count -gt 0) {
  foreach ($file in $envFiles) {
    $errors.Add("Forbidden .env-like file under .codex: $($file.FullName)")
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  checked_at = (Get-Date).ToString("o")
  local_environment_count = $localRows.Count
  environment_queue_count = $queueRows.Count
  registered_repo_count = $registeredRepos.Count
  codex_cloud_inventory_count = $cloudRows.Count
  warnings = @($warnings)
  errors = @($errors)
} | ConvertTo-Json -Depth 6

if ($errors.Count -gt 0) {
  exit 1
}
