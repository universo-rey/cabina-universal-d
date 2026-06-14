param(
  [string]$Root = ".agents\codex"
)

$ErrorActionPreference = "Stop"

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing CSV: $Path"
  }
  return @(Import-Csv -LiteralPath $Path)
}

function Test-File {
  param([string]$Path, [System.Collections.Generic.List[string]]$Errors)
  if (-not (Test-Path -LiteralPath $Path)) {
    $Errors.Add("Missing file: $Path")
  }
}

function Test-Columns {
  param(
    [string]$Path,
    [string[]]$Required,
    [System.Collections.Generic.List[string]]$Errors
  )
  $header = Get-Content -LiteralPath $Path -TotalCount 1
  $actual = @($header -split ",")
  foreach ($column in $Required) {
    if ($actual -notcontains $column) {
      $Errors.Add("Missing column '$column' in $Path")
    }
  }
}

$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

$enginePath = Join-Path $Root "engines\MULTI_CANON_EXECUTION_ENGINE.md"
$chainPath = Join-Path $Root "matrices\MULTI_CANON_AGENT_CHAIN_MATRIX.csv"
$surfacePath = Join-Path $Root "matrices\MULTI_CANON_SURFACE_POLICY_MATRIX.csv"
$wave2Path = Join-Path $Root "matrices\MULTI_CANON_WAVE2_STABILIZATION_MATRIX_20260614.csv"
$graphPath = Join-Path $Root "maps\MULTI_CANON_AGENTIC_EXECUTION_GRAPH.md"
$readbackPath = Join-Path $Root "readbacks\2026-06-14_multi_canon_execution_engine_wave2_readback.md"

foreach ($path in @($enginePath, $chainPath, $surfacePath, $wave2Path, $graphPath, $readbackPath)) {
  Test-File -Path $path -Errors $errors
}

if ($errors.Count -eq 0) {
  Test-Columns -Path $chainPath -Required @(
    "stage_id","agent_id","role","input_contract","allowed_reads","blocked_writes",
    "output_contract","evidence","validator","stop_condition","handoff_to"
  ) -Errors $errors
  Test-Columns -Path $surfacePath -Required @(
    "surface","mode","allowed_read","evidence_use","blocked_without_atomic_order",
    "required_atomic_order_fields","owner_agent","validator","stop_condition"
  ) -Errors $errors
  Test-Columns -Path $wave2Path -Required @(
    "repo","pr_url","branch","head_commit","wave2_status","checks_state",
    "mergeability","review_state","threads_state","action_required",
    "gate_type","next_action","auto_merge_allowed"
  ) -Errors $errors

  $chainRows = Read-CsvRequired -Path $chainPath
  $requiredStages = @(
    "S01_INTAKE","S02_REPO_STATE","S03_FRONTIER","S04_EVIDENCE",
    "S05_SCHEMA","S06_PROMOTION","S07_REVIEW","S08_MERGE_GATE","S09_LEARNING"
  )
  $stageSet = @{}
  foreach ($row in $chainRows) { $stageSet[$row.stage_id] = $true }
  foreach ($stage in $requiredStages) {
    if (-not $stageSet.ContainsKey($stage)) {
      $errors.Add("Missing agent chain stage: $stage")
    }
  }
  foreach ($row in $chainRows) {
    foreach ($field in @("agent_id","allowed_reads","blocked_writes","output_contract","validator","stop_condition")) {
      if ([string]::IsNullOrWhiteSpace($row.$field)) {
        $errors.Add("Missing $field for stage $($row.stage_id)")
      }
    }
  }

  $surfaceRows = Read-CsvRequired -Path $surfacePath
  $requiredSurfaces = @("github_pr","sharepoint","dataverse","power_platform","graph_admin","planner_sgin","agent365_copilot_mcp")
  $surfaceSet = @{}
  foreach ($row in $surfaceRows) { $surfaceSet[$row.surface] = $row }
  foreach ($surface in $requiredSurfaces) {
    if (-not $surfaceSet.ContainsKey($surface)) {
      $errors.Add("Missing governed surface: $surface")
    }
  }
  foreach ($surface in @("sharepoint","dataverse","power_platform","graph_admin")) {
    if ($surfaceSet.ContainsKey($surface)) {
      $row = $surfaceSet[$surface]
      if ($row.mode -notmatch "governed_read_information") {
        $errors.Add("Surface $surface must be governed_read_information by default")
      }
      if ($row.blocked_without_atomic_order -notmatch "write") {
        $errors.Add("Surface $surface must block writes without atomic order")
      }
    }
  }

  $waveRows = Read-CsvRequired -Path $wave2Path
  $requiredRepos = @(
    "torre-gemela-escribania",
    "cabina-universal-d",
    "microsoft-agents-governed-lab",
    "modo-on-foundation",
    "organizacion"
  )
  $repoSet = @{}
  foreach ($row in $waveRows) { $repoSet[$row.repo] = $row }
  foreach ($repo in $requiredRepos) {
    if (-not $repoSet.ContainsKey($repo)) {
      $errors.Add("Missing Wave 2 repo row: $repo")
    }
  }
  foreach ($row in $waveRows) {
    if ($row.auto_merge_allowed -ne "no") {
      $errors.Add("auto_merge_allowed must be no for $($row.repo)")
    }
  }
  if ($repoSet.ContainsKey("torre-gemela-escribania") -and $repoSet["torre-gemela-escribania"].review_state -ne "REVIEW_REQUIRED") {
    $errors.Add("Torre PR must remain REVIEW_REQUIRED in Wave 2")
  }
  if ($repoSet.ContainsKey("microsoft-agents-governed-lab") -and $repoSet["microsoft-agents-governed-lab"].wave2_status -ne "WAITING_CHECKS") {
    $errors.Add("Microsoft lab must remain WAITING_CHECKS in Wave 2")
  }

  $engine = Get-Content -LiteralPath $enginePath -Raw
  foreach ($marker in @(
    "MULTI_CANON_EXECUTION_ENGINE_ACTIVE_REPO_LOCAL_20260614",
    "ANALIZAR -> PRONAR -> PROMOVER -> CONFIRMAR -> EXPANDIR",
    "Write live por inferencia no",
    "Wave 2"
  )) {
    if ($engine -notmatch [regex]::Escape($marker)) {
      $errors.Add("Missing engine marker: $marker")
    }
  }

  $toolIndex = Join-Path $Root "tools\TOOL_INDEX.csv"
  $toolGovernance = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
  $matrixIndex = Join-Path $Root "matrices\MATRIX_INDEX.csv"
  foreach ($path in @($toolIndex, $toolGovernance, $matrixIndex)) {
    Test-File -Path $path -Errors $errors
  }
  if ((Get-Content -LiteralPath $toolIndex -Raw) -notmatch "tool.local_validate_multi_canon_execution_engine") {
    $errors.Add("TOOL_INDEX missing tool.local_validate_multi_canon_execution_engine")
  }
  if ((Get-Content -LiteralPath $toolGovernance -Raw) -notmatch "tool.local_validate_multi_canon_execution_engine") {
    $errors.Add("TOOL_GOVERNANCE_MATRIX missing tool.local_validate_multi_canon_execution_engine")
  }
  if ((Get-Content -LiteralPath $matrixIndex -Raw) -notmatch "multi_canon_wave2_stabilization_matrix") {
    $errors.Add("MATRIX_INDEX missing multi_canon_wave2_stabilization_matrix")
  }
}

$result = [ordered]@{
  status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
  engine = $enginePath
  wave2_matrix = $wave2Path
  error_count = $errors.Count
  errors = @($errors)
  warning_count = $warnings.Count
  warnings = @($warnings)
}

$result | ConvertTo-Json -Depth 5
if ($errors.Count -gt 0) { exit 1 }
