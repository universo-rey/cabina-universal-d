param(
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d",
  [string]$MatrixPath = "01_GOVERNANCE_REGISTRY\GITHUB_BASE_WORK_MATRIX.csv",
  [switch]$SkipGithub,
  [switch]$WriteResult
)

$ErrorActionPreference = "Stop"

function Normalize-RemoteName([string]$Remote) {
  if ([string]::IsNullOrWhiteSpace($Remote)) {
    return ""
  }

  $trimmed = $Remote.Trim()
  if ($trimmed -match "^https://github\.com/(.+?)(?:\.git)?$") {
    return $Matches[1]
  }
  if ($trimmed -match "^git@github\.com:(.+?)(?:\.git)?$") {
    return $Matches[1]
  }

  return $trimmed
}

function Invoke-GitLines {
  param(
    [string]$Path,
    [string[]]$GitArgs
  )

  $output = @(& git -C $Path @GitArgs 2>$null)
  if ($LASTEXITCODE -ne 0) {
    return $null
  }
  return $output
}

function Invoke-GhJson([string[]]$Arguments) {
  $output = gh @Arguments 2>&1 | Out-String
  if ($LASTEXITCODE -ne 0) {
    return @{
      ok = $false
      value = $null
      error = $output.Trim()
    }
  }

  return @{
    ok = $true
    value = ($output | ConvertFrom-Json)
    error = $null
  }
}

if (-not (Test-Path -LiteralPath $MatrixPath)) {
  throw "Missing GitHub base work matrix: $MatrixPath"
}

$rows = @(Import-Csv -LiteralPath $MatrixPath)
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$repoResults = New-Object System.Collections.Generic.List[object]

$seenRepoIds = @{}
foreach ($row in $rows) {
  foreach ($field in @("repo_id", "repository_full_name", "local_path", "branch_rule", "pr_rule", "merge_rule", "status")) {
    if ([string]::IsNullOrWhiteSpace($row.$field)) {
      $errors.Add("Matrix row missing ${field}: $($row.repo_id)")
    }
  }

  if ($seenRepoIds.ContainsKey($row.repo_id)) {
    $errors.Add("Duplicate repo_id in GitHub base work matrix: $($row.repo_id)")
  } else {
    $seenRepoIds[$row.repo_id] = $true
  }

  if ($row.branch_rule -ne "codex/*") {
    $errors.Add("Repo branch rule must remain codex/*: $($row.repo_id) -> $($row.branch_rule)")
  }

  if ($row.merge_rule -notmatch "precheck" -or $row.merge_rule -notmatch "HEAD") {
    $errors.Add("Repo merge rule must reference approved precheck and fixed HEAD: $($row.repo_id)")
  }

  $path = $row.local_path
  $exists = Test-Path -LiteralPath $path
  $insideGit = $false
  $branch = $null
  $head = $null
  $origin = $null
  $worktreeState = "missing"
  $dirtyCount = $null
  $githubAccess = $null
  $defaultBranch = $null
  $visibility = $null
  $openPrCount = $null
  $openPrs = @()

  if (-not $exists) {
    $message = "Registered repo path missing: $($row.repo_id) -> $path"
    if ($isGitHubActions -and $row.status -eq "ACTIVE_SIBLING_REPO") {
      $warnings.Add("$message (expected absent in GitHub Actions checkout for sibling repo reference)")
    } else {
      $errors.Add($message)
    }
  } else {
    $insideGitRaw = Invoke-GitLines -Path $path -GitArgs @("rev-parse", "--is-inside-work-tree")
    $insideGit = ($insideGitRaw -and @($insideGitRaw)[0] -eq "true")
    if (-not $insideGit) {
      $errors.Add("Registered repo path is not a git worktree: $($row.repo_id) -> $path")
    } else {
      $branchRaw = Invoke-GitLines -Path $path -GitArgs @("branch", "--show-current")
      $headRaw = Invoke-GitLines -Path $path -GitArgs @("rev-parse", "--short", "HEAD")
      $originRaw = Invoke-GitLines -Path $path -GitArgs @("remote", "get-url", "origin")
      $statusRaw = @(Invoke-GitLines -Path $path -GitArgs @("status", "--short"))

      $branch = if ($branchRaw) { @($branchRaw)[0] } else { "" }
      $head = if ($headRaw) { @($headRaw)[0] } else { "" }
      $origin = if ($originRaw) { @($originRaw)[0] } else { "" }
      $dirtyCount = $statusRaw.Count
      $worktreeState = if ($dirtyCount -eq 0) { "clean" } else { "dirty" }

      $actualRemoteName = Normalize-RemoteName $origin
      if ($actualRemoteName -ne $row.repository_full_name) {
        $errors.Add("Origin remote mismatch: $($row.repo_id) expected $($row.repository_full_name) got $origin")
      }

      if ($dirtyCount -gt 0) {
        $warnings.Add("Repo has local worktree changes: $($row.repo_id) dirty_count=$dirtyCount branch=$branch")
      }
    }
  }

  if (-not $SkipGithub) {
    $repoView = Invoke-GhJson @("repo", "view", $row.repository_full_name, "--json", "nameWithOwner,defaultBranchRef,visibility")
    if (-not $repoView.ok) {
      $errors.Add("GitHub repo view failed: $($row.repo_id) -> $($repoView.error)")
      $githubAccess = $false
    } else {
      $githubAccess = $true
      $defaultBranch = $repoView.value.defaultBranchRef.name
      $visibility = $repoView.value.visibility
      if ($defaultBranch -ne "main") {
        $warnings.Add("GitHub default branch is not main: $($row.repo_id) -> $defaultBranch")
      }
    }

    $prList = Invoke-GhJson @("pr", "list", "--repo", $row.repository_full_name, "--state", "open", "--limit", "20", "--json", "number,title,headRefName,baseRefName,isDraft,mergeStateStatus,updatedAt")
    if (-not $prList.ok) {
      $warnings.Add("GitHub PR list failed: $($row.repo_id) -> $($prList.error)")
    } else {
      $openPrItems = @($prList.value)
      $openPrCount = $openPrItems.Count
      $openPrs = @($openPrItems | ForEach-Object {
        [ordered]@{
          number = $_.number
          head_ref = $_.headRefName
          base_ref = $_.baseRefName
          is_draft = $_.isDraft
          merge_state = $_.mergeStateStatus
          updated_at = $_.updatedAt
        }
      })
      if ($openPrCount -gt 0) {
        $warnings.Add("Repo has open PRs: $($row.repo_id) count=$openPrCount")
      }
    }
  }

  $repoResults.Add([pscustomobject][ordered]@{
    repo_id = $row.repo_id
    repository_full_name = $row.repository_full_name
    local_path = $row.local_path
    exists = $exists
    git_worktree = $insideGit
    branch = $branch
    head = $head
    origin = $origin
    worktree_state = $worktreeState
    dirty_count = $dirtyCount
    github_access = $githubAccess
    default_branch = $defaultBranch
    visibility = $visibility
    open_pr_count = $openPrCount
    open_prs = $openPrs
    matrix_status = $row.status
  })
}

$repoResultArray = @($repoResults.ToArray())
$dirtyRepoCount = @($repoResultArray | Where-Object { $_.dirty_count -gt 0 }).Count
$nestedDirtyRepoCount = @($repoResultArray | Where-Object { $_.repo_id -ne "D_CABINA_UNIVERSAL_ROOT" -and $_.dirty_count -gt 0 }).Count
$githubAccessCount = @($repoResultArray | Where-Object { $_.github_access -eq $true }).Count
$openPrTotal = 0
foreach ($repo in $repoResults) {
  if ($null -ne $repo.open_pr_count -and $repo.open_pr_count -is [int]) {
    $openPrTotal += $repo.open_pr_count
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
$payload = [ordered]@{
  status = $status
  mode = if ($SkipGithub) { "LOCAL_REPO_ALIGNMENT_ONLY" } else { "LOCAL_AND_GITHUB_READONLY_ALIGNMENT" }
  repo_root = $RepoRoot
  matrix_path = $MatrixPath
  repo_count = $rows.Count
  local_git_repo_count = @($repoResultArray | Where-Object { $_.git_worktree -eq $true }).Count
  github_access_count = $githubAccessCount
  dirty_repo_count = $dirtyRepoCount
  nested_dirty_repo_count = $nestedDirtyRepoCount
  open_pr_count = $openPrTotal
  root_base_repo_id = "D_CABINA_UNIVERSAL_ROOT"
  root_base_remote = "universo-rey/cabina-universal-d"
  blocked_surfaces = @(
    "openai_api_live",
    "microsoft_live",
    "production",
    "permissions",
    "secrets",
    "force_push",
    "merge_without_approved_precheck",
    "root_repo_absorbing_nested_repos"
  )
  repos = @($repoResultArray)
  warning_count = $warnings.Count
  warnings = @($warnings)
  error_count = $errors.Count
  errors = @($errors)
  generated_at = (Get-Date).ToUniversalTime().ToString("o")
  result_written = $WriteResult.IsPresent
}

if ($WriteResult) {
  $resultRoot = Join-Path $RepoRoot ".agents\codex\evals\results"
  New-Item -ItemType Directory -Force -Path $resultRoot | Out-Null
  $resultPath = Join-Path $resultRoot "all_repo_github_alignment_latest.json"
  $payload | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $resultPath -Encoding UTF8
}

$payload | ConvertTo-Json -Depth 12
if ($errors.Count -gt 0) {
  exit 1
}
