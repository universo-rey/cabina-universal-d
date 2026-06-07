param(
  [int]$Port = 8795,
  [int]$MinimumCompletedTaskNumber = 39,
  [switch]$NoOpenVsi
)

$ErrorActionPreference = "Stop"

function Resolve-RepoRoot {
  $candidate = Join-Path $PSScriptRoot "..\..\.."
  return (Resolve-Path -LiteralPath $candidate).Path
}

function Get-JsonObject {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    return [pscustomobject]@{}
  }
  $raw = Get-Content -LiteralPath $Path -Raw
  if ([string]::IsNullOrWhiteSpace($raw)) {
    return [pscustomobject]@{}
  }
  return $raw | ConvertFrom-Json
}

function Set-JsonProperty {
  param(
    [object]$Object,
    [string]$Name,
    [object]$Value
  )
  $property = $Object.PSObject.Properties[$Name]
  if ($property) {
    $oldValue = $property.Value
    $property.Value = $Value
    return ($oldValue -ne $Value)
  }
  Add-Member -InputObject $Object -NotePropertyName $Name -NotePropertyValue $Value
  return $true
}

function Test-BridgeHealth {
  param([string]$BaseUrl)
  try {
    $health = Invoke-RestMethod -Method Get -Uri "$BaseUrl/health" -TimeoutSec 3
    return ($health.status -eq "ok" -and $health.live_executed -eq $false)
  } catch {
    return $false
  }
}

function Start-Bridge {
  param(
    [string]$RepoRoot,
    [int]$Port
  )
  $nodeCommand = Get-Command "node.exe" -ErrorAction Stop
  $bridgeRoot = Join-Path $RepoRoot "local-agent-bridge"
  $previousPort = $env:SDU_BRIDGE_PORT
  $previousHost = $env:SDU_BRIDGE_BIND_HOST
  try {
    $env:SDU_BRIDGE_PORT = [string]$Port
    $env:SDU_BRIDGE_BIND_HOST = "127.0.0.1"
    return Start-Process -FilePath $nodeCommand.Source -ArgumentList @("src/server.mjs") -WorkingDirectory $bridgeRoot -WindowStyle Hidden -PassThru
  } finally {
    $env:SDU_BRIDGE_PORT = $previousPort
    $env:SDU_BRIDGE_BIND_HOST = $previousHost
  }
}

function Wait-Bridge {
  param(
    [string]$BaseUrl,
    [int]$Seconds = 20
  )
  $deadline = (Get-Date).AddSeconds($Seconds)
  while ((Get-Date) -lt $deadline) {
    if (Test-BridgeHealth -BaseUrl $BaseUrl) {
      return $true
    }
    Start-Sleep -Milliseconds 500
  }
  return $false
}

function Get-TaskNumber {
  param([string]$TaskId)
  if ($TaskId -match '(\d+)$') {
    return [int]$Matches[1]
  }
  return $null
}

function Assert-NoCompletedTaskDowngrade {
  param(
    [object[]]$Tasks,
    [int]$MinimumCompletedTaskNumber
  )
  $downgraded = @()
  foreach ($task in @($Tasks)) {
    $taskNumber = Get-TaskNumber -TaskId ([string]$task.task_id)
    if ($null -eq $taskNumber -or $taskNumber -gt $MinimumCompletedTaskNumber) {
      continue
    }
    $status = [string]$task.status
    if (-not $status.StartsWith("EXECUTED", [System.StringComparison]::OrdinalIgnoreCase)) {
      $downgraded += [pscustomobject]@{
        task_id = $task.task_id
        status = $status
      }
    }
  }
  if ($downgraded.Count -gt 0) {
    $summary = ($downgraded | ForEach-Object { "$($_.task_id)=$($_.status)" }) -join "; "
    throw "vsi_startup_state_regression_detected: $summary"
  }
}

$repoRoot = Resolve-RepoRoot
$dashboardUrl = "http://127.0.0.1:$Port"
$bridgeStarted = $false
$bridgeProcessId = $null

if (-not (Test-BridgeHealth -BaseUrl $dashboardUrl)) {
  $bridgeProcess = Start-Bridge -RepoRoot $repoRoot -Port $Port
  $bridgeProcessId = $bridgeProcess.Id
  $bridgeStarted = $true
  if (-not (Wait-Bridge -BaseUrl $dashboardUrl)) {
    throw "vsi_startup_bridge_unhealthy: $dashboardUrl"
  }
}

$codeInsiders = Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code Insiders\bin\code-insiders.cmd"
if (-not (Test-Path -LiteralPath $codeInsiders)) {
  throw "vsi_startup_vscode_insiders_missing: $codeInsiders"
}

$settingsPath = Join-Path $env:APPDATA "Code - Insiders\User\settings.json"
$settingsDir = Split-Path -Parent $settingsPath
New-Item -ItemType Directory -Force -Path $settingsDir | Out-Null
$settings = Get-JsonObject -Path $settingsPath
$cataloguePath = Join-Path $repoRoot ".agents\skills"
if (-not (Test-Path -LiteralPath $cataloguePath)) {
  throw "vsi_startup_skill_catalogue_missing: $cataloguePath"
}
$settingChanged = Set-JsonProperty -Object $settings -Name "agileagentcanvas.userCataloguePath" -Value $cataloguePath
if ($settingChanged) {
  $settings | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $settingsPath -Encoding UTF8
}

$extensionVersion = "NO_ENCONTRADO"
try {
  $extensions = & $codeInsiders --list-extensions --show-versions 2>$null
  $match = @($extensions | Where-Object { $_ -like "msayedshokry.agileagentcanvas@*" } | Select-Object -First 1)
  if ($match.Count -gt 0) {
    $extensionVersion = [string]$match[0]
  }
} catch {
  $extensionVersion = "NO_ENCONTRADO"
}
if ($extensionVersion -eq "NO_ENCONTRADO") {
  throw "vsi_startup_agile_agent_canvas_extension_missing"
}

if (-not $NoOpenVsi) {
  & $codeInsiders --reuse-window $repoRoot | Out-Null
  Start-Sleep -Seconds 2
  Start-Process "vscode-insiders://command/workbench.view.extension.agileagentcanvas-explorer" | Out-Null
  Start-Sleep -Milliseconds 800
  Start-Process "vscode-insiders://command/agileagentcanvas.openCanvas" | Out-Null
}

$dashboard = Invoke-RestMethod -Method Get -Uri "$dashboardUrl/api/dashboard" -TimeoutSec 8
Assert-NoCompletedTaskDowngrade -Tasks @($dashboard.agent_task_queue) -MinimumCompletedTaskNumber $MinimumCompletedTaskNumber

$summary = $dashboard.summary
if ([int]$summary.queued_agent_tasks -ne 0) {
  throw "vsi_startup_queue_not_empty: queued_agent_tasks=$($summary.queued_agent_tasks)"
}
if ([int]$summary.executed_agent_tasks -lt $MinimumCompletedTaskNumber) {
  throw "vsi_startup_executed_task_count_low: executed_agent_tasks=$($summary.executed_agent_tasks)"
}

$canvasWindow = @(Get-Process -ErrorAction SilentlyContinue | Where-Object {
  $_.MainWindowTitle -match "Agile Agent Canvas|cabina-universal-d.*Visual Studio Code - Insiders|Visual Studio Code - Insiders"
} | Select-Object -First 1)

$head = (& git -C $repoRoot rev-parse --short HEAD).Trim()
$branch = (& git -C $repoRoot branch --show-current).Trim()

[pscustomobject]@{
  status = "PASS"
  repo_root = $repoRoot
  branch = $branch
  head = $head
  dashboard_url = $dashboardUrl
  bridge_started = $bridgeStarted
  bridge_process_id = $bridgeProcessId
  vscode_insiders = $codeInsiders
  agile_agent_canvas_extension = $extensionVersion
  user_catalogue_path = $cataloguePath
  user_setting_changed = $settingChanged
  canvas_window_found = ($canvasWindow.Count -gt 0)
  canvas_status = $dashboard.canvas_workbench.status
  active_lane_status = $dashboard.canvas_workbench.active_governed_lane.status
  local_actions_ready = $summary.local_actions_ready
  agent_task_queue_records = $summary.agent_task_queue_records
  executed_agent_tasks = $summary.executed_agent_tasks
  queued_agent_tasks = $summary.queued_agent_tasks
  minimum_completed_task_number = $MinimumCompletedTaskNumber
  no_completed_task_downgrade = $true
  live_executed = $false
  stop_condition = "vsi_startup_state_regression_detected"
} | ConvertTo-Json -Depth 8
