param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$EnvironmentUrl = 'https://org084965d9.crm.dynamics.com',
  [string]$EnvironmentId = '7f65fc04-c27a-ea0d-bd2d-266aa9203c1e',
  [string]$ExpectedUser = 'efigueroa@registronotarial8tdf.com.ar',
  [string]$OutputDir = 'dataverse/validation/gate_state_patch_20260608',
  [switch]$Apply,
  [switch]$Rollback
)

$ErrorActionPreference = 'Stop'

if ($Apply -and $Rollback) {
  throw 'APPLY_AND_ROLLBACK_ARE_MUTUALLY_EXCLUSIVE'
}

function Invoke-JsonCommand {
  param([string[]]$Command)
  $raw = & $Command[0] @($Command | Select-Object -Skip 1) 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw (($raw | Out-String).Trim())
  }
  return ($raw | Out-String | ConvertFrom-Json)
}

function Invoke-TextCommand {
  param([string[]]$Command)
  $raw = & $Command[0] @($Command | Select-Object -Skip 1) 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw (($raw | Out-String).Trim())
  }
  return @($raw | ForEach-Object { ($_ | Out-String).Trim() } | Where-Object { $_ })
}

function Get-AccessToken {
  param([string]$Resource)
  $token = & az account get-access-token --resource $Resource --query accessToken -o tsv 2>$null
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($token)) {
    throw 'AZURE_CLI_TOKEN_UNAVAILABLE'
  }
  return $token.Trim()
}

function Invoke-DataverseGet {
  param([string]$Uri, [hashtable]$Headers)
  return Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers
}

function Invoke-DataversePatch {
  param(
    [string]$Uri,
    [hashtable]$Headers,
    [hashtable]$Payload
  )
  $patchHeaders = $Headers.Clone()
  $patchHeaders['Content-Type'] = 'application/json'
  $patchHeaders['If-Match'] = '*'
  Invoke-RestMethod -Method Patch -Uri $Uri -Headers $patchHeaders -Body ($Payload | ConvertTo-Json -Depth 8) | Out-Null
}

function Assert-NotProdLike {
  param([string]$Value, [string]$Label)
  if ($Value -match '(?i)modoe|default|prod|production|test') {
    throw "BLOCKED_TARGET_SCOPE_$Label"
  }
}

function ConvertTo-RecordMap {
  param([object[]]$Rows)
  $map = @{}
  foreach ($row in $Rows) {
    $id = [string]$row.mon_canonical_id
    if ($map.ContainsKey($id)) {
      throw "candidate_count_not_one:$id"
    }
    $map[$id] = $row
  }
  return $map
}

$expectedIds = @(
  'GATE_MICROSOFT_LIVE_GOVERNED_ORDER',
  'GATE_POWER_PLATFORM_DEV_TARGET_EXPLICIT'
)

$targetPayload = @{
  mon_status = 'OPEN_ACTIVE_CONTROLLED'
  mon_allowed_actions = 'local_inventory|order_preparation|dry_run_validation|tenant_controlled_segmented_write'
  mon_blocked_actions = 'write_free|unsegmented_global_write|production|secret_materialization|default_as_dev|runtime_discovery|modoe_scope|flow_activation'
  mon_stop_condition = 'target_identity_missing|rollback_missing|postcheck_missing|inference_required|segment_not_in_inventory|modoe_scope_detected'
  mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
  mon_notes = 'Operator authorized Microsoft live and Power Platform gates; gates remain controlled, segmented, reversible and postchecked.'
}

$seedPath = Join-Path $Root 'dataverse/data/seed_connection_gates.csv'
if (-not (Test-Path -LiteralPath $seedPath)) {
  throw "ROLLBACK_SOURCE_MISSING:$seedPath"
}

$rollbackRows = @(Import-Csv -LiteralPath $seedPath | Where-Object { $_.canonical_id -in $expectedIds })
if ($rollbackRows.Count -ne 2) {
  throw "ROLLBACK_SOURCE_CANDIDATE_COUNT_NOT_TWO:$($rollbackRows.Count)"
}
$rollbackById = @{}
foreach ($row in $rollbackRows) {
  $rollbackById[$row.canonical_id] = @{
    mon_status = $row.status
    mon_allowed_actions = $row.allowed_actions
    mon_blocked_actions = $row.blocked_actions
    mon_stop_condition = $row.stop_condition
    mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    mon_notes = 'Rollback applied from dataverse/data/seed_connection_gates.csv prior values.'
  }
}

Assert-NotProdLike -Value $EnvironmentUrl -Label 'ENVIRONMENT_URL'

$pacWho = Invoke-TextCommand -Command @('pac', 'org', 'who')
$pacUserLine = $pacWho | Where-Object { $_ -match '^Connected as\s+' } | Select-Object -First 1
$pacEnvLine = $pacWho | Where-Object { $_ -match 'Environment ID:\s+' } | Select-Object -First 1
if (-not $pacUserLine -or -not $pacEnvLine) {
  throw 'PAC_CONTEXT_UNRESOLVED'
}
$pacUser = ($pacUserLine -replace '^Connected as\s+', '').Trim()
$pacEnvironmentId = ($pacEnvLine -replace '^Environment ID:\s+', '').Trim()
if ($pacUser.ToLowerInvariant() -ne $ExpectedUser.ToLowerInvariant()) {
  throw "PAC_IDENTITY_MISMATCH:$pacUser"
}
if ($pacEnvironmentId.ToLowerInvariant() -ne $EnvironmentId.ToLowerInvariant()) {
  throw "PAC_ENVIRONMENT_MISMATCH:$pacEnvironmentId"
}

$azAccount = Invoke-JsonCommand -Command @('az', 'account', 'show', '--query', '{user:user.name,tenantId:tenantId}', '-o', 'json')
if (([string]$azAccount.user).ToLowerInvariant() -ne $ExpectedUser.ToLowerInvariant()) {
  throw "AZURE_IDENTITY_MISMATCH:$($azAccount.user)"
}

$token = Get-AccessToken -Resource $EnvironmentUrl
$headers = @{
  Authorization = "Bearer $token"
  Accept = 'application/json'
}

$metadataUri = "$EnvironmentUrl/api/data/v9.2/EntityDefinitions(LogicalName='mon_sdu_connection_gate')?`$select=EntitySetName,LogicalName,PrimaryIdAttribute"
$metadata = Invoke-DataverseGet -Uri $metadataUri -Headers $headers
if ($metadata.EntitySetName -ne 'mon_sdu_connection_gates') {
  throw "ENTITY_SET_MISMATCH:$($metadata.EntitySetName)"
}

$filter = "mon_canonical_id eq 'GATE_MICROSOFT_LIVE_GOVERNED_ORDER' or mon_canonical_id eq 'GATE_POWER_PLATFORM_DEV_TARGET_EXPLICIT'"
$select = 'mon_canonical_id,mon_status,mon_surface,mon_provider,mon_required_for,mon_allowed_actions,mon_blocked_actions,mon_stop_condition,mon_last_reconciled_at,mon_notes,mon_sdu_connection_gateid'
$queryUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)?`$select=$select&`$filter=$([uri]::EscapeDataString($filter))"
$beforeRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $headers).value)
if ($beforeRows.Count -ne 2) {
  throw "candidate_count_not_two:$($beforeRows.Count)"
}
$beforeMap = ConvertTo-RecordMap -Rows $beforeRows
foreach ($id in $expectedIds) {
  if (-not $beforeMap.ContainsKey($id)) {
    throw "candidate_count_not_one:$id"
  }
}

$resolvedOutputDir = Join-Path $Root $OutputDir
New-Item -ItemType Directory -Force -Path $resolvedOutputDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$beforePath = Join-Path $resolvedOutputDir "before_$stamp.json"
$beforeRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $beforePath -Encoding UTF8

$mode = 'DRY_RUN'
if ($Apply) { $mode = 'APPLY' }
if ($Rollback) { $mode = 'ROLLBACK' }

if ($Apply -or $Rollback) {
  foreach ($id in $expectedIds) {
    $row = $beforeMap[$id]
    $recordId = [string]$row.mon_sdu_connection_gateid
    if ([string]::IsNullOrWhiteSpace($recordId)) {
      throw "identity_field_missing:$id"
    }
    $payload = if ($Apply) { $targetPayload } else { $rollbackById[$id] }
    $patchUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)($recordId)"
    Invoke-DataversePatch -Uri $patchUri -Headers $headers -Payload $payload
  }
}

$afterRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $headers).value)
if ($afterRows.Count -ne 2) {
  throw "postcheck_candidate_count_not_two:$($afterRows.Count)"
}
$afterMap = ConvertTo-RecordMap -Rows $afterRows
foreach ($id in $expectedIds) {
  if (-not $afterMap.ContainsKey($id)) {
    throw "postcheck_candidate_count_not_one:$id"
  }
}

if ($Apply) {
  foreach ($id in $expectedIds) {
    $row = $afterMap[$id]
    if ($row.mon_status -ne $targetPayload.mon_status) { throw "postcheck_status_mismatch:$id" }
    if ($row.mon_allowed_actions -notmatch 'tenant_controlled_segmented_write') { throw "postcheck_allowed_actions_mismatch:$id" }
    if ($row.mon_blocked_actions -notmatch 'write_free') { throw "postcheck_blocked_actions_mismatch:$id" }
  }
}

if ($Rollback) {
  foreach ($id in $expectedIds) {
    $row = $afterMap[$id]
    if ($row.mon_status -ne $rollbackById[$id].mon_status) { throw "rollback_status_mismatch:$id" }
    if ($row.mon_allowed_actions -ne $rollbackById[$id].mon_allowed_actions) { throw "rollback_allowed_actions_mismatch:$id" }
    if ($row.mon_blocked_actions -ne $rollbackById[$id].mon_blocked_actions) { throw "rollback_blocked_actions_mismatch:$id" }
  }
}

$afterPath = Join-Path $resolvedOutputDir "after_$stamp.json"
$afterRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $afterPath -Encoding UTF8

$summary = [pscustomobject]@{
  status = if ($Apply) { 'DATAVERSE_GATE_STATE_PATCH_APPLY_PASS' } elseif ($Rollback) { 'DATAVERSE_GATE_STATE_PATCH_ROLLBACK_PASS' } else { 'DATAVERSE_GATE_STATE_PATCH_DRY_RUN_PASS' }
  mode = $mode
  token_printed = $false
  environment_url = $EnvironmentUrl
  environment_id = $EnvironmentId
  pac_user = $pacUser
  azure_user = $azAccount.user
  entity_set_name = $metadata.EntitySetName
  candidate_count = $afterRows.Count
  canonical_ids = $expectedIds
  before_snapshot = $beforePath
  after_snapshot = $afterPath
  rollback_ready = $true
  postcheck_verified = [bool]($Apply -or $Rollback)
}

$summaryPath = Join-Path $resolvedOutputDir "summary_$stamp.json"
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $summaryPath -Encoding UTF8
$summary | ConvertTo-Json -Depth 8
