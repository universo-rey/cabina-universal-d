param(
  [Parameter(Mandatory = $true)][string]$EnvironmentUrl,
  [Parameter(Mandatory = $true)][string]$AppId,
  [Parameter(Mandatory = $true)][string]$TenantId,
  [Parameter(Mandatory = $true)][string]$SolutionFolder,
  [Parameter(Mandatory = $true)][string]$SolutionName,
  [Parameter(Mandatory = $true)][ValidateSet("Unmanaged", "Managed")][string]$SolutionType,
  [string]$OutputFolder = "artifacts/power-platform",
  [string]$CheckerGeo = "UnitedStates",
  [string]$ClientSecretEnvName = "POWERPLATFORM_CLIENT_SECRET",
  [string]$AuthProfileName = "sgin-dev-staging"
)

$ErrorActionPreference = "Stop"

function Test-NonProductionEnvironment {
  param([string]$Url)
  if ([string]::IsNullOrWhiteSpace($Url)) { throw "EnvironmentUrl is required." }
  if ($Url -match "(?i)(prod|production|live)") {
    throw "EnvironmentUrl looks like production/live. Stop: check only against DEV/STAGING target."
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
if (-not (Test-Path -LiteralPath $SolutionFolder)) { throw "SolutionFolder does not exist: $SolutionFolder" }

$clientSecret = Get-RequiredSecret -Name $ClientSecretEnvName
$zipPath = Join-Path $OutputFolder "$SolutionName-packed.zip"
$checkerOutput = Join-Path $OutputFolder "checker"
New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
New-Item -ItemType Directory -Force -Path $checkerOutput | Out-Null

Write-Output "Authenticating to DEV/STAGING target. Secret value will not be printed."
pac auth create --name $AuthProfileName --applicationId $AppId --clientSecret $clientSecret --tenant $TenantId --environment $EnvironmentUrl
pac org who --environment $EnvironmentUrl

Write-Output "Packing solution source from $SolutionFolder to $zipPath."
pac solution pack --zipfile $zipPath --folder $SolutionFolder --packagetype $SolutionType

Write-Output "Running solution checker. Critical/High findings must be reviewed before import."
pac solution check --environment $EnvironmentUrl --path $zipPath --outputDirectory $checkerOutput --geo $CheckerGeo

Write-Output "PP_PACK_CHECK_COMPLETE zip=$zipPath checker_output=$checkerOutput"
