param(
  [Parameter(Mandatory = $true)][string]$EnvironmentUrl,
  [Parameter(Mandatory = $true)][string]$AppId,
  [Parameter(Mandatory = $true)][string]$TenantId,
  [string]$ClientSecretEnvName = "POWERPLATFORM_CLIENT_SECRET",
  [string]$AuthProfileName = "sgin-dev-staging"
)

$ErrorActionPreference = "Stop"

function Test-NonProductionEnvironment {
  param([string]$Url)
  if ([string]::IsNullOrWhiteSpace($Url)) {
    throw "EnvironmentUrl is required."
  }
  if ($Url -match "(?i)(prod|production|live)") {
    throw "EnvironmentUrl looks like production/live. Stop: provide DEV/STAGING target only."
  }
}

function Get-RequiredSecret {
  param([string]$Name)
  $value = [Environment]::GetEnvironmentVariable($Name, "Process")
  if ([string]::IsNullOrWhiteSpace($value)) {
    $value = [Environment]::GetEnvironmentVariable($Name, "User")
  }
  if ([string]::IsNullOrWhiteSpace($value)) {
    throw "Missing required environment variable: $Name"
  }
  return $value
}

if (-not (Get-Command pac -ErrorAction SilentlyContinue)) {
  throw "PAC CLI is not available in PATH."
}

Test-NonProductionEnvironment -Url $EnvironmentUrl
$clientSecret = Get-RequiredSecret -Name $ClientSecretEnvName

Write-Output "Creating/refreshing PAC auth profile for DEV/STAGING target. Secret value will not be printed."
pac auth create --name $AuthProfileName --applicationId $AppId --clientSecret $clientSecret --tenant $TenantId --environment $EnvironmentUrl

Write-Output "Running PAC who-am-i against DEV/STAGING target."
pac org who --environment $EnvironmentUrl

Write-Output "PP_WHOAMI_COMPLETE"
