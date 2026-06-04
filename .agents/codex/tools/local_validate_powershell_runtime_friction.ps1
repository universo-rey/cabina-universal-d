param(
  [string]$RepoRoot = "D:\",
  [switch]$WriteResult,
  [int]$MaxWarnings = 200
)

$ErrorActionPreference = "Stop"

function Resolve-RepoPath {
  param([string]$Path)
  return (Join-Path $RepoRoot $Path)
}

$parseRoots = @(
  ".agents/codex/tools",
  "dataverse/scripts",
  "scripts"
)

$textRoots = @(
  ".agents/codex/recipes",
  ".agents/codex/matrices",
  "docs",
  "readbacks",
  "retrospectives",
  "validation"
)

$blockFindings = New-Object System.Collections.Generic.List[object]
$warnFindings = New-Object System.Collections.Generic.List[object]
$guardrailDefinitionFiles = @(
  "POWERSHELL_RUNTIME_FRICTION_MATRIX.csv",
  "recipe.powershell_runtime_friction_guard.md",
  "D_SKILL_AVAILABILITY_AND_ISSUE_PR_FRICTION_MATRIX.csv",
  "recipe.d_skill_availability_issue_pr_friction_review.md"
)

foreach ($relativeRoot in $parseRoots) {
  $root = Resolve-RepoPath $relativeRoot
  if (-not (Test-Path -LiteralPath $root)) {
    continue
  }

  Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.ps1" | ForEach-Object {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) {
      foreach ($errorItem in $errors) {
        $blockFindings.Add([pscustomobject]@{
          rule = "ps1_parse_error"
          file = $_.FullName
          line = $errorItem.Extent.StartLineNumber
          message = $errorItem.Message
        })
      }
    }

    $content = Get-Content -LiteralPath $_.FullName -Raw
    if ($content -match '(?m)^\s*(node|python|py|bash|sh|pwsh|powershell)[^\r\n]*<<') {
      $blockFindings.Add([pscustomobject]@{
        rule = "bash_heredoc_in_ps1"
        file = $_.FullName
        line = 0
        message = "Bash heredoc syntax is not valid in PowerShell scripts."
      })
    }
  }
}

$warningRules = @(
  [pscustomobject]@{
    id = "bash_heredoc_snippet"
    pattern = "<<"
    message = "Bash heredoc snippets break in PowerShell. Prefer PowerShell here-strings or node -e."
  },
  [pscustomobject]@{
    id = "shell_redirection_write"
    pattern = "cat\s+>"
    message = "Shell redirection writes are fragile in PowerShell. Prefer apply_patch for repo edits."
  },
  [pscustomobject]@{
    id = "unix_pipeline_assumption"
    pattern = "rg\s+--files.+\|\s*rg"
    message = "Native pipeline behavior differs across shells. Prefer one rg query or assign output before filtering."
  },
  [pscustomobject]@{
    id = "unix_text_tool_assumption"
    pattern = "\b(grep|sed|awk)\b"
    message = "Unix text tools may not exist or may parse differently on Windows. Prefer rg, Select-String, Import-Csv, ConvertFrom-Json, or Node."
  }
)

foreach ($relativeRoot in $textRoots) {
  $root = Resolve-RepoPath $relativeRoot
  if (-not (Test-Path -LiteralPath $root)) {
    continue
  }

  Get-ChildItem -LiteralPath $root -Recurse -File -Include "*.md", "*.csv", "*.json", "*.yml", "*.yaml", "*.ps1" | ForEach-Object {
    if ($guardrailDefinitionFiles -contains $_.Name) {
      return
    }

    $content = Get-Content -LiteralPath $_.FullName -Raw
    foreach ($rule in $warningRules) {
      if ($content -match $rule.pattern) {
        $warnFindings.Add([pscustomobject]@{
          rule = $rule.id
          file = $_.FullName
          line = 0
          message = $rule.message
        })
        if ($warnFindings.Count -ge $MaxWarnings) {
          break
        }
      }
    }
  }
  if ($warnFindings.Count -ge $MaxWarnings) {
    break
  }
}

$status = "PASS"
if ($blockFindings.Count -gt 0) {
  $status = "FAIL"
}

$warningsTruncated = $false
if ($warnFindings.Count -ge $MaxWarnings) {
  $warningsTruncated = $true
}

$result = [pscustomobject]@{
  status = $status
  parse_roots = ($parseRoots -join "|")
  text_roots = ($textRoots -join "|")
  blocking_findings = $blockFindings.Count
  warning_findings = $warnFindings.Count
  warnings_truncated = $warningsTruncated
}

if ($WriteResult) {
  $outDir = Resolve-RepoPath ".agents/codex/evals/results"
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  $outPath = Join-Path $outDir "powershell_runtime_friction_latest.json"
  [pscustomobject]@{
    summary = $result
    blocks = @($blockFindings.ToArray())
    warnings = @($warnFindings.ToArray())
  } | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $outPath -Encoding UTF8
}

if ($blockFindings.Count -gt 0) {
  $result | ConvertTo-Json -Depth 6
  Write-Error "POWERSHELL_RUNTIME_FRICTION_FAIL blocking_findings=$($blockFindings.Count)"
}

Write-Output "POWERSHELL_RUNTIME_FRICTION_PASS warnings=$($warnFindings.Count) truncated=$($result.warnings_truncated)"
