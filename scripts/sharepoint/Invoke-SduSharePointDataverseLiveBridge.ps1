param(
  [ValidateSet('IngestSharePointEvent', 'ProcessOneQueueItem', 'ProcessNextQueueItem')]
  [string]$Mode = 'IngestSharePointEvent',
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$EnvironmentUrl = 'https://org084965d9.crm.dynamics.com',
  [string]$EnvironmentId = '7f65fc04-c27a-ea0d-bd2d-266aa9203c1e',
  [string]$ExpectedUser = 'efigueroa@registronotarial8tdf.com.ar',
  [string]$SiteUrl = 'https://escribaniabitsch.sharepoint.com/sites/SeshatHubRegistroN.8',
  [string]$ListTitle = 'Documentos',
  [string]$EventPayloadJson = '',
  [string]$WorkQueueKey = 'sdu_agent_dispatch_queue',
  [string]$WorkQueueName = 'SDU.Agent.Dispatch.Queue',
  [string]$QueueItemId = '',
  [string]$QueueItemName = '',
  [string]$WorkerId = 'sdu_dataverse_queue_worker',
  [int]$MaxItems = 1,
  [int]$BoundedContentChars = 4000,
  [string]$GateConfirmation = '',
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

$RequiredGateConfirmation = 'GATE_MICROSOFT_LIVE_WRITE+GATE_DATAVERSE_APPLY+GATE_POWER_PLATFORM_APPLY'
$RequiredWorkerGateConfirmation = 'GATE_DATAVERSE_APPLY'
$BatchId = '20260608_sharepoint_dataverse_live_bridge_dev_v1'
$CreatedBySystem = 'sdu_sharepoint_dataverse_live_bridge'
$StopCondition = 'live_dev_bridge_requires_exact_target_rollback_postcheck'
$QueueQueuedState = 0
$QueueProcessingState = 1
$QueueProcessedState = 2
$QueueExceptionState = 4
$QueueQueuedStatus = 0
$QueueProcessingStatus = 1
$QueueProcessedStatus = 2
$QueueGenericExceptionStatus = 4
$RequiredQueueInputFields = @(
  'queue_item_type',
  'canonical_id',
  'correlation_id',
  'idempotency_key',
  'batch_id',
  'source_table',
  'source_matrix',
  'source_path',
  'source_hash',
  'operation',
  'target_environment_id',
  'target_environment_url',
  'gate_required',
  'gate_id',
  'risk_level',
  'priority',
  'stop_condition',
  'rollback_strategy',
  'evidence_required',
  'created_by_system',
  'ai_assisted',
  'ai_validation_status'
)

function Assert-LiveGate {
  if (-not $Apply) { return }
  $requiredGate = if ($Mode -in @('ProcessOneQueueItem', 'ProcessNextQueueItem')) { $RequiredWorkerGateConfirmation } else { $RequiredGateConfirmation }
  if ($GateConfirmation -ne $requiredGate) {
    throw "GATE_CONFIRMATION_REQUIRED:$requiredGate"
  }
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

function Get-DataverseHeaders {
  $token = Get-AccessToken -Resource $EnvironmentUrl
  return @{
    Authorization = "Bearer $token"
    Accept = 'application/json'
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
  Invoke-RestMethod -Method Patch -Uri $Uri -Headers $patchHeaders -Body ($Payload | ConvertTo-Json -Depth 12) | Out-Null
}

function Invoke-DataversePost {
  param([string]$Uri, [hashtable]$Headers, [hashtable]$Payload)
  $postHeaders = $Headers.Clone()
  $postHeaders['Content-Type'] = 'application/json'
  Invoke-RestMethod -Method Post -Uri $Uri -Headers $postHeaders -Body ($Payload | ConvertTo-Json -Depth 12) | Out-Null
}

function Get-EntityMetadata {
  param([string]$LogicalName, [hashtable]$Headers)
  $uri = "$EnvironmentUrl/api/data/v9.2/EntityDefinitions(LogicalName='$LogicalName')?`$select=EntitySetName,LogicalName,PrimaryIdAttribute"
  return Invoke-DataverseGet -Uri $uri -Headers $Headers
}

function Get-QueueItemSelect {
  return 'workqueueitemid,name,statecode,statuscode,input,createdon,modifiedon,processingstarttime,completedon,processingduration,processingresult,retrycount,requeuecount,uniqueidbyqueue,_workqueueid_value'
}

function Get-WorkQueueExact {
  param([hashtable]$Headers)
  $queueUri = "$EnvironmentUrl/api/data/v9.2/workqueues?`$select=workqueueid,name,workqueuekey,statecode,statuscode&`$filter=$([uri]::EscapeDataString("workqueuekey eq '$WorkQueueKey'"))"
  $queues = @((Invoke-DataverseGet -Uri $queueUri -Headers $Headers).value)
  if ($queues.Count -ne 1) { throw "workqueue_candidate_count_not_one:$($queues.Count)" }
  if ([string]$queues[0].name -ne $WorkQueueName) { throw "workqueue_name_mismatch:$($queues[0].name)" }
  return $queues[0]
}

function Get-QueueItemExact {
  param([hashtable]$Headers, [object]$Queue)
  $select = Get-QueueItemSelect
  if (-not [string]::IsNullOrWhiteSpace($QueueItemId)) {
    $itemUri = "$EnvironmentUrl/api/data/v9.2/workqueueitems($QueueItemId)?`$select=$select"
    $item = Invoke-DataverseGet -Uri $itemUri -Headers $Headers
    if ([string]$item._workqueueid_value -ne [string]$Queue.workqueueid) {
      throw "queue_item_wrong_queue:$($item._workqueueid_value)"
    }
    return $item
  }

  if (-not [string]::IsNullOrWhiteSpace($QueueItemName)) {
    $filter = [uri]::EscapeDataString("name eq '$QueueItemName' and _workqueueid_value eq $($Queue.workqueueid)")
    $itemUri = "$EnvironmentUrl/api/data/v9.2/workqueueitems?`$select=$select&`$filter=$filter"
    $items = @((Invoke-DataverseGet -Uri $itemUri -Headers $Headers).value)
    if ($items.Count -ne 1) { throw "queue_item_candidate_count_not_one:$($items.Count)" }
    return $items[0]
  }

  if ($Mode -eq 'ProcessNextQueueItem') {
    $filter = [uri]::EscapeDataString("_workqueueid_value eq $($Queue.workqueueid) and statecode eq $QueueQueuedState and statuscode eq $QueueQueuedStatus")
    $itemUri = "$EnvironmentUrl/api/data/v9.2/workqueueitems?`$select=$select&`$filter=$filter&`$orderby=createdon asc&`$top=2"
    $items = @((Invoke-DataverseGet -Uri $itemUri -Headers $Headers).value)
    if ($items.Count -ne 1) { throw "queue_next_item_candidate_count_not_one:$($items.Count)" }
    return $items[0]
  }

  throw 'QUEUE_ITEM_ID_OR_NAME_REQUIRED'
}

function Assert-AgentDispatchInput {
  param([object]$QueueInput)
  foreach ($field in $RequiredQueueInputFields) {
    if (-not ($QueueInput.PSObject.Properties.Name -contains $field)) {
      throw "queue_input_field_missing:$field"
    }
  }
  if ([string]$QueueInput.queue_item_type -ne 'AGENT_DISPATCH') { throw "queue_item_type_mismatch:$($QueueInput.queue_item_type)" }
  if ([string]$QueueInput.source_table -ne 'mon_sdu_source_artifact') { throw "queue_source_table_mismatch:$($QueueInput.source_table)" }
  if ([string]$QueueInput.target_environment_id -ne $EnvironmentId) { throw "queue_environment_mismatch:$($QueueInput.target_environment_id)" }
  if ([string]$QueueInput.created_by_system -ne $CreatedBySystem) { throw "queue_created_by_system_mismatch:$($QueueInput.created_by_system)" }
}

function Get-SourceHash {
  param([object]$Payload)
  $json = $Payload | ConvertTo-Json -Depth 12 -Compress
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
  $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
  return (($hash | ForEach-Object { $_.ToString('x2') }) -join '')
}

function ConvertTo-AgentRuntimeCanonicalId {
  param([string]$AgentId)
  if ([string]::IsNullOrWhiteSpace($AgentId)) { throw 'agent_id_missing' }
  return "sdu.agent.$($AgentId.Replace('-', '_')).runtime_actions"
}

function Assert-AgentRuntimeAction {
  param([string]$AgentId, [string]$QueueMode, [hashtable]$Headers)
  $metadata = Get-EntityMetadata -LogicalName 'mon_sdu_agent_connection_mapping' -Headers $Headers
  if ($metadata.EntitySetName -ne 'mon_sdu_agent_connection_mappings') { throw "ENTITY_SET_MISMATCH:$($metadata.EntitySetName)" }
  $canonicalId = ConvertTo-AgentRuntimeCanonicalId -AgentId $AgentId
  $filter = "mon_canonical_id eq '$canonicalId'"
  $select = 'mon_sdu_agent_connection_mappingid,mon_canonical_id,mon_status,mon_notes,mon_owner_agent,mon_reviewer_agent'
  $queryUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)?`$select=$select&`$filter=$([uri]::EscapeDataString($filter))"
  $rows = @((Invoke-DataverseGet -Uri $queryUri -Headers $Headers).value)
  if ($rows.Count -ne 1) { throw "agent_runtime_candidate_count_not_one:$($canonicalId):$($rows.Count)" }
  if ([string]$rows[0].mon_status -ne 'ACTIVE_DEV') { throw "agent_runtime_status_not_active:$($canonicalId):$($rows[0].mon_status)" }
  $notes = [string]$rows[0].mon_notes | ConvertFrom-Json
  $queueModes = @($notes.queue_modes | ForEach-Object { [string]$_ })
  if ($QueueMode -notin $queueModes) { throw "agent_runtime_queue_mode_not_allowed:$($AgentId):$QueueMode" }
  return [pscustomobject]@{
    canonical_id = $canonicalId
    owner_agent = $rows[0].mon_owner_agent
    reviewer_agent = $rows[0].mon_reviewer_agent
    queue_modes = $queueModes
  }
}

function Get-AgentIdFromQueueInput {
  param([object]$QueueInput)
  $agentId = ([string]$QueueInput.operation -replace '^live_agent_dispatch\.', '')
  if ([string]::IsNullOrWhiteSpace($agentId) -or $agentId -eq [string]$QueueInput.operation) {
    throw "queue_operation_agent_missing:$($QueueInput.operation)"
  }
  return $agentId
}

function Get-SourceArtifactCanonicalIdFromQueueInput {
  param([object]$QueueInput)
  $sourceArtifactCanonicalId = [string]$QueueInput.source_artifact_canonical_id
  if ([string]::IsNullOrWhiteSpace($sourceArtifactCanonicalId) -and ([string]$QueueInput.idempotency_key -match 'sp-live\.(spdoc\.[^.]+)\.')) {
    $sourceArtifactCanonicalId = $Matches[1]
  }
  if ([string]::IsNullOrWhiteSpace($sourceArtifactCanonicalId) -and ([string]$QueueInput.canonical_id -match '(spdoc\.[A-Za-z0-9]+)')) {
    $sourceArtifactCanonicalId = $Matches[1]
  }
  if ([string]::IsNullOrWhiteSpace($sourceArtifactCanonicalId)) {
    throw 'source_artifact_canonical_id_missing'
  }
  return $sourceArtifactCanonicalId
}

function Assert-SourceArtifactExact {
  param([string]$SourceArtifactCanonicalId, [hashtable]$Headers)
  $sourceMetadata = Get-EntityMetadata -LogicalName 'mon_sdu_source_artifact' -Headers $Headers
  if ($sourceMetadata.EntitySetName -ne 'mon_sdu_source_artifacts') { throw "ENTITY_SET_MISMATCH:$($sourceMetadata.EntitySetName)" }
  $sourceFilter = "mon_canonical_id eq '$SourceArtifactCanonicalId'"
  $sourceQueryUri = "$EnvironmentUrl/api/data/v9.2/$($sourceMetadata.EntitySetName)?`$select=mon_sdu_source_artifactid,mon_canonical_id,mon_status&`$filter=$([uri]::EscapeDataString($sourceFilter))"
  $sourceRows = @((Invoke-DataverseGet -Uri $sourceQueryUri -Headers $Headers).value)
  if ($sourceRows.Count -ne 1) { throw "source_artifact_candidate_count_not_one:$($sourceRows.Count)" }
  return $sourceRows[0]
}

function Assert-QueueItemReadyForWorker {
  param([object]$Item, [hashtable]$Headers)
  Assert-QueueItemIsQueued -Item $Item
  $queueInputObject = [string]$Item.input | ConvertFrom-Json
  Assert-AgentDispatchInput -QueueInput $queueInputObject
  $agentId = Get-AgentIdFromQueueInput -QueueInput $queueInputObject
  $agentRuntime = Assert-AgentRuntimeAction -AgentId $agentId -QueueMode $Mode -Headers $Headers
  $sourceArtifactCanonicalId = Get-SourceArtifactCanonicalIdFromQueueInput -QueueInput $queueInputObject
  $sourceArtifact = Assert-SourceArtifactExact -SourceArtifactCanonicalId $sourceArtifactCanonicalId -Headers $Headers
  return [pscustomobject]@{
    input = $queueInputObject
    agent_id = $agentId
    agent_runtime = $agentRuntime
    source_artifact_canonical_id = $sourceArtifactCanonicalId
    source_artifact_id = $sourceArtifact.mon_sdu_source_artifactid
  }
}

function Assert-QueueItemIsQueued {
  param([object]$Item)
  if ([int]$Item.statecode -ne $QueueQueuedState -or [int]$Item.statuscode -ne $QueueQueuedStatus) {
    throw "queue_item_not_queued:$($Item.workqueueitemid):state=$($Item.statecode):status=$($Item.statuscode)"
  }
}

function Get-QueueItemById {
  param([string]$ItemId, [hashtable]$Headers)
  $select = Get-QueueItemSelect
  return Invoke-DataverseGet -Uri "$EnvironmentUrl/api/data/v9.2/workqueueitems($ItemId)?`$select=$select" -Headers $Headers
}

function Claim-WorkQueueItem {
  param([object]$Item, [hashtable]$Headers)
  Assert-QueueItemIsQueued -Item $Item
  $startedAt = (Get-Date).ToUniversalTime()
  $claimResult = [ordered]@{
    worker_id = $WorkerId
    action = 'claim'
    claimed_at_utc = $startedAt.ToString('o')
    previous_statecode = [int]$Item.statecode
    previous_statuscode = [int]$Item.statuscode
  }
  $payload = @{
    statecode = $QueueProcessingState
    statuscode = $QueueProcessingStatus
    processingstarttime = $startedAt.ToString('o')
    processingresult = ($claimResult | ConvertTo-Json -Depth 8 -Compress)
  }
  Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/workqueueitems($($Item.workqueueitemid))" -Headers $Headers -Payload $payload
  $postcheck = Get-QueueItemById -ItemId $Item.workqueueitemid -Headers $Headers
  if ([int]$postcheck.statecode -ne $QueueProcessingState -or [int]$postcheck.statuscode -ne $QueueProcessingStatus) {
    throw "queue_item_claim_postcheck_failed:$($Item.workqueueitemid)"
  }
  return $postcheck
}

function Complete-WorkQueueItem {
  param([object]$Item, [object]$AgentResult, [hashtable]$Headers)
  $completedAt = (Get-Date).ToUniversalTime()
  $startedAt = if ($Item.processingstarttime) { [DateTime]$Item.processingstarttime } else { $completedAt }
  $duration = [Math]::Max(0, [int]($completedAt - $startedAt).TotalSeconds)
  $processingResult = [ordered]@{
    worker_id = $WorkerId
    action = 'complete'
    completed_at_utc = $completedAt.ToString('o')
    evidence_canonical_id = $AgentResult.evidence_canonical_id
    source_artifact_canonical_id = $AgentResult.source_artifact_canonical_id
    agent_id = $AgentResult.agent_id
  }
  $payload = @{
    statecode = $QueueProcessedState
    statuscode = $QueueProcessedStatus
    completedon = $completedAt.ToString('o')
    processingduration = $duration
    processingresult = ($processingResult | ConvertTo-Json -Depth 8 -Compress)
  }
  Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/workqueueitems($($Item.workqueueitemid))" -Headers $Headers -Payload $payload
  $postcheck = Get-QueueItemById -ItemId $Item.workqueueitemid -Headers $Headers
  if ([int]$postcheck.statecode -ne $QueueProcessedState -or [int]$postcheck.statuscode -ne $QueueProcessedStatus) {
    throw "queue_item_complete_postcheck_failed:$($Item.workqueueitemid)"
  }
  if ([string]::IsNullOrWhiteSpace([string]$postcheck.completedon)) {
    throw "queue_item_complete_completedon_missing:$($Item.workqueueitemid)"
  }
  return $postcheck
}

function Fail-WorkQueueItem {
  param([object]$Item, [string]$Reason, [hashtable]$Headers)
  if ($null -eq $Item -or [string]::IsNullOrWhiteSpace([string]$Item.workqueueitemid)) { return }
  $failedAt = (Get-Date).ToUniversalTime()
  $processingResult = [ordered]@{
    worker_id = $WorkerId
    action = 'fail'
    failed_at_utc = $failedAt.ToString('o')
    reason = $Reason
  }
  $payload = @{
    statecode = $QueueExceptionState
    statuscode = $QueueGenericExceptionStatus
    completedon = $failedAt.ToString('o')
    processingresult = ($processingResult | ConvertTo-Json -Depth 8 -Compress)
  }
  Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/workqueueitems($($Item.workqueueitemid))" -Headers $Headers -Payload $payload
}

function Get-ShortHash {
  param([object]$Payload)
  return (Get-SourceHash -Payload $Payload).Substring(0, 16)
}

function Get-DocumentCanonicalId {
  param([object]$Document)
  $key = @($Document.SiteUrl, $Document.LibraryTitle, $Document.FilePath, $Document.FileName) -join '|'
  return "spdoc.$(Get-ShortHash -Payload $key)"
}

function ConvertTo-DocumentEvent {
  param([string]$Json)
  if (-not [string]::IsNullOrWhiteSpace($Json)) {
    return @($Json | ConvertFrom-Json)
  }

  if ($Apply) {
    if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
      throw 'PNP_POWERSHELL_MODULE_MISSING'
    }
    Connect-PnPOnline -Url $SiteUrl -Interactive
    $items = Get-PnPListItem -List $ListTitle -PageSize 25 | Select-Object -First $MaxItems
    return @($items | ForEach-Object {
      [pscustomobject]@{
        SiteUrl = $SiteUrl
        LibraryTitle = $ListTitle
        FileName = $_.FieldValues.FileLeafRef
        FilePath = $_.FieldValues.FileRef
        FileUrl = "$SiteUrl$($_.FieldValues.FileRef)"
        ContentType = $_.FieldValues.ContentTypeId
        ModifiedUtc = $_.FieldValues.Modified
        Author = if ($_.FieldValues.Author) { $_.FieldValues.Author.LookupValue } else { '' }
        Trigger = 'live_sharepoint_read'
      }
    })
  }

  return @(
    [pscustomobject]@{
      SiteUrl = $SiteUrl
      LibraryTitle = $ListTitle
      FileName = 'dry-run-sharepoint-event.txt'
      FilePath = '/dry-run/sharepoint-event.txt'
      FileUrl = "$SiteUrl/dry-run/sharepoint-event.txt"
      ContentType = 'dry_run'
      ModifiedUtc = (Get-Date).ToUniversalTime().ToString('o')
      Author = 'dry_run'
      Trigger = 'dry_run_fixture'
    }
  )
}

function Assert-Identity {
  if (-not $Apply) { return }
  $pacWho = Invoke-TextCommand -Command @('pac', 'org', 'who')
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

function Upsert-SourceArtifact {
  param([object]$Document, [hashtable]$Headers)
  $metadata = Get-EntityMetadata -LogicalName 'mon_sdu_source_artifact' -Headers $Headers
  if ($metadata.EntitySetName -ne 'mon_sdu_source_artifacts') { throw "ENTITY_SET_MISMATCH:$($metadata.EntitySetName)" }

  $canonicalId = Get-DocumentCanonicalId -Document $Document
  $sourceHash = Get-SourceHash -Payload $Document
  $filter = "mon_canonical_id eq '$canonicalId'"
  $queryUri = "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)?`$select=mon_sdu_source_artifactid,mon_canonical_id,mon_status,mon_source_hash&`$filter=$([uri]::EscapeDataString($filter))"
  $beforeRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $Headers).value)
  if ($beforeRows.Count -gt 1) { throw "candidate_count_not_one:$($beforeRows.Count)" }

  $payload = @{
    mon_canonical_id = $canonicalId
    mon_display_name = [string]$Document.FileName
    mon_status = 'Pending'
    mon_seed_batch_id = $BatchId
    mon_source_system = 'SharePoint'
    mon_source_path = [string]$Document.FileUrl
    mon_source_hash = $sourceHash
    mon_snapshot_path = [string]$Document.FilePath
    mon_environment_scope = "HUBDesarrollo|$EnvironmentId"
    mon_environment_id = $EnvironmentId
    mon_environment_url = $EnvironmentUrl
    mon_gate_required = $true
    mon_owner = 'sdu-live-agent-dispatch'
    mon_risk_level = 'medium'
    mon_tenant_scope = 'escribaniabitsch.sharepoint.com'
    mon_stop_condition = $StopCondition
    mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    mon_notes = "Live SharePoint event reference. SharePoint remains document source; Dataverse stores metadata, state and trace."
  }

  if ($Apply) {
    if ($beforeRows.Count -eq 0) {
      Invoke-DataversePost -Uri "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)" -Headers $Headers -Payload $payload
    } else {
      $recordId = [string]$beforeRows[0].mon_sdu_source_artifactid
      if ([string]::IsNullOrWhiteSpace($recordId)) { throw 'identity_field_missing:mon_sdu_source_artifactid' }
      Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/$($metadata.EntitySetName)($recordId)" -Headers $Headers -Payload $payload
    }
  }

  return [pscustomobject]@{
    canonical_id = $canonicalId
    candidate_count_before = $beforeRows.Count
    source_hash = $sourceHash
    payload = $payload
  }
}

function Get-AgentForDocument {
  param([object]$Document)
  $haystack = (@($Document.FileName, $Document.FilePath, $Document.ContentType) -join ' ').ToLowerInvariant()
  if ($haystack -match 'uif|kyc|cumplimiento|compliance') { return 'maat-cumplimiento' }
  if ($haystack -match 'riesgo|risk|alerta') { return 'horus-riesgo' }
  if ($haystack -match 'gate|control|validacion|validator') { return 'anubis-gate' }
  if ($haystack -match 'json|csv|metadata|schema|contenttype|campo') { return 'thot-tecnico' }
  return 'seshat-normativa'
}

function Add-WorkQueueItem {
  param([object]$Document, [object]$SourceArtifact, [hashtable]$Headers)
  $queue = Get-WorkQueueExact -Headers $Headers

  $agentId = Get-AgentForDocument -Document $Document
  $queueInput = @{
    queue_item_type = 'AGENT_DISPATCH'
    canonical_id = "queue.sdu_agent_dispatch.$agentId.$($SourceArtifact.canonical_id)"
    correlation_id = "sp-live.$($SourceArtifact.source_hash.Substring(0, 16))"
    idempotency_key = "sp-live.$($SourceArtifact.canonical_id).$agentId"
    batch_id = $BatchId
    source_table = 'mon_sdu_source_artifact'
    source_artifact_canonical_id = [string]$SourceArtifact.canonical_id
    source_matrix = 'scripts/sharepoint/Invoke-SduSharePointDataverseLiveBridge.ps1'
    source_path = [string]$Document.FileUrl
    source_hash = $SourceArtifact.source_hash
    operation = "live_agent_dispatch.$agentId"
    target_environment_id = $EnvironmentId
    target_environment_url = $EnvironmentUrl
    gate_required = $true
    gate_id = 'GATE_DATAVERSE_APPLY'
    risk_level = 'medium'
    priority = 'high'
    stop_condition = $StopCondition
    rollback_strategy = 'cancel_or_deactivate_exact_workqueueitem_and_patch_source_artifact_status'
    evidence_required = @('queue_item_id', 'source_artifact_canonical_id', 'postcheck_snapshot', 'agent_result')
    created_by_system = $CreatedBySystem
    ai_assisted = $false
    ai_validation_status = 'LOCAL_RULE_VALIDATED_NO_OPENAI_REQUIRED'
  }

  $itemPayload = @{
    name = $queueInput.canonical_id
    input = ($queueInput | ConvertTo-Json -Depth 12 -Compress)
    priority = 1
    uniqueidbyqueue = [string]$queueInput.idempotency_key
    'workqueueid@odata.bind' = "/workqueues($($queue.workqueueid))"
  }

  $filter = [uri]::EscapeDataString("_workqueueid_value eq $($queue.workqueueid) and uniqueidbyqueue eq '$($queueInput.idempotency_key)'")
  $existingUri = "$EnvironmentUrl/api/data/v9.2/workqueueitems?`$select=$(Get-QueueItemSelect)&`$filter=$filter&`$top=2"
  $existingResponse = if ($Apply) { Invoke-DataverseGet -Uri $existingUri -Headers $Headers } else { $null }
  $existingRows = @()
  if ($existingResponse -and $existingResponse.PSObject.Properties.Name -contains 'value' -and $null -ne $existingResponse.value) {
    $existingRows = @($existingResponse.value)
  }
  if ($existingRows.Count -gt 1) { throw "workqueueitem_idempotency_candidate_count_not_one:$($existingRows.Count)" }

  if ($Apply) {
    if ($existingRows.Count -eq 0) {
      Invoke-DataversePost -Uri "$EnvironmentUrl/api/data/v9.2/workqueueitems" -Headers $Headers -Payload $itemPayload
    }
  }

  return [pscustomobject]@{
    queue_name = $WorkQueueName
    workqueueid = $queue.workqueueid
    agent_id = $agentId
    candidate_count_before = $existingRows.Count
    queue_item_id = if ($existingRows.Count -eq 1) { $existingRows[0].workqueueitemid } else { '' }
    input = $queueInput
    payload = $itemPayload
  }
}

function Publish-AgentResult {
  param([object]$Item, [hashtable]$Headers)
  if ($null -eq $Item) { throw 'QUEUE_ITEM_REQUIRED' }

  $queueInputObject = [string]$Item.input | ConvertFrom-Json
  Assert-AgentDispatchInput -QueueInput $queueInputObject
  $agentId = Get-AgentIdFromQueueInput -QueueInput $queueInputObject
  $agentRuntime = if ($Apply) { Assert-AgentRuntimeAction -AgentId $agentId -QueueMode $Mode -Headers $Headers } else { $null }
  $sourceArtifactCanonicalId = Get-SourceArtifactCanonicalIdFromQueueInput -QueueInput $queueInputObject
  $evidenceMetadata = Get-EntityMetadata -LogicalName 'mon_sdu_evidence' -Headers $Headers
  if ($evidenceMetadata.EntitySetName -ne 'mon_sdu_evidences') { throw "ENTITY_SET_MISMATCH:$($evidenceMetadata.EntitySetName)" }

  $canonicalId = "agentresult.$agentId.$($queueInputObject.source_hash.Substring(0, 16))"
  $filter = "mon_canonical_id eq '$canonicalId'"
  $queryUri = "$EnvironmentUrl/api/data/v9.2/$($evidenceMetadata.EntitySetName)?`$select=mon_sdu_evidenceid,mon_canonical_id,mon_status&`$filter=$([uri]::EscapeDataString($filter))"
  $beforeRows = @((Invoke-DataverseGet -Uri $queryUri -Headers $Headers).value)
  if ($beforeRows.Count -gt 1) { throw "candidate_count_not_one:$($beforeRows.Count)" }

  $result = @{
    agent_id = $agentId
    agent_runtime_canonical_id = if ($agentRuntime) { $agentRuntime.canonical_id } else { ConvertTo-AgentRuntimeCanonicalId -AgentId $agentId }
    state = 'Completed'
    processed_at_utc = (Get-Date).ToUniversalTime().ToString('o')
    source_artifact = $queueInputObject.canonical_id
    summary = "Live bounded agent processing completed for $($queueInputObject.source_path)."
  }
  $payload = @{
    mon_canonical_id = $canonicalId
    mon_connection_canonical_id = [string]$queueInputObject.canonical_id
    mon_display_name = "Agent result $agentId"
    mon_status = 'Completed'
    mon_seed_batch_id = $BatchId
    mon_source_system = 'Power Automate Work Queue'
    mon_source_path = [string]$queueInputObject.source_path
    mon_source_hash = [string]$queueInputObject.source_hash
    mon_evidence_hash = Get-SourceHash -Payload $result
    mon_evidence_type = 'live_agent_result'
    mon_environment_scope = "HUBDesarrollo|$EnvironmentId"
    mon_gate_required = $true
    mon_owner = $agentId
    mon_risk_level = [string]$queueInputObject.risk_level
    mon_tenant_scope = 'escribaniabitsch.sharepoint.com'
    mon_stop_condition = 'agent_live_processing_completed_postcheck_required'
    mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
    mon_notes = ($result | ConvertTo-Json -Depth 8 -Compress)
  }

  if ($Apply) {
    if ($beforeRows.Count -eq 0) {
      Invoke-DataversePost -Uri "$EnvironmentUrl/api/data/v9.2/$($evidenceMetadata.EntitySetName)" -Headers $Headers -Payload $payload
    } else {
      $recordId = [string]$beforeRows[0].mon_sdu_evidenceid
      if ([string]::IsNullOrWhiteSpace($recordId)) { throw 'identity_field_missing:mon_sdu_evidenceid' }
      Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/$($evidenceMetadata.EntitySetName)($recordId)" -Headers $Headers -Payload $payload
    }

    $sourceRows = @(Assert-SourceArtifactExact -SourceArtifactCanonicalId $sourceArtifactCanonicalId -Headers $Headers)
    $sourceId = [string]$sourceRows[0].mon_sdu_source_artifactid
    if ([string]::IsNullOrWhiteSpace($sourceId)) { throw 'identity_field_missing:mon_sdu_source_artifactid' }
    $sourcePayload = @{
      mon_status = 'Completed'
      mon_stop_condition = 'dataverse_queue_worker_item_completed_postchecked'
      mon_last_reconciled_at = (Get-Date).ToString('yyyy-MM-ddTHH:mm:sszzz')
      mon_notes = 'Dataverse queue worker completed: exact workqueueitem processed directly from Dataverse, with no Power Automate dependency, and agent evidence persisted. Rollback: patch this row to Pending and return the exact workqueueitem to queued state if required.'
    }
    Invoke-DataversePatch -Uri "$EnvironmentUrl/api/data/v9.2/mon_sdu_source_artifacts($sourceId)" -Headers $Headers -Payload $sourcePayload
  }

  return [pscustomobject]@{
    queue_item_id = $Item.workqueueitemid
    queue_item_name = $Item.name
    agent_id = $agentId
    agent_runtime_canonical_id = if ($agentRuntime) { $agentRuntime.canonical_id } else { ConvertTo-AgentRuntimeCanonicalId -AgentId $agentId }
    source_artifact_canonical_id = $sourceArtifactCanonicalId
    evidence_canonical_id = $canonicalId
    candidate_count_before = $beforeRows.Count
    result = $result
  }
}

Assert-LiveGate
Assert-NotProdLike -Value $EnvironmentUrl -Label 'ENVIRONMENT_URL'
if ($MaxItems -lt 1 -or $MaxItems -gt 10) { throw 'MAX_ITEMS_OUT_OF_BOUNDS' }
if ($BoundedContentChars -lt 256 -or $BoundedContentChars -gt 12000) { throw 'BOUNDED_CONTENT_CHARS_OUT_OF_BOUNDS' }
Assert-Identity

$summary = [ordered]@{
  status = if ($Apply) { 'LIVE_BRIDGE_READY_APPLY_MODE' } else { 'LIVE_BRIDGE_DRY_RUN_READY' }
  mode = $Mode
  apply = [bool]$Apply
  token_printed = $false
  sharepoint_write = $false
  flow_dependency = $false
  worker_id = $WorkerId
  environment_url = $EnvironmentUrl
  environment_id = $EnvironmentId
  workqueuekey = $WorkQueueKey
  workqueue_name = $WorkQueueName
  max_items = $MaxItems
  bounded_content_chars = $BoundedContentChars
  rollback = 'cancel_or_deactivate_exact_workqueueitem_and_patch_source_artifact_status'
  postcheck = 'read mon_sdu_source_artifact, workqueueitem and mon_sdu_evidence by exact canonical id; verify workqueueitem state/status transitions'
  stop_condition = $StopCondition
  results = @()
}

if ($Apply) {
  $headers = Get-DataverseHeaders
} else {
  $headers = @{}
}

if ($Mode -eq 'IngestSharePointEvent') {
  $documents = @(ConvertTo-DocumentEvent -Json $EventPayloadJson | Select-Object -First $MaxItems)
  foreach ($document in $documents) {
    if ($Apply) {
      $sourceArtifact = Upsert-SourceArtifact -Document $document -Headers $headers
      $queueItem = Add-WorkQueueItem -Document $document -SourceArtifact $sourceArtifact -Headers $headers
    } else {
      $sourceArtifact = [pscustomobject]@{
        canonical_id = Get-DocumentCanonicalId -Document $document
        source_hash = Get-SourceHash -Payload $document
        candidate_count_before = 0
      }
      $queueItem = [pscustomobject]@{
        queue_name = $WorkQueueName
        agent_id = Get-AgentForDocument -Document $document
        input = @{
          queue_item_type = 'AGENT_DISPATCH'
          canonical_id = "dryrun.$($sourceArtifact.canonical_id)"
          source_table = 'mon_sdu_source_artifact'
          operation = "live_agent_dispatch.$(Get-AgentForDocument -Document $document)"
        }
      }
    }
    $summary.results += [pscustomobject]@{
      document = $document
      source_artifact = $sourceArtifact
      queue_item = $queueItem
    }
  }
} else {
  if (-not $Apply) {
    $summary.results += [pscustomobject]@{
      queue_item_id = if ($QueueItemId) { $QueueItemId } else { 'dry-run-queue-item-id' }
      queue_item_name = if ($QueueItemName) { $QueueItemName } else { 'dry-run-queue-item-name' }
      agent_id = 'seshat-normativa'
      evidence_canonical_id = 'agentresult.dryrun'
      flow_dependency = $false
      result = 'dry_run_only'
    }
  } else {
    $queue = Get-WorkQueueExact -Headers $headers
    $item = Get-QueueItemExact -Headers $headers -Queue $queue
    $claimed = $null
    try {
      $ready = Assert-QueueItemReadyForWorker -Item $item -Headers $headers
      $claimed = Claim-WorkQueueItem -Item $item -Headers $headers
      $agentResult = Publish-AgentResult -Item $claimed -Headers $headers
      $completed = Complete-WorkQueueItem -Item $claimed -AgentResult $agentResult -Headers $headers
      $summary.results += [pscustomobject]@{
        queue_item_id = $completed.workqueueitemid
        queue_item_name = $completed.name
        final_statecode = $completed.statecode
        final_statuscode = $completed.statuscode
        completedon = $completed.completedon
        agent_result = $agentResult
      }
    } catch {
      if ($null -ne $claimed) {
        Fail-WorkQueueItem -Item $claimed -Reason $_.Exception.Message -Headers $headers
      }
      throw
    }
  }
}

$summary | ConvertTo-Json -Depth 16
