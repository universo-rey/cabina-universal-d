param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$SolutionName = $env:DATAVERSE_SOLUTION_UNIQUE_NAME,
  [string]$OutDir = (Join-Path $Root 'dataverse/validation/exports'),
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'precheck_dataverse_environment.ps1') -Root $Root -RequireDevReady:$Apply | Out-Host

if (-not $Apply) {
  Write-Host 'DRY_RUN_EXPORT_SOLUTION_DEV_READY'
  exit 0
}
if ([string]::IsNullOrWhiteSpace($SolutionName)) { throw 'SOLUTION_NAME_MISSING' }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$zipPath = Join-Path $OutDir "$SolutionName.zip"
pac solution export --name $SolutionName --path $zipPath --managed false --async false
Write-Host "EXPORT_SOLUTION_DEV_COMPLETED path=$zipPath"
