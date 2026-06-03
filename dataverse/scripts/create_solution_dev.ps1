param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$SolutionUniqueName = $env:DATAVERSE_SOLUTION_UNIQUE_NAME,
  [string]$PublisherUniqueName = $env:POWERPLATFORM_PUBLISHER_UNIQUE_NAME,
  [string]$PublisherPrefix = 'sdu',
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'precheck_dataverse_environment.ps1') -Root $Root -RequireDevReady:$Apply | Out-Host

if (-not $Apply) {
  Write-Host 'DRY_RUN_CREATE_SOLUTION_DEV_READY'
  Write-Host 'No Dataverse write executed. Pass -Apply only after DEV gates pass.'
  exit 0
}

if ([string]::IsNullOrWhiteSpace($SolutionUniqueName) -or [string]::IsNullOrWhiteSpace($PublisherUniqueName)) {
  throw 'SOLUTION_OR_PUBLISHER_MISSING'
}

Write-Host 'CREATE_SOLUTION_DEV_APPLY_REQUESTED'
Write-Host 'Use Power Apps maker portal or PAC project init/import according to solution manifest. No blind PROD/default writes allowed.'
exit 0
