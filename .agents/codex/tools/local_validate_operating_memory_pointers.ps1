param(
  [string]$RepoRoot = ""
)

$ErrorActionPreference = "Stop"

function Add-Finding {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Category,
    [string]$File,
    [string]$Message
  )
  $List.Add([pscustomobject]@{
    category = $Category
    file = $File
    message = $Message
  }) | Out-Null
}

function Convert-ToRepoRelativePath {
  param(
    [string]$RepoRoot,
    [string]$FullPath
  )
  $root = $RepoRoot.TrimEnd("\", "/")
  if ($FullPath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
    return ($FullPath.Substring($root.Length).TrimStart("\", "/") -replace "\\", "/")
  }
  return ($FullPath -replace "\\", "/")
}

function Join-RepoPath {
  param(
    [string]$RepoRoot,
    [string]$RelativePath
  )
  return Join-Path $RepoRoot ($RelativePath -replace "/", "\")
}

function Get-DocumentText {
  param(
    [string]$RepoRoot,
    [string]$RelativePath
  )
  $fullPath = Join-RepoPath -RepoRoot $RepoRoot -RelativePath $RelativePath
  if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
    return $null
  }
  return Get-Content -LiteralPath $fullPath -Raw
}

function Complete-Check {
  param(
    [System.Collections.IDictionary]$Checks,
    [System.Collections.Generic.List[object]]$Errors,
    [System.Collections.Generic.List[object]]$Warnings,
    [string]$Category
  )
  $errorCount = @($Errors | Where-Object { $_.category -eq $Category }).Count
  $warningCount = @($Warnings | Where-Object { $_.category -eq $Category }).Count
  $Checks[$Category] = [pscustomobject]@{
    status = if ($errorCount -eq 0) { "PASS" } else { "FAIL" }
    errors = $errorCount
    warnings = $warningCount
  }
}

function Test-TextHasPointer {
  param(
    [string]$Text,
    [string]$Target
  )
  if ([string]::IsNullOrWhiteSpace($Text)) {
    return $false
  }
  $slash = $Target -replace "\\", "/"
  $backslash = $Target -replace "/", "\"
  return ($Text.Contains($slash) -or $Text.Contains($backslash))
}

function Test-Metadata {
  param(
    [string]$RelativePath,
    [string]$Text,
    [string[]]$AllowedStatuses,
    [System.Collections.Generic.List[object]]$Errors
  )
  $category = "metadata"
  $hasVersion = ($Text -match '(?mi)^\s*-\s*Version\s*:') -or ($Text -match '(?mi)^##\s+Version\s*$')
  $hasCurrent = $Text -match '(?mi)^\s*-\s*Current\s*:'
  $hasLastUpdated = $Text -match '(?mi)^\s*-\s*Last updated\s*:'
  $statusMatch = [regex]::Match($Text, '(?mi)^\s*-\s*Status\s*:\s*(.+?)\s*$')

  if (-not $hasVersion) {
    Add-Finding -List $Errors -Category $category -File $RelativePath -Message "missing Version metadata"
  }
  if (-not $hasCurrent) {
    Add-Finding -List $Errors -Category $category -File $RelativePath -Message "missing Current metadata"
  }
  if (-not $hasLastUpdated) {
    Add-Finding -List $Errors -Category $category -File $RelativePath -Message "missing Last updated metadata"
  }
  if (-not $statusMatch.Success) {
    Add-Finding -List $Errors -Category $category -File $RelativePath -Message "missing Status metadata"
    return
  }

  $statusValue = $statusMatch.Groups[1].Value.Trim()
  $statusValue = ($statusValue -replace '^[`''"]+|[`''"]+$', '').ToLowerInvariant()
  if ($statusValue -notin $AllowedStatuses) {
    Add-Finding -List $Errors -Category $category -File $RelativePath -Message "invalid Status '$statusValue'"
  }
}

function Test-MarkdownLinks {
  param(
    [string]$RepoRoot,
    [string]$RelativePath,
    [System.Collections.Generic.List[object]]$Errors,
    [System.Collections.Generic.List[object]]$Warnings
  )
  $category = "markdown_relative_links"
  $fullPath = Join-RepoPath -RepoRoot $RepoRoot -RelativePath $RelativePath
  if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
    return
  }

  $lines = @(Get-Content -LiteralPath $fullPath)
  $baseDir = Split-Path -Parent $fullPath
  $isArchive = ($RelativePath -replace "\\", "/").StartsWith("docs/operations/archive/", [System.StringComparison]::OrdinalIgnoreCase)
  $linkPattern = '(?!!)\[[^\]]+\]\(([^)]+)\)'

  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = [string]$lines[$i]
    if ($line -match '[A-Za-z]:(\\|/)') {
      if (-not $isArchive -and $line -notmatch '(?i)legacy|archive|histor') {
        Add-Finding -List $Warnings -Category $category -File $RelativePath -Message "line $($i + 1) contains local absolute Windows path"
      }
    }

    foreach ($match in [regex]::Matches($line, $linkPattern)) {
      $rawTarget = $match.Groups[1].Value.Trim().Trim("<", ">")
      if ([string]::IsNullOrWhiteSpace($rawTarget)) {
        continue
      }

      $target = ($rawTarget -split '\s+')[0]
      $target = $target -replace '^[''"]+|[''"]+$', ''
      if ($target.StartsWith("#")) {
        continue
      }
      if ($target -match '^(?i)(https?://|mailto:|app://)') {
        continue
      }
      if ($target -match '^[A-Za-z]:(\\|/)') {
        if (-not $isArchive -and $line -notmatch '(?i)legacy|archive|histor') {
          Add-Finding -List $Warnings -Category $category -File $RelativePath -Message "line $($i + 1) links to local absolute Windows path"
        }
        continue
      }

      $targetPath = ($target -split '#')[0]
      if ([string]::IsNullOrWhiteSpace($targetPath)) {
        continue
      }
      $candidate = Join-Path $baseDir ($targetPath -replace "/", "\")
      if (-not (Test-Path -LiteralPath $candidate)) {
        Add-Finding -List $Errors -Category $category -File $RelativePath -Message "line $($i + 1) broken markdown link: $target"
      }
    }
  }
}

function Test-HistoryRegression {
  param(
    [string]$RelativePath,
    [string]$Text,
    [int]$MaxLines,
    [string]$Category,
    [System.Collections.Generic.List[object]]$Errors
  )
  $lineCount = @($Text -split "`r?`n").Count
  if ($lineCount -gt $MaxLines) {
    Add-Finding -List $Errors -Category $Category -File $RelativePath -Message "line_count=$lineCount exceeds max_lines=$MaxLines"
  }

  $prMentions = [regex]::Matches($Text, '#\d+').Count
  if ($prMentions -gt 40) {
    Add-Finding -List $Errors -Category $Category -File $RelativePath -Message "too many PR-number mentions for active memory: $prMentions"
  }

  if ($Text -match '(?i)PR\s+#1\s*-\s*#144|#1-#144|PRs?\s+#1\s+through\s+#144') {
    Add-Finding -List $Errors -Category $Category -File $RelativePath -Message "historical PR range belongs in changelog/archive"
  }

  if ($Text -match '(?is)##\s+Archived AGENTS\.md History Block|```md\s*#\s+Current State') {
    Add-Finding -List $Errors -Category $Category -File $RelativePath -Message "embedded archived source block found in active document"
  }
}

$errors = New-Object System.Collections.Generic.List[object]
$warnings = New-Object System.Collections.Generic.List[object]
$checks = [ordered]@{}

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  $gitRootOutput = @(& git rev-parse --show-toplevel 2>&1)
  if ($LASTEXITCODE -ne 0 -or $gitRootOutput.Count -eq 0) {
    Add-Finding -List $errors -Category "root_detection" -File "" -Message "not_inside_git_repo"
    $result = [pscustomobject]@{
      status = "FAIL"
      repo_root = $null
      checks = $checks
      warning_count = $warnings.Count
      warnings = @($warnings.ToArray())
      error_count = $errors.Count
      errors = @($errors.ToArray())
    }
    $result | ConvertTo-Json -Depth 8
    exit 1
  }
  $RepoRoot = [string]$gitRootOutput[0]
}

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$coreWorktree = @(& git -C $RepoRoot config --get core.worktree 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace(($coreWorktree -join ""))) {
  $coreWorktreeStatus = "unset_normal"
} else {
  $coreWorktreeStatus = ($coreWorktree -join "").Trim()
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "root_detection"

$requiredFiles = @(
  "AGENTS.md",
  "02_AUTHORITY_CANON/CURRENT_STATE.md",
  "MANIFEST.yaml",
  "docs/operations/OPERATING_MEMORY_INDEX.md",
  "docs/operations/CANON_CHANGELOG.md",
  "docs/operations/archive/AGENTS_HISTORY_20260608.md",
  "docs/operations/archive/CURRENT_STATE_HISTORY_20260608.md"
)

foreach ($relative in $requiredFiles) {
  if (-not (Test-Path -LiteralPath (Join-RepoPath -RepoRoot $RepoRoot -RelativePath $relative) -PathType Leaf)) {
    Add-Finding -List $errors -Category "required_files" -File $relative -Message "required file missing"
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "required_files"

$agentsText = Get-DocumentText -RepoRoot $RepoRoot -RelativePath "AGENTS.md"
$indexText = Get-DocumentText -RepoRoot $RepoRoot -RelativePath "docs/operations/OPERATING_MEMORY_INDEX.md"
$manifestText = Get-DocumentText -RepoRoot $RepoRoot -RelativePath "MANIFEST.yaml"
$currentText = Get-DocumentText -RepoRoot $RepoRoot -RelativePath "02_AUTHORITY_CANON/CURRENT_STATE.md"

foreach ($target in @(
  "docs/operations/OPERATING_MEMORY_INDEX.md",
  "02_AUTHORITY_CANON/CURRENT_STATE.md",
  "MANIFEST.yaml",
  "docs/operations/archive/AGENTS_HISTORY_20260608.md"
)) {
  if (-not (Test-TextHasPointer -Text $agentsText -Target $target)) {
    Add-Finding -List $errors -Category "agents_min_pointers" -File "AGENTS.md" -Message "missing pointer to $target"
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "agents_min_pointers"

foreach ($target in @(
  "AGENTS.md",
  "02_AUTHORITY_CANON/CURRENT_STATE.md",
  "MANIFEST.yaml",
  "docs/operations/CANON_CHANGELOG.md",
  "docs/operations/archive/AGENTS_HISTORY_20260608.md",
  "docs/operations/archive/CURRENT_STATE_HISTORY_20260608.md"
)) {
  if (-not (Test-TextHasPointer -Text $indexText -Target $target)) {
    Add-Finding -List $errors -Category "index_min_pointers" -File "docs/operations/OPERATING_MEMORY_INDEX.md" -Message "missing pointer to $target"
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "index_min_pointers"

$allowedStatuses = @("active", "snapshot", "archive", "archived", "deprecated", "needs verification")
foreach ($relative in @(
  "AGENTS.md",
  "02_AUTHORITY_CANON/CURRENT_STATE.md",
  "docs/operations/OPERATING_MEMORY_INDEX.md",
  "docs/operations/CANON_CHANGELOG.md",
  "docs/operations/archive/AGENTS_HISTORY_20260608.md",
  "docs/operations/archive/CURRENT_STATE_HISTORY_20260608.md"
)) {
  $text = Get-DocumentText -RepoRoot $RepoRoot -RelativePath $relative
  if ($null -ne $text) {
    Test-Metadata -RelativePath $relative -Text $text -AllowedStatuses $allowedStatuses -Errors $errors
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "metadata"

if ($null -ne $agentsText) {
  Test-HistoryRegression -RelativePath "AGENTS.md" -Text $agentsText -MaxLines 400 -Category "agents_anti_history" -Errors $errors
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "agents_anti_history"

if ($null -ne $currentText) {
  Test-HistoryRegression -RelativePath "02_AUTHORITY_CANON/CURRENT_STATE.md" -Text $currentText -MaxLines 200 -Category "current_state_snapshot" -Errors $errors
  if ($currentText -match '(?i)##\s+Milestones|##\s+PR Ranges') {
    Add-Finding -List $errors -Category "current_state_snapshot" -File "02_AUTHORITY_CANON/CURRENT_STATE.md" -Message "snapshot contains changelog section"
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "current_state_snapshot"

foreach ($relative in @(
  "AGENTS.md",
  "02_AUTHORITY_CANON/CURRENT_STATE.md",
  "docs/operations/OPERATING_MEMORY_INDEX.md",
  "docs/operations/CANON_CHANGELOG.md"
)) {
  Test-MarkdownLinks -RepoRoot $RepoRoot -RelativePath $relative -Errors $errors -Warnings $warnings
}

$archiveRoot = Join-RepoPath -RepoRoot $RepoRoot -RelativePath "docs/operations/archive"
if (Test-Path -LiteralPath $archiveRoot -PathType Container) {
  Get-ChildItem -LiteralPath $archiveRoot -Filter "*.md" -File | ForEach-Object {
    $relative = Convert-ToRepoRelativePath -RepoRoot $RepoRoot -FullPath $_.FullName
    Test-MarkdownLinks -RepoRoot $RepoRoot -RelativePath $relative -Errors $errors -Warnings $warnings
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "markdown_relative_links"

$manifestPath = Join-RepoPath -RepoRoot $RepoRoot -RelativePath "MANIFEST.yaml"
if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
  $python = Get-Command python -ErrorAction SilentlyContinue
  if (-not $python) {
    Add-Finding -List $errors -Category "manifest_yaml" -File "MANIFEST.yaml" -Message "python unavailable for YAML parse"
  } else {
    $manifestForPython = $manifestPath -replace "\\", "/"
    $yamlCheck = @(& $python.Source -c "import pathlib, yaml; yaml.safe_load(pathlib.Path('$manifestForPython').read_text(encoding='utf-8'))" 2>&1)
    if ($LASTEXITCODE -ne 0) {
      Add-Finding -List $errors -Category "manifest_yaml" -File "MANIFEST.yaml" -Message "YAML parse failed: $($yamlCheck -join ' ')"
    }
  }

  foreach ($target in @(
    "AGENTS.md",
    "02_AUTHORITY_CANON/CURRENT_STATE.md",
    "docs/operations/OPERATING_MEMORY_INDEX.md",
    "docs/operations/CANON_CHANGELOG.md",
    "docs/operations/archive/AGENTS_HISTORY_20260608.md",
    "docs/operations/archive/CURRENT_STATE_HISTORY_20260608.md"
  )) {
    if (-not (Test-TextHasPointer -Text $manifestText -Target $target)) {
      Add-Finding -List $errors -Category "manifest_yaml" -File "MANIFEST.yaml" -Message "manifest missing operating memory pointer to $target"
    }
  }
}
Complete-Check -Checks $checks -Errors $errors -Warnings $warnings -Category "manifest_yaml"

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
$result = [pscustomobject]@{
  status = $status
  validator = "tool.local_validate_operating_memory_pointers"
  repo_root = $RepoRoot
  core_worktree = $coreWorktreeStatus
  checked_required_files = $requiredFiles.Count
  checks = $checks
  warning_count = $warnings.Count
  warnings = @($warnings.ToArray())
  error_count = $errors.Count
  errors = @($errors.ToArray())
}

$result | ConvertTo-Json -Depth 8

if ($status -ne "PASS") {
  exit 1
}
