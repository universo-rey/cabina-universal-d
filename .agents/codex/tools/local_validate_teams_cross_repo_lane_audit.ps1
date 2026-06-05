param(
  [string]$Root = ".agents\codex"
)

$ErrorActionPreference = "Stop"

function Read-CsvSafe {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing CSV: $Path"
  }
  @(Import-Csv -LiteralPath $Path)
}

function Resolve-CabinaPath {
  param([string]$Path)
  if ([string]::IsNullOrWhiteSpace($Path)) { return $Path }
  $resolvedRoot = (Resolve-Path -LiteralPath $Root).Path
  $repoRoot = Split-Path -Parent (Split-Path -Parent $resolvedRoot)
  $normalized = $Path -replace "/", "\"
  if ($normalized.StartsWith(".agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $Root ($normalized.Substring(".agents\codex".Length).TrimStart("\"))
  }
  if ($normalized.StartsWith("C:\Users\enzo1\Documents\GitHub\cabina-universal-d", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $repoRoot ($normalized.Substring("C:\Users\enzo1\Documents\GitHub\cabina-universal-d".Length).TrimStart("\"))
  }
  return $Path
}

$matrixPath = Join-Path $Root "matrices\TEAMS_CROSS_REPO_LANE_AUDIT_MATRIX_20260602.csv"
$nextLaneMatrixPath = Join-Path $Root "matrices\MICROSOFT_NEXT_LANE_EXECUTION_MATRIX_20260602.csv"
$readbackPath = Join-Path $Root "readbacks\2026-06-02_teams_cross_repo_lane_audit_readback.md"
$nextLaneReadbackPath = Join-Path $Root "readbacks\2026-06-02_microsoft_production_tenant_write_next_lanes_readback.md"
$orderPath = Join-Path $Root "orders\ORDER_MICROSOFT_TEAMS_LIVE_READ_INVENTORY_20260602.md"
$productionTenantOrderPath = Join-Path $Root "orders\ORDER_MICROSOFT_PRODUCTION_TENANT_WRITES_APPROVAL_20260602.md"
$matrixIndexPath = Join-Path $Root "matrices\MATRIX_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$toolGovernancePath = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
$validationCoveragePath = Join-Path $Root "matrices\VALIDATION_COVERAGE_MATRIX.csv"
$skillUsagePath = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$localSkillCatalogPath = Join-Path $Root "matrices\LOCAL_SKILL_CATALOG.csv"
$pluginUsagePath = Join-Path $Root "matrices\PLUGIN_USAGE_MATRIX.csv"
$pluginBoundaryPath = Join-Path $Root "matrices\PLUGIN_SKILL_BOUNDARY_MATRIX.csv"
$resolvedRootForOrderIndex = (Resolve-Path -LiteralPath $Root).Path
$repoRootForOrderIndex = Split-Path -Parent (Split-Path -Parent $resolvedRootForOrderIndex)
$orderIndexPath = Join-Path $repoRootForOrderIndex "02_AUTHORITY_CANON\GOVERNED_ORDERS_INDEX.csv"
$stopGlossaryPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

foreach ($path in @($matrixPath,$nextLaneMatrixPath,$readbackPath,$nextLaneReadbackPath,$orderPath,$productionTenantOrderPath,$matrixIndexPath,$toolIndexPath,$toolGovernancePath,$validationCoveragePath,$skillUsagePath,$localSkillCatalogPath,$pluginUsagePath,$pluginBoundaryPath,$orderIndexPath,$stopGlossaryPath)) {
  if (-not (Test-Path -LiteralPath $path)) {
    $errors.Add("Missing required Teams lane artifact: $path")
  }
}

if ($errors.Count -eq 0) {
  $rows = Read-CsvSafe -Path $matrixPath
  $requiredColumns = @("lane_id","repo_id","repository","universe","lane_type","agent","recipe","tool","skill","plugin","surface","status","live_microsoft_mode","allowed_actions","blocked_actions","evidence","validator","risk","rollback","stop_condition","proximos_carriles")
  $actualColumns = @($rows[0].PSObject.Properties.Name)
  foreach ($column in $requiredColumns) {
    if ($column -notin $actualColumns) {
      $errors.Add("Teams lane matrix missing column: $column")
    }
  }

  $expectedRepoIds = @(
    "D_CABINA_UNIVERSAL_ROOT",
    "ORGANIZACION",
    "TORRE_GEMELA_ESCRIBANIA",
    "TGE_AGENTIC_RUNTIME",
    "SGIN_CUMPLIMIENTO",
    "CDF_SOLUCIONES",
    "JARA_CONSULTORES",
    "MODO_ON_FOUNDATION",
    "SDU_CANON",
    "SESHAT_BOOTSTRAP",
    "SGIN",
    "TCU_AGENTIC_RUNTIME"
  )
  $repoIds = @($rows | ForEach-Object { $_.repo_id } | Sort-Object -Unique)
  foreach ($repoId in $expectedRepoIds) {
    if ($repoId -notin $repoIds) {
      $errors.Add("Teams lane matrix missing repo_id: $repoId")
    }
  }

  $knownStops = @((Read-CsvSafe -Path $stopGlossaryPath) | ForEach-Object { $_.stop_condition })
  $laneIds = @{}
  foreach ($row in $rows) {
    if ([string]::IsNullOrWhiteSpace($row.lane_id)) {
      $errors.Add("Teams lane row has blank lane_id")
    } elseif ($laneIds.ContainsKey($row.lane_id)) {
      $errors.Add("Duplicate Teams lane_id: $($row.lane_id)")
    } else {
      $laneIds[$row.lane_id] = $true
    }
    foreach ($field in $requiredColumns) {
      if ([string]::IsNullOrWhiteSpace($row.$field)) {
        $errors.Add("Teams lane '$($row.lane_id)' missing $field")
      }
    }
    if ($row.validator -notmatch "tool\.local_validate_teams_cross_repo_lane_audit") {
      $errors.Add("Teams lane '$($row.lane_id)' does not reference local Teams validator")
    }
    foreach ($stop in @($row.stop_condition -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
      if ($stop -notin $knownStops) {
        $errors.Add("Teams lane '$($row.lane_id)' references unknown stop_condition: $stop")
      }
    }
    $forbiddenAllowed = @("send_channel_message","send_chat_message","reply_to_message","reply_to_channel_message","create_channel","create_chat","permission_change","production")
    foreach ($token in $forbiddenAllowed) {
      if ($row.allowed_actions -match [regex]::Escape($token)) {
        $errors.Add("Teams lane '$($row.lane_id)' allowed_actions includes forbidden token: $token")
      }
    }
    if (($row.live_microsoft_mode -match "LIVE_READ_APPROVED") -and ($row.blocked_actions -notmatch "Teams writes")) {
      $errors.Add("Teams lane '$($row.lane_id)' has live read approval without explicit Teams write block")
    }
  }

  $matrixIndexRows = Read-CsvSafe -Path $matrixIndexPath
  if ("teams_cross_repo_lane_audit_matrix" -notin @($matrixIndexRows | ForEach-Object { $_.matrix_id })) {
    $errors.Add("MATRIX_INDEX missing teams_cross_repo_lane_audit_matrix")
  }
  if ("microsoft_next_lane_execution_matrix" -notin @($matrixIndexRows | ForEach-Object { $_.matrix_id })) {
    $errors.Add("MATRIX_INDEX missing microsoft_next_lane_execution_matrix")
  }

  $nextLaneRows = Read-CsvSafe -Path $nextLaneMatrixPath
  $nextLaneColumns = @("lane_id","repository","issue_or_pr","surface","authorization_state","owner_agent","recipe","tool","status","allowed_actions","blocked_actions","evidence","validator","rollback","postcheck","stop_condition","next_action")
  $nextLaneActualColumns = @($nextLaneRows[0].PSObject.Properties.Name)
  foreach ($column in $nextLaneColumns) {
    if ($column -notin $nextLaneActualColumns) {
      $errors.Add("Microsoft next-lane matrix missing column: $column")
    }
  }
  foreach ($requiredLane in @(
    "microsoft.tenant.production.approval_gate",
    "teams.consent.read.scope",
    "teams.selected.triage",
    "tge.selected.process.production",
    "sdu_cn.teams.target.boundary",
    "cdf.teams.ci.evidence",
    "sgin.teams.read.write.split"
  )) {
    if ($requiredLane -notin @($nextLaneRows | ForEach-Object { $_.lane_id })) {
      $errors.Add("Microsoft next-lane matrix missing lane_id: $requiredLane")
    }
  }
  foreach ($row in $nextLaneRows) {
    foreach ($field in $nextLaneColumns) {
      if ([string]::IsNullOrWhiteSpace($row.$field)) {
        $errors.Add("Microsoft next-lane '$($row.lane_id)' missing $field")
      }
    }
    foreach ($stop in @($row.stop_condition -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
      if ($stop -notin $knownStops) {
        $errors.Add("Microsoft next-lane '$($row.lane_id)' references unknown stop_condition: $stop")
      }
    }
    foreach ($blocked in @("secret", "raw", "production")) {
      if ($row.blocked_actions -notmatch $blocked) {
        $errors.Add("Microsoft next-lane '$($row.lane_id)' blocked_actions missing expected boundary token: $blocked")
      }
    }
  }

  $toolRows = Read-CsvSafe -Path $toolIndexPath
  if ("tool.local_validate_teams_cross_repo_lane_audit" -notin @($toolRows | ForEach-Object { $_.tool_id })) {
    $errors.Add("TOOL_INDEX missing local Teams lane validator")
  }

  $toolGovernanceRows = Read-CsvSafe -Path $toolGovernancePath
  if ("tool.local_validate_teams_cross_repo_lane_audit" -notin @($toolGovernanceRows | ForEach-Object { $_.tool_id })) {
    $errors.Add("TOOL_GOVERNANCE_MATRIX missing local Teams lane validator")
  }

  $coverageRows = Read-CsvSafe -Path $validationCoveragePath
  if ("teams_cross_repo_lane_audit" -notin @($coverageRows | ForEach-Object { $_.artifact_class })) {
    $errors.Add("VALIDATION_COVERAGE_MATRIX missing teams_cross_repo_lane_audit")
  }
  if ("microsoft_next_lane_execution" -notin @($coverageRows | ForEach-Object { $_.artifact_class })) {
    $errors.Add("VALIDATION_COVERAGE_MATRIX missing microsoft_next_lane_execution")
  }

  $skillIds = @((Read-CsvSafe -Path $skillUsagePath) | ForEach-Object { $_.skill_id })
  foreach ($skill in @("teams:teams","teams:teams-messages","teams:teams-planner-task-management")) {
    if ($skill -notin $skillIds) {
      $errors.Add("SKILL_USAGE_MATRIX missing $skill")
    }
  }
  $catalogSkillIds = @((Read-CsvSafe -Path $localSkillCatalogPath) | ForEach-Object { $_.skill_id })
  foreach ($skill in @("teams:teams","teams:teams-messages","teams:teams-planner-task-management")) {
    if ($skill -notin $catalogSkillIds) {
      $errors.Add("LOCAL_SKILL_CATALOG missing $skill")
    }
  }

  $pluginRows = Read-CsvSafe -Path $pluginUsagePath
  $teamsPlugin = @($pluginRows | Where-Object { $_.plugin_id -eq "Teams" })
  if ($teamsPlugin.Count -eq 0) {
    $errors.Add("PLUGIN_USAGE_MATRIX missing Teams plugin")
  } elseif ($teamsPlugin[0].live_boundary -notmatch "governed_order") {
    $errors.Add("Teams plugin live boundary does not require governed order")
  }

  $pluginBoundaryRows = Read-CsvSafe -Path $pluginBoundaryPath
  if ("Teams" -notin @($pluginBoundaryRows | ForEach-Object { $_.plugin_id })) {
    $errors.Add("PLUGIN_SKILL_BOUNDARY_MATRIX missing Teams row")
  }

  $orderIndexRows = Read-CsvSafe -Path $orderIndexPath
  if ("D_MICROSOFT_TEAMS_LIVE_READ_INVENTORY_20260602" -notin @($orderIndexRows | ForEach-Object { $_.order_id })) {
    $errors.Add("GOVERNED_ORDERS_INDEX missing Teams live-read order")
  }
  if ("D_MICROSOFT_PRODUCTION_TENANT_WRITES_APPROVAL_20260602" -notin @($orderIndexRows | ForEach-Object { $_.order_id })) {
    $errors.Add("GOVERNED_ORDERS_INDEX missing Microsoft production tenant write approval order")
  }

  $readback = Get-Content -Raw -LiteralPath $readbackPath
  foreach ($requiredText in @("write tools called: none","raw previews were discarded","Team.ReadBasic.All","production: approved gated after initial preflight; not executed")) {
    if ($readback -notmatch [regex]::Escape($requiredText)) {
      $errors.Add("Readback missing expected evidence text: $requiredText")
    }
  }
  $nextLaneReadback = Get-Content -Raw -LiteralPath $nextLaneReadbackPath
  foreach ($requiredText in @("APPROVED_GATED_NOT_EXECUTED","No tenant write","https://github.com/universo-rey/cabina-universal-d/issues/32","https://github.com/SeshatSgin/cdf-soluciones/pull/23")) {
    if ($nextLaneReadback -notmatch [regex]::Escape($requiredText)) {
      $errors.Add("Next-lane readback missing expected evidence text: $requiredText")
    }
  }

  $orderText = Get-Content -Raw -LiteralPath $orderPath
  foreach ($blockedText in @("send_chat_message","send_channel_message","create_channel","permission_change","production","raw_message_export")) {
    if ($orderText -notmatch [regex]::Escape($blockedText)) {
      $errors.Add("Teams order missing blocked action: $blockedText")
    }
  }
  $productionTenantOrderText = Get-Content -Raw -LiteralPath $productionTenantOrderPath
  foreach ($requiredText in @("issue-scoped governed execution","exact surface, object, identity, owner, rollback, postcheck","broad tenant write","secret materialization")) {
    if ($productionTenantOrderText -notmatch [regex]::Escape($requiredText)) {
      $errors.Add("Production tenant order missing required boundary text: $requiredText")
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
  $scanFiles = @($matrixPath,$nextLaneMatrixPath,$readbackPath,$nextLaneReadbackPath,$orderPath,$productionTenantOrderPath)
  foreach ($file in $scanFiles) {
    foreach ($pattern in $secretPatterns) {
      $hits = Select-String -LiteralPath $file -Pattern $pattern -CaseSensitive -ErrorAction SilentlyContinue
      foreach ($hit in $hits) {
        $errors.Add("Secret-like pattern in Teams artifact $file line $($hit.LineNumber): $pattern")
      }
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  matrix = $matrixPath
  next_lane_matrix = $nextLaneMatrixPath
  readback = $readbackPath
  next_lane_readback = $nextLaneReadbackPath
  order = $orderPath
  production_tenant_order = $productionTenantOrderPath
  error_count = $errors.Count
  errors = $errors
  warning_count = $warnings.Count
  warnings = $warnings
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
