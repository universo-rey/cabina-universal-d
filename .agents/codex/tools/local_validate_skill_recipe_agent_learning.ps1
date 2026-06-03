param(
  [string]$RepoRoot = "D:\"
)

$ErrorActionPreference = "Stop"

$requiredFiles = @(
  "retrospectives/2026-06-03_SDU_DATAVERSE_WORKQUEUES_OPENAI_RUNTIME_RETROSPECTIVE_TIMELINE.md",
  "retrospectives/2026-06-03_OPERATIONAL_RETROSPECTIVE.md",
  "retrospectives/skills/LEARNED_SKILL_CANDIDATES_MATRIX.csv",
  "retrospectives/skills/SKILL_CANONIZATION_DECISION_MATRIX.csv",
  "retrospectives/recipes/LEARNED_RECIPE_CANDIDATES_MATRIX.csv",
  "retrospectives/recipes/RECIPE_CANONIZATION_DECISION_MATRIX.csv",
  "retrospectives/agents/AGENT_LEARNING_PROPAGATION_MATRIX.csv",
  "retrospectives/agents/AGENT_SKILL_ASSIGNMENT_DELTA.csv",
  "retrospectives/agents/AGENT_RECIPE_ASSIGNMENT_DELTA.csv",
  "retrospectives/deltas/RETROSPECTIVE_MATRIX_UPDATE_PLAN.csv",
  "retrospectives/validators/VALIDATOR_CANDIDATE_MATRIX.csv",
  "retrospectives/validators/VALIDATOR_IMPLEMENTATION_DECISION_MATRIX.csv",
  "retrospectives/prompts/PROMPT_IMPROVEMENT_PACK.md",
  "readbacks/retrospectives/READBACK_SKILLS_RECIPES_AGENT_LEARNING_RETROSPECTIVE.md",
  ".agents/skills/dataverse-metadata-only-provisioning/SKILL.md",
  ".agents/skills/agent-retrospective-learning/SKILL.md",
  ".agents/skills/dataverse-workqueue-backreference-mapping/SKILL.md",
  ".agents/skills/no-inference-runtime-write-guard/SKILL.md",
  ".agents/codex/recipes/recipe.one-flow-one-item-runtime-test.md",
  ".agents/codex/recipes/recipe.retrospective-to-skill-propagation.md",
  ".agents/codex/recipes/recipe.backreference-target-mapping-before-write.md",
  ".agents/codex/recipes/recipe.mapping-record-before-target-write.md"
)

$missing = @()
foreach ($file in $requiredFiles) {
  $path = Join-Path $RepoRoot $file
  if (-not (Test-Path -LiteralPath $path)) {
    $missing += $file
  }
}

if ($missing.Count -gt 0) {
  Write-Error ("RETROSPECTIVE_LEARNING_VALIDATION_FAIL missing=" + ($missing -join "|"))
}

$csvFiles = $requiredFiles | Where-Object { $_.EndsWith(".csv") }
foreach ($file in $csvFiles) {
  $path = Join-Path $RepoRoot $file
  $rows = Import-Csv -LiteralPath $path
  if ($rows.Count -lt 1) {
    Write-Error "RETROSPECTIVE_LEARNING_VALIDATION_FAIL empty_csv=$file"
  }
}

$requiredSkillIds = @(
  "skill.dataverse-metadata-only-provisioning",
  "skill.agent-retrospective-learning",
  "skill.dataverse-workqueue-backreference-mapping",
  "skill.no-inference-runtime-write-guard"
)
$skillDecisions = Import-Csv -LiteralPath (Join-Path $RepoRoot "retrospectives/skills/SKILL_CANONIZATION_DECISION_MATRIX.csv")
foreach ($skillId in $requiredSkillIds) {
  if (-not ($skillDecisions | Where-Object { $_.skill_id -eq $skillId -and $_.decision -eq "CANONIZE_NOW" })) {
    Write-Error "RETROSPECTIVE_LEARNING_VALIDATION_FAIL skill_not_canonized=$skillId"
  }
}

$blockedMarkers = @(
  "DATAVERSE_LIVE_NEW_EXECUTED",
  "POWER_AUTOMATE_LIVE_NEW_EXECUTED",
  "OPENAI_API_EXECUTED_NEW",
  "BATCH_API_SENT",
  "PROD_TOUCHED",
  "TEST_TOUCHED",
  "DEFAULT_USED",
  "SECRET_PRINTED"
)
$textFiles = $requiredFiles | Where-Object { $_.EndsWith(".md") -or $_.EndsWith(".csv") }
foreach ($file in $textFiles) {
  $path = Join-Path $RepoRoot $file
  $content = Get-Content -LiteralPath $path -Raw
  foreach ($marker in $blockedMarkers) {
    if ($content.Contains($marker)) {
      Write-Error "RETROSPECTIVE_LEARNING_VALIDATION_FAIL blocked_marker=$marker file=$file"
    }
  }
}

Write-Output "RETROSPECTIVE_LEARNING_VALIDATION_PASS files=$($requiredFiles.Count)"
