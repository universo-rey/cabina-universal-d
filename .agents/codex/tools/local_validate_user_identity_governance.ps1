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

$matrixPath = Join-Path $Root "matrices\USER_IDENTITY_GOVERNANCE_MATRIX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$toolGovernancePath = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
$pluginPath = Join-Path $Root "plugins\PLUGIN_USAGE_MATRIX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$policyPath = "D:\02_AUTHORITY_CANON\POLICIES\EFIGUEROA_USER_GOVERNANCE_POLICY_20260602.md"
$globalPolicyPath = "D:\02_AUTHORITY_CANON\POLICIES\GLOBAL_MICROSOFT_LIVE_PRODUCTION_POLICY_20260601.md"
$orderPath = Join-Path $Root "orders\ORDER_EFIGUEROA_USER_GOVERNANCE_LIVE_READ_DRAFT_20260602.md"
$readbackPath = Join-Path $Root "readbacks\2026-06-02_efigueroa_user_governance_readback.md"
$workpaperPath = Join-Path $Root "workpapers\user_efigueroa_registronotarial8tdf\README.md"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

Require-File -Path $policyPath -Errors $errors
Require-File -Path $globalPolicyPath -Errors $errors
Require-File -Path $orderPath -Errors $errors
Require-File -Path $readbackPath -Errors $errors
Require-File -Path $workpaperPath -Errors $errors

Require-Columns -Path $matrixPath -Columns @(
  "subject_id",
  "upn",
  "domain",
  "universe",
  "tenant_hint",
  "surface",
  "owner_agent",
  "reviewer_agent",
  "evidence_agent",
  "skill",
  "recipe",
  "tool",
  "plugin",
  "allowed_local",
  "live_read_gate",
  "live_write_gate",
  "permission_gate",
  "production_gate",
  "evidence",
  "validator",
  "risk",
  "rollback",
  "stop_condition",
  "status"
) -Errors $errors

$knownStops = @((Read-CsvSafe -Path $stopPath) | ForEach-Object { $_.stop_condition })
$toolIds = @((Read-CsvSafe -Path $toolIndexPath) | ForEach-Object { $_.tool_id })
$toolGovernanceIds = @((Read-CsvSafe -Path $toolGovernancePath) | ForEach-Object { $_.tool_id })
$plugins = @(Read-CsvSafe -Path $pluginPath)
$graphPlugin = @($plugins | Where-Object { $_.plugin_id -eq "Microsoft Graph direct tenant admin" })

if ("tool.local_validate_user_identity_governance" -notin $toolIds) {
  $errors.Add("TOOL_INDEX missing tool.local_validate_user_identity_governance")
}
if ("tool.local_validate_user_identity_governance" -notin $toolGovernanceIds) {
  $errors.Add("TOOL_GOVERNANCE_MATRIX missing tool.local_validate_user_identity_governance")
}
if ($graphPlugin.Count -eq 0) {
  $errors.Add("PLUGIN_USAGE_MATRIX missing Microsoft Graph direct tenant admin row")
} elseif ($graphPlugin[0].availability -notmatch "NO_DISPONIBLE") {
  $errors.Add("Microsoft Graph direct tenant admin must remain NO_DISPONIBLE without separate connector/order")
}

$rows = Read-CsvSafe -Path $matrixPath
$requiredSurfaces = @(
  "identity.local_registry",
  "entra.account_profile",
  "entra.roles_groups_memberships",
  "licenses_apps",
  "teams_outlook_sharepoint_onedrive",
  "devices_security_audit",
  "graph_connector_gap"
)

foreach ($surface in $requiredSurfaces) {
  if ($surface -notin @($rows | ForEach-Object { $_.surface })) {
    $errors.Add("Missing user identity governance surface row: $surface")
  }
}

foreach ($row in $rows) {
  foreach ($field in @("subject_id","upn","domain","universe","surface","owner_agent","reviewer_agent","evidence_agent","skill","recipe","tool","allowed_local","live_read_gate","live_write_gate","permission_gate","production_gate","evidence","validator","risk","rollback","stop_condition","status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("User identity row '$($row.surface)' missing $field")
    }
  }
  if ($row.upn -ne "efigueroa@registronotarial8tdf.com.ar") {
    $errors.Add("Unexpected UPN in '$($row.surface)': $($row.upn)")
  }
  if ($row.domain -ne "registronotarial8tdf.com.ar") {
    $errors.Add("Unexpected domain in '$($row.surface)': $($row.domain)")
  }
  if ($row.universe -ne "ESCRIBANIA") {
    $errors.Add("User identity row '$($row.surface)' must route to ESCRIBANIA")
  }
  if ($row.status -ne "ACTIVE_LOCAL_PREP") {
    $errors.Add("User identity row '$($row.surface)' must remain ACTIVE_LOCAL_PREP")
  }
  if ($row.live_read_gate -notmatch "governed_order_required") {
    $errors.Add("User identity row '$($row.surface)' missing governed live read gate")
  }
  if ($row.live_write_gate -notmatch "separate_explicit") {
    $errors.Add("User identity row '$($row.surface)' missing separate explicit write gate")
  }
  if ($row.permission_gate -notmatch "separate_explicit_permission") {
    $errors.Add("User identity row '$($row.surface)' missing explicit permission gate")
  }
  if ($row.production_gate -notmatch "separate_explicit_production") {
    $errors.Add("User identity row '$($row.surface)' missing explicit production gate")
  }
  if ($row.stop_condition -notmatch "microsoft_live_requested_without_governed_order") {
    $errors.Add("User identity row '$($row.surface)' must include Microsoft live stop condition")
  }
  Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "User identity row '$($row.surface)'"
}

Require-Text -Path $policyPath -Tokens @(
  'Sujeto gobernado: `efigueroa@registronotarial8tdf.com.ar`',
  "no se confirma existencia",
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
  "STOP_BEFORE_EFIGUEROA_USER_LIVE_READ"
) -Errors $errors

Require-Text -Path $readbackPath -Tokens @(
  "EFIGUEROA_USER_GOVERNANCE_LOCAL_PREPARED_NO_LIVE_EXECUTION",
  "No se consulto Entra ID",
  "microsoft_live_requested_without_governed_order"
) -Errors $errors

$secretPatterns = @("client_secret", "password", "authorization:", "bearer ", "api_key", ("tok" + "en="))
foreach ($path in @($policyPath, $orderPath, $readbackPath, $matrixPath)) {
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
  subject = "efigueroa@registronotarial8tdf.com.ar"
  user_identity_surface_count = $rows.Count
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
