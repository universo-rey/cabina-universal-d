param(
  [string]$Root = ".agents\codex",
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d"
)

$ErrorActionPreference = "Stop"

function Read-CsvRequired {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing required CSV: $Path"
  }
  @(Import-Csv -LiteralPath $Path)
}

function Require-Columns {
  param(
    [string]$Path,
    [string[]]$Columns,
    [System.Collections.Generic.List[string]]$Errors
  )
  $rows = Read-CsvRequired -Path $Path
  $actual = @()
  if ($rows.Count -gt 0) {
    $actual = @($rows[0].PSObject.Properties.Name)
  } else {
    $header = Get-Content -LiteralPath $Path -TotalCount 1
    if ($header) { $actual = @($header -split ",") }
  }
  foreach ($column in $Columns) {
    if ($column -notin $actual) {
      $Errors.Add("Missing column '$column' in $Path")
    }
  }
}

function Check-Path {
  param(
    [string]$Path,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  $normalized = $Path -replace "/", "\"
  if ($normalized.StartsWith(".agents\codex", [System.StringComparison]::OrdinalIgnoreCase)) {
    $resolved = Join-Path $Root ($normalized.Substring(".agents\codex".Length).TrimStart("\"))
  } elseif ($normalized.StartsWith("C:\Users\enzo1\Documents\GitHub\cabina-universal-d", [System.StringComparison]::OrdinalIgnoreCase)) {
    $resolved = Join-Path $RepoRoot ($normalized.Substring("C:\Users\enzo1\Documents\GitHub\cabina-universal-d".Length).TrimStart("\"))
  } else {
    $resolved = Join-Path $RepoRoot $normalized
  }
  if (-not (Test-Path -LiteralPath $resolved)) {
    $Errors.Add("$Context references missing path: $Path")
  }
}

function Check-StopCondition {
  param(
    [string]$Value,
    [string[]]$KnownStops,
    [System.Collections.Generic.List[string]]$Errors,
    [string]$Context
  )
  foreach ($token in @($Value -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
    if ($token -notin $KnownStops) {
      $Errors.Add("$Context references unknown stop_condition: $token")
    }
  }
}

$upstreamPath = Join-Path $Root "matrices\OPENAI_UPSTREAM_REFERENCE_MATRIX.csv"
$adoptionPath = Join-Path $Root "matrices\OPENAI_TWO_WAVE_ADOPTION_MATRIX_20260602.csv"
$recipePath = Join-Path $Root "recipes\recipe.openai_review_repair_validate_loop.md"
$readbackPath = Join-Path $Root "readbacks\2026-06-02_openai_two_wave_adoption_readback.md"
$matrixIndexPath = Join-Path $Root "matrices\MATRIX_INDEX.csv"
$recipeIndexPath = Join-Path $Root "recipes\RECIPE_INDEX.csv"
$toolIndexPath = Join-Path $Root "tools\TOOL_INDEX.csv"
$toolGovernancePath = Join-Path $Root "matrices\TOOL_GOVERNANCE_MATRIX.csv"
$coveragePath = Join-Path $Root "matrices\VALIDATION_COVERAGE_MATRIX.csv"
$evidencePath = Join-Path $Root "matrices\EVIDENCE_AND_VALIDATION_MATRIX.csv"
$skillReferencePath = Join-Path $Root "matrices\SKILL_REFERENCE_SOURCE_MATRIX.csv"
$stopPath = Join-Path $Root "matrices\STOP_CONDITION_GLOSSARY.csv"
$agentsPath = Join-Path $Root "agents.json"
$workpaperTech = Join-Path $Root "workpapers\tech.reference_librarian\2026-06-02_openai_upstream_reference.md"
$workpaperDispatcher = Join-Path $Root "workpapers\court.openai_dispatcher\2026-06-02_openai_repair_loop_and_repo_lanes.md"
$workpaperSdu = Join-Path $Root "workpapers\court.sdu_gate\2026-06-02_openai_adoption_gate_review.md"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

foreach ($path in @($upstreamPath,$adoptionPath,$recipePath,$readbackPath,$matrixIndexPath,$recipeIndexPath,$toolIndexPath,$toolGovernancePath,$coveragePath,$evidencePath,$skillReferencePath,$stopPath,$agentsPath,$workpaperTech,$workpaperDispatcher,$workpaperSdu)) {
  if (-not (Test-Path -LiteralPath $path)) {
    $errors.Add("Missing required OpenAI adoption artifact: $path")
  }
}

if ($errors.Count -eq 0) {
  Require-Columns -Path $upstreamPath -Columns @(
    "upstream_id","repository","url","category","current_signal",
    "latest_release_or_state","pushed_at","license","authority_class",
    "allowed_use","blocked_use","owner_agent","reviewer_agent",
    "skill_refs","recipe_refs","tool_refs","evidence","validator",
    "status","stop_condition"
  ) -Errors $errors

  Require-Columns -Path $adoptionPath -Columns @(
    "lane_id","wave","repo_or_surface","upstream_refs","lead_agent",
    "owner_agent","reviewer_agent","skill","recipe","tool",
    "allowed_actions","blocked_actions","evidence","validator","risk",
    "rollback","stop_condition","status","next_action"
  ) -Errors $errors

  $upstreamRows = Read-CsvRequired -Path $upstreamPath
  $adoptionRows = Read-CsvRequired -Path $adoptionPath
  $matrixRows = Read-CsvRequired -Path $matrixIndexPath
  $recipeRows = Read-CsvRequired -Path $recipeIndexPath
  $toolRows = Read-CsvRequired -Path $toolIndexPath
  $toolGovernanceRows = Read-CsvRequired -Path $toolGovernancePath
  $coverageRows = Read-CsvRequired -Path $coveragePath
  $evidenceRows = Read-CsvRequired -Path $evidencePath
  $skillReferenceRows = Read-CsvRequired -Path $skillReferencePath
  $knownStops = @((Read-CsvRequired -Path $stopPath) | ForEach-Object { $_.stop_condition })
  $agentIds = @((Get-Content -Raw -LiteralPath $agentsPath | ConvertFrom-Json).agents | ForEach-Object { $_.id })
  $recipeIds = @($recipeRows | ForEach-Object { $_.recipe_id })
  $toolIds = @($toolRows | ForEach-Object { $_.tool_id })

  foreach ($requiredRepo in @(
    "openai/codex",
    "openai/skills",
    "openai/openai-cookbook",
    "openai/openai-agents-python",
    "openai/openai-agents-js",
    "openai/openai-openapi",
    "openai/codex-action",
    "openai/evals",
    "openai/openai-guardrails-python",
    "openai/openai-guardrails-js",
    "openai/privacy-filter",
    "openai/model_spec",
    "openai/model_spec_dataset",
    "openai/openai-python",
    "openai/openai-node"
  )) {
    if ($requiredRepo -notin @($upstreamRows | ForEach-Object { $_.repository })) {
      $errors.Add("Missing required OpenAI upstream repository: $requiredRepo")
    }
  }

  $seenUpstream = @{}
  foreach ($row in $upstreamRows) {
    foreach ($field in @("upstream_id","repository","url","category","current_signal","latest_release_or_state","pushed_at","license","authority_class","allowed_use","blocked_use","owner_agent","reviewer_agent","skill_refs","recipe_refs","tool_refs","evidence","validator","status","stop_condition")) {
      if ([string]::IsNullOrWhiteSpace($row.$field)) {
        $errors.Add("OpenAI upstream '$($row.upstream_id)' missing $field")
      }
    }
    if ($seenUpstream.ContainsKey($row.upstream_id)) {
      $errors.Add("Duplicate OpenAI upstream_id: $($row.upstream_id)")
    } else {
      $seenUpstream[$row.upstream_id] = $true
    }
    if ($row.repository -notmatch "^openai/") {
      $errors.Add("OpenAI upstream '$($row.upstream_id)' repository is not openai/*")
    }
    if ($row.url -notmatch "^https://github.com/openai/") {
      $errors.Add("OpenAI upstream '$($row.upstream_id)' URL is not official GitHub")
    }
    if ($row.authority_class -notmatch "technical_reference") {
      $errors.Add("OpenAI upstream '$($row.upstream_id)' must remain technical reference")
    }
    foreach ($blocked in @("treat_as_canon","bulk_copy","openai_api_live","production","secrets","permission_change","remote_agent_persistence")) {
      if ($row.blocked_use -notmatch [regex]::Escape($blocked)) {
        $errors.Add("OpenAI upstream '$($row.upstream_id)' blocked_use missing $blocked")
      }
    }
    foreach ($agentField in @("owner_agent","reviewer_agent")) {
      if ($row.$agentField -notin $agentIds) {
        $errors.Add("OpenAI upstream '$($row.upstream_id)' references unknown $agentField`: $($row.$agentField)")
      }
    }
    foreach ($recipe in @($row.recipe_refs -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
      if ($recipe -notin $recipeIds) {
        $errors.Add("OpenAI upstream '$($row.upstream_id)' references unknown recipe: $recipe")
      }
    }
    foreach ($tool in @($row.tool_refs -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
      if ($tool -notin $toolIds) {
        $errors.Add("OpenAI upstream '$($row.upstream_id)' references unknown tool: $tool")
      }
    }
    if ($row.validator -notmatch "local_validate_openai_upstream_adoption") {
      $errors.Add("OpenAI upstream '$($row.upstream_id)' must use OpenAI adoption validator")
    }
    if ($row.status -notin @("ADOPT_REFERENCE_NOW","MAP_LOCAL_ONLY","DEFER_UNTIL_CI_ORDER","REVIEW_BEFORE_ADOPTION","DEFER_UNTIL_GOVERNED_ORDER","REFERENCE_ONLY")) {
      $errors.Add("OpenAI upstream '$($row.upstream_id)' has invalid status: $($row.status)")
    }
    Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "OpenAI upstream '$($row.upstream_id)'"
  }

  foreach ($requiredLane in @(
    "openai.wave1.upstream_reference_matrix",
    "openai.wave1.review_repair_validate_recipe",
    "openai.wave1.validator_and_indices",
    "openai.wave1.readback_and_workpapers",
    "openai.wave2.tcu_runtime_control",
    "openai.wave2.sdu_canon",
    "openai.wave2.seshat_bootstrap_sdu_cn",
    "openai.wave2.tge_main",
    "openai.wave2.tge_runtime",
    "openai.wave2.cdf_soluciones",
    "openai.wave2.jara_consultores",
    "openai.wave2.modo_on_foundation"
  )) {
    if ($requiredLane -notin @($adoptionRows | ForEach-Object { $_.lane_id })) {
      $errors.Add("Missing required OpenAI adoption lane: $requiredLane")
    }
  }

  $seenLane = @{}
  foreach ($row in $adoptionRows) {
    foreach ($field in @("lane_id","wave","repo_or_surface","upstream_refs","lead_agent","owner_agent","reviewer_agent","skill","recipe","tool","allowed_actions","blocked_actions","evidence","validator","risk","rollback","stop_condition","status","next_action")) {
      if ([string]::IsNullOrWhiteSpace($row.$field)) {
        $errors.Add("OpenAI adoption lane '$($row.lane_id)' missing $field")
      }
    }
    if ($seenLane.ContainsKey($row.lane_id)) {
      $errors.Add("Duplicate OpenAI adoption lane_id: $($row.lane_id)")
    } else {
      $seenLane[$row.lane_id] = $true
    }
    foreach ($agentField in @("lead_agent","owner_agent","reviewer_agent")) {
      if ($row.$agentField -notin $agentIds) {
        $errors.Add("OpenAI adoption lane '$($row.lane_id)' references unknown $agentField`: $($row.$agentField)")
      }
    }
    foreach ($recipe in @($row.recipe -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
      if ($recipe -notin $recipeIds) {
        $errors.Add("OpenAI adoption lane '$($row.lane_id)' references unknown recipe: $recipe")
      }
    }
    foreach ($tool in @($row.tool -split "\|" | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
      if ($tool -notin $toolIds) {
        $errors.Add("OpenAI adoption lane '$($row.lane_id)' references unknown tool: $tool")
      }
    }
    foreach ($blocked in @("openai_api_live","production","secrets")) {
      if ($row.blocked_actions -notmatch [regex]::Escape($blocked)) {
        $errors.Add("OpenAI adoption lane '$($row.lane_id)' blocked_actions missing $blocked")
      }
    }
    if (($row.wave -eq "2") -and ($row.blocked_actions -notmatch "nested_repo_mixed_commit")) {
      $errors.Add("Wave 2 lane '$($row.lane_id)' must block nested_repo_mixed_commit")
    }
    if ($row.validator -notmatch "local_validate_openai_upstream_adoption") {
      $errors.Add("OpenAI adoption lane '$($row.lane_id)' must reference OpenAI validator")
    }
    if ($row.status -notin @("APPLIED_LOCAL_ROOT","READY_REPO_NATIVE_CARRIL")) {
      $errors.Add("OpenAI adoption lane '$($row.lane_id)' has invalid status: $($row.status)")
    }
    Check-StopCondition -Value $row.stop_condition -KnownStops $knownStops -Errors $errors -Context "OpenAI adoption lane '$($row.lane_id)'"
  }

  if ("openai_upstream_reference_matrix" -notin @($matrixRows | ForEach-Object { $_.matrix_id })) {
    $errors.Add("MATRIX_INDEX missing openai_upstream_reference_matrix")
  }
  if ("openai_two_wave_adoption_matrix" -notin @($matrixRows | ForEach-Object { $_.matrix_id })) {
    $errors.Add("MATRIX_INDEX missing openai_two_wave_adoption_matrix")
  }
  if ("recipe.openai_review_repair_validate_loop" -notin $recipeIds) {
    $errors.Add("RECIPE_INDEX missing recipe.openai_review_repair_validate_loop")
  }
  if ("tool.local_validate_openai_upstream_adoption" -notin $toolIds) {
    $errors.Add("TOOL_INDEX missing tool.local_validate_openai_upstream_adoption")
  }
  if ("tool.local_validate_openai_upstream_adoption" -notin @($toolGovernanceRows | ForEach-Object { $_.tool_id })) {
    $errors.Add("TOOL_GOVERNANCE_MATRIX missing tool.local_validate_openai_upstream_adoption")
  }
  if ("openai_upstream_adoption" -notin @($coverageRows | ForEach-Object { $_.artifact_class })) {
    $errors.Add("VALIDATION_COVERAGE_MATRIX missing openai_upstream_adoption")
  }
  if ("openai_upstream_adoption" -notin @($evidenceRows | ForEach-Object { $_.event_type })) {
    $errors.Add("EVIDENCE_AND_VALIDATION_MATRIX missing openai_upstream_adoption")
  }
  if ("openai_official_github_org_20260602" -notin @($skillReferenceRows | ForEach-Object { $_.source_id })) {
    $errors.Add("SKILL_REFERENCE_SOURCE_MATRIX missing openai_official_github_org_20260602")
  }

  $recipeText = Get-Content -Raw -LiteralPath $recipePath
  foreach ($phrase in @("review -> classify -> repair -> validate -> readback","does not call the OpenAI API","Treating `openai/*` as authority canon","local_validate_openai_upstream_adoption")) {
    if ($recipeText -notmatch [regex]::Escape($phrase)) {
      $errors.Add("OpenAI repair loop recipe missing phrase: $phrase")
    }
  }

  $readbackText = Get-Content -Raw -LiteralPath $readbackPath
  foreach ($phrase in @("No OpenAI API live","No Microsoft live","No production","No nested repo files were changed","READY_REPO_NATIVE_CARRIL")) {
    if ($readbackText -notmatch [regex]::Escape($phrase)) {
      $errors.Add("OpenAI readback missing phrase: $phrase")
    }
  }

  foreach ($path in @($upstreamPath,$adoptionPath,$recipePath,$readbackPath,$workpaperTech,$workpaperDispatcher,$workpaperSdu)) {
    foreach ($pattern in @("sk-[A-Za-z0-9_-]{20,}","OPENAI_API_KEY\s*=","BEGIN [A-Z ]*PRIVATE KEY","password\s*=","access_token\s*=","refresh_token\s*=")) {
      $hits = Select-String -LiteralPath $path -Pattern $pattern -CaseSensitive -ErrorAction SilentlyContinue
      foreach ($hit in $hits) {
        $errors.Add("Secret-like pattern in OpenAI adoption artifact $path line $($hit.LineNumber): $pattern")
      }
    }
  }
}

$status = if ($errors.Count -eq 0) { "PASS" } else { "FAIL" }
[pscustomobject]@{
  status = $status
  root = $Root
  repo_root = $RepoRoot
  upstream_count = if (Test-Path -LiteralPath $upstreamPath) { @(Import-Csv -LiteralPath $upstreamPath).Count } else { 0 }
  lane_count = if (Test-Path -LiteralPath $adoptionPath) { @(Import-Csv -LiteralPath $adoptionPath).Count } else { 0 }
  warning_count = $warnings.Count
  warnings = $warnings
  error_count = $errors.Count
  errors = $errors
} | ConvertTo-Json -Depth 6

if ($status -ne "PASS") {
  exit 1
}
