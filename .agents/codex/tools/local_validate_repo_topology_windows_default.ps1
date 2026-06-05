param(
  [string]$Root = ".agents\codex",
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d",
  [string]$GitHubRoot = "C:\Users\enzo1\Documents\GitHub"
)

$ErrorActionPreference = "Stop"

function Normalize-Remote {
  param([string]$Remote)
  if ([string]::IsNullOrWhiteSpace($Remote)) { return "" }
  return ($Remote.Trim() -replace "\.git$", "")
}

function Resolve-LocalPath {
  param([string]$Path)
  if ([string]::IsNullOrWhiteSpace($Path)) { return $Path }
  if ($Path -eq "NO_APLICA_OUT_OF_BASE") { return $Path }
  return ($Path -replace "/", "\")
}

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$GitHubRoot = (Resolve-Path -LiteralPath $GitHubRoot).Path
$matrixPath = Join-Path $Root "matrices\CODEX_LOCAL_REPO_TOPOLOGY_MATRIX_20260605.csv"
$runtimePath = Join-Path $Root "matrices\REPO_RUNTIME_ALIGNMENT_MATRIX.csv"
$queuePath = Join-Path $Root "matrices\CODEX_ENVIRONMENT_CREATION_QUEUE_20260602.csv"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path -LiteralPath $matrixPath)) {
  throw "Missing topology matrix: $matrixPath"
}

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
if (-not (Test-Path -LiteralPath $codexHome -PathType Container)) {
  $errors.Add("Effective CODEX_HOME missing: $codexHome")
}

$globalStateInRepo = @(
  ".codex\.codex-global-state.json",
  ".codex\.sandbox-bin",
  ".codex\.sandbox-secrets"
)
foreach ($relative in $globalStateInRepo) {
  $candidate = Join-Path $RepoRoot $relative
  if (Test-Path -LiteralPath $candidate) {
    $errors.Add("Global Codex runtime state found in repo scope: $relative")
  }
}

$nestedGit = @(Get-ChildItem -LiteralPath $RepoRoot -Force -Recurse -ErrorAction SilentlyContinue | Where-Object {
  $_.Name -eq ".git" -and $_.FullName -ne (Join-Path $RepoRoot ".git")
})
foreach ($entry in $nestedGit) {
  $errors.Add("Nested Git metadata found inside cabina repo: $($entry.FullName)")
}

$matrixRows = @(Import-Csv -LiteralPath $matrixPath)
$runtimeRows = @(Import-Csv -LiteralPath $runtimePath)
$queueRows = @(Import-Csv -LiteralPath $queuePath)

foreach ($row in $matrixRows) {
  $expectedPath = Resolve-LocalPath -Path $row.expected_local_path
  if (-not $expectedPath.StartsWith($GitHubRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    $errors.Add("Repo '$($row.repo_id)' expected path is outside GitHub root: $($row.expected_local_path)")
    continue
  }
  if (-not (Test-Path -LiteralPath $expectedPath -PathType Container)) {
    $errors.Add("Repo '$($row.repo_id)' missing expected sibling folder: $expectedPath")
    continue
  }
  if (-not (Test-Path -LiteralPath (Join-Path $expectedPath ".git"))) {
    $errors.Add("Repo '$($row.repo_id)' missing Git metadata at sibling path: $expectedPath")
    continue
  }

  $actualRemote = & git -C $expectedPath remote get-url origin 2>$null
  if ((Normalize-Remote $actualRemote) -ne (Normalize-Remote $row.remote_url)) {
    $errors.Add("Repo '$($row.repo_id)' remote mismatch: expected '$($row.remote_url)' actual '$actualRemote'")
  }

  if ($row.repo_id -ne "D_CABINA_UNIVERSAL_ROOT") {
    $status = @(& git -C $expectedPath status --short)
    if ($status.Count -gt 0) {
      $errors.Add("Sibling repo '$($row.repo_id)' is dirty: $($status -join ' ')")
    }
  }
}

foreach ($row in $runtimeRows) {
  if ($row.local_path -eq "NO_APLICA_OUT_OF_BASE") { continue }
  $path = Resolve-LocalPath -Path $row.local_path
  if (-not $path.StartsWith($GitHubRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    $errors.Add("Runtime alignment row '$($row.repo_id)' is not a GitHub sibling path: $($row.local_path)")
  }
}

foreach ($row in $queueRows) {
  if ($row.local_path -eq "NO_APLICA_OUT_OF_BASE") { continue }
  $path = Resolve-LocalPath -Path $row.local_path
  if (-not $path.StartsWith($GitHubRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    $errors.Add("Codex environment queue row '$($row.repo_id)' is not a GitHub sibling path: $($row.local_path)")
  }
}

$result = [pscustomobject]@{
  status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
  validator = "local_validate_repo_topology_windows_default"
  repo_root = $RepoRoot
  github_root = $GitHubRoot
  effective_codex_home = $codexHome
  topology_rows = $matrixRows.Count
  warning_count = $warnings.Count
  warnings = @($warnings.ToArray())
  error_count = $errors.Count
  errors = @($errors.ToArray())
}

$result | ConvertTo-Json -Depth 6

if ($errors.Count -gt 0) {
  exit 1
}
