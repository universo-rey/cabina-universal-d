param(
  [string]$Root = ".agents\codex",
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d",
  [string]$BaseRef = "origin/main",
  [string]$HeadRef = "HEAD",
  [switch]$ValidateManifest,
  [switch]$BuildPlan,
  [switch]$ExecutePlan,
  [switch]$VerifyCoverageEquivalence,
  [switch]$EmitAuditArtifact,
  [switch]$UseWorkingTreeChanges,
  [string]$AuditPath
)

$ErrorActionPreference = "Stop"

$manifestPath = Join-Path $Root "matrices\CHANGE_AWARE_TEST_MANIFEST.csv"
$riskPath = Join-Path $Root "matrices\CHANGE_AWARE_RISK_POLICY.csv"
$graphPath = Join-Path $Root "matrices\CHANGE_AWARE_IMPACT_GRAPH.csv"

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required CSV: $Path"
  }
  return @(Import-Csv -LiteralPath $Path)
}

function New-StringList {
  return ,([System.Collections.Generic.List[string]]::new())
}

function Convert-ToBool {
  param([object]$Value)
  return ([string]$Value).Trim().Equals("true", [System.StringComparison]::OrdinalIgnoreCase)
}

function Split-List {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) { return @() }
  return @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function Split-Arguments {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) { return @() }
  return @($Value -split ";" | ForEach-Object {
    $_.Trim().Replace("{Root}", $Root).Replace("{RepoRoot}", $RepoRoot)
  } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function Resolve-CabinaPath {
  param([string]$Path)
  if ([string]::IsNullOrWhiteSpace($Path)) { return $Path }
  if ($Path.StartsWith("inline.", [System.StringComparison]::OrdinalIgnoreCase)) {
    return $Path
  }
  $normalized = $Path -replace "/", "\"
  if ($normalized.StartsWith(".agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $Root ($normalized.Substring(".agents\codex".Length).TrimStart("\"))
  }
  if ($normalized.StartsWith("C:\Users\enzo1\Documents\GitHub\cabina-universal-d", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $RepoRoot ($normalized.Substring("C:\Users\enzo1\Documents\GitHub\cabina-universal-d".Length).TrimStart("\"))
  }
  return Join-Path $RepoRoot $normalized
}

function Test-PathPattern {
  param(
    [string]$Path,
    [string]$Pattern
  )
  $normalizedPath = ($Path -replace "\\", "/").TrimStart("/")
  $normalizedPattern = ($Pattern -replace "\\", "/").TrimStart("/")
  $wildcard = $normalizedPattern.Replace("**", "*")
  return $normalizedPath -like $wildcard
}

function Get-ChildPowerShell {
  $current = (Get-Process -Id $PID).Path
  if ($current -and (Test-Path -LiteralPath $current)) { return $current }
  if (Get-Command pwsh -ErrorAction SilentlyContinue) { return "pwsh" }
  return "powershell"
}

function Get-ObjectProperty {
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

function Test-RequiredColumns {
  param(
    [string]$Path,
    [object[]]$Rows,
    [string[]]$Columns,
    [System.Collections.Generic.List[string]]$Errors
  )
  if ($Rows.Count -lt 1) {
    $Errors.Add("No rows in $Path")
    return
  }
  $actual = @($Rows[0].PSObject.Properties.Name)
  foreach ($column in $Columns) {
    if ($actual -notcontains $column) {
      $Errors.Add("Missing column '$column' in $Path")
    }
  }
}

function Test-ManifestAndGraph {
  $errors = New-StringList
  $warnings = New-StringList
  $manifestRows = @()
  $riskRows = @()
  $graphRows = @()

  try { $manifestRows = Read-CsvRequired -Path $manifestPath } catch { $errors.Add($_.Exception.Message) }
  try { $riskRows = Read-CsvRequired -Path $riskPath } catch { $errors.Add($_.Exception.Message) }
  try { $graphRows = Read-CsvRequired -Path $graphPath } catch { $errors.Add($_.Exception.Message) }

  if ($manifestRows.Count -gt 0) {
    Test-RequiredColumns -Path $manifestPath -Rows $manifestRows -Columns @("test_id","required","command","arguments","coverage_tags","priority","blocks_merge","blocks_release","flaky_policy","timeout_seconds","runner_group") -Errors $errors
  }
  if ($riskRows.Count -gt 0) {
    Test-RequiredColumns -Path $riskPath -Rows $riskRows -Columns @("risk_id","path_pattern","risk_level","priority","parallelism","required_tags","expansion","blocks_release","reason") -Errors $errors
  }
  if ($graphRows.Count -gt 0) {
    Test-RequiredColumns -Path $graphPath -Rows $graphRows -Columns @("graph_id","source_pattern","impacted_tags","priority_boost","additional_test_ids","expansion","reason") -Errors $errors
  }

  $testIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  $requiredCount = 0
  foreach ($row in $manifestRows) {
    if ([string]::IsNullOrWhiteSpace($row.test_id)) {
      $errors.Add("Manifest row has empty test_id")
      continue
    }
    if (-not $testIds.Add($row.test_id)) {
      $errors.Add("Duplicate test_id: $($row.test_id)")
    }
    if (Convert-ToBool $row.required) {
      $requiredCount++
      if ($row.flaky_policy -ne "fail_visible") {
        $errors.Add("Required test must use fail_visible flaky policy: $($row.test_id)")
      }
    }
    if ([string]::IsNullOrWhiteSpace($row.command)) {
      $errors.Add("Manifest row has empty command: $($row.test_id)")
    } elseif (-not $row.command.StartsWith("inline.", [System.StringComparison]::OrdinalIgnoreCase)) {
      $resolved = Resolve-CabinaPath -Path $row.command
      if (-not (Test-Path -LiteralPath $resolved)) {
        $errors.Add("Manifest command does not exist for $($row.test_id): $resolved")
      }
    }
    $priority = 0
    if (-not [int]::TryParse([string]$row.priority, [ref]$priority)) {
      $errors.Add("Invalid priority for $($row.test_id)")
    }
  }
  if ($requiredCount -lt 1) {
    $errors.Add("Manifest declares no required tests")
  }

  foreach ($edge in $graphRows) {
    foreach ($testId in (Split-List $edge.additional_test_ids)) {
      if (-not $testIds.Contains($testId)) {
        $errors.Add("Impact graph references unknown test_id '$testId' in $($edge.graph_id)")
      }
    }
    $boost = 0
    if (-not [int]::TryParse([string]$edge.priority_boost, [ref]$boost)) {
      $errors.Add("Invalid priority_boost in $($edge.graph_id)")
    }
  }

  foreach ($risk in $riskRows) {
    $priority = 0
    $parallelism = 0
    if (-not [int]::TryParse([string]$risk.priority, [ref]$priority)) {
      $errors.Add("Invalid priority in $($risk.risk_id)")
    }
    if (-not [int]::TryParse([string]$risk.parallelism, [ref]$parallelism) -or $parallelism -lt 1) {
      $errors.Add("Invalid parallelism in $($risk.risk_id)")
    }
  }

  return [pscustomobject]@{
    manifest_rows = $manifestRows
    risk_rows = $riskRows
    graph_rows = $graphRows
    manifest_valid = ($errors.Count -eq 0 -and $manifestRows.Count -gt 0)
    graph_valid = ($errors.Count -eq 0 -and $graphRows.Count -gt 0 -and $riskRows.Count -gt 0)
    errors = @($errors)
    warnings = @($warnings)
    required_count = $requiredCount
  }
}

function Get-GitChangedFiles {
  $errors = New-StringList
  $files = New-Object System.Collections.Generic.List[string]
  $impactUnknown = $false

  if ($UseWorkingTreeChanges) {
    try {
      $statusLines = & git -C $RepoRoot status --porcelain 2>$null
      if ($LASTEXITCODE -ne 0) { throw "git status failed" }
      foreach ($line in @($statusLines)) {
        if ($line.Length -lt 4) { continue }
        $path = $line.Substring(3).Trim()
        if ($path -match " -> ") {
          $parts = $path -split " -> "
          $path = $parts[$parts.Length - 1]
        }
        if (-not [string]::IsNullOrWhiteSpace($path)) {
          $files.Add(($path -replace "\\", "/"))
        }
      }
    } catch {
      $errors.Add($_.Exception.Message)
      $impactUnknown = $true
    }
  } else {
    try {
      $diffLines = & git -C $RepoRoot diff --name-only $BaseRef $HeadRef 2>$null
      if ($LASTEXITCODE -ne 0) { throw "git diff failed for $BaseRef $HeadRef" }
      foreach ($line in @($diffLines)) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
          $files.Add(($line -replace "\\", "/"))
        }
      }
    } catch {
      $errors.Add($_.Exception.Message)
      $impactUnknown = $true
    }
  }

  $unique = @($files.ToArray() | Sort-Object -Unique)
  if ($unique.Count -eq 0 -and -not $UseWorkingTreeChanges) {
    $impactUnknown = $true
    $errors.Add("No changed files were detected from git diff; using full expansion")
  }

  return [pscustomobject]@{
    files = $unique
    impact_unknown = $impactUnknown
    errors = @($errors)
  }
}

function Test-BlockedSurfaces {
  param([string[]]$ChangedFiles)
  $blocked = New-Object System.Collections.Generic.List[object]
  $governedBoundaryEvidencePaths = @(
    "dataverse/data/seed_connection_secret_boundaries.csv",
    "matrices/connections/connection_secret_boundary_matrix.csv",
    "governance/connections/sdu_agent_connection_secrets_variables_contract_20260603.md",
    "governance/connections/sdu_dev_activation_secrets_checklist_20260603.md",
    ".agents/codex/workpapers/2026-06-12_dataverse_branch_evidence_multi_cabina/20_ORDER_PACKET_SECRET_REGULATED_BOUNDARY.md",
    "scripts/validators/sdu_agent_connection_secrets_contract_validator.py",
    "scripts/validators/sdu_dev_activation_secret_contract_validator.py",
    "validation/versioning/local_package_secret_scan_report.md"
  )
  $patterns = @(
    @{ pattern = ".env"; reason = "secret_file" },
    @{ pattern = ".env.*"; reason = "secret_file" },
    @{ pattern = "*secret*"; reason = "secret_path" },
    @{ pattern = "*secreto*"; reason = "secret_path" },
    @{ pattern = "*token*"; reason = "secret_path" },
    @{ pattern = "*credential*"; reason = "credential_path" },
    @{ pattern = "*password*"; reason = "password_path" },
    @{ pattern = "*/production/*"; reason = "production_path" },
    @{ pattern = "*/tenant/*"; reason = "tenant_path" }
  )
  foreach ($file in @($ChangedFiles)) {
    $normalized = ($file -replace "\\", "/").ToLowerInvariant()
    $leaf = Split-Path -Leaf ($file -replace "/", "\")
    foreach ($entry in $patterns) {
      if ($file -like $entry.pattern -or $leaf -like $entry.pattern) {
        if ($entry.reason -eq "secret_path" -and $governedBoundaryEvidencePaths -contains $normalized) {
          continue
        }
        $blocked.Add([pscustomobject]@{ path = $file; reason = $entry.reason })
      }
    }
  }
  return @($blocked.ToArray())
}

function New-ExecutionPlan {
  param([object]$Validation)
  $change = Get-GitChangedFiles
  $blocked = Test-BlockedSurfaces -ChangedFiles $change.files
  $riskMatches = New-Object System.Collections.Generic.List[object]
  $graphMatches = New-Object System.Collections.Generic.List[object]
  $priorityById = @{}
  $reasonsById = @{}
  $parallelism = 3
  $expansionApplied = $false

  foreach ($row in $Validation.manifest_rows) {
    $priorityById[$row.test_id] = [int]$row.priority
    $reasonsById[$row.test_id] = New-StringList
    if (Convert-ToBool $row.required) {
      $reasonsById[$row.test_id].Add("mandatory_full_coverage")
    }
  }

  foreach ($file in @($change.files)) {
    $matchedAny = $false
    foreach ($risk in $Validation.risk_rows) {
      if (Test-PathPattern -Path $file -Pattern $risk.path_pattern) {
        $matchedAny = $true
        $expansionApplied = $true
        $parallelism = [Math]::Min($parallelism, [int]$risk.parallelism)
        $riskMatches.Add([pscustomobject]@{
          path = $file
          risk_id = $risk.risk_id
          risk_level = $risk.risk_level
          expansion = $risk.expansion
          reason = $risk.reason
        })
        $tags = Split-List $risk.required_tags
        foreach ($row in $Validation.manifest_rows) {
          $rowTags = Split-List $row.coverage_tags
          if (@($rowTags | Where-Object { $tags -contains $_ }).Count -gt 0 -or $tags -contains "all") {
            $priorityById[$row.test_id] = [Math]::Min([int]$priorityById[$row.test_id], [int]$risk.priority)
            $reasonsById[$row.test_id].Add("risk:$($risk.risk_id)")
          }
        }
      }
    }
    foreach ($edge in $Validation.graph_rows) {
      if (Test-PathPattern -Path $file -Pattern $edge.source_pattern) {
        $matchedAny = $true
        $expansionApplied = $true
        $graphMatches.Add([pscustomobject]@{
          path = $file
          graph_id = $edge.graph_id
          expansion = $edge.expansion
          reason = $edge.reason
        })
        $edgeTags = Split-List $edge.impacted_tags
        $edgeTestIds = Split-List $edge.additional_test_ids
        foreach ($row in $Validation.manifest_rows) {
          $rowTags = Split-List $row.coverage_tags
          if (@($rowTags | Where-Object { $edgeTags -contains $_ }).Count -gt 0 -or $edgeTags -contains "all" -or $edgeTestIds -contains $row.test_id) {
            $priorityById[$row.test_id] = [Math]::Min([int]$priorityById[$row.test_id], [int]$edge.priority_boost)
            $reasonsById[$row.test_id].Add("impact:$($edge.graph_id)")
          }
        }
      }
    }
    if (-not $matchedAny) {
      $change.impact_unknown = $true
    }
  }

  if ($change.impact_unknown) {
    $expansionApplied = $true
    foreach ($row in $Validation.manifest_rows) {
      $priorityById[$row.test_id] = [Math]::Min([int]$priorityById[$row.test_id], 1)
      $reasonsById[$row.test_id].Add("impact_unknown_expand_execution")
    }
  }

  $planned = New-Object System.Collections.Generic.List[object]
  foreach ($row in $Validation.manifest_rows) {
    $required = Convert-ToBool $row.required
    if ($required) {
      $planned.Add([pscustomobject]@{
        test_id = $row.test_id
        required = $required
        command = $row.command
        arguments = $row.arguments
        coverage_tags = $row.coverage_tags
        priority = [int]$priorityById[$row.test_id]
        blocks_merge = Convert-ToBool $row.blocks_merge
        blocks_release = Convert-ToBool $row.blocks_release
        flaky_policy = $row.flaky_policy
        timeout_seconds = [int]$row.timeout_seconds
        runner_group = $row.runner_group
        reasons = @($reasonsById[$row.test_id].ToArray() | Sort-Object -Unique)
      })
    }
  }

  $plannedArray = @($planned.ToArray() | Sort-Object priority, runner_group, test_id)
  $requiredIds = @($Validation.manifest_rows | Where-Object { Convert-ToBool $_.required } | ForEach-Object { $_.test_id })
  $plannedIds = @($plannedArray | ForEach-Object { $_.test_id })
  $missing = @($requiredIds | Where-Object { $plannedIds -notcontains $_ })

  return [pscustomobject]@{
    changed_files = @($change.files)
    change_detection_errors = @($change.errors)
    impact_unknown = [bool]$change.impact_unknown
    expansion_applied = [bool]$expansionApplied
    risk_matches = @($riskMatches.ToArray())
    graph_matches = @($graphMatches.ToArray())
    blocked_surfaces = @($blocked)
    blocked_surfaces_clear = (@($blocked).Count -eq 0)
    max_parallel = [Math]::Max(1, $parallelism)
    required_tests = @($requiredIds)
    planned_tests = @($plannedArray)
    missing_required_tests = @($missing)
    coverage_equivalence_planned = ($missing.Count -eq 0 -and $plannedArray.Count -ge $requiredIds.Count)
  }
}

function Invoke-GitHubActionsPolicyCheck {
  $errors = New-StringList
  $warnings = New-StringList
  $workflowPath = Join-Path $RepoRoot ".github\workflows\cabina-validation.yml"
  $matrixPath = Join-Path $Root "matrices\GITHUB_ACTIONS_WORKFLOW_MATRIX.csv"

  if (-not (Test-Path -LiteralPath $workflowPath)) {
    $errors.Add("Missing workflow: $workflowPath")
  } else {
    $workflowText = Get-Content -LiteralPath $workflowPath -Raw
    $nativeGateBypass = "continue" + "-on-error"
    foreach ($blockedText in @($nativeGateBypass, "contents: write", "write-all", "secrets.", "environment: production")) {
      if ($workflowText -match [regex]::Escape($blockedText)) {
        $errors.Add("Workflow contains blocked token: $blockedText")
      }
    }
    if ($workflowText -notmatch "contents:\s*read") {
      $errors.Add("Workflow must keep contents: read permissions")
    }
    if ($workflowText -notmatch "local_run_change_aware_full_coverage_orchestrator\.ps1") {
      $errors.Add("Workflow must call the change-aware full coverage orchestrator")
    }
  }

  if (-not (Test-Path -LiteralPath $matrixPath)) {
    $errors.Add("Missing workflow matrix: $matrixPath")
  } else {
    $rows = @(Import-Csv -LiteralPath $matrixPath)
    foreach ($row in $rows) {
      if ($row.permissions -ne "contents:read") {
        $errors.Add("Workflow matrix permissions must be contents:read")
      }
      if ($row.workflow_id -eq "cabina_validation" -and $row.validator -notmatch "tool.local_run_change_aware_full_coverage_orchestrator") {
        $errors.Add("cabina_validation workflow matrix row must name the orchestrator validator")
      }
      foreach ($blocked in @("secrets", "production", "microsoft_live", "openai_api_live", "permission_write")) {
        if ($row.blocked_actions -notmatch $blocked) {
          $errors.Add("Workflow matrix missing blocked action: $blocked")
        }
      }
    }
  }

  return [pscustomobject]@{
    status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
    warning_count = $warnings.Count
    warnings = @($warnings)
    error_count = $errors.Count
    errors = @($errors)
  }
}

function Invoke-PlanItem {
  param([object]$Item)
  $started = Get-Date
  $errors = New-StringList
  $warnings = New-StringList
  $payload = $null
  $status = "FAIL"
  $exitCode = 1

  if ($Item.command -eq "inline.github_actions_policy_check") {
    $payload = Invoke-GitHubActionsPolicyCheck
    $status = $payload.status
    $exitCode = if ($status -eq "PASS") { 0 } else { 1 }
    foreach ($error in @($payload.errors)) { $errors.Add([string]$error) }
    foreach ($warning in @($payload.warnings)) { $warnings.Add([string]$warning) }
  } else {
    $tool = Resolve-CabinaPath -Path $Item.command
    if (-not (Test-Path -LiteralPath $tool)) {
      $errors.Add("Missing required test command: $tool")
    } else {
      $ps = Get-ChildPowerShell
      $args = @("-NoProfile", "-File", $tool) + (Split-Arguments $Item.arguments)
      try {
        $rawOutput = & $ps @args 2>&1
        $exitCode = if ($null -eq $LASTEXITCODE) { 0 } else { [int]$LASTEXITCODE }
        $text = ($rawOutput | ForEach-Object { $_.ToString() }) -join "`n"
        if (-not [string]::IsNullOrWhiteSpace($text)) {
          try {
            $payload = $text | ConvertFrom-Json
            $status = [string](Get-ObjectProperty -Payload $payload -Name "status" -Default $(if ($exitCode -eq 0) { "PASS" } else { "FAIL" }))
            foreach ($error in @(Get-ObjectProperty -Payload $payload -Name "errors" -Default @())) { $errors.Add([string]$error) }
            foreach ($warning in @(Get-ObjectProperty -Payload $payload -Name "warnings" -Default @())) { $warnings.Add([string]$warning) }
          } catch {
            $status = "FAIL"
            $errors.Add("Required test did not emit parseable JSON")
          }
        } else {
          $status = if ($exitCode -eq 0) { "PASS" } else { "FAIL" }
        }
      } catch {
        $status = "FAIL"
        $exitCode = 1
        $errors.Add($_.Exception.Message)
      }
    }
  }

  if ($exitCode -ne 0 -and $errors.Count -eq 0) {
    $errors.Add("Required test exited with code $exitCode")
  }
  if ($status -ne "PASS" -and $errors.Count -eq 0) {
    $errors.Add("Required test status was $status")
  }

  $finished = Get-Date
  return [pscustomobject]@{
    test_id = $Item.test_id
    required = [bool]$Item.required
    status = $status
    exit_code = $exitCode
    started_at = $started.ToString("o")
    finished_at = $finished.ToString("o")
    duration_ms = [int][Math]::Round(($finished - $started).TotalMilliseconds)
    warning_count = $warnings.Count
    error_count = $errors.Count
    warnings = @($warnings)
    errors = @($errors)
  }
}

function Test-CoverageEquivalence {
  param(
    [object]$Validation,
    [object]$Plan,
    [object[]]$Results
  )
  $requiredIds = @($Validation.manifest_rows | Where-Object { Convert-ToBool $_.required } | ForEach-Object { $_.test_id })
  $executedIds = @($Results | Where-Object { $_.required } | ForEach-Object { $_.test_id })
  $missing = @($requiredIds | Where-Object { $executedIds -notcontains $_ })
  $failed = @($Results | Where-Object { $_.required -and ($_.status -ne "PASS" -or $_.exit_code -ne 0) } | ForEach-Object { $_.test_id })
  $hiddenFlaky = @($Results | Where-Object { $_.required -and $_.status -eq "FLAKY_HIDDEN" } | ForEach-Object { $_.test_id })
  $allRequiredPassed = ($missing.Count -eq 0 -and $failed.Count -eq 0)
  $noHiddenFlaky = ($hiddenFlaky.Count -eq 0)
  $coverageEquivalence = (
    [bool]$Validation.manifest_valid -and
    [bool]$Validation.graph_valid -and
    [bool]$Plan.coverage_equivalence_planned -and
    $allRequiredPassed -and
    $noHiddenFlaky -and
    [bool]$Plan.blocked_surfaces_clear
  )

  return [pscustomobject]@{
    required_test_count = $requiredIds.Count
    executed_required_test_count = $executedIds.Count
    missing_required_tests = @($missing)
    failed_required_tests = @($failed)
    hidden_flaky_tests = @($hiddenFlaky)
    all_required_passed = [bool]$allRequiredPassed
    coverage_equivalence = [bool]$coverageEquivalence
    no_hidden_flaky = [bool]$noHiddenFlaky
  }
}

function New-BasePayload {
  param(
    [string]$Status,
    [object]$Validation,
    [object]$Plan,
    [object[]]$Results,
    [object]$Equivalence,
    [datetime]$StartedAt,
    [datetime]$FinishedAt
  )

  $payload = [ordered]@{
    status = $Status
    orchestrator_id = "change_aware_full_coverage_orchestrator"
    mode = "PRODUCTIVE_FULL_COVERAGE_GATE"
    root = $Root
    repo_root = $RepoRoot
    base_ref = $BaseRef
    head_ref = $HeadRef
    manifest_path = $manifestPath
    risk_policy_path = $riskPath
    impact_graph_path = $graphPath
    manifest_valid = [bool]$Validation.manifest_valid
    graph_valid = [bool]$Validation.graph_valid
    required_test_count = [int]$Validation.required_count
    changed_files = if ($Plan) { @($Plan.changed_files) } else { @() }
    impact_unknown = if ($Plan) { [bool]$Plan.impact_unknown } else { $false }
    expansion_applied = if ($Plan) { [bool]$Plan.expansion_applied } else { $false }
    blocked_surfaces_clear = if ($Plan) { [bool]$Plan.blocked_surfaces_clear } else { $false }
    blocked_surfaces = if ($Plan) { @($Plan.blocked_surfaces) } else { @() }
    max_parallel = if ($Plan) { [int]$Plan.max_parallel } else { 0 }
    coverage_equivalence_planned = if ($Plan) { [bool]$Plan.coverage_equivalence_planned } else { $false }
    missing_required_test_count = if ($Plan) { @($Plan.missing_required_tests).Count } else { 0 }
    missing_required_tests = if ($Plan) { @($Plan.missing_required_tests) } else { @() }
    planned_test_count = if ($Plan) { @($Plan.planned_tests).Count } else { 0 }
    planned_tests = if ($Plan) { @($Plan.planned_tests | ForEach-Object {
      [ordered]@{
        test_id = $_.test_id
        required = $_.required
        priority = $_.priority
        blocks_merge = $_.blocks_merge
        blocks_release = $_.blocks_release
        runner_group = $_.runner_group
        reasons = @($_.reasons)
      }
    }) } else { @() }
    risk_matches = if ($Plan) { @($Plan.risk_matches) } else { @() }
    graph_matches = if ($Plan) { @($Plan.graph_matches) } else { @() }
    all_required_passed = if ($Equivalence) { [bool]$Equivalence.all_required_passed } else { $false }
    coverage_equivalence = if ($Equivalence) { [bool]$Equivalence.coverage_equivalence } else { $false }
    no_hidden_flaky = if ($Equivalence) { [bool]$Equivalence.no_hidden_flaky } else { $false }
    executed_required_test_count = if ($Equivalence) { [int]$Equivalence.executed_required_test_count } else { 0 }
    failed_required_tests = if ($Equivalence) { @($Equivalence.failed_required_tests) } else { @() }
    hidden_flaky_tests = if ($Equivalence) { @($Equivalence.hidden_flaky_tests) } else { @() }
    result_written = $false
    audit_path = $AuditPath
    started_at = $StartedAt.ToString("o")
    finished_at = $FinishedAt.ToString("o")
    duration_ms = [int][Math]::Round(($FinishedAt - $StartedAt).TotalMilliseconds)
    errors = @($Validation.errors)
    warnings = @($Validation.warnings)
    results = @($Results)
  }

  return [pscustomobject]$payload
}

$started = Get-Date
if (-not ($ValidateManifest -or $BuildPlan -or $ExecutePlan -or $VerifyCoverageEquivalence -or $EmitAuditArtifact)) {
  $ValidateManifest = $true
  $BuildPlan = $true
  $ExecutePlan = $true
  $VerifyCoverageEquivalence = $true
}

if ([string]::IsNullOrWhiteSpace($AuditPath)) {
  $AuditPath = Join-Path $Root "evals\results\change_aware_full_coverage_audit_latest.json"
}

if ($VerifyCoverageEquivalence -and -not $ExecutePlan -and -not $BuildPlan -and (Test-Path -LiteralPath $AuditPath)) {
  $existing = Get-Content -LiteralPath $AuditPath -Raw | ConvertFrom-Json
  $status = if (
    $existing.all_required_passed -eq $true -and
    $existing.coverage_equivalence -eq $true -and
    $existing.manifest_valid -eq $true -and
    $existing.graph_valid -eq $true -and
    $existing.no_hidden_flaky -eq $true -and
    $existing.blocked_surfaces_clear -eq $true
  ) { "PASS" } else { "FAIL" }
  $payload = [pscustomobject]@{
    status = $status
    verifier_id = "change_aware_full_coverage_equivalence"
    audit_path = $AuditPath
    all_required_passed = [bool]$existing.all_required_passed
    coverage_equivalence = [bool]$existing.coverage_equivalence
    manifest_valid = [bool]$existing.manifest_valid
    graph_valid = [bool]$existing.graph_valid
    no_hidden_flaky = [bool]$existing.no_hidden_flaky
    blocked_surfaces_clear = [bool]$existing.blocked_surfaces_clear
  }
  $payload | ConvertTo-Json -Depth 5
  if ($status -ne "PASS") { exit 1 }
  exit 0
}

$validation = Test-ManifestAndGraph
$plan = $null
$results = @()
$equivalence = $null

if ($BuildPlan -or $ExecutePlan -or $VerifyCoverageEquivalence -or $EmitAuditArtifact) {
  $plan = New-ExecutionPlan -Validation $validation
}

if ($ExecutePlan) {
  $resultList = New-Object System.Collections.Generic.List[object]
  foreach ($item in @($plan.planned_tests)) {
    $resultList.Add((Invoke-PlanItem -Item $item))
  }
  $results = @($resultList.ToArray())
}

if ($ExecutePlan -or $VerifyCoverageEquivalence -or $EmitAuditArtifact) {
  $equivalence = Test-CoverageEquivalence -Validation $validation -Plan $plan -Results $results
}

$finished = Get-Date
$status = "PASS"
if (-not $validation.manifest_valid -or -not $validation.graph_valid) {
  $status = "FAIL"
}
if ($BuildPlan -and $plan -and -not $plan.coverage_equivalence_planned) {
  $status = "FAIL"
}
if (($ExecutePlan -or $VerifyCoverageEquivalence -or $EmitAuditArtifact) -and $equivalence -and -not $equivalence.coverage_equivalence) {
  $status = "FAIL"
}

$payload = New-BasePayload -Status $status -Validation $validation -Plan $plan -Results $results -Equivalence $equivalence -StartedAt $started -FinishedAt $finished

if ($EmitAuditArtifact) {
  $resultDir = Split-Path -Parent $AuditPath
  New-Item -ItemType Directory -Force -Path $resultDir | Out-Null
  $payload.result_written = $true
  $payload | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $AuditPath -Encoding UTF8
}

$payload | ConvertTo-Json -Depth 10

if ($status -ne "PASS") {
  exit 1
}
