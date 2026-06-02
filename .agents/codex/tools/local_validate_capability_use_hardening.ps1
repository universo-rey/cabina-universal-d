param(
  [string]$Root = "D:\.agents\codex",
  [string]$RepoRoot = "D:\"
)

$ErrorActionPreference = "Stop"
$script:CsvCache = @{}

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required CSV: $Path"
  }
  $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
  if (-not $script:CsvCache.ContainsKey($resolvedPath)) {
    $script:CsvCache[$resolvedPath] = @(Import-Csv -LiteralPath $resolvedPath)
  }
  return $script:CsvCache[$resolvedPath]
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

$matrixPath = Join-Path $Root "matrices\CAPABILITY_USE_HARDENING_MATRIX.csv"
$agentsPath = Join-Path $Root "agents.json"
$routingPath = Join-Path $Root "routing.json"
$skillUsagePath = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$pluginBoundaryPath = Join-Path $Root "matrices\PLUGIN_SKILL_BOUNDARY_MATRIX.csv"
$defaultSkillPath = Join-Path $Root "matrices\AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv"
$agentContractPath = Join-Path $Root "matrices\AGENT_TOOL_RECIPE_SKILL_MATRIX.csv"
$repoRuntimePath = Join-Path $Root "matrices\REPO_RUNTIME_ALIGNMENT_MATRIX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$mandatorySkill = "tcu-descubridor-capacidades"
$mandatorySkillPath = Join-Path $RepoRoot ".agents\skills\tcu-descubridor-capacidades\SKILL.md"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $matrixPath -Columns @(
  "stage_id",
  "applies_to",
  "lead_agent",
  "owner_agent",
  "reviewer_agent",
  "assignment_source",
  "derivation_source",
  "required_skill_source",
  "required_recipe_source",
  "required_plugin_source",
  "required_tool_source",
  "required_surface_source",
  "required_validator",
  "evidence",
  "allowed_actions",
  "blocked_actions",
  "stop_condition",
  "status"
) -Errors $errors

Require-Columns -Path $defaultSkillPath -Columns @("agent_id","default_skill_refs","default_recipe_refs","default_tool_refs","default_plugin_refs","validator","stop_condition") -Errors $errors
Require-Columns -Path $agentContractPath -Columns @("agent_id","skill_refs","recipe_refs","tool_refs","plugin_refs","validator","stop_condition") -Errors $errors
Require-Columns -Path $pluginBoundaryPath -Columns @("plugin_id","skill_refs","assigned_agents","allowed_surface","requires_order_for","blocked_surface","validator","stop_condition") -Errors $errors
Require-Columns -Path $repoRuntimePath -Columns @("repo_id","repository_full_name","default_skill_refs","default_recipe_refs","default_tool_refs","default_plugin_refs") -Errors $errors

$agentsPayload = Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json
$agents = @($agentsPayload.agents)
$agentIds = @($agents | ForEach-Object { $_.id })
$skillIds = @((Read-CsvRequired -Path $skillUsagePath) | ForEach-Object { $_.skill_id })
$recipeRows = Read-CsvRequired -Path $recipeIndexPath
$recipeIds = @($recipeRows | ForEach-Object { $_.recipe_id })
$toolRows = Read-CsvRequired -Path $toolIndexPath
$toolIds = @($toolRows | ForEach-Object { $_.tool_id })
$pluginRows = Read-CsvRequired -Path $pluginBoundaryPath
$pluginIds = @($pluginRows | ForEach-Object { $_.plugin_id })
$repoRuntimeRows = Read-CsvRequired -Path $repoRuntimePath
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })

if ($mandatorySkill -notin $skillIds) {
  $errors.Add("Mandatory capability discovery skill missing from SKILL_USAGE_MATRIX: $mandatorySkill")
}
if (-not (Test-Path -LiteralPath $mandatorySkillPath)) {
  $errors.Add("Mandatory repo-local skill file missing: $mandatorySkillPath")
}

$rows = Read-CsvRequired -Path $matrixPath
$expectedStages = @(
  "capability_use.session_intake",
  "capability_use.before_local_read",
  "capability_use.before_local_write",
  "capability_use.before_live_or_cost",
  "capability_use.skill_discovery_assignment",
  "capability_use.autonomous_execution",
  "capability_use.agent_derivation",
  "capability_use.parallel_dispatch",
  "capability_use.every_closeout"
)

foreach ($expected in $expectedStages) {
  if ($expected -notin @($rows | ForEach-Object { $_.stage_id })) {
    $errors.Add("Missing capability-use hardening row: $expected")
  }
}

foreach ($row in $rows) {
  foreach ($field in @("stage_id","applies_to","lead_agent","owner_agent","reviewer_agent","assignment_source","derivation_source","required_skill_source","required_recipe_source","required_plugin_source","required_tool_source","required_surface_source","required_validator","evidence","allowed_actions","blocked_actions","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Capability-use row '$($row.stage_id)' missing $field")
    }
  }
  foreach ($agentField in @("lead_agent","owner_agent","reviewer_agent")) {
    if ($row.$agentField -notin $agentIds) {
      $errors.Add("Capability-use row '$($row.stage_id)' references unknown ${agentField}: $($row.$agentField)")
    }
  }
  if ($row.owner_agent -eq $row.reviewer_agent) {
    $errors.Add("Capability-use row '$($row.stage_id)' owner_agent and reviewer_agent must differ")
  }
  if ($row.status -ne "ACTIVE_REQUIRED") {
    $errors.Add("Capability-use row '$($row.stage_id)' must be ACTIVE_REQUIRED")
  }
  foreach ($sourceField in @("assignment_source","derivation_source","required_skill_source","required_recipe_source","required_plugin_source","required_tool_source","required_surface_source","required_validator")) {
    Check-PathTokens -Value $row.$sourceField -Errors $errors -Context "Capability-use row '$($row.stage_id)' $sourceField"
  }
  foreach ($blocked in @("execution_without_capability_preflight","microsoft_live","openai_api_live","production","secrets")) {
    if ($row.blocked_actions -notmatch [regex]::Escape($blocked)) {
      $errors.Add("Capability-use row '$($row.stage_id)' missing blocked action '$blocked'")
    }
  }
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Capability-use row '$($row.stage_id)'"
}

foreach ($agent in $agents) {
  foreach ($field in @("default_skills","default_recipes","default_tools","default_plugins")) {
    if (-not $agent.PSObject.Properties.Name.Contains($field) -or @($agent.$field).Count -eq 0) {
      $errors.Add("agents.json $($agent.id) missing $field")
    }
  }
  Check-Refs -Value (@($agent.default_skills) -join "|") -Known $skillIds -Errors $errors -Context "agents.json $($agent.id) default_skills"
  if ($mandatorySkill -notin @($agent.default_skills)) {
    $errors.Add("agents.json $($agent.id) missing mandatory default skill: $mandatorySkill")
  }
  Check-Refs -Value (@($agent.default_recipes) -join "|") -Known $recipeIds -Errors $errors -Context "agents.json $($agent.id) default_recipes"
  Check-Refs -Value (@($agent.default_tools) -join "|") -Known $toolIds -Errors $errors -Context "agents.json $($agent.id) default_tools"
  Check-Refs -Value (@($agent.default_plugins) -join "|") -Known $pluginIds -Errors $errors -Context "agents.json $($agent.id) default_plugins"
}

foreach ($row in (Read-CsvRequired -Path $defaultSkillPath)) {
  if ($row.agent_id -notin $agentIds) {
    $errors.Add("Default assignment references unknown agent: $($row.agent_id)")
  }
  if ($mandatorySkill -notin (Split-Tokens -Value $row.default_skill_refs)) {
    $errors.Add("Default assignment '$($row.agent_id)' missing mandatory skill: $mandatorySkill")
  }
  Check-Refs -Value $row.default_skill_refs -Known $skillIds -Errors $errors -Context "Default assignment '$($row.agent_id)' skills"
  Check-Refs -Value $row.default_recipe_refs -Known $recipeIds -Errors $errors -Context "Default assignment '$($row.agent_id)' recipes"
  Check-Refs -Value $row.default_tool_refs -Known $toolIds -Errors $errors -Context "Default assignment '$($row.agent_id)' tools"
  Check-Refs -Value $row.default_plugin_refs -Known $pluginIds -Errors $errors -Context "Default assignment '$($row.agent_id)' plugins"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Default assignment '$($row.agent_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Default assignment '$($row.agent_id)'"
}

foreach ($row in (Read-CsvRequired -Path $agentContractPath)) {
  if ($row.agent_id -notin $agentIds) {
    $errors.Add("Agent execution contract references unknown agent: $($row.agent_id)")
  }
  foreach ($field in @("skill_refs","recipe_refs","tool_refs","plugin_refs","validator","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Agent execution contract '$($row.agent_id)' missing $field")
    }
  }
  Check-Refs -Value $row.skill_refs -Known $skillIds -Errors $errors -Context "Agent execution contract '$($row.agent_id)' skills"
  if ($mandatorySkill -notin (Split-Tokens -Value $row.skill_refs)) {
    $errors.Add("Agent execution contract '$($row.agent_id)' missing mandatory skill: $mandatorySkill")
  }
  Check-Refs -Value $row.recipe_refs -Known $recipeIds -Errors $errors -Context "Agent execution contract '$($row.agent_id)' recipes"
  Check-Refs -Value $row.tool_refs -Known $toolIds -Errors $errors -Context "Agent execution contract '$($row.agent_id)' tools"
  Check-Refs -Value $row.plugin_refs -Known $pluginIds -Errors $errors -Context "Agent execution contract '$($row.agent_id)' plugins"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Agent execution contract '$($row.agent_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Agent execution contract '$($row.agent_id)'"
}

foreach ($row in $repoRuntimeRows) {
  foreach ($field in @("repo_id","repository_full_name","default_skill_refs","default_recipe_refs","default_tool_refs","default_plugin_refs")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Repo runtime alignment '$($row.repo_id)' missing $field")
    }
  }
  if ($mandatorySkill -notin (Split-Tokens -Value $row.default_skill_refs)) {
    $errors.Add("Repo runtime alignment '$($row.repo_id)' missing mandatory skill: $mandatorySkill")
  }
  Check-Refs -Value $row.default_skill_refs -Known $skillIds -Errors $errors -Context "Repo runtime alignment '$($row.repo_id)' skills"
  Check-Refs -Value $row.default_recipe_refs -Known $recipeIds -Errors $errors -Context "Repo runtime alignment '$($row.repo_id)' recipes"
  Check-Refs -Value $row.default_tool_refs -Known $toolIds -Errors $errors -Context "Repo runtime alignment '$($row.repo_id)' tools"
  Check-Refs -Value $row.default_plugin_refs -Known $pluginIds -Errors $errors -Context "Repo runtime alignment '$($row.repo_id)' plugins"
}

foreach ($row in $pluginRows) {
  foreach ($field in @("plugin_id","skill_refs","assigned_agents","allowed_surface","requires_order_for","blocked_surface","validator","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Plugin boundary '$($row.plugin_id)' missing $field")
    }
  }
  Check-Refs -Value $row.skill_refs -Known $skillIds -Errors $errors -Context "Plugin boundary '$($row.plugin_id)' skills"
  Check-Refs -Value $row.assigned_agents -Known $agentIds -Errors $errors -Context "Plugin boundary '$($row.plugin_id)' agents"
  Check-PathTokens -Value $row.validator -Errors $errors -Context "Plugin boundary '$($row.plugin_id)' validator"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Plugin boundary '$($row.plugin_id)'"
}

foreach ($row in $toolRows) {
  foreach ($field in @("tool_id","allowed_surface","blocked_surface")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Tool index '$($row.tool_id)' missing $field")
    }
  }
  Check-PathTokens -Value $row.path_or_command -Errors $errors -Context "Tool index '$($row.tool_id)' path"
}

foreach ($row in $recipeRows) {
  if ($row.primary_agent -notin $agentIds) {
    $errors.Add("Recipe '$($row.recipe_id)' references unknown primary_agent: $($row.primary_agent)")
  }
  Check-PathTokens -Value $row.path -Errors $errors -Context "Recipe '$($row.recipe_id)' path"
}

$routing = Get-Content -Raw -LiteralPath $routingPath | ConvertFrom-Json
foreach ($route in @($routing.routes)) {
  Check-Refs -Value (@($route.agents) -join "|") -Known $agentIds -Errors $errors -Context "routing.json route '$($route.order_class)' agents"
}
foreach ($handoff in @($routing.handoff_rules)) {
  if ($handoff.assigned_agent -notin $agentIds) {
    $errors.Add("routing.json handoff '$($handoff.when)' references unknown assigned_agent: $($handoff.assigned_agent)")
  }
  $mustInclude = @($handoff.must_include)
  foreach ($field in @("capability_chain","skill","recipe","plugin","tool","surface","evidence","validator","stop_condition")) {
    if ($field -notin $mustInclude) {
      $warnings.Add("routing.json handoff '$($handoff.when)' does not require $field")
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  capability_use_rows = $rows.Count
  agents = $agentIds.Count
  skills = $skillIds.Count
  recipes = $recipeIds.Count
  tools = $toolIds.Count
  plugins = $pluginIds.Count
  repo_runtime_rows = $repoRuntimeRows.Count
  mandatory_skill = $mandatorySkill
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
