param(
  [Parameter(Mandatory = $true)][string]$EnvironmentUrl,
  [Parameter(Mandatory = $true)][string]$AppId,
  [Parameter(Mandatory = $true)][string]$TenantId,
  [string]$ClientSecretEnvName = "POWERPLATFORM_CLIENT_SECRET",
  [switch]$RunWhoAmI
)

$ErrorActionPreference = "Stop"

function Test-NonProductionEnvironment {
  param([string]$Url)
  if ([string]::IsNullOrWhiteSpace($Url)) { throw "EnvironmentUrl is required." }
  if ($Url -notmatch "^https://") { throw "EnvironmentUrl must be an https URL." }
  if ($Url -match "(?i)(prod|production|live)") {
    throw "EnvironmentUrl looks like production/live. Stop: provide DEV/STAGING target only."
  }
}

function Test-RequiredSecretVariable {
  param([string]$Name)
  $value = [Environment]::GetEnvironmentVariable($Name, "Process")
  if ([string]::IsNullOrWhiteSpace($value)) { $value = [Environment]::GetEnvironmentVariable($Name, "User") }
  if ([string]::IsNullOrWhiteSpace($value)) { throw "Missing required environment variable: $Name" }
}

if (-not (Get-Command pac -ErrorAction SilentlyContinue)) {
  throw "PAC CLI is not available in PATH."
}

Test-NonProductionEnvironment -Url $EnvironmentUrl
Test-RequiredSecretVariable -Name $ClientSecretEnvName

if ([string]::IsNullOrWhiteSpace($AppId)) { throw "AppId is required." }
if ([string]::IsNullOrWhiteSpace($TenantId)) { throw "TenantId is required." }

Write-Output "PP_VALIDATE_ENV_PRECHECK_PASS target=$EnvironmentUrl"

if ($RunWhoAmI) {
  & (Join-Path $PSScriptRoot "pp-whoami.ps1") -EnvironmentUrl $EnvironmentUrl -AppId $AppId -TenantId $TenantId -ClientSecretEnvName $ClientSecretEnvName
}
