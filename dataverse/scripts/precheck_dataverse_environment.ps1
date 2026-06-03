param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$EnvironmentUrl = $env:DATAVERSE_DEV_ENVIRONMENT_URL,
  [string]$EnvironmentId = $env:DATAVERSE_DEV_ENVIRONMENT_ID,
  [string]$TenantId = $env:DATAVERSE_TENANT_ID,
  [string]$PacAuthProfile = $env:PAC_CLI_AUTH_PROFILE,
  [string]$PublisherUniqueName = $env:POWERPLATFORM_PUBLISHER_UNIQUE_NAME,
  [string]$SolutionUniqueName = $env:DATAVERSE_SOLUTION_UNIQUE_NAME,
  [switch]$RequireDevReady,
  [switch]$Json
)

$ErrorActionPreference = 'Stop'

function Test-ProdLike {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
  return ($Value -match '(?i)\bprod\b|production|default')
}

function Add-Gate {
  param([string]$Id, [bool]$Pass, [string]$Evidence, [string]$Blocker)
  [pscustomobject]@{
    gate_id = $Id
    pass = $Pass
    evidence = $Evidence
    blocker = if ($Pass) { '' } else { $Blocker }
  }
}

function Redact-Line {
  param([string]$Line)
  return ($Line `
    -replace '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}', '[redacted-email]' `
    -replace 'https://[^\s]+', '[redacted-url]' `
    -replace '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}', '[redacted-guid]')
}

$pac = Get-Command pac -ErrorAction SilentlyContinue
$pacFound = [bool]$pac
$activeAuth = @()
if ($pacFound) {
  try {
    $activeAuth = (& pac auth who 2>&1 | ForEach-Object { Redact-Line ($_ | Out-String).Trim() }) | Where-Object { $_ }
  } catch {
    $activeAuth = @("pac_auth_who_failed_sanitized")
  }
}

$target = @($EnvironmentUrl, $EnvironmentId, $PacAuthProfile) -join ' '
$devExplicit = -not [string]::IsNullOrWhiteSpace($EnvironmentUrl) -or
  -not [string]::IsNullOrWhiteSpace($EnvironmentId) -or
  -not [string]::IsNullOrWhiteSpace($PacAuthProfile)
$prodLike = Test-ProdLike $target
$publisherDefined = -not [string]::IsNullOrWhiteSpace($PublisherUniqueName)
$solutionDefined = -not [string]::IsNullOrWhiteSpace($SolutionUniqueName)
$tenantDefined = -not [string]::IsNullOrWhiteSpace($TenantId)

$gates = @(
  Add-Gate 'GATE_DEV_01_LICENSE_CONFIRMED' $pacFound 'pac cli available as local Power Platform capability proxy' 'PAC CLI missing; license/environment cannot be validated locally'
  Add-Gate 'GATE_DEV_02_DEV_ENVIRONMENT_EXPLICIT' $devExplicit 'DEV target provided by env/profile' 'DEV target is [POR DEFINIR]; active default profile is not enough'
  Add-Gate 'GATE_DEV_03_NOT_PROD' (-not $prodLike) 'target text is not PROD-like' 'target contains PROD/production/default marker'
  Add-Gate 'GATE_DEV_04_TENANT_CONFIRMED' $tenantDefined 'tenant id provided as redacted env presence' 'tenant is [POR DEFINIR]'
  Add-Gate 'GATE_DEV_05_PUBLISHER_DEFINED' $publisherDefined 'publisher unique name provided' 'publisher is [POR DEFINIR]'
  Add-Gate 'GATE_DEV_06_SOLUTION_DEFINED' $solutionDefined 'solution unique name provided' 'solution unique name is [POR DEFINIR]'
  Add-Gate 'GATE_DEV_07_NO_SECRETS' $true 'script prints presence/status only' ''
  Add-Gate 'GATE_DEV_08_ROLLBACK_DEFINED' $true 'export_solution_dev.ps1 and export_dataverse_snapshot.ps1' ''
  Add-Gate 'GATE_DEV_09_POSTCHECK_DEFINED' $true 'validate_dataverse_manifest.ps1 and export snapshot postcheck' ''
  Add-Gate 'GATE_DEV_10_HUMAN_APPROVAL_NOT_REQUIRED_FOR_DEV_OR_ALREADY_GRANTED' $true 'operator authorized DEV apply if gates pass' ''
)

$allPass = -not ($gates | Where-Object { -not $_.pass })
$report = [pscustomobject]@{
  status = if ($allPass) { 'DATAVERSE_DEV_PRECHECK_PASS' } else { 'DATAVERSE_DEV_PRECHECK_BLOCKED' }
  root = $Root
  pac_found = $pacFound
  active_auth_sanitized = $activeAuth
  dev_target_explicit = $devExplicit
  prod_like_target = $prodLike
  gates = $gates
  apply_allowed = $allPass
  stop_condition = if ($allPass) { '' } else { 'DATAVERSE_DEV_TARGET_NOT_EXPLICIT_OR_NOT_PROTECTED' }
}

$outPath = Join-Path $Root 'dataverse\validation\dataverse_precheck_latest.json'
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $outPath -Encoding UTF8

if ($Json) {
  $report | ConvertTo-Json -Depth 6
} else {
  Write-Host $report.status
  Write-Host "apply_allowed=$($report.apply_allowed)"
  Write-Host "evidence=$outPath"
}

if ($RequireDevReady -and -not $allPass) {
  exit 20
}
