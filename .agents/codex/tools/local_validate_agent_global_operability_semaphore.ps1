$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$Root = Join-Path $RepoRoot ".agents\codex"
$SemaphorePath = Join-Path $Root "matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv"
$BacklogPath = Join-Path $Root "matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATED_BACKLOG_20260605.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Error {
    param([string]$Message)
    $errors.Add($Message) | Out-Null
}

function Read-CsvRequired {
    param(
        [string]$Path,
        [string]$Name
    )
    if (-not (Test-Path $Path)) {
        Add-Error "$Name missing: $Path"
        return @()
    }
    return @(Import-Csv $Path)
}

$semaphoreRows = Read-CsvRequired -Path $SemaphorePath -Name "semaphore_matrix"
$backlogRows = Read-CsvRequired -Path $BacklogPath -Name "gated_backlog_matrix"

$requiredSemaphoreColumns = @(
    "semaphore_id",
    "source_backlog_id",
    "decision_id",
    "color",
    "operational_meaning",
    "current_state",
    "decision_owner",
    "execution_owner",
    "gate_required",
    "next_action",
    "validator",
    "evidence",
    "rollback",
    "postcheck",
    "stop_condition"
)

$requiredBacklogColumns = @(
    "backlog_id",
    "decision_id",
    "owner_agent",
    "current_local_state",
    "gate_required",
    "gate_owner",
    "validator",
    "rollback",
    "postcheck",
    "status",
    "stop_condition"
)

if ($semaphoreRows.Count -gt 0) {
    $columns = @($semaphoreRows[0].PSObject.Properties.Name)
    foreach ($column in $requiredSemaphoreColumns) {
        if ($column -notin $columns) {
            Add-Error "semaphore missing column: $column"
        }
    }
}

if ($backlogRows.Count -gt 0) {
    $columns = @($backlogRows[0].PSObject.Properties.Name)
    foreach ($column in $requiredBacklogColumns) {
        if ($column -notin $columns) {
            Add-Error "backlog missing column: $column"
        }
    }
}

$backlogById = @{}
foreach ($row in $backlogRows) {
    if ([string]::IsNullOrWhiteSpace($row.backlog_id)) {
        Add-Error "backlog row without backlog_id"
        continue
    }
    if ($backlogById.ContainsKey($row.backlog_id)) {
        Add-Error "duplicate backlog_id: $($row.backlog_id)"
        continue
    }
    $backlogById[$row.backlog_id] = $row
}

$colorState = @{
    GREEN = "SATISFIED_LOCAL"
    YELLOW = "GUARDRAIL_ACTIVE"
    RED = "GATED_PENDING"
}

$seenSemaphore = New-Object System.Collections.Generic.HashSet[string]([StringComparer]::OrdinalIgnoreCase)

foreach ($row in $semaphoreRows) {
    if ([string]::IsNullOrWhiteSpace($row.semaphore_id)) {
        Add-Error "semaphore row without semaphore_id"
    }
    elseif (-not $seenSemaphore.Add($row.semaphore_id)) {
        Add-Error "duplicate semaphore_id: $($row.semaphore_id)"
    }

    foreach ($field in $requiredSemaphoreColumns) {
        if ([string]::IsNullOrWhiteSpace($row.$field)) {
            Add-Error "semaphore $($row.semaphore_id) missing $field"
        }
    }

    if (-not $colorState.ContainsKey($row.color)) {
        Add-Error "semaphore $($row.semaphore_id) invalid color: $($row.color)"
        continue
    }

    if ($row.current_state -ne $colorState[$row.color]) {
        Add-Error "semaphore $($row.semaphore_id) color/state mismatch: $($row.color) -> $($row.current_state)"
    }

    if (-not $backlogById.ContainsKey($row.source_backlog_id)) {
        Add-Error "semaphore $($row.semaphore_id) missing source backlog: $($row.source_backlog_id)"
        continue
    }

    $backlog = $backlogById[$row.source_backlog_id]
    foreach ($field in @("decision_id", "gate_required", "validator", "rollback", "postcheck", "stop_condition")) {
        if ($row.$field -ne $backlog.$field) {
            Add-Error "semaphore $($row.semaphore_id) mismatch ${field}: semaphore=$($row.$field) backlog=$($backlog.$field)"
        }
    }

    if ($row.current_state -ne $backlog.status) {
        Add-Error "semaphore $($row.semaphore_id) current_state/status mismatch: semaphore=$($row.current_state) backlog=$($backlog.status)"
    }

    if ($row.decision_owner -ne $backlog.owner_agent) {
        Add-Error "semaphore $($row.semaphore_id) decision_owner mismatch: semaphore=$($row.decision_owner) backlog=$($backlog.owner_agent)"
    }

    if (($row.execution_owner -ne $backlog.owner_agent) -and ($row.execution_owner -ne $backlog.gate_owner)) {
        Add-Error "semaphore $($row.semaphore_id) execution_owner must match backlog owner_agent or gate_owner"
    }

    if (($row.color -eq "RED") -and ($row.gate_required -eq "none")) {
        Add-Error "semaphore $($row.semaphore_id) RED requires a concrete gate"
    }
}

$colorCounts = @{}
foreach ($color in @("GREEN", "YELLOW", "RED")) {
    $colorCounts[$color] = @($semaphoreRows | Where-Object { $_.color -eq $color }).Count
}

$result = [ordered]@{
    status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
    root = ".agents\codex"
    semaphore_rows = $semaphoreRows.Count
    backlog_rows = $backlogRows.Count
    green = $colorCounts["GREEN"]
    yellow = $colorCounts["YELLOW"]
    red = $colorCounts["RED"]
    warning_count = $warnings.Count
    warnings = @($warnings)
    error_count = $errors.Count
    errors = @($errors)
}

$result | ConvertTo-Json -Depth 6

if ($errors.Count -gt 0) {
    exit 1
}
