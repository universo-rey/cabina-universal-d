param(
  [string]$Root = "D:\.agents\codex"
)

$ErrorActionPreference = "Stop"

function Read-CsvSafe {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing CSV: $Path"
  }
  @(Import-Csv -LiteralPath $Path)
}

function Test-RequiredColumns {
  param(
    [string]$Path,
    [string[]]$Columns
  )
  $rows = Read-CsvSafe -Path $Path
  $actual = @()
  if ($rows.Count -gt 0) {
    $actual = @($rows[0].PSObject.Properties.Name)
  } else {
    $header = (Get-Content -LiteralPath $Path -TotalCount 1)
    if ($header) { $actual = @($header -split ",") }
  }
  foreach ($column in $Columns) {
    if ($column -notin $actual) {
      return "Missing column '$column' in $Path"
    }
  }
  return $null
}

function Is-LocalPathLike {
  param([string]$Value)
  return ($Value -match '^[A-Za-z]:\\')
}

function Resolve-CabinaPath {
  param([string]$Path)
  if ([string]::IsNullOrWhiteSpace($Path)) {
    return $Path
  }
  $repoRoot = Split-Path -Parent (Split-Path -Parent $Root)
  $normalized = $Path -replace "/", "\"
  if ($normalized.StartsWith("D:\.agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    $suffix = $normalized.Substring("D:\.agents\codex".Length).TrimStart("\")
    return Join-Path $Root $suffix
  }
  if ($normalized.StartsWith("D:\", [System.StringComparison]::OrdinalIgnoreCase)) {
    $suffix = $normalized.Substring("D:\".Length).TrimStart("\")
    return Join-Path $repoRoot $suffix
  }
  return $Path
}

$levelValidator = Join-Path $Root "tools\local_validate_agent_levels.ps1"
$matrixIndex = Join-Path $Root "matrices\MATRIX_INDEX.csv"
$recipeIndex = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$skillUsage = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$toolIndex = Join-Path $Root "tools\TOOL_INDEX.csv"
$localSkillCatalog = Join-Path $Root "matrices\LOCAL_SKILL_CATALOG.csv"
$ratGovernance = Join-Path $Root "matrices\REPO_AGENT_TOOL_GOVERNANCE_MATRIX.csv"
$repoGovernance = Join-Path $Root "matrices\REPO_GOVERNANCE_ASSIGNMENT_MATRIX.csv"
$agentGovernance = Join-Path $Root "matrices\AGENT_GOVERNANCE_MATRIX.csv"
$toolGovernance = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
$validationCoverage = Join-Path $Root "matrices\VALIDATION_COVERAGE_MATRIX.csv"
$canonicalInventory = Join-Path $Root "matrices\GOVERNED_ASSET_CANONICAL_INVENTORY.csv"
$stopGlossary = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$coverageExceptions = Join-Path $Root "matrices\COVERAGE_EXCEPTION_REGISTRY.csv"
$lineageAudit = Join-Path $Root "matrices\CANONICAL_INDEX_LINEAGE_AUDIT.csv"
$agentWorkpapers = Join-Path $Root "matrices\AGENT_WORKPAPERS_MATRIX.csv"
$pluginUsage = Join-Path $Root "matrices\PLUGIN_USAGE_MATRIX.csv"
$purposeSurfaceCapability = Join-Path $Root "matrices\PURPOSE_SURFACE_CAPABILITY_MATRIX.csv"
$workpaperIndex = Join-Path $Root "workpapers\WORKPAPER_INDEX.csv"
$workpaperValidator = Join-Path $Root "tools\local_validate_agent_workpapers.ps1"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path -LiteralPath $levelValidator)) {
  $errors.Add("Missing level validator: $levelValidator")
} else {
  & $levelValidator -Root $Root | Out-Null
}

$requiredColumnChecks = @(
  @{ Path = $matrixIndex; Columns = @("matrix_id","path","scope","primary_reader","update_rule") },
  @{ Path = $recipeIndex; Columns = @("recipe_id","level_id","primary_agent","path","output") },
  @{ Path = $skillUsage; Columns = @("skill_id","source","assigned_level","assigned_agents","use_when","live_boundary") },
  @{ Path = $toolIndex; Columns = @("tool_id","level_id","tool_type","path_or_command","allowed_surface","blocked_surface") },
  @{ Path = $localSkillCatalog; Columns = @("skill_id","path","source","owner_agent","primary_recipe","validator","use_when","live_boundary") },
  @{ Path = $ratGovernance; Columns = @("asset_class","governing_matrix","primary_owner_agent","authority_level","required_recipe","required_tool","evidence","validator","stop_condition") },
  @{ Path = $repoGovernance; Columns = @("repo_id","path","remote","universe","tower","owner_agent","authority_level","allowed_actions","blocked_without_order","evidence","validator","stop_condition") },
  @{ Path = $agentGovernance; Columns = @("agent_id","level_id","governs_asset_classes","authority_scope","allowed_actions","blocked_without_order","escalates_to","evidence","validator") },
  @{ Path = $toolGovernance; Columns = @("tool_id","owner_agent","tool_type","governed_asset_classes","allowed_surface","allowed_actions","blocked_surface","required_evidence","validator") },
  @{ Path = $validationCoverage; Columns = @("artifact_class","required_index","required_validator","owner_agent","coverage_status","stop_condition") },
  @{ Path = $canonicalInventory; Columns = @("asset_class","asset_id","owner_agent","authority_level","governing_matrix","required_recipe","required_tool","evidence","validator","coverage_status","stop_condition") },
  @{ Path = $stopGlossary; Columns = @("stop_condition","normalized_family","meaning","required_action","applies_to") },
  @{ Path = $coverageExceptions; Columns = @("exception_id","asset_class","asset_id","reason","coverage_status","owner_agent","validator","next_review") },
  @{ Path = $lineageAudit; Columns = @("lineage_id","source","derived","derivation","owner_agent","validator") },
  @{ Path = $agentWorkpapers; Columns = @("agent_id","level_id","workpapers_path","repo_snapshot_path","status","primary_surface","purpose","required_matrices","required_recipes","required_tools","required_validators","evidence_policy","validator","stop_condition") },
  @{ Path = $pluginUsage; Columns = @("plugin_id","availability","assigned_agents","purpose","surface","live_boundary","tool_refs","validator","stop_condition") },
  @{ Path = $purposeSurfaceCapability; Columns = @("artifact_id","artifact_type","agent_id","level_id","purpose","surface","universe","tower","owner_agent","authority_level","lifecycle","status","local_allowed","governed_order_required","allowed_actions","blocked_actions","skill_refs","recipe_refs","tool_refs","plugin_refs","validator_refs","evidence_required","workpaper_path","source_policy","source_refs","last_validated","stop_condition","next_review") },
  @{ Path = $workpaperIndex; Columns = @("agent_id","level_id","workpaper_path","status","last_updated","primary_surface","purpose","owner_agent","required_matrices","required_recipes","required_tools","required_validators","evidence_policy","stop_condition") }
)

foreach ($check in $requiredColumnChecks) {
  $err = Test-RequiredColumns -Path $check.Path -Columns $check.Columns
  if ($err) { $errors.Add($err) }
}

$matrixRows = Read-CsvSafe -Path $matrixIndex
foreach ($row in $matrixRows) {
  if ([string]::IsNullOrWhiteSpace($row.matrix_id) -or [string]::IsNullOrWhiteSpace($row.path)) {
    $errors.Add("Matrix index row with blank matrix_id or path")
  } elseif ((Is-LocalPathLike $row.path) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.path))) {
    $errors.Add("Matrix index path missing: $($row.path)")
  }
}

$recipeRows = Read-CsvSafe -Path $recipeIndex
foreach ($row in $recipeRows) {
  if ([string]::IsNullOrWhiteSpace($row.recipe_id) -or [string]::IsNullOrWhiteSpace($row.primary_agent)) {
    $errors.Add("Recipe row with blank recipe_id or primary_agent")
  }
  if ((Is-LocalPathLike $row.path) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.path))) {
    $errors.Add("Recipe path missing: $($row.path)")
  }
}

$toolRows = Read-CsvSafe -Path $toolIndex
foreach ($row in $toolRows) {
  if ([string]::IsNullOrWhiteSpace($row.tool_id) -or [string]::IsNullOrWhiteSpace($row.allowed_surface) -or [string]::IsNullOrWhiteSpace($row.blocked_surface)) {
    $errors.Add("Tool row missing id, allowed_surface or blocked_surface")
  }
  if ((Is-LocalPathLike $row.path_or_command) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.path_or_command))) {
    $errors.Add("Tool path missing: $($row.path_or_command)")
  }
}

$skillRows = Read-CsvSafe -Path $localSkillCatalog
foreach ($row in $skillRows) {
  if ([string]::IsNullOrWhiteSpace($row.skill_id) -or [string]::IsNullOrWhiteSpace($row.owner_agent)) {
    $errors.Add("Skill catalog row missing skill_id or owner_agent")
  }
  if ((Is-LocalPathLike $row.path) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.path))) {
    $warnings.Add("Skill catalog path not present in this cabina: $($row.path)")
  }
}

$repoRows = Read-CsvSafe -Path $repoGovernance
foreach ($row in $repoRows) {
  if ([string]::IsNullOrWhiteSpace($row.repo_id) -or [string]::IsNullOrWhiteSpace($row.universe) -or [string]::IsNullOrWhiteSpace($row.owner_agent)) {
    $errors.Add("Repo governance row missing repo_id, universe or owner_agent")
  }
  if ((Is-LocalPathLike $row.path) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.path))) {
    $warnings.Add("Repo path not present in this cabina: $($row.path)")
  }
}

$agentRows = Read-CsvSafe -Path $agentGovernance
foreach ($row in $agentRows) {
  if ([string]::IsNullOrWhiteSpace($row.agent_id) -or [string]::IsNullOrWhiteSpace($row.level_id) -or [string]::IsNullOrWhiteSpace($row.escalates_to)) {
    $errors.Add("Agent governance row missing agent_id, level_id or escalates_to")
  }
}

$governanceRows = Read-CsvSafe -Path $ratGovernance
foreach ($row in $governanceRows) {
  if ([string]::IsNullOrWhiteSpace($row.asset_class) -or [string]::IsNullOrWhiteSpace($row.primary_owner_agent) -or [string]::IsNullOrWhiteSpace($row.required_recipe) -or [string]::IsNullOrWhiteSpace($row.required_tool)) {
    $errors.Add("Repo-agent-tool governance row missing asset_class, owner, recipe or tool")
  }
  if ((Is-LocalPathLike $row.governing_matrix) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.governing_matrix))) {
    $errors.Add("Governance matrix path missing: $($row.governing_matrix)")
  }
}

$inventoryRows = Read-CsvSafe -Path $canonicalInventory
foreach ($row in $inventoryRows) {
  if ([string]::IsNullOrWhiteSpace($row.asset_class) -or [string]::IsNullOrWhiteSpace($row.asset_id) -or [string]::IsNullOrWhiteSpace($row.owner_agent) -or [string]::IsNullOrWhiteSpace($row.validator)) {
    $errors.Add("Canonical inventory row missing asset_class, asset_id, owner_agent or validator")
  }
}

$glossaryRows = Read-CsvSafe -Path $stopGlossary
foreach ($row in $glossaryRows) {
  if ([string]::IsNullOrWhiteSpace($row.stop_condition) -or [string]::IsNullOrWhiteSpace($row.normalized_family)) {
    $errors.Add("Stop condition glossary row missing stop_condition or normalized_family")
  }
}

$exceptionRows = Read-CsvSafe -Path $coverageExceptions
foreach ($row in $exceptionRows) {
  if ([string]::IsNullOrWhiteSpace($row.exception_id) -or [string]::IsNullOrWhiteSpace($row.owner_agent) -or [string]::IsNullOrWhiteSpace($row.validator)) {
    $errors.Add("Coverage exception row missing exception_id, owner_agent or validator")
  }
}

$lineageRows = Read-CsvSafe -Path $lineageAudit
foreach ($row in $lineageRows) {
  if ([string]::IsNullOrWhiteSpace($row.lineage_id) -or [string]::IsNullOrWhiteSpace($row.source) -or [string]::IsNullOrWhiteSpace($row.derived)) {
    $errors.Add("Lineage audit row missing lineage_id, source or derived")
  }
}

if (-not (Test-Path -LiteralPath $workpaperValidator)) {
  $errors.Add("Missing workpaper validator: $workpaperValidator")
} else {
  & $workpaperValidator -Root $Root | Out-Null
}

$agentData = Get-Content -LiteralPath (Join-Path $Root "agents.json") -Raw | ConvertFrom-Json
$agentIds = @($agentData.agents | ForEach-Object { $_.id })
$agentWorkpaperRows = Read-CsvSafe -Path $agentWorkpapers
$workpaperIndexRows = Read-CsvSafe -Path $workpaperIndex
$workpaperMatrixIds = @($agentWorkpaperRows | ForEach-Object { $_.agent_id })
$workpaperIndexIds = @($workpaperIndexRows | ForEach-Object { $_.agent_id })
foreach ($agentId in $agentIds) {
  if ($agentId -notin $workpaperMatrixIds) {
    $errors.Add("Agent missing from workpaper matrix: $agentId")
  }
  if ($agentId -notin $workpaperIndexIds) {
    $errors.Add("Agent missing from workpaper index: $agentId")
  }
}
foreach ($row in $agentWorkpaperRows) {
  if ((Is-LocalPathLike $row.workpapers_path) -and -not (Test-Path -LiteralPath (Resolve-CabinaPath $row.workpapers_path) -PathType Container)) {
    $errors.Add("Workpaper folder missing: $($row.workpapers_path)")
  }
  if ([string]::IsNullOrWhiteSpace($row.repo_snapshot_path) -or [string]::IsNullOrWhiteSpace($row.required_validators)) {
    $errors.Add("Workpaper matrix row missing repo_snapshot_path or required_validators: $($row.agent_id)")
  }
}
foreach ($row in Read-CsvSafe -Path $pluginUsage) {
  if ([string]::IsNullOrWhiteSpace($row.plugin_id) -or [string]::IsNullOrWhiteSpace($row.availability) -or [string]::IsNullOrWhiteSpace($row.live_boundary)) {
    $errors.Add("Plugin usage row missing plugin_id, availability or live_boundary")
  }
}
foreach ($row in Read-CsvSafe -Path $purposeSurfaceCapability) {
  if ([string]::IsNullOrWhiteSpace($row.artifact_id) -or [string]::IsNullOrWhiteSpace($row.agent_id) -or [string]::IsNullOrWhiteSpace($row.surface) -or [string]::IsNullOrWhiteSpace($row.workpaper_path)) {
    $errors.Add("Purpose surface capability row missing artifact_id, agent_id, surface or workpaper_path")
  }
}

$secretPatterns = @(
  "sk-[A-Za-z0-9_-]{20,}",
  "OPENAI_API_KEY\s*=",
  "BEGIN [A-Z ]*PRIVATE KEY",
  "password\s*=",
  "secret\s*=",
  "token\s*="
)
$scanFiles = @(
  Get-ChildItem -LiteralPath $Root -Recurse -File -Include "*.md","*.csv","*.json","*.yaml","*.yml","*.ps1" |
    Where-Object { $_.FullName -notmatch "\\readbacks\\.*RAW" -and $_.FullName -notmatch "\\SOURCE_" }
)
$secretHits = New-Object System.Collections.Generic.List[object]
foreach ($file in $scanFiles) {
  foreach ($pattern in $secretPatterns) {
    $hits = Select-String -LiteralPath $file.FullName -Pattern $pattern -CaseSensitive -ErrorAction SilentlyContinue
    foreach ($hit in $hits) {
      $secretHits.Add([pscustomobject]@{ path = $file.FullName; line = $hit.LineNumber; pattern = $pattern })
    }
  }
}
if ($secretHits.Count -gt 0) {
  $errors.Add("Secret-like hits detected: $($secretHits.Count)")
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }

[pscustomobject]@{
  status = $status
  root = $Root
  matrix_count = $matrixRows.Count
  recipe_count = $recipeRows.Count
  tool_count = $toolRows.Count
  local_skill_count = $skillRows.Count
  governed_repo_count = $repoRows.Count
  governed_agent_count = $agentRows.Count
  governed_asset_class_count = $governanceRows.Count
  canonical_inventory_count = $inventoryRows.Count
  stop_condition_count = $glossaryRows.Count
  coverage_exception_count = $exceptionRows.Count
  lineage_count = $lineageRows.Count
  workpaper_count = $agentWorkpaperRows.Count
  plugin_usage_count = (Read-CsvSafe -Path $pluginUsage).Count
  purpose_surface_capability_count = (Read-CsvSafe -Path $purposeSurfaceCapability).Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
  secret_hit_count = $secretHits.Count
  secret_hits = $secretHits
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
