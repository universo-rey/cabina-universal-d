param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$OutPath = (Join-Path $Root 'dataverse/validation/dataverse_snapshot_latest.json'),
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'precheck_dataverse_environment.ps1') -Root $Root -RequireDevReady:$Apply | Out-Host

$snapshot = [pscustomobject]@{
  status = if ($Apply) { 'SNAPSHOT_REQUESTED_DEV' } else { 'DRY_RUN_SNAPSHOT_READY' }
  generated_at = '2026-06-03'
  tables = Get-ChildItem -LiteralPath (Join-Path $Root 'dataverse/schema') -Filter '*.yml' | ForEach-Object { $_.BaseName }
  data_policy = 'metadata_only_no_sensitive_payload'
}
$snapshot | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutPath -Encoding UTF8
Write-Host "SNAPSHOT_ARTIFACT_WRITTEN path=$OutPath"
