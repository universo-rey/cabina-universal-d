param(
  [string]$Root = "D:\.agents\codex",
  [string]$RepoRoot = "D:\"
)

$ErrorActionPreference = "Stop"

function Get-ChildPowerShell {
  $current = (Get-Process -Id $PID).Path
  if ($current -and (Test-Path -LiteralPath $current)) { return $current }
  if (Get-Command pwsh -ErrorAction SilentlyContinue) { return "pwsh" }
  return "powershell"
}

function Invoke-Orchestrator {
  param([string[]]$Arguments)
  $tool = Join-Path $Root "tools\local_run_change_aware_full_coverage_orchestrator.ps1"
  if (-not (Test-Path -LiteralPath $tool)) {
    throw "Missing orchestrator: $tool"
  }
  $ps = Get-ChildPowerShell
  $output = & $ps -NoProfile -File $tool -Root $Root -RepoRoot $RepoRoot @Arguments 2>&1
  $text = ($output | ForEach-Object { $_.ToString() }) -join "`n"
  if ([string]::IsNullOrWhiteSpace($text)) {
    throw "Orchestrator emitted no JSON"
  }
  try {
    return $text | ConvertFrom-Json
  } catch {
    throw "Orchestrator JSON parse failed: $($_.Exception.Message)"
  }
}

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$started = Get-Date
$validatePayload = $null
$planPayload = $null

try {
  $validatePayload = Invoke-Orchestrator -Arguments @("-ValidateManifest")
  if ($validatePayload.status -ne "PASS") {
    $errors.Add("Manifest or graph validation did not pass")
  }
  if ($validatePayload.manifest_valid -ne $true) {
    $errors.Add("manifest_valid was not true")
  }
  if ($validatePayload.graph_valid -ne $true) {
    $errors.Add("graph_valid was not true")
  }
} catch {
  $errors.Add($_.Exception.Message)
}

try {
  $planPayload = Invoke-Orchestrator -Arguments @("-BuildPlan", "-UseWorkingTreeChanges")
  if ($planPayload.status -ne "PASS") {
    $errors.Add("Plan build did not pass")
  }
  if ($planPayload.coverage_equivalence_planned -ne $true) {
    $errors.Add("Plan does not include every required test")
  }
  if ([int]$planPayload.required_test_count -lt 1) {
    $errors.Add("Plan has no required tests")
  }
  if ([int]$planPayload.missing_required_test_count -ne 0) {
    $errors.Add("Plan is missing required tests")
  }
} catch {
  $errors.Add($_.Exception.Message)
}

$finished = Get-Date
$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }

$payload = [pscustomobject]@{
  status = $status
  validator_id = "change_aware_full_coverage_orchestrator_static"
  root = $Root
  repo_root = $RepoRoot
  manifest_valid = if ($validatePayload) { [bool]$validatePayload.manifest_valid } else { $false }
  graph_valid = if ($validatePayload) { [bool]$validatePayload.graph_valid } else { $false }
  coverage_equivalence_planned = if ($planPayload) { [bool]$planPayload.coverage_equivalence_planned } else { $false }
  required_test_count = if ($planPayload) { [int]$planPayload.required_test_count } else { 0 }
  planned_test_count = if ($planPayload) { [int]$planPayload.planned_test_count } else { 0 }
  missing_required_test_count = if ($planPayload) { [int]$planPayload.missing_required_test_count } else { -1 }
  started_at = $started.ToString("o")
  finished_at = $finished.ToString("o")
  duration_ms = [int][Math]::Round(($finished - $started).TotalMilliseconds)
  warning_count = $warnings.Count
  warnings = @($warnings)
  error_count = $errors.Count
  errors = @($errors)
}

$payload | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
