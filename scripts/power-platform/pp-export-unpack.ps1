param(
  [Parameter(Mandatory = $true)][string]$EnvironmentUrl,
  [Parameter(Mandatory = $true)][string]$AppId,
  [Parameter(Mandatory = $true)][string]$TenantId,
  [Parameter(Mandatory = $true)][string]$SolutionName,
  [Parameter(Mandatory = $true)][ValidateSet("Unmanaged", "Managed")][string]$SolutionType,
  [Parameter(Mandatory = $true)][string]$TargetFolder,
  [string]$OutputFolder = "artifacts/power-platform",
  [string]$ClientSecretEnvName = "POWERPLATFORM_CLIENT_SECRET",
  [string]$AuthProfileName = "sgin-dev-staging"
)

$ErrorActionPreference = "Stop"

function Test-NonProductionEnvironment {
  param([string]$Url)
  if ([string]::IsNullOrWhiteSpace($Url)) { throw "EnvironmentUrl is required." }
  if ($Url -match "(?i)(prod|production|live)") {
    throw "EnvironmentUrl looks like production/live. Stop: export only from DEV/STAGING target."
  }
}

function Get-RequiredSecret {
  param([string]$Name)
  $value = [Environment]::GetEnvironmentVariable($Name, "Process")
  if ([string]::IsNullOrWhiteSpace($value)) { $value = [Environment]::GetEnvironmentVariable($Name, "User") }
  if ([string]::IsNullOrWhiteSpace($value)) { throw "Missing required environment variable: $Name" }
  return $value
}

if (-not (Get-Command pac -ErrorAction SilentlyContinue)) { throw "PAC CLI is not available in PATH." }
Test-NonProductionEnvironment -Url $EnvironmentUrl
if ([string]::IsNullOrWhiteSpace($SolutionName)) { throw "SolutionName is required." }

$clientSecret = Get-RequiredSecret -Name $ClientSecretEnvName
$zipPath = Join-Path $OutputFolder "$SolutionName-$($SolutionType.ToLowerInvariant()).zip"
New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
New-Item -ItemType Directory -Force -Path $TargetFolder | Out-Null

Write-Output "Authenticating to DEV/STAGING target. Secret value will not be printed."
pac auth create --name $AuthProfileName --applicationId $AppId --clientSecret $clientSecret --tenant $TenantId --environment $EnvironmentUrl
pac org who --environment $EnvironmentUrl

$exportArgs = @("solution", "export", "--environment", $EnvironmentUrl, "--name", $SolutionName, "--path", $zipPath, "--overwrite")
if ($SolutionType -eq "Managed") { $exportArgs += "--managed" }

Write-Output "Exporting solution to $zipPath."
& pac @exportArgs

Write-Output "Unpacking solution to $TargetFolder."
pac solution unpack --zipfile $zipPath --folder $TargetFolder --packagetype $SolutionType

Write-Output "PP_EXPORT_UNPACK_COMPLETE zip=$zipPath target_folder=$TargetFolder"
