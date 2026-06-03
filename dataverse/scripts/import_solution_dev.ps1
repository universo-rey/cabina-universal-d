param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$SolutionZip,
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'precheck_dataverse_environment.ps1') -Root $Root -RequireDevReady:$Apply | Out-Host

if (-not $Apply) {
  Write-Host 'DRY_RUN_IMPORT_SOLUTION_DEV_READY'
  exit 0
}
if ([string]::IsNullOrWhiteSpace($SolutionZip) -or -not (Test-Path -LiteralPath $SolutionZip)) {
  throw 'SOLUTION_ZIP_MISSING'
}

pac solution import --path $SolutionZip --async false
Write-Host 'IMPORT_SOLUTION_DEV_COMPLETED'
