param(
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d",
  [string]$AllowlistPath = ""
)

$ErrorActionPreference = "Stop"

function Convert-ToRepoRelativePath {
  param([string]$Path)
  return ($Path -replace "\\", "/")
}

function Test-AllowedDReference {
  param(
    [string]$RelativePath,
    [string]$Line,
    [object[]]$Allowlist
  )

  foreach ($row in $Allowlist) {
    if ($row.status -ne "ACTIVE_ALLOWED") {
      continue
    }

    if (
      [regex]::IsMatch($RelativePath, $row.path_regex) -and
      [regex]::IsMatch($Line, $row.context_regex)
    ) {
      return $true
    }
  }

  return $false
}

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

if (-not $AllowlistPath) {
  $AllowlistPath = Join-Path $RepoRoot ".agents\codex\matrices\C_ROOT_LEGACY_D_REFERENCE_ALLOWLIST_20260605.csv"
}

if (-not (Test-Path -LiteralPath $AllowlistPath)) {
  throw "missing_allowlist: $AllowlistPath"
}

$allowlist = @(Import-Csv -LiteralPath $AllowlistPath)
if ($allowlist.Count -eq 0) {
  throw "empty_allowlist: $AllowlistPath"
}

$tracked = @(& git -C $RepoRoot ls-files)
$untracked = @(& git -C $RepoRoot ls-files --others --exclude-standard)
$files = @($tracked + $untracked | Where-Object { $_ } | Sort-Object -Unique)

$violations = New-Object System.Collections.Generic.List[object]
$allowedMatches = New-Object System.Collections.Generic.List[object]

foreach ($file in $files) {
  $fullPath = Join-Path $RepoRoot $file
  if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
    continue
  }

  try {
    [string[]]$lines = @(Get-Content -LiteralPath $fullPath -ErrorAction Stop)
  } catch {
    continue
  }

  $relative = Convert-ToRepoRelativePath -Path $file
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = [string]$lines[$i]
    if (-not ($line.Contains("D:\") -or $line.Contains("D:/") -or $line.Contains("D:\\"))) {
      continue
    }

    if (Test-AllowedDReference -RelativePath $relative -Line $line -Allowlist $allowlist) {
      $allowedMatches.Add([pscustomobject]@{
        path = $relative
        line = $i + 1
      }) | Out-Null
      continue
    }

    $violations.Add([pscustomobject]@{
      path = $relative
      line = $i + 1
      issue = "unallowlisted_d_reference"
      text = $line.Trim()
    }) | Out-Null
  }
}

$toolFiles = Get-ChildItem -LiteralPath (Join-Path $RepoRoot ".agents\codex\tools") -Filter "*.ps1" -File
foreach ($toolFile in $toolFiles) {
  $text = Get-Content -LiteralPath $toolFile.FullName -Raw
  $relative = Convert-ToRepoRelativePath -Path ($toolFile.FullName.Substring($RepoRoot.Length).TrimStart("\", "/"))
  if ($text -match '\[string\]\$(RepoRoot|Root|repoRoot)\s*=\s*"D:') {
    $violations.Add([pscustomobject]@{
      path = $relative
      line = 0
      issue = "default_repo_root_d"
      text = "PowerShell validator/tool defaults to D root"
    }) | Out-Null
  }
}

$toolIndexPath = Join-Path $RepoRoot ".agents\codex\tools\TOOL_INDEX.csv"
if (Test-Path -LiteralPath $toolIndexPath) {
  foreach ($row in @(Import-Csv -LiteralPath $toolIndexPath)) {
    if ($row.path_or_command -match '^\s*D:(\\|/)') {
      $violations.Add([pscustomobject]@{
        path = ".agents/codex/tools/TOOL_INDEX.csv"
        line = 0
        issue = "tool_index_operational_d_path"
        text = "$($row.tool_id) -> $($row.path_or_command)"
      }) | Out-Null
    }
  }
}

$status = if ($violations.Count -eq 0) { "PASS" } else { "FAIL" }
$violationItems = @($violations.ToArray())

$result = [pscustomobject]@{
  validator = "local_validate_c_root_reference_reconciliation"
  repo_root = $RepoRoot
  status = $status
  files_scanned = $files.Count
  allowed_legacy_d_references = $allowedMatches.Count
  violations = $violationItems
}

$result | ConvertTo-Json -Depth 6

if ($violations.Count -gt 0) {
  exit 1
}
