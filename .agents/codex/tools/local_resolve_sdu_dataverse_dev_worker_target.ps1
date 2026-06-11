param(
  [string]$RepoRoot = ".",
  [string]$CachePath = ".agents/codex/evals/results/sdu_dataverse_dev_worker_target_latest.json",
  [string]$FlowName = "SDU_Process_Dataverse_Apply_Work_Items",
  [string]$QueueName = "SDU.Dataverse.Apply.Queue"
)

$ErrorActionPreference = "Stop"

function Join-RepoPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) {
    return $Path
  }
  return Join-Path $RepoRoot $Path
}
function Read-JsonFile {
  param([string]$Path)
  $resolved = Join-RepoPath -Path $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    return $null
  }
  return Get-Content -Raw -LiteralPath $resolved | ConvertFrom-Json
}

function Read-YamlNamedBlock {
  param(
    [string]$Path,
    [string]$Name
  )
  $resolved = Join-RepoPath -Path $Path
  $data = [ordered]@{}
  if (-not (Test-Path -LiteralPath $resolved)) {
    return $data
  }

  $inBlock = $false
  foreach ($line in Get-Content -LiteralPath $resolved) {
    if ($line -match '^\s*-\s+name:\s*(.+?)\s*$') {
      if ($inBlock) { break }
      $candidate = $Matches[1].Trim().Trim('"').Trim("'")
      if ($candidate -eq $Name) {
        $inBlock = $true
        $data["name"] = $candidate
      }
      continue
    }

    if ($inBlock -and $line -match '^\s+([A-Za-z0-9_]+):\s*(.*?)\s*$') {
      $data[$Matches[1]] = $Matches[2].Trim().Trim('"').Trim("'")
    }
  }
  return $data
}

$deployment = Read-JsonFile -Path "powerplatform/settings/deployment-settings.dev.json"
$cache = Read-JsonFile -Path $CachePath
$flow = Read-YamlNamedBlock -Path "powerplatform/flows/dev-disabled-flow-manifest.yml" -Name $FlowName
$queue = Read-YamlNamedBlock -Path "powerplatform/workqueues/workqueue.manifest.yml" -Name $QueueName

$errors = New-Object System.Collections.Generic.List[string]
if ($null -eq $deployment) { $errors.Add("missing_deployment_settings") }
if ($flow.Count -eq 0) { $errors.Add("missing_flow_manifest_block") }
if ($queue.Count -eq 0) { $errors.Add("missing_workqueue_manifest_block") }
if ($null -eq $cache) { $errors.Add("missing_target_cache") }

$cacheMatches = $false
if ($null -ne $cache) {
  $cacheMatches = (
    $cache.flow.name -eq $FlowName -and
    $cache.workqueue.name -eq $QueueName -and
    $cache.environment.url -eq $deployment.Target.EnvironmentUrl
  )
}

$decision = "TARGET_CACHE_READY"
if ($errors.Count -gt 0) {
  $decision = "TARGET_CACHE_INCOMPLETE"
} elseif (-not $cacheMatches) {
  $decision = "TARGET_CACHE_MISMATCH"
} elseif ($cache.decision -eq "NO_OP_LISTO_ALREADY_ACTIVE") {
  $decision = "NO_OP_LISTO_ALREADY_ACTIVE"
}

[pscustomobject]@{
  status = if ($errors.Count -eq 0 -and $cacheMatches) { "PASS" } else { "FAIL" }
  decision = $decision
  cache_path = $CachePath
  environment = if ($null -ne $deployment) {
    [pscustomobject]@{
      url = $deployment.Target.EnvironmentUrl
      environment_id = $deployment.Target.EnvironmentId
      organization_id = $deployment.Target.OrganizationId
      expected_pac_profile = $deployment.Target.PacProfile
      safe_active_profile = if ($null -ne $cache) { $cache.environment.safe_active_profile } else { $null }
    }
  } else { $null }
  flow = [pscustomobject]@{
    name = $FlowName
    manifest_workflowid = $flow["workflowid"]
    cached_workflowid = if ($null -ne $cache) { $cache.flow.workflowid } else { $null }
    cached_state = if ($null -ne $cache) { $cache.flow.live_state } else { $null }
    candidate_count = if ($null -ne $cache) { $cache.flow.candidate_count } else { $null }
  }
  workqueue = [pscustomobject]@{
    name = $QueueName
    manifest_queue_id = $queue["queue_id"]
    cached_queue_id = if ($null -ne $cache) { $cache.workqueue.workqueueid } else { $null }
    cached_state = if ($null -ne $cache) { $cache.workqueue.live_state } else { $null }
    candidate_count = if ($null -ne $cache) { $cache.workqueue.candidate_count } else { $null }
  }
  no_repeat = [pscustomobject]@{
    pac_fetch_required = $decision -notin @("NO_OP_LISTO_ALREADY_ACTIVE", "TARGET_CACHE_READY")
    activation_required = $decision -ne "NO_OP_LISTO_ALREADY_ACTIVE"
    global_validation_required = $false
  }
  errors = $errors
} | ConvertTo-Json -Depth 8

if ($errors.Count -gt 0 -or -not $cacheMatches) {
  exit 1
}
