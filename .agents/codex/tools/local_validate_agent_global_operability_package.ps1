$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Error {
    param([string]$Message)
    $errors.Add($Message) | Out-Null
}

function Read-CsvChecked {
    param(
        [string]$RelativePath,
        [string[]]$RequiredColumns
    )
    $path = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path $path)) {
        Add-Error "missing csv: $RelativePath"
        return @()
    }
    $rows = @(Import-Csv $path)
    if ($rows.Count -eq 0) {
        Add-Error "empty csv: $RelativePath"
        return @()
    }
    $columns = @($rows[0].PSObject.Properties.Name)
    foreach ($column in $RequiredColumns) {
        if ($column -notin $columns) {
            Add-Error "$RelativePath missing column: $column"
        }
    }
    return $rows
}

function Require-Fields {
    param(
        [object[]]$Rows,
        [string]$IdField,
        [string[]]$Fields,
        [string]$Name
    )
    $seen = New-Object System.Collections.Generic.HashSet[string]([StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $Rows) {
        $id = $row.$IdField
        if ([string]::IsNullOrWhiteSpace($id)) {
            Add-Error "$Name row without $IdField"
            continue
        }
        if (-not $seen.Add($id)) {
            Add-Error "$Name duplicate $IdField`: $id"
        }
        foreach ($field in $Fields) {
            if ([string]::IsNullOrWhiteSpace($row.$field)) {
                Add-Error "$Name $id missing $field"
            }
        }
    }
}

function As-Map {
    param(
        [object[]]$Rows,
        [string]$Key
    )
    $map = @{}
    foreach ($row in $Rows) {
        if (-not [string]::IsNullOrWhiteSpace($row.$Key)) {
            $map[$row.$Key] = $row
        }
    }
    return $map
}

function Test-Refs {
    param(
        [string]$SourceId,
        [string]$Value,
        [hashtable]$TargetMap,
        [string]$TargetName
    )
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }
    foreach ($ref in ($Value -split "\|")) {
        $trimmed = $ref.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            continue
        }
        if (-not $TargetMap.ContainsKey($trimmed)) {
            Add-Error "$SourceId references missing $TargetName`: $trimmed"
        }
    }
}

$findings = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_FINDINGS_20260605.csv" @("finding_id","source_record","finding_type","severity","evidence","recommendation","next_lane","stop_condition")
$decisions = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_DECISION_MATRIX_20260605.csv" @("decision_id","finding_id","source_record","decision","decision_owner","action","target_artifact","gate_required","validator","postcheck","rollback","status","stop_condition")
$raci = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_RACI_MATRIX_20260605.csv" @("raci_id","decision_id","finding_id","capability","responsible","accountable","consulted","informed","gate_owner","evidence_owner","validator_owner","execution_surface","status","stop_condition")
$workflow = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_REVIEW_EVALUATION_DECISION_WORKFLOW_20260605.csv" @("workflow_step_id","phase","purpose","input_artifact","owner_agent","required_recipe","required_tool","output_artifact","validator","human_gate_required","next_step","status","stop_condition")
$org = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_ORG_CHART_20260605.csv" @("node_id","parent_node_id","level","agent_id","org_role","decision_scope","linked_raci_rows","linked_workflow_steps","authority_boundary","escalates_to","status","stop_condition")
$plan = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SDU_SEARCH_SELECTION_PLAN_20260605.csv" @("plan_step_id","canonical_sdu_agent","operational_agent","phase","purpose","search_scope","selection_criteria","input_artifact","output_artifact","gate_required","validator","next_step","status","stop_condition")
$framework = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_FRAMEWORK_20260605.csv" @("framework_component_id","component_type","component_name","source_artifact","purpose","owner_agent","validator","evidence","gate_policy","output_artifact","status","stop_condition")
$backlog = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATED_BACKLOG_20260605.csv" @("backlog_id","decision_id","source_decision","owner_agent","target_artifact","current_local_state","next_allowed_action","gate_required","gate_owner","required_input","validator","rollback","postcheck","status","stop_condition")
$semaphore = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv" @("semaphore_id","source_backlog_id","decision_id","color","operational_meaning","current_state","decision_owner","execution_owner","gate_required","next_action","validator","evidence","rollback","postcheck","stop_condition")
$gateQueue = Read-CsvChecked ".agents\codex\matrices\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATE_QUEUE_20260605.csv" @("queue_id","semaphore_id","decision_id","color","gate_required","gate_owner","domain_owner","execution_owner","required_input","target_artifact","allowed_preparation","blocked_execution","validator","rollback","postcheck","status","stop_condition")

Require-Fields $findings "finding_id" @("source_record","finding_type","severity","evidence","recommendation","next_lane","stop_condition") "findings"
Require-Fields $decisions "decision_id" @("finding_id","decision","decision_owner","action","target_artifact","gate_required","validator","postcheck","rollback","status","stop_condition") "decisions"
Require-Fields $raci "raci_id" @("decision_id","finding_id","responsible","accountable","gate_owner","evidence_owner","validator_owner","execution_surface","status","stop_condition") "raci"
Require-Fields $workflow "workflow_step_id" @("phase","purpose","owner_agent","required_recipe","required_tool","validator","human_gate_required","next_step","status","stop_condition") "workflow"
Require-Fields $org "node_id" @("parent_node_id","agent_id","org_role","linked_raci_rows","linked_workflow_steps","authority_boundary","escalates_to","status","stop_condition") "org_chart"
Require-Fields $plan "plan_step_id" @("canonical_sdu_agent","operational_agent","phase","purpose","selection_criteria","input_artifact","output_artifact","gate_required","validator","next_step","status","stop_condition") "sdu_plan"
Require-Fields $framework "framework_component_id" @("component_type","component_name","source_artifact","purpose","owner_agent","validator","evidence","gate_policy","output_artifact","status","stop_condition") "framework"
Require-Fields $backlog "backlog_id" @("decision_id","source_decision","owner_agent","target_artifact","current_local_state","next_allowed_action","gate_required","gate_owner","required_input","validator","rollback","postcheck","status","stop_condition") "backlog"
Require-Fields $semaphore "semaphore_id" @("source_backlog_id","decision_id","color","current_state","decision_owner","execution_owner","gate_required","next_action","validator","evidence","rollback","postcheck","stop_condition") "semaphore"
Require-Fields $gateQueue "queue_id" @("semaphore_id","decision_id","color","gate_required","gate_owner","domain_owner","execution_owner","required_input","target_artifact","allowed_preparation","blocked_execution","validator","rollback","postcheck","status","stop_condition") "gate_queue"

$findingById = As-Map $findings "finding_id"
$decisionById = As-Map $decisions "decision_id"
$raciById = As-Map $raci "raci_id"
$workflowById = As-Map $workflow "workflow_step_id"
$orgById = As-Map $org "node_id"
$planById = As-Map $plan "plan_step_id"
$backlogById = As-Map $backlog "backlog_id"
$semaphoreById = As-Map $semaphore "semaphore_id"

$allowedDecision = @("KEEP_GATED","RETAIN_BOUNDARY","REQUIRE_LIVE_GATE","REQUIRE_HUMAN_GATE","EXECUTE_ON_NEXT_LANE","REQUIRE_WORKTREE_GATE","SERIALIZE")
foreach ($row in $decisions) {
    if (-not $findingById.ContainsKey($row.finding_id)) {
        Add-Error "decision $($row.decision_id) references missing finding: $($row.finding_id)"
    }
    if ($row.decision -notin $allowedDecision) {
        Add-Error "decision $($row.decision_id) invalid decision: $($row.decision)"
    }
    if ($row.status -ne "DECIDED") {
        Add-Error "decision $($row.decision_id) status must be DECIDED"
    }
}

foreach ($row in $raci) {
    Test-Refs $row.raci_id $row.decision_id $decisionById "decision"
    Test-Refs $row.raci_id $row.finding_id $findingById "finding"
}

foreach ($row in $workflow) {
    if (($row.next_step -ne "END") -and (-not $workflowById.ContainsKey($row.next_step))) {
        Add-Error "workflow $($row.workflow_step_id) next_step missing: $($row.next_step)"
    }
}

foreach ($row in $org) {
    if (($row.parent_node_id -ne "ROOT") -and (-not $orgById.ContainsKey($row.parent_node_id))) {
        Add-Error "org $($row.node_id) parent missing: $($row.parent_node_id)"
    }
    Test-Refs $row.node_id $row.linked_raci_rows $raciById "raci"
    Test-Refs $row.node_id $row.linked_workflow_steps $workflowById "workflow"
}

$canonicalAgents = @("seshat-normativa","thot-tecnico","anubis-gate","maat-cumplimiento","horus-riesgo","narrador-normativo")
foreach ($row in $plan) {
    if ($row.canonical_sdu_agent -notin $canonicalAgents) {
        Add-Error "sdu plan $($row.plan_step_id) invalid canonical agent: $($row.canonical_sdu_agent)"
    }
    if (($row.next_step -ne "END") -and (-not $planById.ContainsKey($row.next_step))) {
        Add-Error "sdu plan $($row.plan_step_id) next_step missing: $($row.next_step)"
    }
}

foreach ($row in $framework) {
    foreach ($field in @("source_artifact","output_artifact","validator")) {
        $value = $row.$field
        foreach ($part in ($value -split "\|")) {
            $candidateValue = $part.Trim()
            if ($candidateValue -like ".agents/*" -or $candidateValue -like "governance/*" -or $candidateValue -like "AGENTS.md" -or $candidateValue -like "MANIFEST.yaml") {
                $candidate = Join-Path $RepoRoot ($candidateValue -replace "/", "\")
                if (-not (Test-Path $candidate)) {
                    Add-Error "framework $($row.framework_component_id) missing ${field} path: $candidateValue"
                }
            }
        }
    }
}

foreach ($row in $backlog) {
    if (-not $decisionById.ContainsKey($row.decision_id)) {
        Add-Error "backlog $($row.backlog_id) references missing decision: $($row.decision_id)"
    }
}

$colorState = @{
    GREEN = "SATISFIED_LOCAL"
    YELLOW = "GUARDRAIL_ACTIVE"
    RED = "GATED_PENDING"
}

foreach ($row in $semaphore) {
    if (-not $backlogById.ContainsKey($row.source_backlog_id)) {
        Add-Error "semaphore $($row.semaphore_id) references missing backlog: $($row.source_backlog_id)"
        continue
    }
    if (-not $colorState.ContainsKey($row.color)) {
        Add-Error "semaphore $($row.semaphore_id) invalid color: $($row.color)"
        continue
    }
    $source = $backlogById[$row.source_backlog_id]
    if ($row.current_state -ne $colorState[$row.color]) {
        Add-Error "semaphore $($row.semaphore_id) color/state mismatch"
    }
    foreach ($field in @("decision_id","gate_required","validator","rollback","postcheck","stop_condition")) {
        if ($row.$field -ne $source.$field) {
            Add-Error "semaphore $($row.semaphore_id) mismatch $field"
        }
    }
    if ($row.current_state -ne $source.status) {
        Add-Error "semaphore $($row.semaphore_id) status mismatch with backlog"
    }
}

$redSemaphoreIds = New-Object System.Collections.Generic.HashSet[string]([StringComparer]::OrdinalIgnoreCase)
foreach ($row in $semaphore) {
    if ($row.color -eq "RED") {
        $redSemaphoreIds.Add($row.semaphore_id) | Out-Null
    }
}

$queuedSemaphoreIds = New-Object System.Collections.Generic.HashSet[string]([StringComparer]::OrdinalIgnoreCase)
foreach ($row in $gateQueue) {
    if (-not $semaphoreById.ContainsKey($row.semaphore_id)) {
        Add-Error "gate queue $($row.queue_id) references missing semaphore: $($row.semaphore_id)"
        continue
    }

    $source = $semaphoreById[$row.semaphore_id]
    if ($source.color -ne "RED") {
        Add-Error "gate queue $($row.queue_id) must reference RED semaphore, got $($source.color)"
    }

    foreach ($field in @("decision_id","gate_required","validator","rollback","postcheck","stop_condition")) {
        if ($row.$field -ne $source.$field) {
            Add-Error "gate queue $($row.queue_id) mismatch ${field}"
        }
    }

    if ($row.color -ne "RED") {
        Add-Error "gate queue $($row.queue_id) color must be RED"
    }

    if ($row.status -ne "GATE_PACKET_REQUIRED") {
        Add-Error "gate queue $($row.queue_id) status must be GATE_PACKET_REQUIRED"
    }

    if ($row.allowed_preparation -notlike "prepare_*") {
        Add-Error "gate queue $($row.queue_id) allowed_preparation must be prepare-only"
    }

    if ([string]::IsNullOrWhiteSpace($row.blocked_execution)) {
        Add-Error "gate queue $($row.queue_id) missing blocked execution"
    }

    $queuedSemaphoreIds.Add($row.semaphore_id) | Out-Null
}

foreach ($semaphoreId in $redSemaphoreIds) {
    if (-not $queuedSemaphoreIds.Contains($semaphoreId)) {
        Add-Error "RED semaphore missing from gate queue: $semaphoreId"
    }
}

$mapPaths = @(
    ".agents\codex\maps\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_ORG_CHART_20260605.md",
    ".agents\codex\maps\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SDU_SEARCH_SELECTION_PLAN_20260605.md",
    ".agents\codex\maps\AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_FRAMEWORK_20260605.md"
)
foreach ($mapPath in $mapPaths) {
    $fullPath = Join-Path $RepoRoot $mapPath
    if (-not (Test-Path $fullPath)) {
        Add-Error "missing map: $mapPath"
    }
    elseif ((Get-Item $fullPath).Length -eq 0) {
        Add-Error "empty map: $mapPath"
    }
}

$result = [ordered]@{
    status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
    root = ".agents\codex"
    findings = $findings.Count
    decisions = $decisions.Count
    raci = $raci.Count
    workflow = $workflow.Count
    org_chart = $org.Count
    sdu_plan = $plan.Count
    framework = $framework.Count
    backlog = $backlog.Count
    semaphore = $semaphore.Count
    gate_queue = $gateQueue.Count
    warning_count = $warnings.Count
    warnings = @($warnings)
    error_count = $errors.Count
    errors = @($errors)
}

$result | ConvertTo-Json -Depth 6

if ($errors.Count -gt 0) {
    exit 1
}
