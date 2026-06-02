param(
  [string]$Root = "D:\.agents\codex"
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
  $repoRoot = Split-Path -Parent (Split-Path -Parent $Root)
  $normalized = $Path -replace "/", "\"
  if ($normalized.StartsWith("D:\.agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $Root ($normalized.Substring("D:\.agents\codex".Length).TrimStart("\"))
  }
  if ($normalized.StartsWith("D:\", [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $repoRoot ($normalized.Substring("D:\".Length).TrimStart("\"))
  }
  return $Path
}

$matrixPath = Join-Path $Root "matrices\TEAMS_CROSS_REPO_LANE_AUDIT_MATRIX_20260602.csv"
$readbackPath = Join-Path $Root "readbacks\2026-06-02_teams_cross_repo_lane_audit_readback.md"
$orderPath = Join-Path $Root "orders\ORDER_MICROSOFT_TEAMS_LIVE_READ_INVENTORY_20260602.md"
$matrixIndexPath = Join-Path $Root "matrices\MATRIX_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$toolGovernancePath = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
$validationCoveragePath = Join-Path $Root "matrices\VALIDATION_COVERAGE_MATRIX.csv"
$skillUsagePath = Join-Path $Root "skills\SKILL_USAGE_MATRIX.csv"
$localSkillCatalogPath = Join-Path $Root "matrices\LOCAL_SKILL_CATALOG.csv"
$pluginUsagePath = Join-Path $Root "matrices\PLUGIN_USAGE_MATRIX.csv"
$pluginBoundaryPath = Join-Path $Root "matrices\PLUGIN_SKILL_BOUNDARY_MATRIX.csv"
$orderIndexPath = Join-Path (Split-Path -Parent (Split-Path -Parent $Root)) "02_AUTHORITY_CANON\GOVERNED_ORDERS_INDEX.csv"
$stopGlossaryPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

foreach ($path in @($matrixPath,$readbackPath,$orderPath,$matrixIndexPath,$toolIndexPath,$toolGovernancePath,$validationCoveragePath,$skillUsagePath,$localSkillCatalogPath,$pluginUsagePath,$pluginBoundaryPath,$orderIndexPath,$stopGlossaryPath)) {
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

  $readback = Get-Content -Raw -LiteralPath $readbackPath
  foreach ($requiredText in @("write tools called: none","raw previews were discarded","Team.ReadBasic.All","production: not authorized")) {
    if ($readback -notmatch [regex]::Escape($requiredText)) {
      $errors.Add("Readback missing expected evidence text: $requiredText")
    }
  }

  $orderText = Get-Content -Raw -LiteralPath $orderPath
  foreach ($blockedText in @("send_chat_message","send_channel_message","create_channel","permission_change","production","raw_message_export")) {
    if ($orderText -notmatch [regex]::Escape($blockedText)) {
      $errors.Add("Teams order missing blocked action: $blockedText")
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
  $scanFiles = @($matrixPath,$readbackPath,$orderPath)
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
  readback = $readbackPath
  order = $orderPath
  error_count = $errors.Count
  errors = $errors
  warning_count = $warnings.Count
  warnings = $warnings
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
