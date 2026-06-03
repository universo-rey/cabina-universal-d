param(
  [Parameter(Mandatory = $true)][string]$EnvironmentUrl,
  [Parameter(Mandatory = $true)][string]$AppId,
  [Parameter(Mandatory = $true)][string]$TenantId,
  [Parameter(Mandatory = $true)][string]$SolutionFile,
  [switch]$ImportToDev,
  [switch]$PublishAfterImport,
  [switch]$ConfirmNonProduction,
  [string]$DeploymentSettingsFile,
  [string]$ClientSecretEnvName = "POWERPLATFORM_CLIENT_SECRET",
  [string]$AuthProfileName = "sgin-dev-staging"
)

$ErrorActionPreference = "Stop"

function Test-NonProductionEnvironment {
  param([string]$Url)
  if ([string]::IsNullOrWhiteSpace($Url)) { throw "EnvironmentUrl is required." }
  if ($Url -match "(?i)(prod|production|live)") {
    throw "EnvironmentUrl looks like production/live. Stop: import/publish is DEV/STAGING only."
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
if (-not (Test-Path -LiteralPath $SolutionFile)) { throw "SolutionFile does not exist: $SolutionFile" }

if (-not $ImportToDev) {
  Write-Output "DRY_RUN_ONLY: ImportToDev was not provided. No import or publish executed."
  exit 0
}
if (-not $ConfirmNonProduction) {
  throw "ConfirmNonProduction is required before DEV/STAGING import."
}

$clientSecret = Get-RequiredSecret -Name $ClientSecretEnvName

Write-Output "Authenticating to DEV/STAGING target. Secret value will not be printed."
pac auth create --name $AuthProfileName --applicationId $AppId --clientSecret $clientSecret --tenant $TenantId --environment $EnvironmentUrl
pac org who --environment $EnvironmentUrl

$importArgs = @("solution", "import", "--environment", $EnvironmentUrl, "--path", $SolutionFile)
if (-not [string]::IsNullOrWhiteSpace($DeploymentSettingsFile)) {
  if (-not (Test-Path -LiteralPath $DeploymentSettingsFile)) { throw "DeploymentSettingsFile does not exist: $DeploymentSettingsFile" }
  $importArgs += @("--settings-file", $DeploymentSettingsFile)
}

Write-Output "Importing solution into DEV/STAGING target."
& pac @importArgs

if ($PublishAfterImport) {
  Write-Output "Publishing DEV/STAGING customizations after import."
  pac solution publish --environment $EnvironmentUrl
} else {
  Write-Output "PublishAfterImport not provided. Publish skipped."
}

Write-Output "PP_IMPORT_DEV_COMPLETE publish_after_import=$($PublishAfterImport.IsPresent)"
