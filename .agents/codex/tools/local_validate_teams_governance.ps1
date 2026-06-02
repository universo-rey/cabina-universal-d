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

function Require-Columns {
  param(
    [string]$Path,
    [string[]]$Columns,
    [System.Collections.Generic.List[string]]$Errors
  )
  $rows = Read-CsvSafe -Path $Path
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

function Require-File {
  param(
    [string]$Path,
    [System.Collections.Generic.List[string]]$Errors
  )
  $resolved = Resolve-CabinaPath -Path $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    $Errors.Add("Missing file: $Path")
  }
}

function Require-Text {
  param(
    [string]$Path,
    [string[]]$Tokens,
    [System.Collections.Generic.List[string]]$Errors
  )
  $resolved = Resolve-CabinaPath -Path $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    $Errors.Add("Missing text file: $Path")
    return
  }
  $text = Get-Content -Raw -LiteralPath $resolved
  foreach ($token in $Tokens) {
    if ($text -notmatch [regex]::Escape($token)) {
      $Errors.Add("$Path missing token: $token")
    }
  }
}

function Check-StopCondition {
  param(
    [string]$Value,
    [string[]]$KnownStops,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($token in @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($token -notin $KnownStops) {
      $Errors.Add("$Context references unknown stop_condition: $token")
    }
  }
}

$surfacePath = Join-Path $Root "matrices\TEAMS_GOVERNANCE_SURFACE_MATRIX.csv"
$capabilityPath = Join-Path $Root "matrices\TEAMS_AGENT_CAPABILITY_MATRIX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$pluginPath = Join-Path $Root "matrices\PLUGIN_USAGE_MATRIX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$policyPath = "D:\02_AUTHORITY_CANON\POLICIES\TEAMS_GOVERNANCE_POLICY_20260602.md"
$globalPolicyPath = "D:\02_AUTHORITY_CANON\POLICIES\GLOBAL_MICROSOFT_LIVE_PRODUCTION_POLICY_20260601.md"
$orderPath = Join-Path $Root "orders\ORDER_TEAMS_GOVERNANCE_LIVE_READ_DRAFT_20260602.md"
$readbackPath = Join-Path $Root "readbacks\2026-06-02_teams_governance_readback.md"
$workpaperPath = Join-Path $Root "workpapers\teams\README.md"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-File -Path $policyPath -Errors $errors
Require-File -Path $globalPolicyPath -Errors $errors
Require-File -Path $orderPath -Errors $errors
Require-File -Path $readbackPath -Errors $errors
Require-File -Path $workpaperPath -Errors $errors

Require-Columns -Path $surfacePath -Columns @("surface_id","universe","microsoft_surface","owner_agent","reviewer_agent","agent","skill","recipe","tool","plugin","read_scope","write_scope","allowed_without_order","live_read_gate","live_write_gate","evidence","validator","risk","rollback","stop_condition","status") -Errors $errors
Require-Columns -Path $capabilityPath -Columns @("agent_id","role","universe","teams_surface","workpaper_folder","skills","recipes","tools","plugins","allowed_actions","blocked_actions","evidence","validator","risk","rollback","stop_condition","status") -Errors $errors

$knownStops = @((Read-CsvSafe -Path $stopPath) | ForEach-Object { $_.stop_condition })
$toolIds = @((Read-CsvSafe -Path $toolIndexPath) | ForEach-Object { $_.tool_id })
$plugins = @(Read-CsvSafe -Path $pluginPath)
$teamsPlugin = @($plugins | Where-Object { $_.plugin_id -eq "Teams" })

if ("tool.local_validate_teams_governance" -notin $toolIds) {
  $errors.Add("TOOL_INDEX missing tool.local_validate_teams_governance")
}
if ($teamsPlugin.Count -eq 0) {
  $errors.Add("PLUGIN_USAGE_MATRIX missing Teams plugin row")
} elseif ($teamsPlugin[0].live_boundary -notmatch "governed_order") {
  $errors.Add("Teams plugin row must keep governed_order live boundary")
}

$surfaces = Read-CsvSafe -Path $surfacePath
$capabilities = Read-CsvSafe -Path $capabilityPath

$requiredSurfaces = @(
  "teams.chat",
  "teams.channel_messages",
  "teams.team_channel_inventory",
  "teams.membership_permissions",
  "teams.apps_connectors_webhooks",
  "teams.files_sharepoint_bridge",
  "teams.planner",
  "teams.meetings_calendar",
  "teams.notifications",
  "teams.graph_fallback"
)

foreach ($surfaceId in $requiredSurfaces) {
  if ($surfaceId -notin @($surfaces | ForEach-Object { $_.surface_id })) {
    $errors.Add("Missing Teams surface row: $surfaceId")
  }
}

foreach ($row in $surfaces) {
  foreach ($field in @("surface_id","owner_agent","reviewer_agent","skill","recipe","tool","plugin","read_scope","write_scope","evidence","validator","risk","rollback","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Teams surface '$($row.surface_id)' missing $field")
    }
  }
  if ($row.status -ne "ACTIVE_LOCAL_PREP") {
    $errors.Add("Teams surface '$($row.surface_id)' must remain ACTIVE_LOCAL_PREP")
  }
  if ($row.live_read_gate -notmatch "governed_order_required") {
    $errors.Add("Teams surface '$($row.surface_id)' missing governed live read gate")
  }
  if ($row.live_write_gate -notmatch "separate_explicit") {
    $errors.Add("Teams surface '$($row.surface_id)' missing separate explicit write gate")
  }
  if ($row.write_scope -notmatch "none without separate order") {
    $errors.Add("Teams surface '$($row.surface_id)' write_scope must block writes")
  }
  if ($row.stop_condition -notmatch "microsoft_live_requested_without_governed_order") {
    $errors.Add("Teams surface '$($row.surface_id)' must include microsoft live stop condition")
  }
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Teams surface '$($row.surface_id)'"
}

$requiredAgents = @(
  "rey.frontier_guardian",
  "court.sdu_gate",
  "court.seshat_evidence",
  "court.thot_schema",
  "universe.escribania_tower",
  "universe.modo_on_tower",
  "tech.reference_librarian"
)

foreach ($agentId in $requiredAgents) {
  if ($agentId -notin @($capabilities | ForEach-Object { $_.agent_id })) {
    $errors.Add("Missing Teams capability agent row: $agentId")
  }
}

foreach ($row in $capabilities) {
  foreach ($field in @("agent_id","role","universe","teams_surface","workpaper_folder","skills","recipes","tools","plugins","allowed_actions","blocked_actions","evidence","validator","risk","rollback","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Teams capability '$($row.agent_id)' missing $field")
    }
  }
  if ($row.status -ne "ACTIVE_LOCAL_PREP") {
    $errors.Add("Teams capability '$($row.agent_id)' must remain ACTIVE_LOCAL_PREP")
  }
  if ($row.blocked_actions -notmatch "live|message|permission|production|secret|raw|tenant") {
    $warnings.Add("Teams capability '$($row.agent_id)' blocked_actions may be too weak")
  }
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "Teams capability '$($row.agent_id)'"
}

Require-Text -Path $policyPath -Tokens @(
  "Teams queda gobernado como superficie Microsoft live",
  "No autoriza lectura live",
  "Produccion queda cerrada"
) -Errors $errors

Require-Text -Path $orderPath -Tokens @(
  "- order_class:",
  "- surface:",
  "- owner:",
  "- identity:",
  "- data_boundary:",
  "- allowed_actions:",
  "- blocked_actions:",
  "- rollback:",
  "- postcheck:",
  "- evidence:",
  "- validator:",
  "- stop_condition:",
  "STOP_BEFORE_TEAMS_LIVE_READ"
) -Errors $errors

Require-Text -Path $readbackPath -Tokens @(
  "TEAMS_GOVERNANCE_LOCAL_PREPARED_NO_LIVE_EXECUTION",
  "No se leyo Teams live",
  "microsoft_live_requested_without_governed_order"
) -Errors $errors

$secretPatterns = @("client_secret", "password", "authorization:", "bearer ", "api_key", ("tok" + "en="))
foreach ($path in @($policyPath, $orderPath, $readbackPath, $surfacePath, $capabilityPath)) {
  $resolved = Resolve-CabinaPath -Path $path
  if (Test-Path -LiteralPath $resolved) {
    $text = Get-Content -Raw -LiteralPath $resolved
    foreach ($pattern in $secretPatterns) {
      if ($text.ToLowerInvariant().Contains($pattern)) {
        $errors.Add("Secret-like token detected in ${path}: $pattern")
      }
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  teams_surface_count = $surfaces.Count
  teams_capability_count = $capabilities.Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
