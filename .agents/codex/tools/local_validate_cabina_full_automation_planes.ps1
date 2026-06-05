param(
  [string]$Root = ".agents\codex",
  [string]$RepoRoot = "."
)

$ErrorActionPreference = "Stop"

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing CSV: $Path"
  }
  return @(Import-Csv -LiteralPath $Path)
}

function New-StringSet {
  param([object[]]$Values)
  $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($value in @($Values)) {
    if (-not [string]::IsNullOrWhiteSpace([string]$value)) {
      [void]$set.Add([string]$value)
    }
  }
  return $set
}

function Test-Columns {
  param(
    [string]$Path,
    [string[]]$RequiredColumns,
    [System.Collections.Generic.List[string]]$Errors
  )
  $header = Get-Content -LiteralPath $Path -TotalCount 1
  $actual = @($header -split ",")
  $actualSet = New-StringSet -Values $actual
  foreach ($column in $RequiredColumns) {
    if (-not $actualSet.Contains($column)) {
      $Errors.Add("Missing column '$column' in $Path")
    }
  }
}

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

$matrixPath = Join-Path $Root "matrices\CABINA_FULL_AUTOMATION_PLANE_MATRIX_20260605.csv"
$canonPath = Join-Path $RepoRoot "governance\canon\CABINA_FULL_AUTOMATION_BY_PLANES.md"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$matrixIndexPath = Join-Path $Root "matrices\MATRIX_INDEX.csv"
$validationCoveragePath = Join-Path $Root "matrices\VALIDATION_COVERAGE_MATRIX.csv"
$evidenceValidationPath = Join-Path $Root "matrices\EVIDENCE_AND_VALIDATION_MATRIX.csv"

if (-not (Test-Path -LiteralPath $canonPath)) {
  $errors.Add("Missing canon automation contract: $canonPath")
}

$requiredColumns = @(
  "plane_id",
  "plane_name",
  "purpose",
  "input",
  "output",
  "owner_agent",
  "required_skill",
  "required_recipe",
  "tool_or_command",
  "validator",
  "evidence",
  "auto_executable",
  "human_gate_required",
  "blocked_surfaces",
  "next_plane",
  "stop_condition"
)
Test-Columns -Path $matrixPath -RequiredColumns $requiredColumns -Errors $errors

$rows = Read-CsvRequired -Path $matrixPath
$expectedPlanes = @(
  "P01_INTAKE",
  "P02_CLASSIFICATION",
  "P03_AGENTS",
  "P04_SKILLS",
  "P05_RECIPES",
  "P06_CODEX_CLOUD",
  "P07_GIT_LOCAL",
  "P08_GITHUB",
  "P09_VALIDATION",
  "P10_FAN_IN",
  "P11_GATES",
  "P12_EVIDENCE",
  "P13_READBACK",
  "P14_OBSERVABILITY",
  "P15_EVOLUTION"
)

if ($rows.Count -ne $expectedPlanes.Count) {
  $errors.Add("Plane matrix must contain exactly $($expectedPlanes.Count) rows. Found $($rows.Count)")
}

$planeIds = @($rows | ForEach-Object { $_.plane_id })
$planeSet = New-StringSet -Values $planeIds
foreach ($plane in $expectedPlanes) {
  if (-not $planeSet.Contains($plane)) {
    $errors.Add("Missing required plane: $plane")
  }
}

for ($i = 0; $i -lt $expectedPlanes.Count; $i++) {
  if ($i -lt $rows.Count -and $rows[$i].plane_id -ne $expectedPlanes[$i]) {
    $errors.Add("Plane order mismatch at position $($i + 1): expected $($expectedPlanes[$i]) got $($rows[$i].plane_id)")
  }
}

$toolRows = Read-CsvRequired -Path $toolIndexPath
$toolIds = New-StringSet -Values @($toolRows | ForEach-Object { $_.tool_id })
$recipeRows = Read-CsvRequired -Path $recipeIndexPath
$recipeIds = New-StringSet -Values @($recipeRows | ForEach-Object { $_.recipe_id })

foreach ($row in $rows) {
  foreach ($column in $requiredColumns) {
    if ([string]::IsNullOrWhiteSpace($row.$column)) {
      $errors.Add("$($row.plane_id) has blank required column: $column")
    }
  }

  if ($row.auto_executable -notin @("true", "false")) {
    $errors.Add("$($row.plane_id) auto_executable must be true or false")
  }

  if ($row.required_recipe -ne "NO_APLICA" -and -not $recipeIds.Contains($row.required_recipe)) {
    $errors.Add("$($row.plane_id) references unknown recipe: $($row.required_recipe)")
  }

  if ($row.tool_or_command -match "^tool\." -and -not $toolIds.Contains($row.tool_or_command)) {
    $errors.Add("$($row.plane_id) references unknown tool: $($row.tool_or_command)")
  }

  if ($row.validator -match "^\." -and -not (Test-Path -LiteralPath $row.validator)) {
    $errors.Add("$($row.plane_id) validator path missing: $($row.validator)")
  }

  if ($row.human_gate_required -eq "none" -and $row.blocked_surfaces -match "production|microsoft_live_write|openai_api_live|permission_change|tenant_write|merge_without_approved_precheck|codex_cloud_apply_without_review") {
    if ($row.plane_id -notin @("P06_CODEX_CLOUD", "P08_GITHUB", "P11_GATES")) {
      $warnings.Add("$($row.plane_id) blocks critical surfaces but does not require human gate; accepted only if the plane stops before executing those surfaces")
    }
  }
}

for ($i = 0; $i -lt ($expectedPlanes.Count - 1); $i++) {
  $row = $rows[$i]
  $expectedNext = $expectedPlanes[$i + 1]
  if ($row.next_plane -ne $expectedNext) {
    $errors.Add("$($row.plane_id) next_plane must be $expectedNext")
  }
}
if ($rows[-1].next_plane -ne "END") {
  $errors.Add("P15_EVOLUTION next_plane must be END")
}

$matrixIndexRows = Read-CsvRequired -Path $matrixIndexPath
if (-not (New-StringSet -Values @($matrixIndexRows | ForEach-Object { $_.matrix_id })).Contains("cabina_full_automation_plane_matrix")) {
  $errors.Add("MATRIX_INDEX missing cabina_full_automation_plane_matrix")
}

$validationRows = Read-CsvRequired -Path $validationCoveragePath
if (-not (New-StringSet -Values @($validationRows | ForEach-Object { $_.artifact_class })).Contains("cabina_full_automation_planes")) {
  $errors.Add("VALIDATION_COVERAGE_MATRIX missing cabina_full_automation_planes")
}

$evidenceRows = Read-CsvRequired -Path $evidenceValidationPath
if (-not (New-StringSet -Values @($evidenceRows | ForEach-Object { $_.event_type })).Contains("cabina_full_automation_planes")) {
  $errors.Add("EVIDENCE_AND_VALIDATION_MATRIX missing cabina_full_automation_planes")
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }

[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  plane_count = $rows.Count
  required_plane_count = $expectedPlanes.Count
  auto_executable_count = @($rows | Where-Object { $_.auto_executable -eq "true" }).Count
  human_gate_plane_count = @($rows | Where-Object { $_.human_gate_required -ne "none" }).Count
  warning_count = $warnings.Count
  warnings = @($warnings)
  error_count = $errors.Count
  errors = @($errors)
} | ConvertTo-Json -Depth 5

if ($status -ne "PASS") {
  exit 1
}
