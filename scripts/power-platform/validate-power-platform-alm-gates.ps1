Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..")
$workflowPaths = @(
  ".github/workflows/power-platform-alm-full-dev.yml",
  ".github/workflows/power-platform-pack-import-dev.yml"
)

$checks = [System.Collections.Generic.List[object]]::new()

function Add-Check {
  param(
    [Parameter(Mandatory=$true)][string]$Id,
    [Parameter(Mandatory=$true)][bool]$Pass,
    [Parameter(Mandatory=$true)][string]$Detail
  )
  $checks.Add([pscustomobject]@{
    id = $Id
    pass = $Pass
    detail = $Detail
  }) | Out-Null
}

function Get-WorkflowText {
  param([Parameter(Mandatory=$true)][string]$RelativePath)
  $path = Join-Path $repoRoot $RelativePath
  if (-not (Test-Path -LiteralPath $path)) {
    Add-Check -Id "workflow_exists:$RelativePath" -Pass $false -Detail "Workflow not found"
    return $null
  }
  Add-Check -Id "workflow_exists:$RelativePath" -Pass $true -Detail "Workflow exists"
  return Get-Content -LiteralPath $path -Raw
}

function Test-StageInput {
  param([Parameter(Mandatory=$true)][string]$Text)
  return $Text -match "(?ms)environment_stage:\s*\r?\n\s+description:" -and
    $Text -match "(?ms)environment_stage:[\s\S]*?type:\s*choice" -and
    $Text -match "(?ms)environment_stage:[\s\S]*?options:\s*\r?\n\s+- DEV\r?\n\s+- STAGING"
}

function Test-MutableGate {
  param(
    [Parameter(Mandatory=$true)][string]$Text,
    [Parameter(Mandatory=$true)][string]$ActionName
  )
  $escapedAction = [regex]::Escape($ActionName)
  $match = [regex]::Match($Text, "(?ms)- name: .*$escapedAction.*?(?=\r?\n\s+- name:|\z)")
  if (-not $match.Success) { return $false }
  $section = $match.Value
  return $section -match "if:\s*\$\{\{[^\r\n]*inputs\.confirm_non_production == true" -and
    $section -match "inputs\.environment_stage == 'DEV'" -and
    $section -match "inputs\.environment_stage == 'STAGING'"
}

function Test-NoSecretValues {
  param([Parameter(Mandatory=$true)][string]$Text)
  $literalSecretAssignments = @(
    '(?im)^\s*(client-secret|password|token):\s*["'']?[A-Za-z0-9_\-+/=]{16,}["'']?\s*$',
    '(?im)^\s*\$[A-Za-z0-9_]*(client_secret|password|token)[A-Za-z0-9_]*\s*=\s*["''][^\$%\{][^"'']{15,}["'']'
  )
  foreach ($pattern in $literalSecretAssignments) {
    if ($Text -match $pattern) { return $false }
  }
  return $true
}

$workflowTexts = @{}
foreach ($workflow in $workflowPaths) {
  $text = Get-WorkflowText -RelativePath $workflow
  if ($null -eq $text) { continue }
  $workflowTexts[$workflow] = $text

  Add-Check -Id "environment_stage_input:$workflow" -Pass (Test-StageInput -Text $text) -Detail "environment_stage must be a DEV/STAGING choice input"
  Add-Check -Id "allowlist_variable:$workflow" -Pass ($text -match "POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS") -Detail "Workflow must read the explicit DEV/STAGING environment URL allowlist"
  Add-Check -Id "normalizes_url:$workflow" -Pass ($text -match "Normalize-EnvironmentUrl" -and $text -match "GetLeftPart\(\[System\.UriPartial\]::Authority\)") -Detail "Workflow must normalize target and allowlist URLs"
  Add-Check -Id "requires_https:$workflow" -Pass ($text -match '\$uri\.Scheme -ne ''https''') -Detail "Workflow must require https URLs"
  Add-Check -Id "allowlist_required_for_mutation:$workflow" -Pass ($text -match "POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS must list approved DEV/STAGING URLs before import or publish") -Detail "Import/publish must fail when allowlist is blank"
  Add-Check -Id "target_must_match_allowlist:$workflow" -Pass ($text -match "environment_url is not in POWERPLATFORM_DEV_STAGING_ENVIRONMENT_URLS") -Detail "Target URL must match the explicit allowlist"
  Add-Check -Id "not_substring_only_gate:$workflow" -Pass ($text -notmatch '(?ms)if\s*\(\s*\$url\s+-match\s+[''"]\(\?i\)\(prod\|production\|live\)[''"]\s*\)\s*\{\s*throw') -Detail "Production-like URL words can warn, but cannot be the only mutable gate"
  Add-Check -Id "import_stage_confirmation_gate:$workflow" -Pass (Test-MutableGate -Text $text -ActionName "Import solution") -Detail "import-solution step must require confirmation and DEV/STAGING stage"
  Add-Check -Id "publish_stage_confirmation_gate:$workflow" -Pass (Test-MutableGate -Text $text -ActionName "Publish DEV/STAGING") -Detail "publish-solution step must require confirmation and DEV/STAGING stage"
  Add-Check -Id "no_hardcoded_secret_values:$workflow" -Pass (Test-NoSecretValues -Text $text) -Detail "Workflow must not hardcode secret values"
  Add-Check -Id "no_production_url_hardcoded:$workflow" -Pass ($text -notmatch "https://[^\s'\""]*(prod|production|live)[^\s'\""]*") -Detail "Workflow must not hardcode production/live URLs"
  Add-Check -Id "no_environment_delete_reset_restore:$workflow" -Pass ($text -notmatch "(?i)(delete-environment|reset-environment|restore-environment|pac\s+(admin|env)\s+(delete|reset|restore))") -Detail "Workflow must not delete, reset or restore environments"
}

$scriptTexts = Get-ChildItem -LiteralPath (Join-Path $repoRoot "scripts/power-platform") -Filter "*.ps1" | ForEach-Object {
  Get-Content -LiteralPath $_.FullName -Raw
}
$joinedScripts = $scriptTexts -join "`n"
Add-Check -Id "scripts_no_hardcoded_secret_values" -Pass (Test-NoSecretValues -Text $joinedScripts) -Detail "Power Platform scripts must not hardcode secret values"
Add-Check -Id "scripts_no_production_url_hardcoded" -Pass ($joinedScripts -notmatch "https://[^\s'\""]*(prod|production|live)[^\s'\""]*") -Detail "Power Platform scripts must not hardcode production/live URLs"
Add-Check -Id "scripts_no_environment_delete_reset_restore" -Pass ($joinedScripts -notmatch "(?i)(pac\s+(admin|env)\s+(delete|reset|restore))") -Detail "Power Platform scripts must not delete, reset or restore environments"

$failed = @($checks | Where-Object { -not $_.pass })
$result = [pscustomobject]@{
  status = if ($failed.Count -eq 0) { "PASS" } else { "FAIL" }
  checked_at = (Get-Date).ToString("o")
  workflows = $workflowPaths
  check_count = $checks.Count
  failed_count = $failed.Count
  checks = $checks
}

$result | ConvertTo-Json -Depth 5
if ($failed.Count -gt 0) { exit 1 }
