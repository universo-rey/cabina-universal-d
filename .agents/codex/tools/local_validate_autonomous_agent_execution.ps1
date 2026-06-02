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
  foreach ($token in (Split-Tokens -Value $Value)) {
    if ($token -match '^task_e_') { continue }
    if ($token -match '^NO_') { continue }
    if ($token -match '^[A-Z0-9_]+$') { continue }
    if ($token -match '^[A-Za-z]:[\\/]') {
      $resolved = Resolve-CabinaPath -Path $token
      if (-not (Test-Path -LiteralPath $resolved)) {
        $Errors.Add("$Context references missing path: $token")
      }
    }
  }
}

function Check-Refs {
  param(
    [string]$Value,
    [string[]]$Known,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($token in (Split-Tokens -Value $Value)) {
    if ($token -notin $Known) {
      $Errors.Add("$Context references unknown id: $token")
    }
  }
}

function Check-RequiredTokens {
  param(
    [string]$Value,
    [string[]]$Required,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  $tokens = Split-Tokens -Value $Value
  foreach ($required in $Required) {
    if ($required -notin $tokens) {
      $Errors.Add("$Context missing token: $required")
    }
  }
}

$matrixPath = Join-Path $Root "matrices\AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv"
$agentsPath = Join-Path $Root "agents.json"
$skillUsagePath = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$defaultSkillPath = Join-Path $Root "matrices\AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv"
$agentContractPath = Join-Path $Root "matrices\AGENT_TOOL_RECIPE_SKILL_MATRIX.csv"
$repoRuntimePath = Join-Path $Root "matrices\REPO_RUNTIME_ALIGNMENT_MATRIX.csv"
$capabilityMatrixPath = Join-Path $Root "matrices\CAPABILITY_USE_HARDENING_MATRIX.csv"
$capabilityValidatorPath = Join-Path $Root "tools\local_validate_capability_use_hardening.ps1"
$githubBasePath = Join-Path $RepoRoot "01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv"
$mandatorySkill = "tcu-descubridor-capacidades"
$mandatorySkillPath = Join-Path $RepoRoot ".agents\skills\tcu-descubridor-capacidades\SKILL.md"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @(
  "execution_id",
  "scope_type",
  "target_id",
  "repository_full_name",
  "local_path",
  "owner_agent",
  "reviewer_agent",
  "execution_mode",
  "codex_cloud_environment_label",
  "codex_cloud_status",
  "mandatory_discovery_skill",
  "capability_preflight",
  "allowed_autonomous_actions",
  "requires_order_for",
  "blocked_actions",
  "required_recipe",
  "required_tool",
  "evidence",
  "validator",
  "status",
  "stop_condition"
) -Errors $errors

$rows = Read-CsvRequired -Path $matrixPath
$agentsPayload = Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json
$agents = @($agentsPayload.agents)
$agentIds = @($agents | ForEach-Object { $_.id })
$skillIds = @((Read-CsvRequired -Path $skillUsagePath) | ForEach-Object { $_.skill_id })
$recipeIds = @((Read-CsvRequired -Path $recipeIndexPath) | ForEach-Object { $_.recipe_id })
$toolIds = @((Read-CsvRequired -Path $toolIndexPath) | ForEach-Object { $_.tool_id })
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$githubRepos = Read-CsvRequired -Path $githubBasePath
$repoIds = @($githubRepos | ForEach-Object { $_.repo_id })
$defaultRows = Read-CsvRequired -Path $defaultSkillPath
$contractRows = Read-CsvRequired -Path $agentContractPath
$repoRuntimeRows = Read-CsvRequired -Path $repoRuntimePath

foreach ($path in @($mandatorySkillPath, $capabilityMatrixPath, $capabilityValidatorPath)) {
  if (-not (Test-Path -LiteralPath $path)) {
    $errors.Add("Missing required autonomous preflight artifact: $path")
  }
}
if ($mandatorySkill -notin $skillIds) {
  $errors.Add("Mandatory skill missing from SKILL_USAGE_MATRIX: $mandatorySkill")
}
if ("tool.local_validate_autonomous_agent_execution" -notin $toolIds) {
  $errors.Add("TOOL_INDEX missing tool.local_validate_autonomous_agent_execution")
}

$expectedAgentRows = @($rows | Where-Object { $_.scope_type -eq "agent" })
$expectedRepoRows = @($rows | Where-Object { $_.scope_type -eq "repo" })
foreach ($agentId in $agentIds) {
  if ($agentId -notin @($expectedAgentRows | ForEach-Object { $_.target_id })) {
    $errors.Add("Autonomous execution matrix missing agent row: $agentId")
  }
}
foreach ($repoId in $repoIds) {
  if ($repoId -notin @($expectedRepoRows | ForEach-Object { $_.target_id })) {
    $errors.Add("Autonomous execution matrix missing repo row: $repoId")
  }
}

$allowedScopeTypes = @("agent", "repo", "repo_candidate")
$allowedStatuses = @(
  "ACTIVE_LOCAL_TASK_SCOPED",
  "ACTIVE_CODEX_CLOUD_READY",
  "ACTIVE_CODEX_CLOUD_READY_OUT_OF_BASE_MATRIX",
  "BLOCKED_NO_CODEX_CLOUD_ENVIRONMENT",
  "ACTIVE_REMOTE_REFERENCE_ENV_PENDING"
)

foreach ($agent in $agents) {
  if ($mandatorySkill -notin @($agent.default_skills)) {
    $errors.Add("agents.json $($agent.id) missing mandatory default skill: $mandatorySkill")
  }
}
foreach ($row in $defaultRows) {
  if ($mandatorySkill -notin (Split-Tokens -Value $row.default_skill_refs)) {
    $errors.Add("Default assignment '$($row.agent_id)' missing mandatory skill: $mandatorySkill")
  }
}
foreach ($row in $contractRows) {
  if ($mandatorySkill -notin (Split-Tokens -Value $row.skill_refs)) {
    $errors.Add("Agent contract '$($row.agent_id)' missing mandatory skill: $mandatorySkill")
  }
}
foreach ($row in $repoRuntimeRows) {
  if ($mandatorySkill -notin (Split-Tokens -Value $row.default_skill_refs)) {
    $errors.Add("Repo runtime '$($row.repo_id)' missing mandatory skill: $mandatorySkill")
  }
}

$seen = @{}
foreach ($row in $rows) {
  foreach ($field in @("execution_id","scope_type","target_id","owner_agent","reviewer_agent","execution_mode","mandatory_discovery_skill","capability_preflight","allowed_autonomous_actions","requires_order_for","blocked_actions","required_recipe","required_tool","evidence","validator","status","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Autonomous execution row '$($row.execution_id)' missing $field")
    }
  }
  if ($seen.ContainsKey($row.execution_id)) {
    $errors.Add("Duplicate autonomous execution row: $($row.execution_id)")
  } else {
    $seen[$row.execution_id] = $true
  }
  if ($row.scope_type -notin $allowedScopeTypes) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' has invalid scope_type: $($row.scope_type)")
  }
  if ($row.status -notin $allowedStatuses) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' has invalid status: $($row.status)")
  }
  if ($row.owner_agent -notin $agentIds) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' references unknown owner_agent: $($row.owner_agent)")
  }
  if ($row.reviewer_agent -notin $agentIds) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' references unknown reviewer_agent: $($row.reviewer_agent)")
  }
  if ($row.owner_agent -eq $row.reviewer_agent) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' owner_agent and reviewer_agent must differ")
  }
  if ($row.mandatory_discovery_skill -ne $mandatorySkill) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' must use mandatory skill: $mandatorySkill")
  }
  Check-RequiredTokens -Value $row.capability_preflight -Required @(
    "D:/.agents/codex/matrices/CAPABILITY_USE_HARDENING_MATRIX.csv",
    "D:/.agents/codex/tools/local_validate_capability_use_hardening.ps1"
  ) -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' capability_preflight"
  Check-RequiredTokens -Value $row.requires_order_for -Required @(
    "codex_cloud_exec",
    "codex_cloud_apply",
    "github_pr_open",
    "microsoft_live",
    "openai_api_live",
    "production",
    "permission_change",
    "tenant_write",
    "remote_agent_persistence"
  ) -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' requires_order_for"
  Check-RequiredTokens -Value $row.blocked_actions -Required @(
    "secret_materialization",
    "microsoft_live",
    "production",
    "permission_change",
    "openai_api_live",
    "regulated_data_dump",
    "tenant_write",
    "remote_agent_persistence_without_order",
    "codex_cloud_apply_without_review"
  ) -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' blocked_actions"
  Check-Refs -Value $row.required_recipe -Known $recipeIds -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' recipes"
  Check-Refs -Value $row.required_tool -Known $toolIds -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' tools"
  Check-PathTokens -Value $row.capability_preflight -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' capability_preflight"
  Check-PathTokens -Value $row.evidence -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' evidence"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Autonomous execution row '$($row.execution_id)' validator"
  foreach ($stop in (Split-Tokens -Value $row.stop_condition)) {
    if ($stop -notin $knownStops) {
      $errors.Add("Autonomous execution row '$($row.execution_id)' references unknown stop_condition: $stop")
    }
  }
  if ($row.scope_type -eq "agent" -and $row.target_id -notin $agentIds) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' references unknown agent target: $($row.target_id)")
  }
  if ($row.scope_type -eq "repo" -and $row.target_id -notin $repoIds) {
    $errors.Add("Autonomous execution row '$($row.execution_id)' references unknown repo target: $($row.target_id)")
  }
  if ($row.status -match "CODEX_CLOUD_READY" -and $row.evidence -notmatch "task_e_|codex_cloud_list") {
    $errors.Add("Autonomous execution row '$($row.execution_id)' is Cloud-ready without task or list evidence")
  }
  if ($row.status -eq "BLOCKED_NO_CODEX_CLOUD_ENVIRONMENT" -and $row.codex_cloud_status -notmatch "NO_VISIBLE_ENVIRONMENT|NO_DISPONIBLE") {
    $errors.Add("Autonomous execution row '$($row.execution_id)' is blocked for Cloud env without NO_VISIBLE evidence")
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  autonomous_rows = $rows.Count
  agent_rows = $expectedAgentRows.Count
  repo_rows = $expectedRepoRows.Count
  repo_candidate_rows = @($rows | Where-Object { $_.scope_type -eq "repo_candidate" }).Count
  mandatory_skill = $mandatorySkill
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
