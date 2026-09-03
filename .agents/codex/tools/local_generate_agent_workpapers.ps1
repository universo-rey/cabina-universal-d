param(
  [string]$Root = ".agents\codex",
  [string]$Today = "2026-06-01"
)

$ErrorActionPreference = "Stop"
$Status = "LOCAL_GOVERNED_WORKPAPERS_ACTIVE"

function Export-Rows {
  param([string]$Path, [object[]]$Rows)
  $parent = Split-Path -Parent $Path
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
  $Rows | Export-Csv -LiteralPath $Path -NoTypeInformation -Encoding UTF8
}

function Join-Unique {
  param([object[]]$Values)
  @($Values | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Select-Object -Unique) -join "|"
}

function Add-UniqueRows {
  param(
    [object[]]$Rows,
    [object[]]$NewRows,
    [string[]]$Keys
  )
  $allRows = @($Rows) + @($NewRows)
  $seen = @{}
  $result = @()
  foreach ($row in $allRows) {
    $key = Join-Unique (@($Keys | ForEach-Object { [string]$row.$_ }))
    if (-not $seen.ContainsKey($key)) {
      $seen[$key] = $true
      $result += $row
    }
  }
  $result
}

function Agent-Surface {
  param($Agent)
  $id = [string]$Agent.id
  $reads = Join-Unique @($Agent.reads)
  if ($id -match "escribania") { return "10_UNIVERSOS\ESCRIBANIA|TGE tenant surfaces governed" }
  if ($id -match "modo_on") { return "10_UNIVERSOS\MODO_ON|CDF Jara provider surfaces governed" }
  if ($id -match "sdu|seshat|openai|thot") { return "03_CORTE_EJECUTORA_DEL_REY|SDU Seshat Corte surfaces" }
  if ($id -match "repo|governance|migration") { return "01_GOVERNANCE_REGISTRY|repo local remote metadata" }
  if ($id -match "frontier|canon") { return "02_AUTHORITY_CANON|gates policies orders" }
  if ($id -match "workspace|reference") { return ".agents\codex|80_REFERENCIAS_TECNICAS" }
  $reads
}

function Agent-Universe {
  param([string]$AgentId)
  if ($AgentId -match "escribania") { return "ESCRIBANIA" }
  if ($AgentId -match "modo_on") { return "MODO_ON" }
  if ($AgentId -match "sdu|seshat|openai|thot") { return "CORTE_EJECUTORA" }
  "CABINA_UNIVERSAL"
}

function Agent-Tower {
  param([string]$AgentId)
  if ($AgentId -match "escribania") { return "TGE" }
  if ($AgentId -match "modo_on") { return "CDF_JARA" }
  if ($AgentId -match "sdu|seshat") { return "SDU_SESHAT" }
  "ROOT"
}

function Agent-Plugins {
  param([string]$AgentId, [string]$SkillRefs)
  $plugins = @("Superpowers")
  if ($SkillRefs -match "github") { $plugins += "GitHub" }
  if ($SkillRefs -match "sharepoint" -or $AgentId -match "sdu|seshat|escribania|modo_on") { $plugins += "SharePoint" }
  if ($SkillRefs -match "openai") { $plugins += "OpenAI Developers" }
  if ($AgentId -eq "codex.workspace_guardian") { $plugins += "Operativa Guardian" }
  Join-Unique $plugins
}

function Add-MatrixIndexRow {
  param([object[]]$Rows, [string]$Id, [string]$Path, [string]$Scope, [string]$Reader, [string]$Rule)
  $filtered = @($Rows | Where-Object { $_.matrix_id -ne $Id })
  $filtered + [pscustomobject]@{
    matrix_id = $Id
    path = $Path
    scope = $Scope
    primary_reader = $Reader
    update_rule = $Rule
  }
}

$dataPath = Join-Path $Root "agents.json"
$data = Get-Content -LiteralPath $dataPath -Raw | ConvertFrom-Json
$data.status = $Status
$data.purpose = "Local governed agent layer for the Universal Rey control cabin, with versioned workpapers per agent."
$data.default_policy.required_closeout_fields = @(
  "agente", "orden", "superficie", "estado", "evidencia",
  "validador", "riesgo", "rollback", "stop_condition", "proximos_carriles"
)
$data.artifact_roots | Add-Member -NotePropertyName workpapers -NotePropertyValue ".agents\codex\workpapers" -Force
$data.artifact_roots | Add-Member -NotePropertyName plugins -NotePropertyValue ".agents\codex\plugins" -Force

$existing = Import-Csv -LiteralPath (Join-Path $Root "matrices\AGENT_TOOL_RECIPE_SKILL_MATRIX.csv")
$refs = @{}
foreach ($row in $existing) {
  $id = [string]$row.agent_id
  if (-not $refs.ContainsKey($id)) {
    $refs[$id] = @{
      skills = @()
      recipes = @()
      tools = @()
      mode = @()
    }
  }
  $refs[$id].skills += @([string]$row.skill_refs -split "\|")
  $refs[$id].recipes += @([string]$row.recipe_refs -split "\|")
  $refs[$id].tools += @([string]$row.tool_refs -split "\|")
  $refs[$id].mode += @([string]$row.default_mode -split "\|")
}

$workRoot = Join-Path $Root "workpapers"
$pluginRoot = Join-Path $Root "plugins"
New-Item -ItemType Directory -Path $workRoot -Force | Out-Null
New-Item -ItemType Directory -Path $pluginRoot -Force | Out-Null

Set-Content -LiteralPath (Join-Path $workRoot "README.md") -Encoding UTF8 -Value @"
# Agent Workpapers

Status: $Status

This folder turns the local Codex agent layer into governed operating workpapers. It does not create remote persistent agents and does not authorize Microsoft live, production, tenant writes, secrets, cost, or broad regulated reads by itself.

Every agent has a folder with current workpaper, routing map, evidence log, decision log, open items and validation log. Repo-visible snapshots live under 05_AGENTES/D_DRIVE_CODEX_AGENT_LAYER/workpapers in universo-rey/organizacion.
"@

Set-Content -LiteralPath (Join-Path $pluginRoot "README.md") -Encoding UTF8 -Value @"
# Plugin Boundary

Plugin availability and boundaries are declared in matrices/PLUGIN_USAGE_MATRIX.csv. Microsoft live, OpenAI API, production and tenant writes remain governed by explicit order.
"@

$workRows = @()
$workIndexRows = @()
$purposeRows = @()
$indexRows = @()
$toolSkillRows = @()

foreach ($agent in @($data.agents)) {
  $id = [string]$agent.id
  $workPath = Join-Path $workRoot $id
  $snapshotPath = "05_AGENTES/D_DRIVE_CODEX_AGENT_LAYER/workpapers/$id"
  $primarySurface = if ($agent.reads -and $agent.reads.Count -gt 0) { [string]$agent.reads[0] } else { "AGENTS.md" }
  $surface = Agent-Surface $agent
  $agentRefs = $refs[$id]
  $skills = if ($agentRefs) { Join-Unique ($agentRefs.skills + @("superpowers:verification-before-completion")) } else { "superpowers:verification-before-completion" }
  $recipes = if ($agentRefs) { Join-Unique ($agentRefs.recipes + @("recipe.agent_workpaper_operation")) } else { "recipe.agent_workpaper_operation" }
  $tools = if ($agentRefs) { Join-Unique ($agentRefs.tools + @("tool.workpaper_index_check", "tool.local_validate_agent_workpapers")) } else { "tool.workpaper_index_check|tool.local_validate_agent_workpapers" }
  $mode = if ($agentRefs) { Join-Unique $agentRefs.mode } else { "local_only" }
  $plugins = Agent-Plugins $id $skills
  $stop = if ($id -match "escribania|sdu|seshat|modo_on") { "binding_or_target_resolution_required|high_without_explicit_authorization" } else { "workpaper_missing_for_agent" }

  New-Item -ItemType Directory -Path $workPath -Force | Out-Null
  $agent | Add-Member -NotePropertyName workpapers_path -NotePropertyValue $workPath -Force

  $workRows += [pscustomobject]@{
    agent_id = $id
    level_id = $agent.level_id
    workpapers_path = $workPath
    repo_snapshot_path = $snapshotPath
    status = $Status
    primary_surface = $primarySurface
    purpose = $agent.mission
    owner_agent = $id
    required_matrices = "AGENT_WORKPAPERS_MATRIX|PURPOSE_SURFACE_CAPABILITY_MATRIX|AGENT_TOOL_RECIPE_SKILL_MATRIX|AGENT_GOVERNANCE_MATRIX"
    required_recipes = $recipes
    required_tools = $tools
    required_validators = "tool.local_validate_agent_workpapers|tool.local_validate_agent_layer"
    evidence_policy = "sanitized_repo_visible_evidence_only"
    validator = "tool.local_validate_agent_layer"
    stop_condition = $stop
  }

  $workIndexRows += [pscustomobject]@{
    agent_id = $id
    level_id = $agent.level_id
    workpaper_path = $workPath
    status = $Status
    last_updated = $Today
    primary_surface = $primarySurface
    purpose = $agent.mission
    owner_agent = $id
    required_matrices = "AGENT_WORKPAPERS_MATRIX|PURPOSE_SURFACE_CAPABILITY_MATRIX|AGENT_TOOL_RECIPE_SKILL_MATRIX|AGENT_GOVERNANCE_MATRIX"
    required_recipes = $recipes
    required_tools = $tools
    required_validators = "tool.local_validate_agent_workpapers|tool.local_validate_agent_layer"
    evidence_policy = "sanitized_repo_visible_evidence_only"
    stop_condition = $stop
  }

  $purposeRows += [pscustomobject]@{
    artifact_id = "purpose.$id"
    artifact_type = "agent_surface_capability"
    agent_id = $id
    level_id = $agent.level_id
    purpose = $agent.mission
    surface = $surface
    universe = Agent-Universe $id
    tower = Agent-Tower $id
    owner_agent = $id
    authority_level = $agent.level_id
    lifecycle = "02_ACTIVE"
    status = $Status
    local_allowed = "yes"
    governed_order_required = if ($id -match "escribania|sdu|seshat|modo_on") { "microsoft_live_or_tenant_action" } else { "remote_write_or_production" }
    allowed_actions = Join-Unique @($agent.may_execute)
    blocked_actions = Join-Unique @($agent.blocked)
    skill_refs = $skills
    recipe_refs = $recipes
    tool_refs = $tools
    plugin_refs = $plugins
    validator_refs = "tool.local_validate_agent_workpapers|tool.local_validate_agent_layer"
    evidence_required = Join-Unique @($agent.outputs)
    workpaper_path = $workPath
    source_policy = "copy_adapt_required_before_new_content"
    source_refs = Join-Unique @($agent.reads)
    last_validated = "pending_validator_run_2026-06-01"
    stop_condition = Join-Unique @($agent.stop_conditions)
    next_review = "2026-06-08"
  }

  $indexRows += [pscustomobject]@{
    agent_id = $id
    name = $agent.name
    level_id = $agent.level_id
    layer = $agent.layer
    primary_surface = $primarySurface
    profile_path = $agent.home_path
    workpaper_path = $workPath
    status = $Status
  }

  $toolSkillRows += [pscustomobject]@{
    agent_id = $id
    level_id = $agent.level_id
    purpose = $agent.mission
    surface = $surface
    skill_refs = $skills
    recipe_refs = $recipes
    tool_refs = $tools
    plugin_refs = $plugins
    workpaper_path = $workPath
    validator = "tool.local_validate_agent_layer"
    default_mode = $mode
    stop_condition = $stop
  }

  Set-Content -LiteralPath (Join-Path $workPath "README.md") -Encoding UTF8 -Value @"
# $id Workpapers

Status: $Status

## Mission
$($agent.mission)

## Surface
$surface

## Repo Reading Sources
$((@($agent.reads) -join "`n"))

## Allowed Local Work
$((@($agent.may_execute) -join "`n"))

## Governed Boundary
$((@($agent.blocked) -join "`n"))

## Required Closeout
agente, orden, superficie, estado, evidencia, validador, riesgo, rollback, stop_condition, proximos_carriles.
"@

  Set-Content -LiteralPath (Join-Path $workPath "CURRENT_WORKPAPER.md") -Encoding UTF8 -Value @"
# Current Workpaper - $id

- orden: actualizar capa local agentica con papeles de trabajo versionables.
- estado: $Status
- superficie: $surface
- evidencia: agents.json, AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, SURFACE_ROUTING.csv.
- validador: tool.local_validate_agent_workpapers; tool.local_validate_agent_layer.
- riesgo: ejecucion live accidental o matriz sin validador.
- rollback: revertir cambios de carpeta workpapers, matrices y snapshot repo-visible antes de merge.
- stop_condition: $stop.
- proximos_carriles: TGE, SDU/Seshat y CDF nativos, cada uno en su PR.
"@

  Set-Content -LiteralPath (Join-Path $workPath "CURRENT_STATE.md") -Encoding UTF8 -Value @"
# Current State - $id

Status: $Status
Last updated: $Today
Primary surface: $primarySurface
Workpaper validator: tool.local_validate_agent_workpapers
"@

  $routingRows = @()
  foreach ($read in @($agent.reads)) {
    $routingRows += [pscustomobject]@{
      surface_kind = "read"
      path = $read
      mode = "local_or_read_only"
      gate = "none_unless_live_or_regulated"
      validator = "tool.local_validate_agent_layer"
      stop_condition = "missing_path_or_boundary_unclear"
    }
  }
  foreach ($write in @($agent.writes)) {
    $routingRows += [pscustomobject]@{
      surface_kind = "write"
      path = $write
      mode = "local_versionable_only"
      gate = "governed_order_if_remote_live_or_production"
      validator = "tool.local_validate_agent_workpapers"
      stop_condition = "write_without_order"
    }
  }
  Export-Rows -Path (Join-Path $workPath "SURFACE_ROUTING.csv") -Rows $routingRows
  Export-Rows -Path (Join-Path $workPath "EVIDENCE_LOG.csv") -Rows @([pscustomobject]@{ date=$Today; evidence_id="EVD-$id-WORKPAPERS-20260601"; source="D agent layer"; artifact=$workPath; validator="tool.local_validate_agent_workpapers"; result="prepared_pending_fan_in_validation"; notes="no live execution" })
  Export-Rows -Path (Join-Path $workPath "DECISION_LOG.csv") -Rows @([pscustomobject]@{ date=$Today; decision_id="DEC-$id-WORKPAPERS-20260601"; authority="Cabina Universal order"; decision="agent has versioned workpapers and routing map"; rollback="revert workpaper folder and matrix rows"; stop_condition=$stop })
  Export-Rows -Path (Join-Path $workPath "OPEN_ITEMS.csv") -Rows @([pscustomobject]@{ item_id="OPEN-$id-20260601"; status="tracked"; owner_agent=$id; next_action="keep repo native matrices synchronized"; gate="governed_order_for_live_or_remote_write"; stop_condition=$stop })
  Export-Rows -Path (Join-Path $workPath "VALIDATION_LOG.csv") -Rows @([pscustomobject]@{ date=$Today; validator="tool.local_validate_agent_workpapers"; result="pending_current_run"; evidence="validator will be rerun after generation"; stop_condition="validator_failure" })

  $profilePath = [string]$agent.home_path
  if (Test-Path -LiteralPath $profilePath) {
    $profile = Get-Content -LiteralPath $profilePath -Raw
    $profile = $profile -replace "Estado: ``LOCAL_DRAFT_REVIEW``", "Estado: ``$Status``"
    $profile = $profile -replace "(?s)\r?\n## Papeles de trabajo operativos.*$", ""
    $profile += "`n## Papeles de trabajo operativos`n`n- Ruta local: $workPath`n- Snapshot repo-visible: $snapshotPath`n- Matrices: AGENT_WORKPAPERS_MATRIX, PURPOSE_SURFACE_CAPABILITY_MATRIX, AGENT_TOOL_RECIPE_SKILL_MATRIX.`n- Regla: registrar evidencia, decision, items abiertos y validacion antes de cierre.`n"
    Set-Content -LiteralPath $profilePath -Encoding UTF8 -Value $profile
  }
}

$data | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $dataPath -Encoding UTF8
Export-Rows -Path (Join-Path $Root "AGENTS_INDEX.csv") -Rows $indexRows
Export-Rows -Path (Join-Path $Root "matrices\AGENT_WORKPAPERS_MATRIX.csv") -Rows $workRows
Export-Rows -Path (Join-Path $workRoot "WORKPAPER_INDEX.csv") -Rows $workIndexRows
Export-Rows -Path (Join-Path $Root "matrices\PURPOSE_SURFACE_CAPABILITY_MATRIX.csv") -Rows $purposeRows
Export-Rows -Path (Join-Path $Root "matrices\AGENT_TOOL_RECIPE_SKILL_MATRIX.csv") -Rows $toolSkillRows

$pluginRows = @(
  [pscustomobject]@{ plugin_id="Superpowers"; availability="AVAILABLE"; assigned_agents="all_agents"; purpose="parallel dispatch TDD verification branch finish"; surface="local_codex_methodology"; live_boundary="local_only"; tool_refs="multi_agent_v1|local_validators"; validator="tool.local_validate_agent_layer"; stop_condition="agent_task_without_scope" },
  [pscustomobject]@{ plugin_id="GitHub"; availability="AVAILABLE_GOVERNED_WRITE"; assigned_agents="rey.repo_cartographer|court.seshat_evidence"; purpose="repo status PR update issue preparation draft PR publication"; surface="github_remote"; live_boundary="writes_allowed_only_by_governed_order"; tool_refs="gh|git"; validator="git_diff_check|gh_pr_view"; stop_condition="github_write_without_order" },
  [pscustomobject]@{ plugin_id="SharePoint"; availability="AVAILABLE_GOVERNED_LIVE"; assigned_agents="universe.escribania_tower|court.sdu_gate|court.seshat_evidence|universe.modo_on_tower"; purpose="site discovery and complete-read execution"; surface="microsoft_sharepoint"; live_boundary="read_direct_low_write_default_high_positive_trigger_only"; tool_refs="sharepoint_connector"; validator="postcheck_readback_required"; stop_condition="binding_or_target_resolution_required|high_without_explicit_authorization" },
  [pscustomobject]@{ plugin_id="OpenAI Developers"; availability="AVAILABLE_GOVERNED_API"; assigned_agents="court.openai_dispatcher|court.thot_schema"; purpose="agents sdk design and local evals"; surface="openai_api_or_agents_sdk"; live_boundary="api_live_requires_order_and_cost_boundary"; tool_refs="openai_docs|local_evals"; validator="synthetic_eval_manifest"; stop_condition="openai_api_live_requested_without_order" },
  [pscustomobject]@{ plugin_id="Microsoft Graph direct tenant admin"; availability="NO_DISPONIBLE_DIRECT_PLUGIN"; assigned_agents="rey.frontier_guardian|universe.escribania_tower|court.sdu_gate"; purpose="tenant-wide admin read/write is not directly available from this local layer"; surface="entra_graph_tenant"; live_boundary="requires_separate_governed_order_and_approved_connector_tool"; tool_refs="NO_DISPONIBLE"; validator="frontier_guardian_readback"; stop_condition="tenant_permission_or_production_requested" },
  [pscustomobject]@{ plugin_id="Teams"; availability="AVAILABLE_GOVERNED_LIVE"; assigned_agents="universe.escribania_tower|universe.modo_on_tower"; purpose="Teams Planner bounded reads and classified writes"; surface="microsoft_teams_planner"; live_boundary="read_direct_low_write_default_high_positive_trigger_only"; tool_refs="teams_connector"; validator="postcheck_readback_required"; stop_condition="binding_or_target_resolution_required|high_without_explicit_authorization" }
)
Export-Rows -Path (Join-Path $Root "matrices\PLUGIN_USAGE_MATRIX.csv") -Rows $pluginRows
Copy-Item -LiteralPath (Join-Path $Root "matrices\PLUGIN_USAGE_MATRIX.csv") -Destination (Join-Path $pluginRoot "PLUGIN_USAGE_MATRIX.csv") -Force

$matrixPath = Join-Path $Root "matrices\MATRIX_INDEX.csv"
$matrixRows = @(Import-Csv -LiteralPath $matrixPath)
$matrixRows = Add-MatrixIndexRow $matrixRows "agent_workpapers_matrix" ".agents\codex\matrices\AGENT_WORKPAPERS_MATRIX.csv" "agent_workpapers" "03_CORTE_EJECUTORA" "update when any agent workpaper path or validator changes"
$matrixRows = Add-MatrixIndexRow $matrixRows "plugin_usage_matrix" ".agents\codex\matrices\PLUGIN_USAGE_MATRIX.csv" "plugins" "05_SOPORTE_TECNICO" "update when plugin availability or live boundary changes"
$matrixRows = Add-MatrixIndexRow $matrixRows "purpose_surface_capability_matrix" ".agents\codex\matrices\PURPOSE_SURFACE_CAPABILITY_MATRIX.csv" "agent_surface_capabilities" "00_ROUTER" "update when purpose surface capability or repo reading route changes"
$matrixRows = Add-MatrixIndexRow $matrixRows "workpaper_index" ".agents\codex\workpapers\WORKPAPER_INDEX.csv" "agent_workpapers" "03_CORTE_EJECUTORA" "update when workpaper folder ownership changes"
Export-Rows -Path $matrixPath -Rows $matrixRows

$capPath = Join-Path $Root "matrices\CAPABILITY_MATRIX.csv"
$capRows = @(Import-Csv -LiteralPath $capPath)
$capRows = Add-UniqueRows $capRows @(
  [pscustomobject]@{ capability_id="cap.agent.workpapers"; level_id="03_CORTE_EJECUTORA"; primary_agent="court.thot_schema"; capability_type="workpaper_governance"; local_allowed="yes"; governed_order_required="no"; blocked_without_order="remote_persistent_agent|live_execution"; evidence_required="agent_workpaper_readback" },
  [pscustomobject]@{ capability_id="cap.sdu.sharepoint.complete_read.prepare"; level_id="01_AUTORIDAD_Y_GATES"; primary_agent="court.sdu_gate"; capability_type="microsoft_live_read"; local_allowed="yes"; governed_order_required="no"; blocked_without_order="none"; evidence_required="bounded_readback" },
  [pscustomobject]@{ capability_id="cap.tge.tenant.surface.assignment"; level_id="04_TORRES_DE_UNIVERSO"; primary_agent="universe.escribania_tower"; capability_type="tenant_surface_assignment"; local_allowed="yes"; governed_order_required="tenant_live_read_or_write"; blocked_without_order="tenant_identity_missing|regulated_data_broad_read"; evidence_required="tge_surface_assignment_matrix" },
  [pscustomobject]@{ capability_id="cap.cdf.agent.versioning"; level_id="04_TORRES_DE_UNIVERSO"; primary_agent="universe.modo_on_tower"; capability_type="provider_agent_versioning"; local_allowed="yes"; governed_order_required="microsoft_live_or_production"; blocked_without_order="provider_control_without_trace|tenant_write"; evidence_required="cdf_agent_versioning_readback" }
) @("capability_id")
Export-Rows -Path $capPath -Rows $capRows

$validationPath = Join-Path $Root "matrices\VALIDATION_COVERAGE_MATRIX.csv"
$validationRows = @(Import-Csv -LiteralPath $validationPath)
$validationRows = Add-UniqueRows $validationRows @(
  [pscustomobject]@{ artifact_class="workpapers"; required_index=".agents\codex\workpapers\WORKPAPER_INDEX.csv"; required_validator=".agents\codex\tools\local_validate_agent_workpapers.ps1"; owner_agent="court.seshat_evidence"; coverage_status="covered"; stop_condition="workpaper_missing_for_agent" },
  [pscustomobject]@{ artifact_class="plugins"; required_index=".agents\codex\matrices\PLUGIN_USAGE_MATRIX.csv"; required_validator=".agents\codex\tools\local_validate_agent_layer.ps1"; owner_agent="codex.workspace_guardian"; coverage_status="covered"; stop_condition="plugin_without_surface_boundary" }
) @("artifact_class", "required_index")
Export-Rows -Path $validationPath -Rows $validationRows

$evidencePath = Join-Path $Root "matrices\EVIDENCE_AND_VALIDATION_MATRIX.csv"
$evidenceRows = @(Import-Csv -LiteralPath $evidencePath)
$evidenceRows = Add-UniqueRows $evidenceRows @(
  [pscustomobject]@{ event_type="agent_workpaper_change"; required_agent="court.seshat_evidence"; required_artifact=".agents\codex\workpapers"; validator_or_check="tools\local_validate_agent_workpapers.ps1|tools\local_validate_agent_layer.ps1"; stop_condition="workpaper_missing_for_agent" },
  [pscustomobject]@{ event_type="plugin_boundary_change"; required_agent="codex.workspace_guardian"; required_artifact=".agents\codex\matrices\PLUGIN_USAGE_MATRIX.csv"; validator_or_check="tools\local_validate_agent_layer.ps1"; stop_condition="plugin_without_surface_boundary" }
) @("event_type", "required_artifact")
Export-Rows -Path $evidencePath -Rows $evidenceRows

$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$toolIndexRows = @(Import-Csv -LiteralPath $toolIndexPath)
$toolIndexRows = Add-UniqueRows $toolIndexRows @(
  [pscustomobject]@{ tool_id="tool.local_validate_agent_workpapers"; level_id="03_CORTE_EJECUTORA"; tool_type="run"; path_or_command=".agents\codex\tools\local_validate_agent_workpapers.ps1"; allowed_surface="local_filesystem"; blocked_surface="external_runtime" },
  [pscustomobject]@{ tool_id="tool.local_generate_agent_workpapers"; level_id="03_CORTE_EJECUTORA"; tool_type="run"; path_or_command=".agents\codex\tools\local_generate_agent_workpapers.ps1"; allowed_surface="local_filesystem"; blocked_surface="external_runtime|live_connector_execution" },
  [pscustomobject]@{ tool_id="tool.workpaper_index_check"; level_id="03_CORTE_EJECUTORA"; tool_type="read"; path_or_command=".agents\codex\workpapers\WORKPAPER_INDEX.csv"; allowed_surface="local_filesystem"; blocked_surface="remote_write" },
  [pscustomobject]@{ tool_id="tool.plugin_registry_check"; level_id="05_SOPORTE_TECNICO"; tool_type="read"; path_or_command=".agents\codex\matrices\PLUGIN_USAGE_MATRIX.csv"; allowed_surface="local_filesystem"; blocked_surface="live_connector_execution" },
  [pscustomobject]@{ tool_id="tool.sharepoint_complete_read_order_builder"; level_id="01_AUTORIDAD_Y_GATES"; tool_type="read"; path_or_command="sharepoint_connector"; allowed_surface="microsoft_live_exact_target"; blocked_surface="microsoft_live_read_without_current_binding|target_ambiguous|write_requested" }
) @("tool_id")
Export-Rows -Path $toolIndexPath -Rows $toolIndexRows

$toolGovPath = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
$toolGovRows = @(Import-Csv -LiteralPath $toolGovPath)
$toolGovRows = Add-UniqueRows $toolGovRows @(
  [pscustomobject]@{ tool_id="tool.local_validate_agent_workpapers"; owner_agent="court.thot_schema"; tool_type="run"; governed_asset_classes="agent|workpaper|matrix"; allowed_surface="local_filesystem"; allowed_actions="validate_workpapers"; blocked_surface="external_runtime"; required_evidence="validator_readback"; validator="tool.local_validate_agent_layer" },
  [pscustomobject]@{ tool_id="tool.local_generate_agent_workpapers"; owner_agent="court.thot_schema"; tool_type="run"; governed_asset_classes="agent|workpaper|matrix"; allowed_surface="local_filesystem"; allowed_actions="generate_workpapers"; blocked_surface="external_runtime|live_connector_execution"; required_evidence="workpaper_generation_readback"; validator="tool.local_validate_agent_layer" },
  [pscustomobject]@{ tool_id="tool.workpaper_index_check"; owner_agent="court.seshat_evidence"; tool_type="read"; governed_asset_classes="workpaper"; allowed_surface="local_filesystem"; allowed_actions="read|parse"; blocked_surface="remote_write"; required_evidence="workpaper_index_readback"; validator="tool.local_validate_agent_layer" },
  [pscustomobject]@{ tool_id="tool.plugin_registry_check"; owner_agent="codex.workspace_guardian"; tool_type="read"; governed_asset_classes="plugin|tool"; allowed_surface="local_filesystem"; allowed_actions="read|classify"; blocked_surface="live_connector_execution"; required_evidence="plugin_boundary_readback"; validator="tool.local_validate_agent_layer" },
  [pscustomobject]@{ tool_id="tool.sharepoint_complete_read_order_builder"; owner_agent="rey.frontier_guardian"; tool_type="read"; governed_asset_classes="order|surface|microsoft_live"; allowed_surface="microsoft_live_exact_target"; allowed_actions="execute_bounded_read"; blocked_surface="microsoft_live_read_without_current_binding|target_ambiguous|write_requested"; required_evidence="governed_readback"; validator="tool.local_validate_agent_layer" }
) @("tool_id")
Export-Rows -Path $toolGovPath -Rows $toolGovRows

$recipePath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$recipeRows = @(Import-Csv -LiteralPath $recipePath)
$recipeRows = Add-UniqueRows $recipeRows @(
  [pscustomobject]@{ recipe_id="recipe.agent_workpaper_operation"; level_id="03_CORTE_EJECUTORA"; primary_agent="court.seshat_evidence"; path=".agents\codex\recipes\recipe.agent_workpaper_operation.md"; output="agent_workpaper_packet" },
  [pscustomobject]@{ recipe_id="recipe.sharepoint_complete_read_order"; level_id="01_AUTORIDAD_Y_GATES"; primary_agent="court.sdu_gate"; path=".agents\codex\recipes\recipe.sharepoint_complete_read_order.md"; output="sharepoint_complete_read_order_packet" },
  [pscustomobject]@{ recipe_id="recipe.agent_surface_capability_assignment"; level_id="04_TORRES_DE_UNIVERSO"; primary_agent="universe.escribania_tower"; path=".agents\codex\recipes\recipe.agent_surface_capability_assignment.md"; output="surface_capability_assignment" }
) @("recipe_id")
Export-Rows -Path $recipePath -Rows $recipeRows

Set-Content -LiteralPath (Join-Path $Root "recipes\recipe.agent_workpaper_operation.md") -Encoding UTF8 -Value "# recipe.agent_workpaper_operation`n`n1. Read the agent profile and workpaper index.`n2. Update only the agent-owned workpaper files.`n3. Link evidence, decision, open items and validators.`n4. Stop on live, secret, production or missing owner boundaries.`n"
Set-Content -LiteralPath (Join-Path $Root "recipes\recipe.sharepoint_complete_read_order.md") -Encoding UTF8 -Value "# recipe.sharepoint_complete_read_order`n`nExecute a bounded SharePoint READ directly with authenticated capability, current binding, exact target, minimization and evidence. A known write without a positive HIGH trigger is LOW by default and needs precheck, rollback or compensation, postcheck and evidence; no order, allowlist or receipt. Missing prerequisites yield RESOLUTION_REQUIRED and BLOCKED_NOT_EXECUTABLE while preserving the tier.`n"
Set-Content -LiteralPath (Join-Path $Root "recipes\recipe.agent_surface_capability_assignment.md") -Encoding UTF8 -Value "# recipe.agent_surface_capability_assignment`n`nAssign each agent to its repo sources, tenant or provider surface, responsibility, process, validator and workpaper. Local documentation can advance; live action requires governed order.`n"

$skillPath = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$skillRows = @(Import-Csv -LiteralPath $skillPath)
$skillRows = Add-UniqueRows $skillRows @(
  [pscustomobject]@{ skill_id="superpowers:dispatching-parallel-agents"; source="plugin"; assigned_level="all"; assigned_agents="all_agents"; use_when="independent lanes need fan-out and fan-in"; live_boundary="local_methodology_only" },
  [pscustomobject]@{ skill_id="github:yeet"; source="plugin"; assigned_level="02_REGISTRO_Y_CARTOGRAFIA"; assigned_agents="rey.repo_cartographer|court.seshat_evidence"; use_when="commit push and draft PR update under explicit GitHub order"; live_boundary="github_write_requires_order" },
  [pscustomobject]@{ skill_id="sharepoint:sharepoint"; source="plugin"; assigned_level="04_TORRES_DE_UNIVERSO"; assigned_agents="universe.escribania_tower|court.sdu_gate|universe.modo_on_tower"; use_when="SharePoint live context or bounded complete read"; live_boundary="read_direct_low_default_high_trigger_only" },
  [pscustomobject]@{ skill_id="sdu-auditor-sharepoint-vivo"; source="local"; assigned_level="03_CORTE_EJECUTORA"; assigned_agents="court.sdu_gate|court.seshat_evidence"; use_when="SDU SharePoint bounded live audit with current binding"; live_boundary="read_direct_low_default_high_trigger_only" }
) @("skill_id", "assigned_agents")
Export-Rows -Path $skillPath -Rows $skillRows

$inventoryPath = Join-Path $Root "matrices\GOVERNED_ASSET_CANONICAL_INVENTORY.csv"
$inventoryRows = @(Import-Csv -LiteralPath $inventoryPath)
$inventoryRows = Add-UniqueRows $inventoryRows @(
  [pscustomobject]@{ asset_class="workpapers"; asset_id="D_AGENT_WORKPAPERS"; owner_agent="court.seshat_evidence"; authority_level="03_CORTE_EJECUTORA"; governing_matrix=".agents\codex\matrices\AGENT_WORKPAPERS_MATRIX.csv"; required_recipe="recipe.agent_workpaper_operation"; required_tool="tool.local_validate_agent_workpapers"; evidence="workpaper_readback"; validator="tool.local_validate_agent_layer"; coverage_status="covered"; stop_condition="workpaper_missing_for_agent" },
  [pscustomobject]@{ asset_class="plugins"; asset_id="D_PLUGIN_USAGE"; owner_agent="codex.workspace_guardian"; authority_level="05_SOPORTE_TECNICO"; governing_matrix=".agents\codex\matrices\PLUGIN_USAGE_MATRIX.csv"; required_recipe="recipe.matrix_recipe_skill_sync"; required_tool="tool.plugin_registry_check"; evidence="plugin_boundary_readback"; validator="tool.local_validate_agent_layer"; coverage_status="covered"; stop_condition="plugin_without_surface_boundary" }
) @("asset_class", "asset_id")
Export-Rows -Path $inventoryPath -Rows $inventoryRows

$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$stopRows = @(Import-Csv -LiteralPath $stopPath)
$stopRows = Add-UniqueRows $stopRows @(
  [pscustomobject]@{ stop_condition="workpaper_missing_for_agent"; normalized_family="agent_workpapers"; meaning="an agent lacks folder index row or required workpaper file"; required_action="create or restore workpaper artifacts before closeout"; applies_to="agent|workpaper" },
  [pscustomobject]@{ stop_condition="plugin_without_surface_boundary"; normalized_family="plugin_governance"; meaning="plugin is referenced without availability live boundary or validator"; required_action="declare plugin boundary or mark NO_DISPONIBLE"; applies_to="plugin|tool|agent" },
  [pscustomobject]@{ stop_condition="binding_or_target_resolution_required"; normalized_family="microsoft_live"; meaning="Microsoft execution lacks current binding or bounded exact target"; required_action="resolve capability binding target and execution prerequisites while preserving tier"; applies_to="sharepoint|teams|outlook|graph|tenant" }
) @("stop_condition")
Export-Rows -Path $stopPath -Rows $stopRows

$lineagePath = Join-Path $Root "matrices\CANONICAL_INDEX_LINEAGE_AUDIT.csv"
$lineageRows = @(Import-Csv -LiteralPath $lineagePath)
$lineageRows = Add-UniqueRows $lineageRows @(
  [pscustomobject]@{ lineage_id="agents_json_to_workpapers"; source="agents.json"; derived="AGENT_WORKPAPERS_MATRIX.csv|WORKPAPER_INDEX.csv|workpapers/<agent_id>"; derivation="agent registry materializes workpaper folders and index rows"; owner_agent="court.seshat_evidence"; validator="tool.local_validate_agent_layer" },
  [pscustomobject]@{ lineage_id="plugins_to_purpose_surface_capability"; source="PLUGIN_USAGE_MATRIX.csv"; derived="PURPOSE_SURFACE_CAPABILITY_MATRIX.csv"; derivation="plugin boundaries become agent purpose surface capability refs"; owner_agent="codex.workspace_guardian"; validator="tool.local_validate_agent_layer" }
) @("lineage_id")
Export-Rows -Path $lineagePath -Rows $lineageRows

$routingPath = Join-Path $Root "routing.json"
$routing = Get-Content -LiteralPath $routingPath -Raw | ConvertFrom-Json
$routing.status = $Status
if (-not (@($routing.routes) | Where-Object { $_.order_class -eq "agent_workpapers_versioning" })) {
  $routing.routes += [pscustomobject]@{
    order_class = "agent_workpapers_versioning"
    signals = @("papeles de trabajo", "workpapers", "capacidades por agente", "skills recetas tools plugins", "superficie rol responsabilidad proceso")
    agents = @("court.thot_schema", "court.seshat_evidence", "rey.governance_registrar", "rey.frontier_guardian")
  }
}
$routing | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $routingPath -Encoding UTF8

$readmePath = Join-Path $Root "README.md"
$readme = Get-Content -LiteralPath $readmePath -Raw
$readme = $readme -replace "Los archivos son declarativos\. No crean agentes remotos persistentes, no ejecutan llamadas externas y no autorizan writes live por si mismos\.", "Los archivos son declarativos y operativos locales: cada agente tiene papeles de trabajo versionables. No crean agentes remotos persistentes, no ejecutan llamadas externas y no autorizan writes live por si mismos."
$readme = $readme -replace "- ``readbacks\\``: cierres locales de agentes\.", "- ``readbacks\\``: cierres locales de agentes.`n- ``workpapers\\``: papeles de trabajo por agente, con evidencia, decisiones, pendientes, rutas de superficie y validaciones.`n- ``plugins\\``: matriz de disponibilidad y frontera de plugins."
$readme = $readme -replace "11\. Validar con ``tools\\local_validate_agent_levels\.ps1``\.", "11. Validar con ``tools\\local_validate_agent_levels.ps1``, ``tools\\local_validate_agent_workpapers.ps1`` y ``tools\\local_validate_agent_layer.ps1``."
$readme = $readme -replace "Estado actual: ``LOCAL_GOVERNED_VERSIONING_DRAFT_PR_OPEN``\.", "Estado actual: ``LOCAL_GOVERNED_WORKPAPERS_ACTIVE``."
Set-Content -LiteralPath $readmePath -Encoding UTF8 -Value $readme

Write-Output "generated D agent workpapers for $(@($data.agents).Count) agents"
