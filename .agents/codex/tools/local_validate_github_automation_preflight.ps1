param(
  [string]$Root = "D:\.agents\codex",
  [string]$RepoRoot = "D:\",
  [switch]$CheckLocalSdk
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

function Check-TokenList {
  param(
    [string]$Value,
    [string[]]$Required,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  $tokens = @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  foreach ($requiredToken in $Required) {
    if ($requiredToken -notin $tokens) {
      $Errors.Add("$Context missing token: $requiredToken")
    }
  }
}

function Check-ValidatorRef {
  param(
    [string]$Value,
    [string[]]$ToolIds,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  if ([string]::IsNullOrWhiteSpace($Value)) {
    $Errors.Add("$Context missing validator")
    return
  }
  if ($Value -like "tool.*") {
    if ($Value -notin $ToolIds) {
      $Errors.Add("$Context references unknown validator tool: $Value")
    }
    return
  }
  if ($Value -match '^[A-Za-z]:[\\/]') {
    $resolved = Resolve-CabinaPath -Path $Value
    if (-not (Test-Path -LiteralPath $resolved)) {
      $Errors.Add("$Context validator path missing: $Value")
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

function Require-TemplateId {
  param(
    [string]$Path,
    [string]$Id,
    [System.Collections.Generic.List[string]]$Errors
  )
  if (-not (Test-Path -LiteralPath $Path)) {
    $Errors.Add("Template missing: $Path")
    return
  }
  $text = Get-Content -Raw -LiteralPath $Path
  if ($text -notmatch "id:\s*$([regex]::Escape($Id))\b") {
    $Errors.Add("Template $Path missing id: $Id")
  }
}

$matrixPath = Join-Path $Root "matrices\GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"
$githubActionsPath = Join-Path $Root "matrices\GITHUB_ACTIONS_WORKFLOW_MATRIX.csv"
$orderClassPath = Join-Path $Root "matrices\ORDER_CLASS_CAPABILITY_MATRIX.csv"
$pluginBoundaryPath = Join-Path $Root "matrices\PLUGIN_SKILL_BOUNDARY_MATRIX.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$sdkEvidence = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @("preflight_id","phase","required_before","owner_agent","reviewer_agent","surface","required_artifacts","allowed_actions","blocked_actions","github_mode","agents_sdk_mode","evidence","validator","status","stop_condition") -Errors $errors

$toolIds = @((Read-CsvRequired -Path $toolIndexPath) | ForEach-Object { $_.tool_id })
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })
$rows = Read-CsvRequired -Path $matrixPath
$allowedStatuses = @("READY_PRE_REPO_AUTOMATION","READY_LOCAL_SDK_PREFLIGHT_ONLY","GOVERNED_ORDER_REQUIRED")

foreach ($expected in @(
  "preflight.github_foundation",
  "preflight.github_actions_readonly",
  "preflight.order_packets",
  "preflight.agents_sdk_local",
  "preflight.repo_iteration_gate"
)) {
  if ($expected -notin @($rows | ForEach-Object { $_.preflight_id })) {
    $errors.Add("Missing GitHub automation preflight row: $expected")
  }
}

foreach ($row in $rows) {
  foreach ($field in @("preflight_id","phase","required_before","owner_agent","reviewer_agent","surface","required_artifacts","allowed_actions","blocked_actions","github_mode","agents_sdk_mode","evidence","validator","status","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Preflight row '$($row.preflight_id)' missing $field")
    }
  }
  if ($row.phase -ne "pre_repo_bootstrap") {
    $errors.Add("Preflight row '$($row.preflight_id)' must run in pre_repo_bootstrap phase")
  }
  if ($row.owner_agent -notin $agentIds) {
    $errors.Add("Preflight row '$($row.preflight_id)' references unknown owner_agent: $($row.owner_agent)")
  }
  if ($row.reviewer_agent -notin $agentIds) {
    $errors.Add("Preflight row '$($row.preflight_id)' references unknown reviewer_agent: $($row.reviewer_agent)")
  }
  if ($row.owner_agent -eq $row.reviewer_agent) {
    $errors.Add("Preflight row '$($row.preflight_id)' owner_agent and reviewer_agent must differ")
  }
  if ($row.status -notin $allowedStatuses) {
    $errors.Add("Preflight row '$($row.preflight_id)' has unsupported status: $($row.status)")
  }
  foreach ($artifact in @($row.required_artifacts -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    $resolved = Resolve-CabinaPath -Path $artifact
    if (-not (Test-Path -LiteralPath $resolved)) {
      $errors.Add("Preflight row '$($row.preflight_id)' missing artifact: $artifact")
    }
  }
  Check-ValidatorRef -Value $row.validator -ToolIds $toolIds -Errors $errors -Context "Preflight row '$($row.preflight_id)'"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Preflight row '$($row.preflight_id)'"
  Check-TokenList -Value $row.blocked_actions -Required @("secrets","production") -Errors $errors -Context "Preflight row '$($row.preflight_id)' blocked_actions"
}

$sdkRow = @($rows | Where-Object { $_.preflight_id -eq "preflight.agents_sdk_local" }) | Select-Object -First 1
if ($sdkRow) {
  Check-TokenList -Value $sdkRow.blocked_actions -Required @("openai_api_live","agents_sdk_live","secret_materialization","production") -Errors $errors -Context "Agents SDK preflight blocked_actions"
  if ($sdkRow.agents_sdk_mode -ne "LOCAL_IMPORT_APPROVED_NO_API_CALL") {
    $errors.Add("Agents SDK preflight must remain local no-api-call until a live order is complete")
  }
}

$actionsRows = Read-CsvRequired -Path $githubActionsPath
$cabinaWorkflow = @($actionsRows | Where-Object { $_.workflow_id -eq "cabina_validation" }) | Select-Object -First 1
if (-not $cabinaWorkflow) {
  $errors.Add("GitHub Actions matrix missing cabina_validation row")
} else {
  if ($cabinaWorkflow.permissions -ne "contents:read") {
    $errors.Add("cabina_validation workflow permissions must remain contents:read")
  }
  Check-TokenList -Value $cabinaWorkflow.allowed_actions -Required @("local_github_automation_preflight_validation") -Errors $errors -Context "cabina_validation allowed_actions"
  Check-TokenList -Value $cabinaWorkflow.blocked_actions -Required @("secrets","production","microsoft_live","openai_api_live","permission_write","force_push","merge") -Errors $errors -Context "cabina_validation blocked_actions"
}

$orderClasses = @((Read-CsvRequired -Path $orderClassPath) | ForEach-Object { $_.order_class })
foreach ($orderClass in @("github_merge_or_pr","openai_api_or_remote_agent")) {
  if ($orderClass -notin $orderClasses) {
    $errors.Add("Order class missing for GitHub automation preflight: $orderClass")
  }
}

$openAiPlugin = @((Read-CsvRequired -Path $pluginBoundaryPath) | Where-Object { $_.plugin_id -eq "OpenAI Developers" }) | Select-Object -First 1
if (-not $openAiPlugin) {
  $errors.Add("PLUGIN_SKILL_BOUNDARY_MATRIX missing OpenAI Developers row")
} else {
  Check-TokenList -Value $openAiPlugin.requires_order_for -Required @("openai_api_live","agents_sdk_live","cost") -Errors $errors -Context "OpenAI Developers requires_order_for"
  Check-TokenList -Value $openAiPlugin.blocked_surface -Required @("secret_materialization") -Errors $errors -Context "OpenAI Developers blocked_surface"
}

Require-TemplateId -Path (Join-Path $RepoRoot ".github\ISSUE_TEMPLATE\agent-task.yml") -Id "preflight" -Errors $errors
foreach ($runtimeTemplateId in @("secret_boundary","allowed_actions","blocked_actions","expiration_rule")) {
  Require-TemplateId -Path (Join-Path $RepoRoot ".github\ISSUE_TEMPLATE\runtime-approval.yml") -Id $runtimeTemplateId -Errors $errors
}

if ($CheckLocalSdk) {
  $python = @'
import importlib.metadata as md
from agents import Agent, Runner

agent = Agent(
    name="cabina-github-automation-preflight",
    instructions="Local import smoke only. Do not call external APIs.",
)
print("openai-agents=" + md.version("openai-agents"))
print("openai=" + md.version("openai"))
print("agent_name=" + agent.name)
print("runner_available=" + str(Runner is not None))
print("smoke=OK_NO_API_CALL")
'@
  $output = & python -c $python 2>&1
  if ($LASTEXITCODE -ne 0) {
    $errors.Add("Agents SDK local import smoke failed: $($output -join ' ')")
  } else {
    foreach ($line in $output) {
      $sdkEvidence.Add([string]$line)
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  preflight_count = $rows.Count
  phase = "pre_repo_bootstrap"
  required_before = "repo_iteration"
  local_sdk_checked = [bool]$CheckLocalSdk
  openai_api_key_present = [bool]$env:OPENAI_API_KEY
  sdk_evidence = @($sdkEvidence)
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
