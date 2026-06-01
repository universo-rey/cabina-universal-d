param(
  [string]$Root = "D:\.agents\codex",
  [string]$RepoRoot = "D:\",
  [switch]$NoWrite,
  [switch]$CheckOnly
)

$ErrorActionPreference = "Stop"

function Read-CsvRequired([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required CSV: $Path"
  }
  return @(Import-Csv -LiteralPath $Path)
}

function Read-JsonRequired([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required JSON: $Path"
  }
  return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

$matrixRoot = Join-Path $Root "matrices"
$toolsRoot = Join-Path $Root "tools"
$recipesRoot = Join-Path $Root "recipes"
$skillsRoot = Join-Path $Root "skills"
$pluginsRoot = Join-Path $Root "plugins"
$evalRoot = Join-Path $Root "evals"
$resultRoot = Join-Path $evalRoot "results"
$writeResult = -not ($NoWrite -or $CheckOnly)
if ($writeResult) {
  New-Item -ItemType Directory -Force -Path $resultRoot | Out-Null
}

$agentsJson = Read-JsonRequired (Join-Path $Root "agents.json")
$defaultSkills = Read-CsvRequired (Join-Path $matrixRoot "AGENT_DEFAULT_SKILL_ASSIGNMENT_MATRIX.csv")
$agentContracts = Read-CsvRequired (Join-Path $matrixRoot "AGENT_TOOL_RECIPE_SKILL_MATRIX.csv")
$repoRuntime = Read-CsvRequired (Join-Path $matrixRoot "REPO_RUNTIME_ALIGNMENT_MATRIX.csv")
$cabinaRepoAlignment = Read-CsvRequired (Join-Path $matrixRoot "CABINA_UNIVERSAL_REPO_ALIGNMENT_MATRIX.csv")
$githubBase = Read-CsvRequired (Join-Path $RepoRoot "01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv")
$githubAutomationPreflight = Read-CsvRequired (Join-Path $matrixRoot "GITHUB_AUTOMATION_PREFLIGHT_MATRIX.csv")
$operationalChain = Read-CsvRequired (Join-Path $matrixRoot "OPERATIONAL_CHAIN_GOVERNANCE_MATRIX.csv")
$skillUsage = Read-CsvRequired (Join-Path $skillsRoot "SKILL_USAGE_MATRIX.csv")
$recipeIndex = Read-CsvRequired (Join-Path $recipesRoot "RECIPE_INDEX.csv")
$toolIndex = Read-CsvRequired (Join-Path $toolsRoot "TOOL_INDEX.csv")
$pluginUsage = Read-CsvRequired (Join-Path $pluginsRoot "PLUGIN_USAGE_MATRIX.csv")
$githubActions = Read-CsvRequired (Join-Path $matrixRoot "GITHUB_ACTIONS_WORKFLOW_MATRIX.csv")

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

$agentIds = @($agentsJson.agents | ForEach-Object { $_.id })
$defaultAgentIds = @($defaultSkills | ForEach-Object { $_.agent_id })
$contractAgentIds = @($agentContracts | ForEach-Object { $_.agent_id })

foreach ($agentId in $agentIds) {
  if ($defaultAgentIds -notcontains $agentId) {
    $errors.Add("Agent missing default skills: $agentId")
  }
  if ($contractAgentIds -notcontains $agentId) {
    $errors.Add("Agent missing execution contract: $agentId")
  }
}

$skillIds = @($skillUsage | ForEach-Object { $_.skill_id })
foreach ($row in $defaultSkills) {
  $skills = @($row.default_skill_refs -split "\|" | Where-Object { $_ })
  if ($skills.Count -eq 0) {
    $errors.Add("Agent has empty default skill set: $($row.agent_id)")
  }
  foreach ($skill in $skills) {
    if ($skillIds -notcontains $skill) {
      $errors.Add("Default skill not present in SKILL_USAGE_MATRIX: $($row.agent_id) -> $skill")
    }
  }
}

$recipeIds = @($recipeIndex | ForEach-Object { $_.recipe_id })
$toolIds = @($toolIndex | ForEach-Object { $_.tool_id })
$pluginIds = @($pluginUsage | ForEach-Object { $_.plugin_id })

foreach ($row in $agentContracts) {
  foreach ($recipe in @($row.recipe_refs -split "\|" | Where-Object { $_ })) {
    if ($recipeIds -notcontains $recipe) {
      $errors.Add("Recipe ref not indexed: $($row.agent_id) -> $recipe")
    }
  }
  foreach ($tool in @($row.tool_refs -split "\|" | Where-Object { $_ })) {
    if ($toolIds -notcontains $tool) {
      $errors.Add("Tool ref not indexed: $($row.agent_id) -> $tool")
    }
  }
  foreach ($plugin in @($row.plugin_refs -split "\|" | Where-Object { $_ })) {
    if ($pluginIds -notcontains $plugin) {
      $errors.Add("Plugin ref not indexed: $($row.agent_id) -> $plugin")
    }
  }
}

$githubRepoIds = @($githubBase | ForEach-Object { $_.repo_id })
$runtimeRepoIds = @($repoRuntime | ForEach-Object { $_.repo_id })
$cabinaRepoIds = @($cabinaRepoAlignment | ForEach-Object { $_.repo_id })
foreach ($repoId in $githubRepoIds) {
  if ($runtimeRepoIds -notcontains $repoId) {
    $errors.Add("Repo missing runtime alignment row: $repoId")
  }
  if ($cabinaRepoIds -notcontains $repoId) {
    $errors.Add("Repo missing cabina-universal-d alignment row: $repoId")
  }
}

foreach ($row in $repoRuntime) {
  if ($agentIds -notcontains $row.owner_agent) {
    $errors.Add("Repo runtime owner is not an agent: $($row.repo_id) -> $($row.owner_agent)")
  }
  if ($row.runtime_mode -ne "LOCAL_SYNTHETIC_ALIGNMENT_ONLY") {
    $errors.Add("Repo runtime mode is not local synthetic: $($row.repo_id)")
  }
  if ($row.root_base_repo_id -ne "D_CABINA_UNIVERSAL_ROOT") {
    $errors.Add("Repo runtime root base repo id mismatch: $($row.repo_id) -> $($row.root_base_repo_id)")
  }
  if ($row.root_base_remote -ne "universo-rey/cabina-universal-d") {
    $errors.Add("Repo runtime root base remote mismatch: $($row.repo_id) -> $($row.root_base_remote)")
  }
  if ($row.blocked_surfaces -notmatch "openai_api_live" -or $row.blocked_surfaces -notmatch "microsoft_live" -or $row.blocked_surfaces -notmatch "production") {
    $errors.Add("Repo runtime blocked surfaces incomplete: $($row.repo_id)")
  }
}

foreach ($row in $cabinaRepoAlignment) {
  if ($row.cabina_base_repository -ne "universo-rey/cabina-universal-d") {
    $errors.Add("Repo cabina base mismatch: $($row.repo_id) -> $($row.cabina_base_repository)")
  }
  if ([string]::IsNullOrWhiteSpace($row.alignment_mode)) {
    $errors.Add("Repo cabina alignment mode missing: $($row.repo_id)")
  }
  if ($row.repo_runtime_mode -ne "LOCAL_SYNTHETIC_ALIGNMENT_ONLY") {
    $errors.Add("Repo cabina runtime mode is not local synthetic: $($row.repo_id)")
  }
  if ($row.productive_runtime_status -ne "REQUIRES_GOVERNED_ORDER") {
    $errors.Add("Repo productive runtime not gated: $($row.repo_id)")
  }
  if ($row.github_agent_status -ne "APPROVED_GITHUB_AGENT_SURFACE") {
    $errors.Add("Repo GitHub agent surface not approved: $($row.repo_id)")
  }
  if ($row.github_write_status -ne "APPROVED_BRANCH_COMMIT_PUSH_PR") {
    $errors.Add("Repo GitHub write status is not approved branch/commit/push/PR: $($row.repo_id)")
  }
}

foreach ($row in $githubActions) {
  if ($row.status -ne "APPROVED_GITHUB_ACTIONS_SURFACE") {
    $errors.Add("GitHub Actions workflow surface is not approved: $($row.workflow_id)")
  }
  if ($row.permissions -ne "contents:read") {
    $errors.Add("GitHub Actions workflow permissions are not read-only: $($row.workflow_id) -> $($row.permissions)")
  }
  if ($row.blocked_actions -notmatch "secrets" -or $row.blocked_actions -notmatch "production" -or $row.blocked_actions -notmatch "microsoft_live" -or $row.blocked_actions -notmatch "openai_api_live" -or $row.blocked_actions -notmatch "permission_write") {
    $errors.Add("GitHub Actions workflow blocked actions incomplete: $($row.workflow_id)")
  }
  $workflowPath = Join-Path $RepoRoot $row.path
  if (-not (Test-Path -LiteralPath $workflowPath)) {
    $errors.Add("GitHub Actions workflow path missing: $($row.workflow_id) -> $($row.path)")
  }
}

$preflightIds = @($githubAutomationPreflight | ForEach-Object { $_.preflight_id })
foreach ($expected in @(
  "preflight.github_foundation",
  "preflight.github_actions_readonly",
  "preflight.order_packets",
  "preflight.agents_sdk_local",
  "preflight.operational_chain_global",
  "preflight.repo_iteration_gate"
)) {
  if ($preflightIds -notcontains $expected) {
    $errors.Add("GitHub automation preflight row missing: $expected")
  }
}

foreach ($row in $githubAutomationPreflight) {
  if ($row.phase -ne "pre_repo_bootstrap") {
    $errors.Add("GitHub automation preflight phase is not pre_repo_bootstrap: $($row.preflight_id)")
  }
  if ([string]::IsNullOrWhiteSpace($row.required_before)) {
    $errors.Add("GitHub automation preflight required_before missing: $($row.preflight_id)")
  }
  if ($row.status -notmatch "^READY_") {
    $errors.Add("GitHub automation preflight not ready: $($row.preflight_id) -> $($row.status)")
  }
  if ($row.blocked_actions -notmatch "secrets" -or $row.blocked_actions -notmatch "production") {
    $errors.Add("GitHub automation preflight blocked actions incomplete: $($row.preflight_id)")
  }
}

$agentsSdkPreflight = @($githubAutomationPreflight | Where-Object { $_.preflight_id -eq "preflight.agents_sdk_local" }) | Select-Object -First 1
if (-not $agentsSdkPreflight) {
  $errors.Add("Agents SDK local preflight row missing")
} elseif ($agentsSdkPreflight.agents_sdk_mode -ne "LOCAL_IMPORT_APPROVED_NO_API_CALL" -or $agentsSdkPreflight.blocked_actions -notmatch "openai_api_live" -or $agentsSdkPreflight.blocked_actions -notmatch "agents_sdk_live") {
  $errors.Add("Agents SDK preflight must remain local import no-api-call with live API blocked")
}

$operationalChainIds = @($operationalChain | ForEach-Object { $_.chain_id })
foreach ($expected in @(
  "chain.chat_closeout_global",
  "chain.repo_change_global",
  "chain.github_automation_global",
  "chain.live_runtime_order_global",
  "chain.parallel_subagent_global"
)) {
  if ($operationalChainIds -notcontains $expected) {
    $errors.Add("Operational chain row missing: $expected")
  }
}

foreach ($row in $operationalChain) {
  if ($row.status -ne "ACTIVE_GLOBAL") {
    $errors.Add("Operational chain row is not ACTIVE_GLOBAL: $($row.chain_id)")
  }
  foreach ($field in @("owner_agent","reviewer_agent","required_skill_source","required_recipe_source","required_tool_source","required_validator_source","required_evidence_source","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Operational chain row '$($row.chain_id)' missing $field")
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
$payload = [ordered]@{
  status = $status
  mode = "LOCAL_SYNTHETIC_ALIGNMENT_ONLY"
  root = $Root
  repo_root = $RepoRoot
  agent_count = $agentIds.Count
  default_skill_rows = $defaultSkills.Count
  execution_contract_rows = $agentContracts.Count
  repo_alignment_rows = $repoRuntime.Count
  cabina_repo_alignment_rows = $cabinaRepoAlignment.Count
  github_repo_rows = $githubBase.Count
  skill_usage_rows = $skillUsage.Count
  recipe_rows = $recipeIndex.Count
  tool_rows = $toolIndex.Count
  plugin_rows = $pluginUsage.Count
  github_actions_rows = $githubActions.Count
  github_automation_preflight_rows = $githubAutomationPreflight.Count
  operational_chain_rows = $operationalChain.Count
  root_base_repo_id = "D_CABINA_UNIVERSAL_ROOT"
  root_base_remote = "universo-rey/cabina-universal-d"
  github_agent_status = "APPROVED_GITHUB_AGENT_SURFACE"
  github_actions_status = "APPROVED_GITHUB_ACTIONS_SURFACE"
  blocked_surfaces = @(
    "openai_api_live",
    "microsoft_live",
    "production",
    "permissions",
    "secrets",
    "force_push",
    "merge",
    "non_github_remote_agent_persistence"
  )
  errors = @($errors)
  warnings = @($warnings)
  generated_at = (Get-Date).ToUniversalTime().ToString("o")
  result_written = $writeResult
}

$resultPath = Join-Path $resultRoot "repo_alignment_runtime_latest.json"
if ($writeResult) {
  $payload | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $resultPath -Encoding UTF8
}

if ($errors.Count -gt 0) {
  $payload | ConvertTo-Json -Depth 8
  exit 1
}

$payload | ConvertTo-Json -Depth 8
