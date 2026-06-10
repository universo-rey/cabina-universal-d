param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$EnvironmentUrl = 'https://org084965d9.crm.dynamics.com',
  [string]$EnvironmentId = '7f65fc04-c27a-ea0d-bd2d-266aa9203c1e',
  [string]$ExpectedUser = 'efigueroa@registronotarial8tdf.com.ar',
  [string]$SourceCsv = 'dataverse/data/seed_sdu_agent_runtime_actions.csv',
  [string]$OutputDir = 'dataverse/validation/sdu_agent_runtime_actions_registry_20260608',
  [string]$GateConfirmation = '',
  [switch]$Apply,
  [switch]$Rollback
)

$ErrorActionPreference = 'Stop'

$BatchId = '20260608_sdu_agent_runtime_actions_registry_dev_v1'
$RequiredGateConfirmation = 'GATE_DATAVERSE_APPLY'
$TableLogicalName = 'mon_sdu_agent_connection_mapping'
$ExpectedEntitySetName = 'mon_sdu_agent_connection_mappings'
$StopCondition = 'sdu_agent_runtime_actions_registered_postchecked'
$RollbackStopCondition = 'sdu_agent_runtime_actions_registry_rollback_marker'

if ($Rollback -and -not $Apply) {
  throw 'ROLLBACK_REQUIRES_APPLY'
}

if (($Apply -or $Rollback) -and $GateConfirmation -ne $RequiredGateConfirmation) {
  throw "GATE_CONFIRMATION_REQUIRED:$RequiredGateConfirmation"
}

function Assert-NotProdLike {
  param([string]$Value, [string]$Label)
  if ($Value -match '(?i)\bprod\b|production|default|test') {
    throw "BLOCKED_TARGET_SCOPE_$Label"
  }
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
  param([string]$Uri, [hashtable]$Headers, [hashtable]$Payload)
  $patchHeaders = $Headers.Clone()
  $patchHeaders['Content-Type'] = 'application/json'
  $patchHeaders['If-Match'] = '*'
  Invoke-RestMethod -Method Patch -Uri $Uri -Headers $patchHeaders -Body ($Payload | ConvertTo-Json -Depth 12) | Out-Null
}

function Invoke-DataversePost {
  param([string]$Uri, [hashtable]$Headers, [hashtable]$Payload)
  $postHeaders = $Headers.Clone()
  $postHeaders['Content-Type'] = 'application/json'
  Invoke-RestMethod -Method Post -Uri $Uri -Headers $postHeaders -Body ($Payload | ConvertTo-Json -Depth 12) | Out-Null
}

function Get-SourceHash {
  param([object]$Payload)
  $json = $Payload | ConvertTo-Json -Depth 12 -Compress
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
  $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
  return (($hash | ForEach-Object { $_.ToString('x2') }) -join '')
}

function Assert-Identity {
  if (-not $Apply) { return }
  $pacWho = Invoke-TextCommand -Command @('pac', 'org', 'who', '--environment', $EnvironmentUrl)
  $pacUserLine = $pacWho | Where-Object { $_ -match '^Connected as\s+' } | Select-Object -First 1
  $pacEnvLine = $pacWho | Where-Object { $_ -match 'Environment ID:\s+' } | Select-Object -First 1
  if (-not $pacUserLine -or -not $pacEnvLine) { throw 'PAC_CONTEXT_UNRESOLVED' }
  $pacUser = ($pacUserLine -replace '^Connected as\s+', '').Trim()
  $pacEnvironmentId = ($pacEnvLine -replace '^Environment ID:\s+', '').Trim()
  if ($pacUser.ToLowerInvariant() -ne $ExpectedUser.ToLowerInvariant()) { throw "PAC_IDENTITY_MISMATCH:$pacUser" }
  if ($pacEnvironmentId.ToLowerInvariant() -ne $EnvironmentId.ToLowerInvariant()) { throw "PAC_ENVIRONMENT_MISMATCH:$pacEnvironmentId" }

  $azAccount = Invoke-JsonCommand -Command @('az', 'account', 'show', '--query', '{user:user.name,tenantId:tenantId}', '-o', 'json')
  if (([string]$azAccount.user).ToLowerInvariant() -ne $ExpectedUser.ToLowerInvariant()) {
    throw "AZURE_IDENTITY_MISMATCH:$($azAccount.user)"
  }
}

Assert-NotProdLike -Value $EnvironmentUrl -Label 'ENVIRONMENT_URL'
Assert-Identity

$resolvedCsv = Join-Path $Root $SourceCsv
if (-not (Test-Path -LiteralPath $resolvedCsv)) {
  throw "SOURCE_CSV_MISSING:$SourceCsv"
}

$rows = @(Import-Csv -LiteralPath $resolvedCsv)
if ($rows.Count -ne 7) {
  throw "EXPECTED_SEVEN_SDU_AGENTS_FOUND:$($rows.Count)"
}

$requiredColumns = @(
  'canonical_id',
  'agent_id',
  'display_name',
  'domain',
  'owner_agent',
  'reviewer_agent',
  'allowed_actions',
  'gated_actions',
  'blocked_actions',
  'surfaces',
  'queue_modes',
  'dataverse_tables',
  'risk_level',
  'status',
  'stop_condition'
)
foreach ($column in $requiredColumns) {
  if (-not ($rows[0].PSObject.Properties.Name -contains $column)) {
    throw "SOURCE_CSV_COLUMN_MISSING:$column"
  }
}

$expectedAgents = @(
  'seshat-normativa',
  'thot-tecnico',
  'anubis-gate',
  'maat-cumplimiento',
  'horus-riesgo',
  'cre3c-reconciliar-shell',
  'narrador-normativo'
)
$observedAgents = @($rows | ForEach-Object { $_.agent_id } | Sort-Object)
$missingAgents = @($expectedAgents | Where-Object { $_ -notin $observedAgents })
if ($missingAgents.Count -gt 0) {
  throw "SOURCE_CSV_AGENT_MISSING:$($missingAgents -join ',')"
}

$token = Get-AccessToken -Resource $EnvironmentUrl
$headers = @{
  Authorization = "Bearer $token"
  Accept = 'application/json'
}

$metadataUri = "$EnvironmentUrl/api/data/v9.2/EntityDefinitions(LogicalName='$TableLogicalName')?`$select=EntitySetName,LogicalName,PrimaryIdAttribute"
$metadata = Invoke-DataverseGet -Uri $metadataUri -Headers $headers
if ($metadata.EntitySetName -ne $ExpectedEntitySetName) {
  throw "ENTITY_SET_MISMATCH:$($metadata.EntitySetName)"
}

$resolvedOutputDir = Join-Path $Root $OutputDir
New-Item -ItemType Directory -Force -Path $resolvedOutputDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'

$results = @()
foreach ($row in $rows) {
  $canonicalId = [string]$row.canonical_id
  if ([string]::IsNullOrWhiteSpace($canonicalId)) { throw 'canonical_id_missing' }
  $filter = "mon_canonical_id eq '$canonicalId'"
  $select = 'mon_sdu_agent_connection_mappingid,mon_canonical_id,mon_status,mon_display_name,mon_source_hash,mon_owner_agent,mon_reviewer_agent,mon_stop_condition'
  $queryUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)?`$select=$select&`$filter=$([uri]::EscapeDataString($filter))"
  $beforeRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $headers).value)
  if ($beforeRows.Count -gt 1) {
    throw "candidate_count_not_one:$($canonicalId):$($beforeRows.Count)"
  }

  $actions = [ordered]@{
    agent_id = $row.agent_id
    domain = $row.domain
    allowed_actions = @(([string]$row.allowed_actions).Split('|') | Where-Object { $_ })
    gated_actions = @(([string]$row.gated_actions).Split('|') | Where-Object { $_ })
    blocked_actions = @(([string]$row.blocked_actions).Split('|') | Where-Object { $_ })
    queue_modes = @(([string]$row.queue_modes).Split('|') | Where-Object { $_ })
    dataverse_tables = @(([string]$row.dataverse_tables).Split('|') | Where-Object { $_ })
    stop_condition = $row.stop_condition
  }
  $sourceHash = Get-SourceHash -Payload $actions
  $payload = @{
    mon_canonical_id = $canonicalId
    mon_display_name = [string]$row.display_name
    mon_environment_scope = "HUBDesarrollo|$EnvironmentId"
    mon_gate_required = $true
    mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    mon_notes = ($actions | ConvertTo-Json -Depth 8 -Compress)
    mon_owner = 'SDUCapabilityControlPlane'
    mon_owner_agent = [string]$row.owner_agent
    mon_repo = 'universo-rey/cabina-universal-d'
    mon_repo_id = 'CABINA_UNIVERSAL_D'
    mon_reviewer_agent = [string]$row.reviewer_agent
    mon_risk_level = [string]$row.risk_level
    mon_seed_batch_id = $BatchId
    mon_source_hash = $sourceHash
    mon_source_path = $SourceCsv
    mon_source_system = 'cabina-universal-d'
    mon_status = [string]$row.status
    mon_stop_condition = [string]$row.stop_condition
    mon_surfaces = [string]$row.surfaces
    mon_tenant_scope = 'escribaniabitsch.sharepoint.com'
  }

  if ($Rollback) {
    if ($beforeRows.Count -ne 1) {
      throw "rollback_candidate_count_not_one:$($canonicalId):$($beforeRows.Count)"
    }
    $recordId = [string]$beforeRows[0].mon_sdu_agent_connection_mappingid
    if ([string]::IsNullOrWhiteSpace($recordId)) { throw 'identity_field_missing:mon_sdu_agent_connection_mappingid' }
    $rollbackPayload = @{
      mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
      mon_seed_batch_id = $BatchId
      mon_status = 'ROLLBACK_SUPERSEDED'
      mon_stop_condition = $RollbackStopCondition
    }
    Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)($recordId)" -Headers $headers -Payload $rollbackPayload
  } elseif ($Apply) {
    if ($beforeRows.Count -eq 0) {
      Invoke-DataversePost -Uri "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)" -Headers $headers -Payload $payload
    } else {
      $recordId = [string]$beforeRows[0].mon_sdu_agent_connection_mappingid
      if ([string]::IsNullOrWhiteSpace($recordId)) { throw 'identity_field_missing:mon_sdu_agent_connection_mappingid' }
      Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)($recordId)" -Headers $headers -Payload $payload
    }
  }

  $afterRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $headers).value)
  if ($Apply -and $afterRows.Count -ne 1) {
    throw "postcheck_candidate_count_not_one:$($canonicalId):$($afterRows.Count)"
  }
  if ($Rollback -and [string]$afterRows[0].mon_status -ne 'ROLLBACK_SUPERSEDED') {
    throw "rollback_postcheck_status_mismatch:$canonicalId"
  }
  if ($Rollback -and [string]$afterRows[0].mon_stop_condition -ne $RollbackStopCondition) {
    throw "rollback_postcheck_stop_condition_mismatch:$canonicalId"
  }
  if ($Apply -and -not $Rollback -and [string]$afterRows[0].mon_source_hash -ne $sourceHash) {
    throw "postcheck_source_hash_mismatch:$canonicalId"
  }

  $results += [pscustomobject]@{
    canonical_id = $canonicalId
    agent_id = $row.agent_id
    mode = if ($Rollback) { 'ROLLBACK' } elseif ($Apply) { 'APPLY' } else { 'DRY_RUN' }
    candidate_count_before = $beforeRows.Count
    candidate_count_after = $afterRows.Count
    source_hash = $sourceHash
    record_id = if ($afterRows.Count -eq 1) { $afterRows[0].mon_sdu_agent_connection_mappingid } else { '' }
    status = if ($Rollback) { 'ROLLBACK_POSTCHECKED' } elseif ($Apply) { 'POSTCHECKED' } else { 'DRY_RUN_READY' }
  }
}

$summary = [pscustomobject]@{
  status = if ($Rollback) { 'SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_ROLLBACK_PASS' } elseif ($Apply) { 'SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_APPLY_PASS' } else { 'SDU_AGENT_RUNTIME_ACTIONS_REGISTRY_DRY_RUN_PASS' }
  mode = if ($Rollback) { 'ROLLBACK' } elseif ($Apply) { 'APPLY' } else { 'DRY_RUN' }
  token_printed = $false
  environment_url = $EnvironmentUrl
  environment_id = $EnvironmentId
  table_logical_name = $TableLogicalName
  entity_set_name = $metadata.EntitySetName
  source_csv = $SourceCsv
  batch_id = $BatchId
  row_count = $rows.Count
  rollback = 'Patch exact mon_canonical_id rows to mon_status=ROLLBACK_SUPERSEDED and mon_stop_condition=sdu_agent_runtime_actions_registry_rollback_marker; no physical delete without separate gate.'
  postcheck = 'Read each mon_sdu_agent_connection_mapping row by exact mon_canonical_id and verify mon_source_hash.'
  stop_condition = $StopCondition
  results = $results
}

$summaryPath = Join-Path $resolvedOutputDir "summary_$stamp.json"
$summary | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $summaryPath -Encoding UTF8
$summary | ConvertTo-Json -Depth 12
