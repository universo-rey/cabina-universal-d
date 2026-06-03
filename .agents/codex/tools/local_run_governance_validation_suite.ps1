param(
  [string]$Root = "D:\.agents\codex",
  [string]$RepoRoot = "D:\",
  [switch]$SkipWorkflowNestedValidators,
  [switch]$IncludePayloads,
  [switch]$WriteResult,
  [string]$ResultPath
)

$ErrorActionPreference = "Stop"

function Resolve-ToolPath {
  param([string]$RelativePath)
  return Join-Path $Root $RelativePath
}

function Get-ChildPowerShell {
  $current = (Get-Process -Id $PID).Path
  if ($current -and (Test-Path -LiteralPath $current)) {
    return $current
  }
  if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    return "pwsh"
  }
  return "powershell"
}

function New-SuiteResult {
  param(
    [string]$Id,
    [string]$Tool,
    [string]$Status,
    [int]$ExitCode,
    [datetime]$StartedAt,
    [datetime]$FinishedAt,
    [object]$Payload,
    [string[]]$Errors,
    [string[]]$Warnings,
    [string]$OutputExcerpt
  )

  $result = [ordered]@{
    id = $Id
    tool = $Tool
    status = $Status
    exit_code = $ExitCode
    started_at = $StartedAt.ToString("o")
    finished_at = $FinishedAt.ToString("o")
    duration_ms = [int][Math]::Round(($FinishedAt - $StartedAt).TotalMilliseconds)
    warning_count = @($Warnings).Count
    error_count = @($Errors).Count
    warnings = @($Warnings)
    errors = @($Errors)
  }

  if ($OutputExcerpt) {
    $result.output_excerpt = $OutputExcerpt
  }
  if ($IncludePayloads -and $Payload) {
    $result.payload = $Payload
  }

  return [pscustomobject]$result
}

function Get-PayloadProperty {
  param(
    [object]$Payload,
    [string]$Name,
    [object]$Default
  )
  if ($null -eq $Payload) { return $Default }
  $property = $Payload.PSObject.Properties[$Name]
  if ($null -eq $property) { return $Default }
  return $property.Value
}

function Invoke-ValidatorTool {
  param(
    [string]$Id,
    [string]$Tool,
    [string[]]$Arguments
  )

  $started = Get-Date
  $errors = New-Object System.Collections.Generic.List[string]
  $warnings = New-Object System.Collections.Generic.List[string]
  $payload = $null
  $status = "FAIL"
  $exitCode = 1
  $outputExcerpt = $null

  if (-not (Test-Path -LiteralPath $Tool)) {
    $finished = Get-Date
    $errors.Add("Missing validator tool: $Tool")
    return New-SuiteResult -Id $Id -Tool $Tool -Status "FAIL" -ExitCode 1 -StartedAt $started -FinishedAt $finished -Payload $null -Errors $errors -Warnings $warnings -OutputExcerpt $null
  }

  $ps = Get-ChildPowerShell
  $childArgs = @("-NoProfile", "-File", $Tool) + $Arguments

  try {
    $rawOutput = & $ps @childArgs 2>&1
    $exitCode = if ($null -eq $LASTEXITCODE) { 0 } else { [int]$LASTEXITCODE }
    $text = ($rawOutput | ForEach-Object { $_.ToString() }) -join "`n"
    if (-not [string]::IsNullOrWhiteSpace($text)) {
      try {
        $payload = $text | ConvertFrom-Json
        $status = [string]$payload.status
        if ([string]::IsNullOrWhiteSpace($status)) {
          $status = if ($exitCode -eq 0) { "PASS" } else { "FAIL" }
        }
        $payloadWarnings = @(Get-PayloadProperty -Payload $payload -Name "warnings" -Default @())
        $payloadErrors = @(Get-PayloadProperty -Payload $payload -Name "errors" -Default @())
        if ($payloadWarnings.Count -gt 0) {
          foreach ($warning in $payloadWarnings) { $warnings.Add([string]$warning) }
        }
        if ($payloadErrors.Count -gt 0) {
          foreach ($error in $payloadErrors) { $errors.Add([string]$error) }
        }
      } catch {
        $status = "FAIL"
        $errors.Add("Validator did not emit parseable JSON: $($_.Exception.Message)")
        $outputExcerpt = if ($text.Length -gt 1200) { $text.Substring(0, 1200) } else { $text }
      }
    } else {
      $status = if ($exitCode -eq 0) { "PASS" } else { "FAIL" }
      if ($exitCode -ne 0) {
        $errors.Add("Validator exited non-zero without output")
      }
    }
  } catch {
    $status = "FAIL"
    $exitCode = 1
    $errors.Add($_.Exception.Message)
  }

  if ($exitCode -ne 0 -and $errors.Count -eq 0) {
    $errors.Add("Validator exited with code $exitCode")
  }
  if ($status -ne "PASS" -and $errors.Count -eq 0) {
    $errors.Add("Validator status was $status")
  }

  $finished = Get-Date
  return New-SuiteResult -Id $Id -Tool $Tool -Status $status -ExitCode $exitCode -StartedAt $started -FinishedAt $finished -Payload $payload -Errors $errors -Warnings $warnings -OutputExcerpt $outputExcerpt
}

function Invoke-GitHubActionsPolicyCheck {
  $started = Get-Date
  $errors = New-Object System.Collections.Generic.List[string]
  $warnings = New-Object System.Collections.Generic.List[string]
  $matrixPath = Join-Path $Root "matrices\GITHUB_ACTIONS_WORKFLOW_MATRIX.csv"

  if (-not (Test-Path -LiteralPath $matrixPath)) {
    $errors.Add("Missing GitHub Actions workflow matrix: $matrixPath")
  } else {
    $rows = @(Import-Csv -LiteralPath $matrixPath)
    if ($rows.Count -lt 1) {
      $errors.Add("No GitHub Actions workflow rows declared")
    }
    foreach ($row in $rows) {
      if ($row.status -ne "APPROVED_GITHUB_ACTIONS_SURFACE") {
        $errors.Add("Workflow is not approved: $($row.workflow_id)")
      }
      if ($row.permissions -ne "contents:read") {
        $errors.Add("Workflow permissions must remain contents:read: $($row.workflow_id)")
      }
      foreach ($blocked in @("secrets", "production", "microsoft_live", "openai_api_live", "permission_write")) {
        if ($row.blocked_actions -notmatch $blocked) {
          $errors.Add("Workflow missing blocked action '$blocked': $($row.workflow_id)")
        }
      }
    }
  }

  $finished = Get-Date
  $payload = [pscustomobject]@{
    status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
    matrix_path = $matrixPath
    workflow_count = if (Test-Path -LiteralPath $matrixPath) { @(Import-Csv -LiteralPath $matrixPath).Count } else { 0 }
    error_count = $errors.Count
    errors = @($errors)
    warning_count = $warnings.Count
    warnings = @($warnings)
  }

  return New-SuiteResult -Id "github_actions_policy" -Tool "inline.github_actions_policy_check" -Status $payload.status -ExitCode $(if ($errors.Count -eq 0) { 0 } else { 1 }) -StartedAt $started -FinishedAt $finished -Payload $payload -Errors $errors -Warnings $warnings -OutputExcerpt $null
}

$suiteStarted = Get-Date
$results = New-Object System.Collections.Generic.List[object]

$validatorSpecs = @(
  @{ Id = "change_aware_orchestrator_static"; Tool = Resolve-ToolPath "tools\local_validate_change_aware_full_coverage_orchestrator.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "github_automation_preflight"; Tool = Resolve-ToolPath "tools\local_validate_github_automation_preflight.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "operational_chain"; Tool = Resolve-ToolPath "tools\local_validate_operational_chain.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "capability_use_hardening"; Tool = Resolve-ToolPath "tools\local_validate_capability_use_hardening.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "autonomous_agent_execution"; Tool = Resolve-ToolPath "tools\local_validate_autonomous_agent_execution.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "agents_instruction_hierarchy"; Tool = Resolve-ToolPath "tools\local_validate_agents_instruction_hierarchy.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "skill_metadata"; Tool = Resolve-ToolPath "tools\local_validate_skill_metadata.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "document_skill_lane"; Tool = Resolve-ToolPath "tools\local_validate_document_skill_lane.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "skill_reference_sources"; Tool = Resolve-ToolPath "tools\local_validate_skill_reference_sources.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "frontend_design_lane"; Tool = Resolve-ToolPath "tools\local_validate_frontend_design_lane.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "codex_cloud_governed_lane"; Tool = Resolve-ToolPath "tools\local_validate_codex_cloud_governed_lane.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "codex_app_environments"; Tool = Resolve-ToolPath "tools\local_validate_codex_app_environments.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "teams_cross_repo_lane_audit"; Tool = Resolve-ToolPath "tools\local_validate_teams_cross_repo_lane_audit.ps1"; Args = @("-Root", $Root) },
  @{ Id = "runtime_alignment"; Tool = Resolve-ToolPath "tools\local_run_repo_alignment_runtime.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot, "-NoWrite") },
  @{ Id = "parallel_order_governance"; Tool = Resolve-ToolPath "tools\local_validate_parallel_order_governance.ps1"; Args = @("-Root", $Root) },
  @{ Id = "parallel_issue_queue"; Tool = Resolve-ToolPath "tools\local_validate_parallel_issue_queue.ps1"; Args = @("-Root", $Root, "-RepoRoot", $RepoRoot) },
  @{ Id = "order_packets"; Tool = Resolve-ToolPath "tools\local_validate_order_packets.ps1"; Args = @("-Root", $Root) }
)

$agentLayerArgs = @("-Root", $Root)
if ($SkipWorkflowNestedValidators) {
  $agentLayerArgs += "-SkipWorkflowNestedValidators"
}
$validatorSpecs += @{ Id = "agent_layer"; Tool = Resolve-ToolPath "tools\local_validate_agent_layer.ps1"; Args = $agentLayerArgs }

foreach ($spec in $validatorSpecs) {
  $results.Add((Invoke-ValidatorTool -Id $spec.Id -Tool $spec.Tool -Arguments $spec.Args))
}
$results.Add((Invoke-GitHubActionsPolicyCheck))

$suiteFinished = Get-Date
$resultArray = @($results.ToArray())
$failed = @($resultArray | Where-Object { $_.status -ne "PASS" -or $_.exit_code -ne 0 })
$passedCount = @($resultArray | Where-Object { $_.status -eq "PASS" -and $_.exit_code -eq 0 }).Count
$warningCount = [int](($resultArray | Measure-Object -Property warning_count -Sum).Sum)
$errorCount = [int](($resultArray | Measure-Object -Property error_count -Sum).Sum)
$status = if ($failed.Count -eq 0) { "PASS" } else { "FAIL" }

if ([string]::IsNullOrWhiteSpace($ResultPath)) {
  $ResultPath = Join-Path $Root "evals\results\governance_validation_suite_latest.json"
}

$payload = [pscustomobject]@{
  status = $status
  suite_id = "governance_validation_suite"
  mode = "MAIN_GOVERNANCE_GATE"
  root = $Root
  repo_root = $RepoRoot
  skip_workflow_nested_validators = [bool]$SkipWorkflowNestedValidators
  include_payloads = [bool]$IncludePayloads
  validator_count = $results.Count
  passed_count = $passedCount
  failed_count = $failed.Count
  warning_count = $warningCount
  error_count = $errorCount
  started_at = $suiteStarted.ToString("o")
  finished_at = $suiteFinished.ToString("o")
  duration_ms = [int][Math]::Round(($suiteFinished - $suiteStarted).TotalMilliseconds)
  result_path = $ResultPath
  result_written = $false
  results = @($resultArray)
}

if ($WriteResult) {
  $resultDir = Split-Path -Parent $ResultPath
  New-Item -ItemType Directory -Force -Path $resultDir | Out-Null
  $payload.result_written = $true
  $payload | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ResultPath -Encoding UTF8
}

$payload | ConvertTo-Json -Depth 8

if ($status -ne "PASS") {
  exit 1
}
