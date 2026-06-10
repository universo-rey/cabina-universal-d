param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$EnvironmentUrl = 'https://org084965d9.crm.dynamics.com',
  [string]$EnvironmentId = '7f65fc04-c27a-ea0d-bd2d-266aa9203c1e',
  [string]$ExpectedUser = 'efigueroa@registronotarial8tdf.com.ar',
  [string]$CanonicalId = 'evidence.tenant_apply_log_publish.20260608',
  [string]$SourcePath = '.agents/codex/readbacks/2026-06-08_tenant_apply_log_publish_readback.md',
  [string]$DisplayName = 'Tenant apply log evidence publish 20260608',
  [string]$Status = 'EVIDENCE_PUBLISHED',
  [string]$SeedBatchId = '20260608_tenant_evidence_publish_v1',
  [string]$EvidenceType = 'metadata_pointer_only',
  [string]$RiskLevel = 'low',
  [string]$StopCondition = 'TENANT_APPLY_LOG_PUBLISH_APPLIED_AND_POSTCHECKED',
  [string]$Notes = 'Sanitized metadata evidence row for the tenant apply-log publish segment. No flow activation, no SharePoint write, no production.',
  [string]$OutputDir = 'dataverse/validation/evidence_publish_20260608',
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

function Assert-NotProdLike {
  param([string]$Value, [string]$Label)
  if ($Value -match '(?i)modoe|default|prod|production|test') {
    throw "BLOCKED_TARGET_SCOPE_$Label"
  }
}

function Invoke-DataverseGet {
  param([string]$Uri, [hashtable]$Headers)
  return Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers
}

function Invoke-DataversePatch {
  param([string]$Uri, [hashtable]$Headers, [hashtable]$Payload)
  $patchHeaders = $Headers.Clone()
  $patchHeaders['Content-Type'] = 'application/json'
  $patchHeaders['If-Match'] = '*'
  Invoke-RestMethod -Method Patch -Uri $Uri -Headers $patchHeaders -Body ($Payload | ConvertTo-Json -Depth 8) | Out-Null
}

function Invoke-DataversePost {
  param([string]$Uri, [hashtable]$Headers, [hashtable]$Payload)
  $postHeaders = $Headers.Clone()
  $postHeaders['Content-Type'] = 'application/json'
  Invoke-RestMethod -Method Post -Uri $Uri -Headers $postHeaders -Body ($Payload | ConvertTo-Json -Depth 8) | Out-Null
}

Assert-NotProdLike -Value $EnvironmentUrl -Label 'ENVIRONMENT_URL'

$resolvedSourcePath = Join-Path $Root $SourcePath
if (-not (Test-Path -LiteralPath $resolvedSourcePath)) {
  throw "SOURCE_EVIDENCE_MISSING:$SourcePath"
}
$sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $resolvedSourcePath).Hash.ToLowerInvariant()

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

$metadataUri = "$EnvironmentUrl/api/data/v9.2/EntityDefinitions(LogicalName='mon_sdu_evidence')?`$select=EntitySetName,LogicalName,PrimaryIdAttribute"
$metadata = Invoke-DataverseGet -Uri $metadataUri -Headers $headers
if ($metadata.EntitySetName -ne 'mon_sdu_evidences') {
  throw "ENTITY_SET_MISMATCH:$($metadata.EntitySetName)"
}

$select = 'mon_canonical_id,mon_status,mon_display_name,mon_source_hash,mon_evidence_hash,mon_source_path,mon_evidence_type,mon_stop_condition,mon_notes,mon_sdu_evidenceid'
$filter = "mon_canonical_id eq '$CanonicalId'"
$queryUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)?`$select=$select&`$filter=$([uri]::EscapeDataString($filter))"
$beforeRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $headers).value)
if ($beforeRows.Count -gt 1) {
  throw "candidate_count_not_one:$($beforeRows.Count)"
}

$resolvedOutputDir = Join-Path $Root $OutputDir
New-Item -ItemType Directory -Force -Path $resolvedOutputDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$beforePath = Join-Path $resolvedOutputDir "before_$stamp.json"
$beforeRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $beforePath -Encoding UTF8

$payload = @{
  mon_canonical_id = $CanonicalId
  mon_display_name = $DisplayName
  mon_status = $Status
  mon_seed_batch_id = $SeedBatchId
  mon_source_system = 'cabina-universal-d'
  mon_source_path = $SourcePath
  mon_source_hash = $sourceHash
  mon_evidence_hash = $sourceHash
  mon_evidence_type = $EvidenceType
  mon_environment_scope = 'HUBDesarrollo|7f65fc04-c27a-ea0d-bd2d-266aa9203c1e'
  mon_gate_required = $true
  mon_owner = 'SDUCapabilityControlPlane'
  mon_risk_level = $RiskLevel
  mon_tenant_scope = 'escribaniabitsch.sharepoint.com'
  mon_stop_condition = $StopCondition
  mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
  mon_notes = $Notes
}

$rollbackPayload = @{
  mon_status = 'ROLLBACK_SUPERSEDED'
  mon_stop_condition = 'ROLLBACK_SUPERSEDED_BY_OPERATOR_OR_EVIDENCE_ROLLBACK'
  mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
  mon_notes = 'Evidence publish rollback marker applied. Evidence row retained; no physical delete.'
}

$mode = 'DRY_RUN'
if ($Apply) { $mode = 'APPLY' }
if ($Rollback) { $mode = 'ROLLBACK' }

if ($Apply) {
  if ($beforeRows.Count -eq 0) {
    $postUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)"
    Invoke-DataversePost -Uri $postUri -Headers $headers -Payload $payload
  } else {
    $recordId = [string]$beforeRows[0].mon_sdu_evidenceid
    if ([string]::IsNullOrWhiteSpace($recordId)) { throw 'identity_field_missing:mon_sdu_evidenceid' }
    $patchUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)($recordId)"
    Invoke-DataversePatch -Uri $patchUri -Headers $headers -Payload $payload
  }
}

if ($Rollback) {
  if ($beforeRows.Count -eq 0) {
    throw 'ROLLBACK_TARGET_MISSING'
  }
  $recordId = [string]$beforeRows[0].mon_sdu_evidenceid
  if ([string]::IsNullOrWhiteSpace($recordId)) { throw 'identity_field_missing:mon_sdu_evidenceid' }
  $patchUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)($recordId)"
  Invoke-DataversePatch -Uri $patchUri -Headers $headers -Payload $rollbackPayload
}

$afterRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $headers).value)
if ($Apply -and $afterRows.Count -ne 1) {
  throw "postcheck_candidate_count_not_one:$($afterRows.Count)"
}
if ($Rollback -and $afterRows.Count -ne 1) {
  throw "rollback_candidate_count_not_one:$($afterRows.Count)"
}
if ($Apply) {
  $row = $afterRows[0]
  if ($row.mon_status -ne $payload.mon_status) { throw 'postcheck_status_mismatch' }
  if ($row.mon_evidence_hash -ne $payload.mon_evidence_hash) { throw 'postcheck_hash_mismatch' }
}
if ($Rollback) {
  $row = $afterRows[0]
  if ($row.mon_status -ne $rollbackPayload.mon_status) { throw 'rollback_status_mismatch' }
}

$afterPath = Join-Path $resolvedOutputDir "after_$stamp.json"
$afterRows | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $afterPath -Encoding UTF8

$summary = [pscustomobject]@{
  status = if ($Apply) { 'DATAVERSE_EVIDENCE_PUBLISH_APPLY_PASS' } elseif ($Rollback) { 'DATAVERSE_EVIDENCE_PUBLISH_ROLLBACK_PASS' } else { 'DATAVERSE_EVIDENCE_PUBLISH_DRY_RUN_PASS' }
  mode = $mode
  token_printed = $false
  environment_url = $EnvironmentUrl
  environment_id = $EnvironmentId
  pac_user = $pacUser
  azure_user = $azAccount.user
  entity_set_name = $metadata.EntitySetName
  canonical_id = $CanonicalId
  candidate_count_before = $beforeRows.Count
  candidate_count_after = $afterRows.Count
  source_path = $SourcePath
  evidence_hash = $sourceHash
  before_snapshot = $beforePath
  after_snapshot = $afterPath
  rollback_ready = $true
  postcheck_verified = [bool]($Apply -or $Rollback)
}

$summaryPath = Join-Path $resolvedOutputDir "summary_$stamp.json"
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $summaryPath -Encoding UTF8
$summary | ConvertTo-Json -Depth 8
