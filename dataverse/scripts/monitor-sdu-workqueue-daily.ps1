param(
    [string]$EnvironmentUrl = 'https://org993e120d.crm2.dynamics.com',
    [string]$TenantResource = 'https://org993e120d.crm2.dynamics.com/',
    [int]$ExpectedDefaultTtlMinutes = 50,
    [int]$ExpectedRetryLimit = 25,
    [int]$ExpectedRequeueLimit = 25,
    [int]$ExpectedSlaThreshold = 50,
    [int]$ExpectedPriorityType = 0,
    [string]$OutputDirectory = (Join-Path (Resolve-Path $PSScriptRoot).Path 'monitoring'),
    [switch]$Json,
    [switch]$SummaryOnly
)

$ErrorActionPreference = 'Stop'

function Get-DataverseToken {
    param([string]$Resource)

    $raw = az account get-access-token --resource $Resource --query accessToken -o tsv
    if ([string]::IsNullOrWhiteSpace($raw)) {
        throw "No se pudo obtener token de Azure CLI para el recurso $Resource"
    }
    return $raw
}

function Normalize-Bool {
    param([object]$Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [bool]) { return $Value.ToString().ToLower() }
    return $Value
}

$snapshotAt = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss.fffffffK'
$runId = (Get-Date -Format 'yyyyMMdd_HHmmss')
$outputDir = Join-Path $OutputDirectory $runId
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$token = Get-DataverseToken -Resource $TenantResource
$headers = @{
    Authorization    = "Bearer $token"
    Accept           = 'application/json'
    'OData-Version' = '4.0'
    'OData-MaxVersion' = '4.0'
}

$queuesUri = "$EnvironmentUrl/api/data/v9.2/workqueues?`$select=name,workqueueid,defaultitemtimetoliveinminutes,itemmaxretrycount,itemmaxrequeuecount,slathresholdinpercentage,prioritytype,workqueuetype&`$filter=startswith(name,'SDU.')"
$queueResponse = Invoke-RestMethod -Uri $queuesUri -Headers $headers -Method Get -ErrorAction Stop
$queues = $queueResponse.value

if (-not $queues -or $queues.Count -eq 0) {
    throw "No se encontraron colas con nombre SDU.* en $EnvironmentUrl"
}

$results = New-Object System.Collections.Generic.List[object]

foreach ($queue in $queues) {
    $queueCountUri = "$EnvironmentUrl/api/data/v9.2/workqueueitems?`$filter=_workqueueid_value eq '$($queue.workqueueid)'&`$count=true&`$top=1"
    $queueCountResponse = Invoke-RestMethod -Uri $queueCountUri -Headers $headers -Method Get -ErrorAction Stop
    $backlog = [int]($queueCountResponse.'@odata.count')

    $result = [pscustomobject]@{
        snapshot_at                  = $snapshotAt
        queue_name                   = $queue.name
        workqueueid                  = $queue.workqueueid
        defaultitemtimetoliveinminutes= $queue.defaultitemtimetoliveinminutes
        itemmaxretrycount            = $queue.itemmaxretrycount
        itemmaxrequeuecount          = $queue.itemmaxrequeuecount
        slathresholdinpercentage     = $queue.slathresholdinpercentage
        prioritytype                 = $queue.prioritytype
        workqueuetype                = $queue.workqueuetype
        backlog_total_items          = $backlog
        drift_default_ttl            = ($queue.defaultitemtimetoliveinminutes -ne $ExpectedDefaultTtlMinutes)
        drift_retry_limit            = ($queue.itemmaxretrycount -ne $ExpectedRetryLimit)
        drift_requeue_limit          = ($queue.itemmaxrequeuecount -ne $ExpectedRequeueLimit)
        drift_sla_threshold          = ($queue.slathresholdinpercentage -ne $ExpectedSlaThreshold)
        drift_priority_type          = ($queue.prioritytype -ne $ExpectedPriorityType)
        any_drift                    = $false
    }

    $result.any_drift = ($result.drift_default_ttl -or $result.drift_retry_limit -or $result.drift_requeue_limit -or $result.drift_sla_threshold -or $result.drift_priority_type)
    $results.Add($result)
}

$rows = @($results.ToArray())
$rows = $rows | Sort-Object queue_name

$summary = [pscustomobject]@{
    snapshot_at = $snapshotAt
    environment = $EnvironmentUrl
    rows = $rows.Count
    drift_rows = ($rows | Where-Object { $_.any_drift } | Measure-Object | Select-Object -ExpandProperty Count)
    total_backlog_items = ($rows | Measure-Object -Property backlog_total_items -Sum | Select-Object -ExpandProperty Sum)
}

$summaryPath = Join-Path $outputDir ("sdu_workqueue_snapshot_summary_$runId.json")
$rowsPath = Join-Path $outputDir ("sdu_workqueue_snapshot_rows_$runId.csv")

$summary | ConvertTo-Json -Depth 4 | Set-Content -Path $summaryPath -Encoding UTF8

if (-not $SummaryOnly) {
    $rows | Export-Csv -Path $rowsPath -NoTypeInformation -Encoding UTF8
}

if ($Json) {
    [pscustomobject]@{ summary = $summary; rows = $rows } | ConvertTo-Json -Depth 6
} else {
    Write-Host ('SUMMARY: snapshot={0} environment={1} queues={2} drift_queues={3} backlog_total={4}' -f $snapshotAt, $EnvironmentUrl, $summary.rows, $summary.drift_rows, $summary.total_backlog_items)
    Write-Host ("OUTPUT_SUMMARY=$summaryPath")
    if (-not $SummaryOnly) { Write-Host ("OUTPUT_ROWS=$rowsPath") }
}
