param(
  [string]$Root = ".agents\codex",
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d"
)

$ErrorActionPreference = "Stop"

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required CSV: $Path"
  }
  @(Import-Csv -LiteralPath $Path)
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

function Check-StopCondition {
  param(
    [string]$Value,
    [string[]]$KnownStops,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($token in Split-Tokens -Value $Value) {
    if ($token -notin $KnownStops) {
      $Errors.Add("$Context references unknown stop_condition: $token")
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
    $normalized = $Value -replace "/", "\"
    $resolved = $normalized
    if ($normalized.StartsWith(".agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
      $resolved = Join-Path $Root ($normalized.Substring(".agents\codex".Length).TrimStart("\"))
    } elseif ($normalized.StartsWith("C:\Users\enzo1\Documents\GitHub\cabina-universal-d", [System.StringComparison]::OrdinalIgnoreCase)) {
      $resolved = Join-Path $RepoRoot ($normalized.Substring("C:\Users\enzo1\Documents\GitHub\cabina-universal-d".Length).TrimStart("\"))
    }
    if (-not (Test-Path -LiteralPath $resolved)) {
      $Errors.Add("$Context validator path missing: $Value")
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
  $tokens = Split-Tokens -Value $Value
  foreach ($token in $Required) {
    if ($token -notin $tokens) {
      $Errors.Add("$Context missing token: $token")
    }
  }
}

$queuePath = Join-Path $Root "matrices\PARALLEL_ISSUE_LANE_QUEUE.csv"
$parallelPath = Join-Path $Root "matrices\PARALLEL_OPERATION_CRITERIA_MATRIX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-Columns -Path $queuePath -Columns @(
  "work_unit_id",
  "issue_id",
  "issue_url",
  "title",
  "base_sha",
  "branch",
  "lane_id",
  "lead_agent",
  "owner_agent",
  "reviewer_agent",
  "read_scope",
  "write_scope",
  "lock_key",
  "dependency",
  "max_parallel",
  "allowed_actions",
  "blocked_actions",
  "rollback",
  "postcheck",
  "evidence",
  "validator",
  "status",
  "stop_condition"
) -Errors $errors

$rows = Read-CsvRequired -Path $queuePath
$lanes = Read-CsvRequired -Path $parallelPath
$laneIds = @($lanes | ForEach-Object { $_.lane_id })
$toolIds = @((Read-CsvRequired -Path $toolIndexPath) | ForEach-Object { $_.tool_id })
$knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
$agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })
$allowedStatuses = @("QUEUED_READY", "ACTIVE_IN_PROGRESS", "SERIAL_INTEGRATION_REQUIRED", "BLOCKED", "COMPLETED")
$activeRows = @($rows | Where-Object { $_.status -in @("QUEUED_READY", "ACTIVE_IN_PROGRESS", "SERIAL_INTEGRATION_REQUIRED") })

foreach ($row in $rows) {
  foreach ($field in @("work_unit_id","issue_id","title","base_sha","branch","lane_id","lead_agent","owner_agent","reviewer_agent","read_scope","write_scope","lock_key","dependency","max_parallel","allowed_actions","blocked_actions","rollback","postcheck","evidence","validator","status","stop_condition")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Parallel issue queue row '$($row.work_unit_id)' missing $field")
    }
  }
  if ($row.base_sha -notmatch '^[0-9a-f]{40}$') {
    $errors.Add("Parallel issue queue row '$($row.work_unit_id)' has invalid base_sha: $($row.base_sha)")
  }
  if ($row.branch -notmatch '^codex\/[A-Za-z0-9._-]+$') {
    $errors.Add("Parallel issue queue row '$($row.work_unit_id)' branch must be codex/*: $($row.branch)")
  }
  if ($row.lane_id -notin $laneIds) {
    $errors.Add("Parallel issue queue row '$($row.work_unit_id)' references unknown lane: $($row.lane_id)")
  }
  foreach ($agentField in @("lead_agent","owner_agent","reviewer_agent")) {
    if ($row.$agentField -notin $agentIds) {
      $errors.Add("Parallel issue queue row '$($row.work_unit_id)' references unknown $agentField`: $($row.$agentField)")
    }
  }
  if ($row.owner_agent -eq $row.reviewer_agent) {
    $errors.Add("Parallel issue queue row '$($row.work_unit_id)' owner_agent and reviewer_agent must differ")
  }
  $max = 0
  if (-not [int]::TryParse([string]$row.max_parallel, [ref]$max) -or $max -lt 1 -or $max -gt 5) {
    $errors.Add("Parallel issue queue row '$($row.work_unit_id)' max_parallel must be an integer between 1 and 5")
  } else {
    $lane = @($lanes | Where-Object { $_.lane_id -eq $row.lane_id }) | Select-Object -First 1
    if ($lane) {
      $laneMax = 0
      if ([int]::TryParse([string]$lane.max_parallel, [ref]$laneMax) -and $max -gt $laneMax) {
        $errors.Add("Parallel issue queue row '$($row.work_unit_id)' max_parallel exceeds lane max: $max > $laneMax")
      }
    }
  }
  if ($row.status -notin $allowedStatuses) {
    $errors.Add("Parallel issue queue row '$($row.work_unit_id)' unsupported status: $($row.status)")
  }
  foreach ($token in Split-Tokens -Value $row.write_scope) {
    if ($token -in @("declared_file_set_only","C:/Users/enzo1/Documents/GitHub/cabina-universal-d","C:\Users\enzo1\Documents\GitHub\cabina-universal-d",".agents/codex",".agents\codex",".agents/codex/matrices",".agents\codex\matrices",".github",".github",".github")) {
      $errors.Add("Parallel issue queue row '$($row.work_unit_id)' write_scope is too broad: $token")
    }
  }
  Check-TokenList -Value $row.blocked_actions -Required @("merge_without_approved_precheck","force_push","permission_change","secrets","production","microsoft_live","openai_api_live") -Errors $errors -Context "Parallel issue queue row '$($row.work_unit_id)' blocked_actions"
  Check-TokenList -Value $row.allowed_actions -Required @("explicit_stage","local_validation") -Errors $errors -Context "Parallel issue queue row '$($row.work_unit_id)' allowed_actions"
  Check-ValidatorRef -Value $row.validator -ToolIds $toolIds -Errors $errors -Context "Parallel issue queue row '$($row.work_unit_id)'"
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Parallel issue queue row '$($row.work_unit_id)'"
}

foreach ($group in @($activeRows | Group-Object lock_key | Where-Object { $_.Name -and $_.Count -gt 1 })) {
  $errors.Add("Active parallel issue queue lock_key is duplicated: $($group.Name)")
}

$writeOwners = @{}
foreach ($row in $activeRows) {
  foreach ($token in Split-Tokens -Value $row.write_scope) {
    $key = $token.ToLowerInvariant()
    if ($writeOwners.ContainsKey($key)) {
      $errors.Add("Active parallel issue queue write_scope overlap: $token used by $($writeOwners[$key]) and $($row.work_unit_id)")
    } else {
      $writeOwners[$key] = $row.work_unit_id
    }
  }
}

foreach ($row in $activeRows) {
  foreach ($dependency in Split-Tokens -Value $row.dependency) {
    if ($dependency -ne "none" -and $dependency -notin @($rows | ForEach-Object { $_.work_unit_id })) {
      $errors.Add("Parallel issue queue row '$($row.work_unit_id)' references missing dependency: $dependency")
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  queue_count = $rows.Count
  active_queue_count = $activeRows.Count
  lock_count = @($activeRows | Select-Object -ExpandProperty lock_key -Unique).Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
