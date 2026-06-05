param(
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d",
  [string]$Repository = "universo-rey/cabina-universal-d",
  [switch]$UseGitHub,
  [switch]$WriteResult,
  [int]$Limit = 300
)

$ErrorActionPreference = "Stop"

function Join-RepoPath {
  param([string]$Path)
  return (Join-Path $RepoRoot $Path)
}

function Add-Finding {
  param(
    [System.Collections.Generic.List[object]]$List,
    [string]$Kind,
    [string]$Id,
    [string]$Rule,
    [string]$Severity,
    [string]$Message
  )

  $List.Add([pscustomobject]@{
    kind = $Kind
    id = $Id
    rule = $Rule
    severity = $Severity
    message = $Message
  })
}

$catalogPath = Join-RepoPath ".agents/codex/matrices/LOCAL_SKILL_CATALOG.csv"
if (-not (Test-Path -LiteralPath $catalogPath)) {
  Write-Error "D_SKILL_AVAILABILITY_FAIL missing_catalog=$catalogPath"
}

$skillRoot = Join-RepoPath ".agents/skills"
$dSkillNames = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::OrdinalIgnoreCase)
if (Test-Path -LiteralPath $skillRoot) {
  Get-ChildItem -LiteralPath $skillRoot -Directory | ForEach-Object {
    [void]$dSkillNames.Add($_.Name)
  }
}

$findings = New-Object System.Collections.Generic.List[object]
$catalogRows = @(Import-Csv -LiteralPath $catalogPath)
foreach ($row in $catalogRows) {
  $skillId = [string]$row.skill_id
  $source = [string]$row.source
  $path = [string]$row.path

  if ($source -eq "d_drive_repo_local") {
    $localName = $skillId
    if (-not $dSkillNames.Contains($localName)) {
      Add-Finding $findings "skill" $skillId "d_repo_skill_missing" "block" "Skill is declared d_drive_repo_local but no matching .agents\skills directory exists."
    }
    if ($path -and $path.StartsWith("C:/Users/enzo1/Documents/GitHub/cabina-universal-d")) {
      $candidatePath = $path.Replace("/", "\")
      if (-not (Test-Path -LiteralPath $candidatePath)) {
        Add-Finding $findings "skill" $skillId "d_repo_skill_path_missing" "block" "Skill path does not exist under D:."
      }
    }
  } else {
    Add-Finding $findings "skill" $skillId "not_d_repo_local_skill" "info" "Skill is available only as plugin, installed, system, or external runtime. Treat as tool/runtime capability, not D: durable canon."
  }
}

$frictionRules = @(
  [pscustomobject]@{ id = "bash_heredoc"; pattern = "<<"; message = "Bash heredoc syntax breaks in PowerShell; use PowerShell here-string, checked-in script, or node -e." },
  [pscustomobject]@{ id = "shell_redirection_write"; pattern = "cat\s+>"; message = "Shell redirection writes are fragile on Windows; use apply_patch for repo edits." },
  [pscustomobject]@{ id = "unix_pipeline_assumption"; pattern = "rg\s+--files.+\|\s*rg"; message = "Native pipeline assumptions differ on PowerShell; prefer a single rg query or structured parse." },
  [pscustomobject]@{ id = "unix_text_tool_assumption"; pattern = "\b(grep|sed|awk)\b"; message = "Unix text tools may not exist or parse the same on Windows; prefer rg, Select-String, Import-Csv, ConvertFrom-Json, or Node." },
  [pscustomobject]@{ id = "powershell_runtime_surface"; pattern = "\b(powershell|pwsh|ps1|windows|cross-platform|script|parser|runner|cli)\b"; message = "Issue or PR touches shell/runtime surface; apply the PowerShell runtime friction guard before closeout." }
)

$issuePrFindings = New-Object System.Collections.Generic.List[object]
if ($UseGitHub) {
  $issuesJson = gh issue list --repo $Repository --state all --limit $Limit --json number,title,state,body,url
  $prsJson = gh pr list --repo $Repository --state all --limit $Limit --json number,title,state,headRefName,url
  $issues = @($issuesJson | ConvertFrom-Json)
  $prs = @($prsJson | ConvertFrom-Json)

  foreach ($issue in $issues) {
    $text = (($issue.title, $issue.body) -join " ")
    foreach ($rule in $frictionRules) {
      if ($text -match $rule.pattern) {
        Add-Finding $issuePrFindings "issue" ("#" + $issue.number) $rule.id "warn" $rule.message
      }
    }
  }

  foreach ($pr in $prs) {
    $text = (($pr.title, $pr.headRefName) -join " ")
    foreach ($rule in $frictionRules) {
      if ($text -match $rule.pattern) {
        Add-Finding $issuePrFindings "pr" ("#" + $pr.number) $rule.id "warn" $rule.message
      }
    }
  }
}

$blocking = @($findings | Where-Object { $_.severity -eq "block" })
$externalSkillCount = @($findings | Where-Object { $_.rule -eq "not_d_repo_local_skill" }).Count
$status = "PASS"
if ($blocking.Count -gt 0) {
  $status = "FAIL"
}

$summary = [pscustomobject]@{
  status = $status
  repository = $Repository
  d_repo_skill_count = $dSkillNames.Count
  catalog_skill_count = $catalogRows.Count
  external_or_non_d_skill_count = $externalSkillCount
  blocking_skill_findings = $blocking.Count
  issue_pr_friction_findings = $issuePrFindings.Count
  github_read = [bool]$UseGitHub
}

if ($WriteResult) {
  $outDir = Join-RepoPath ".agents/codex/evals/results"
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  $outPath = Join-Path $outDir "d_skill_availability_issue_pr_friction_latest.json"
  [pscustomobject]@{
    summary = $summary
    skill_findings = @($findings.ToArray())
    issue_pr_findings = @($issuePrFindings.ToArray())
  } | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $outPath -Encoding UTF8
}

if ($blocking.Count -gt 0) {
  $summary | ConvertTo-Json -Depth 4
  Write-Error "D_SKILL_AVAILABILITY_FAIL blocking_skill_findings=$($blocking.Count)"
}

Write-Output "D_SKILL_AVAILABILITY_ISSUE_PR_FRICTION_PASS external_skills=$externalSkillCount issue_pr_findings=$($issuePrFindings.Count)"
