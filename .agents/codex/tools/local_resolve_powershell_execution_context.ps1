param(
  [Parameter(Mandatory = $true)]
  [string]$Objective,
  [string]$TargetPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

function Normalize-ComparablePath {
  param([string]$Path)
  return ([System.IO.Path]::GetFullPath(
    [Environment]::ExpandEnvironmentVariables($Path.Replace("/", "\"))
  )).TrimEnd("\")
}

function Test-PathWithin {
  param(
    [string]$Candidate,
    [string]$Root
  )
  if ($Candidate.Equals($Root, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $true
  }
  return $Candidate.StartsWith(
    $Root + "\",
    [System.StringComparison]::OrdinalIgnoreCase
  )
}

$resolvedTarget = Normalize-ComparablePath $TargetPath
$matrixPath = "D:\.agents\codex\matrices\CABINA_UNIVERSAL_REPO_ALIGNMENT_MATRIX.csv"
$surfaceMapPath = "D:\.agents\codex\maps\SURFACE_BOUNDARY_MAP.csv"
$bontempsResolverPath =
  "D:\.agents\codex\tools\local_resolve_bontemps_workspace.ps1"
$githubAtlasRoot = "C:\Users\enzo1\Documents\GitHub"
$githubAtlasIndexPath = Join-Path $githubAtlasRoot "GITHUB_INDEX.csv"
$federalAgentsPath = "D:\AGENTS.md"
$federalManifestPath = "D:\MANIFEST.yaml"
$dataverseAnchorPath =
  "C:\CEO\sdu-control-plane\00_STATE\DATAVERSE_ANCHOR_STATE_V50.json"
$registeredRepos = Import-Csv -LiteralPath $matrixPath
$githubAtlasEntries = if (
  Test-Path -LiteralPath $githubAtlasIndexPath -PathType Leaf
) {
  @(Import-Csv -LiteralPath $githubAtlasIndexPath)
} else {
  @()
}
$registeredLocalConfigSurfaces = @(
  [pscustomobject]@{
    surface_id = "pipx_local_runtime"
    local_path = "C:\Users\enzo1\pipx"
    universe_id = "CABINA_UNIVERSAL"
    owner_agent = "codex.workspace_guardian"
    classification = "GOVERNED_LOCAL_PIPX_RUNTIME_SURFACE"
    workspace_id = $null
    evidence = "C:\Users\enzo1\pipx\venvs\graphifyy\pipx_metadata.json"
    binding_source = $PSCommandPath
  }
  [pscustomobject]@{
    surface_id = "ceo_machine_governance_root"
    local_path = "C:\CEO"
    universe_id = "CABINA_UNIVERSAL"
    owner_agent = "codex.workspace_guardian"
    classification = "GOVERNED_LOCAL_MACHINE_CONTROL_SURFACE"
    workspace_id = $null
    evidence = "C:\CEO\governance\state\CEO_ROOT_SURFACE_INDEX_20260801.csv"
    binding_source = $PSCommandPath
  }
  [pscustomobject]@{
    surface_id = "vscode_insiders_user_profile_local"
    local_path = "C:\Users\enzo1\AppData\Roaming\Code - Insiders\User"
    universe_id = "CABINA_UNIVERSAL"
    owner_agent = "codex.workspace_guardian"
    classification = "GOVERNED_LOCAL_RUNTIME_CONFIG_SURFACE"
    workspace_id = $null
    evidence = "D:\.agents\codex\maps\SURFACE_BOUNDARY_MAP.csv"
    binding_source = $PSCommandPath
  }
  [pscustomobject]@{
    surface_id = "sdu_control_plane_local"
    local_path = "C:\CEO\sdu-control-plane"
    universe_id = "CABINA_UNIVERSAL"
    owner_agent = "codex.workspace_guardian"
    classification = "GOVERNED_LOCAL_CONTROL_PLANE_SURFACE"
    workspace_id = "SDU_CABINA_UNIVERSAL"
    evidence = "C:\CEO\sdu-control-plane\12_WORKSPACES\WORKSPACE_INDEX_20260702.csv"
    binding_source = $PSCommandPath
  }
  [pscustomobject]@{
    surface_id = "sdu_watchdog_local_runtime"
    local_path = "C:\CEO\watchdog"
    universe_id = "CABINA_UNIVERSAL"
    owner_agent = "codex.workspace_guardian"
    classification = "GOVERNED_LOCAL_WATCHDOG_RUNTIME_SURFACE"
    workspace_id = "SDU_CABINA_UNIVERSAL"
    evidence = "C:\CEO\project-cdx\noc\noc-state.json"
    binding_source = $PSCommandPath
  }
  [pscustomobject]@{
    surface_id = "sdu_total_sync_v43_local"
    local_path = "C:\CEO\sdu-control-plane\17_TOTAL_SYNC"
    universe_id = "CABINA_UNIVERSAL"
    owner_agent = "agent.sync_orchestrator"
    classification = "GOVERNED_LOCAL_PLAN_READY_GATED_SURFACE"
    workspace_id = "SDU_CABINA_UNIVERSAL"
    evidence = "C:\CEO\sdu-control-plane\17_TOTAL_SYNC\TOTAL_SYNC_MASTER_PLAN.json"
    binding_source = $PSCommandPath
  }
  [pscustomobject]@{
    surface_id = "google_drive_tcu_tge_knowledge_source"
    local_path = "G:\Mi unidad\TCU_TGE_CHATGPT_CONTROL"
    universe_id = "HYBRID"
    owner_agent = "court.seshat_evidence"
    classification = "GOVERNED_EXTERNAL_LOCAL_MOUNT_KNOWLEDGE_SOURCE"
    workspace_id = "TCU_TGE_CHATGPT_CONTROL_KNOWLEDGE_SOURCE"
    evidence = "C:\CEO\sdu-control-plane\12_WORKSPACES\GOOGLE_DRIVE_KNOWLEDGE_SOURCE_BINDING_20260726.csv"
    binding_source = $PSCommandPath
    stop_condition = $null
  }
  [pscustomobject]@{
    surface_id = "google_drive_recovery_root_blocked"
    local_path = "G:\Mi unidad\99_RECUPERO_RAIZ_DRIVE_NO_USAR_SIN_REVISION"
    universe_id = "HYBRID"
    owner_agent = "rey.frontier_guardian"
    classification = "BLOCKED_HUMAN_REVIEW_REQUIRED"
    workspace_id = "TCU_TGE_CHATGPT_CONTROL_KNOWLEDGE_SOURCE"
    evidence = "C:\CEO\sdu-control-plane\12_WORKSPACES\GOOGLE_DRIVE_KNOWLEDGE_SOURCE_BINDING_20260726.csv"
    binding_source = $PSCommandPath
    stop_condition = "human_review_required"
  }
)

$matches = foreach ($repo in $registeredRepos) {
  if ([string]::IsNullOrWhiteSpace([string]$repo.local_path)) {
    continue
  }
  $registeredPath = Normalize-ComparablePath $repo.local_path
  if (Test-PathWithin -Candidate $resolvedTarget -Root $registeredPath) {
    [pscustomobject]@{
      repo = $repo
      registered_path = $registeredPath
      specificity = $registeredPath.Length
    }
  }
}

$selected = @($matches | Sort-Object specificity -Descending | Select-Object -First 1)
$repoMatch = if ($selected.Count -eq 1) { $selected[0].repo } else { $null }
$localSurfaceMatches = @(
  foreach ($surface in $registeredLocalConfigSurfaces) {
    $registeredPath = Normalize-ComparablePath $surface.local_path
    if (Test-PathWithin -Candidate $resolvedTarget -Root $registeredPath) {
      [pscustomobject]@{
        surface = $surface
        registered_path = $registeredPath
        specificity = $registeredPath.Length
      }
    }
  }
)
$selectedLocalSurface = @(
  $localSurfaceMatches |
    Sort-Object specificity -Descending |
    Select-Object -First 1
)
$localSurfaceMatch = if ($selectedLocalSurface.Count -eq 1) {
  $selectedLocalSurface[0]
} else {
  $null
}

$instructionFiles = New-Object System.Collections.Generic.List[string]
foreach ($fixedInstruction in @(
  "C:\Users\enzo1\.codex\AGENTS.md",
  "D:\AGENTS.md"
)) {
  if (Test-Path -LiteralPath $fixedInstruction) {
    $instructionFiles.Add($fixedInstruction)
  }
}

$cursor = if (Test-Path -LiteralPath $resolvedTarget -PathType Container) {
  [System.IO.DirectoryInfo]$resolvedTarget
} else {
  [System.IO.FileInfo]$resolvedTarget | ForEach-Object Directory
}

while ($null -ne $cursor) {
  foreach ($instructionName in @("AGENTS.md", "AGENTS.override.md")) {
    $candidate = Join-Path $cursor.FullName $instructionName
    if ((Test-Path -LiteralPath $candidate) -and
        -not $instructionFiles.Contains($candidate)) {
      $instructionFiles.Add($candidate)
    }
  }
  $cursor = $cursor.Parent
}

$gitRoot = $null
if (Get-Command git -ErrorAction SilentlyContinue) {
  $probeDirectory = if (Test-Path -LiteralPath $resolvedTarget -PathType Container) {
    $resolvedTarget
  } else {
    Split-Path -Parent $resolvedTarget
  }
  $gitOutput = & git -C $probeDirectory rev-parse --show-toplevel 2>$null
  if ($LASTEXITCODE -eq 0) {
    $gitRoot = ($gitOutput | Select-Object -First 1)
  }
}

$classification = if ($repoMatch) {
  "REGISTERED_FEDERAL_REPO_SURFACE"
} elseif ($localSurfaceMatch) {
  if ([string]::IsNullOrWhiteSpace([string]$localSurfaceMatch.surface.classification)) {
    "GOVERNED_LOCAL_RUNTIME_CONFIG_SURFACE"
  } else {
    [string]$localSurfaceMatch.surface.classification
  }
} elseif ($resolvedTarget.StartsWith(
    (Normalize-ComparablePath "C:\Users\enzo1\go\pkg\mod") + "\",
    [System.StringComparison]::OrdinalIgnoreCase
  )) {
  "EXCLUDED_REGENERABLE_DEPENDENCY_CACHE__OUTSIDE_GIT_BOUNDARY"
} else {
  "UNREGISTERED_OR_NON_REPO_SURFACE"
}

$physicalClassification = $classification
$physicalStopCondition = if (
  $classification -eq "UNREGISTERED_OR_NON_REPO_SURFACE"
) {
  "powershell_execution_context_unmapped"
} else {
  $null
}
$bontempsIdentity = $null
$federalIdentityClassification = $null
$effectiveStopCondition = $physicalStopCondition
$atlasEntry = $null
$atlasValidationStatus = "NOT_APPLICABLE"

$federalAgentsText = if (Test-Path -LiteralPath $federalAgentsPath) {
  Get-Content -LiteralPath $federalAgentsPath -Raw
} else {
  ""
}
$federalManifestText = if (Test-Path -LiteralPath $federalManifestPath) {
  Get-Content -LiteralPath $federalManifestPath -Raw
} else {
  ""
}
$gitFrozen = -not ($federalAgentsText -match '(?m)`GIT_FROZEN=false`')
$githubWriteStatus = if ($repoMatch) {
  [string]$repoMatch.github_write_status
} elseif ($bontempsIdentity) {
  "REQUIRES_EXPLICIT_GIT_ORDER"
} else {
  "UNMAPPED"
}
$githubAgentStatus = if ($repoMatch) {
  [string]$repoMatch.github_agent_status
} else {
  "UNMAPPED"
}
$githubWriteGoverned = @(
  "APPROVED_BRANCH_COMMIT_PUSH_PR",
  "REQUIRES_EXPLICIT_GIT_ORDER"
) -contains $githubWriteStatus
$lifecycleWriteEnabled = (
  -not $gitFrozen -and
  $githubWriteGoverned -and
  -not [string]::IsNullOrWhiteSpace([string]$gitRoot) -and
  ($repoMatch -or $bontempsIdentity)
)
$dataverseAnchorResolved = Test-Path -LiteralPath $dataverseAnchorPath -PathType Leaf
$codexCloudStatus = if (
  $federalManifestText -match '(?m)^\s*codex_cloud_live:\s*enabled_governed\s*$'
) { "ENABLED_GOVERNED" } else { "NOT_RESOLVED_FROM_FEDERAL_MANIFEST" }
$microsoftLiveStatus = if (
  $federalManifestText -match '(?m)^\s*microsoft_live:\s*enabled_governed_gated\s*$'
) { "ENABLED_GOVERNED_GATED" } else { "NOT_RESOLVED_FROM_FEDERAL_MANIFEST" }
$powerPlatformStatus = if (
  $federalManifestText -match '(?m)^\s*power_platform_live:\s*enabled_governed_gated\s*$'
) { "ENABLED_GOVERNED_GATED" } else { "NOT_RESOLVED_FROM_FEDERAL_MANIFEST" }
$productionStatus = if (
  $federalManifestText -match '(?m)^\s*production:\s*enabled_governed_gated\s*$'
) { "ENABLED_GOVERNED_GATED" } else { "NOT_RESOLVED_FROM_FEDERAL_MANIFEST" }

if (-not [string]::IsNullOrWhiteSpace([string]$gitRoot) -and
    (Test-PathWithin -Candidate (Normalize-ComparablePath $gitRoot) `
      -Root (Normalize-ComparablePath $githubAtlasRoot))) {
  $atlasMatches = @(
    $githubAtlasEntries | Where-Object {
      $entryPath = Normalize-ComparablePath (
        Join-Path $githubAtlasRoot ([string]$_.path)
      )
      $entryPath.Equals(
        (Normalize-ComparablePath $gitRoot),
        [System.StringComparison]::OrdinalIgnoreCase
      )
    }
  )
  if ($atlasMatches.Count -eq 1) {
    $atlasEntry = $atlasMatches[0]
    $atlasValidationStatus = "EXACT_ENTRY"
  } elseif ($atlasMatches.Count -gt 1) {
    $atlasValidationStatus = "AMBIGUOUS_EXACT_ENTRIES"
  } else {
    $atlasValidationStatus = "ENTRY_NOT_PRESENT"
  }
}

if (-not $repoMatch -and
    -not [string]::IsNullOrWhiteSpace([string]$gitRoot) -and
    (Test-Path -LiteralPath $bontempsResolverPath -PathType Leaf)) {
  try {
    $pwsh7 = "C:\Program Files\PowerShell\7\pwsh.exe"
    if (-not (Test-Path -LiteralPath $pwsh7 -PathType Leaf)) {
      throw "powershell_7_not_found"
    }
    $bontempsRaw = & $pwsh7 -NoLogo -NoProfile -File `
      $bontempsResolverPath -TargetPath $resolvedTarget -Intent $Objective
    if ($LASTEXITCODE -ne 0) {
      throw "bontemps_resolution_failed"
    }
    $candidateIdentity = $bontempsRaw | ConvertFrom-Json
    $identityEvidence = $candidateIdentity.repo_identity_evidence
    $resolvedWorkspaceId = if (-not [string]::IsNullOrWhiteSpace(
        [string]$candidateIdentity.workspace_id
      )) {
      [string]$candidateIdentity.workspace_id
    } else {
      [string]$identityEvidence.workspace.workspace_id
    }
    $candidateIdentity | Add-Member -NotePropertyName workspace_id `
      -NotePropertyValue $resolvedWorkspaceId -Force
    $acceptedIdentityResolution = @(
      "GITHUB_REMOTE_IDENTITY_EXACT",
      "GITHUB_REDIRECT_ALIAS_EXACT"
    ) -contains [string]$identityEvidence.identity_resolution
    $acceptedSurfaceClass = @(
      "REGISTERED_REPO_CLONE",
      "REGISTERED_REPO_WORKTREE_GENEALOGY"
    ) -contains [string]$candidateIdentity.surface_class
    $gitRootContainsTarget = Test-PathWithin `
      -Candidate $resolvedTarget `
      -Root (Normalize-ComparablePath $gitRoot)
    $atlasAllowsIdentity = if ($atlasValidationStatus -eq "NOT_APPLICABLE") {
      $true
    } elseif ($atlasValidationStatus -ne "EXACT_ENTRY") {
      $false
    } elseif ([string]$atlasEntry.kind -eq "canonical_repo") {
      [string]$candidateIdentity.surface_class -eq "REGISTERED_REPO_CLONE"
    } elseif ([string]$atlasEntry.kind -eq "derivative_worktree") {
      [string]$candidateIdentity.surface_class -eq
        "REGISTERED_REPO_WORKTREE_GENEALOGY"
    } else {
      $false
    }
    if ([string]$candidateIdentity.status -eq "RESOLVED" -and
        $acceptedIdentityResolution -and
        $acceptedSurfaceClass -and
        $gitRootContainsTarget -and
        $atlasAllowsIdentity -and
        -not [string]::IsNullOrWhiteSpace(
          [string]$candidateIdentity.repo_id
        ) -and
        -not [string]::IsNullOrWhiteSpace(
          [string]$candidateIdentity.workspace_id
        )) {
      $bontempsIdentity = $candidateIdentity
      $federalIdentityClassification = if (
        [string]$candidateIdentity.surface_class -eq
          "REGISTERED_REPO_WORKTREE_GENEALOGY"
      ) {
        "REGISTERED_REPO_WORKTREE_VALIDATED_BY_BONTEMPS"
      } else {
        "REGISTERED_REPO_CLONE_VALIDATED_BY_BONTEMPS"
      }
      $effectiveStopCondition =
        "bontemps_remote_identity_readonly_no_authority_transfer"
    }
  } catch {
    $bontempsIdentity = $null
    $federalIdentityClassification = $null
    $effectiveStopCondition = $physicalStopCondition
  }
}

# Recompose after BONTEMPS has had the opportunity to resolve an unregistered
# physical checkout into a governed repo/worktree identity.
if (-not $repoMatch -and $bontempsIdentity) {
  $githubWriteStatus = "REQUIRES_EXPLICIT_GIT_ORDER"
  $githubAgentStatus = "APPROVED_GITHUB_AGENT_SURFACE"
  $githubWriteGoverned = $true
  $lifecycleWriteEnabled = (
    -not $gitFrozen -and
    -not [string]::IsNullOrWhiteSpace([string]$gitRoot)
  )
}

$result = [ordered]@{
  status = "POWERSHELL_EXECUTION_CONTEXT_RESOLVED"
  objective = $Objective
  shell = [ordered]@{
    executable = (Get-Process -Id $PID).Path
    edition = $PSVersionTable.PSEdition
    version = $PSVersionTable.PSVersion.ToString()
    process_cwd = (Get-Location).Path
  }
  target = [ordered]@{
    path = $resolvedTarget
    classification = $classification
    physical_classification = $physicalClassification
    federal_identity_classification = $federalIdentityClassification
    git_root = $gitRoot
    observed_git_root = $gitRoot
  }
  physical_classification = $physicalClassification
  federal_identity_classification = $federalIdentityClassification
  canonical_checkout = if ($bontempsIdentity) {
    $bontempsIdentity.canonical_checkout
  } elseif ($repoMatch) {
    $repoMatch.local_path
  } else {
    $null
  }
  observed_git_root = $gitRoot
  observed_clone = if ($federalIdentityClassification -eq "REGISTERED_REPO_CLONE_VALIDATED_BY_BONTEMPS") {
    $gitRoot
  } else {
    $null
  }
  physical_stop_condition = $physicalStopCondition
  effective_stop_condition = $effectiveStopCondition
  identity_resolution = if ($bontempsIdentity) {
    $bontempsIdentity.repo_identity_evidence.identity_resolution
  } else {
    $null
  }
  identity_source = if ($bontempsIdentity) {
    $bontempsResolverPath
  } else {
    $matrixPath
  }
  github_atlas = [ordered]@{
    index_path = $githubAtlasIndexPath
    validation_status = $atlasValidationStatus
    entry_name = if ($atlasEntry) { $atlasEntry.name } else { $null }
    entry_kind = if ($atlasEntry) { $atlasEntry.kind } else { $null }
    authority_granted = $false
  }
  lifecycle_write_enabled = $lifecycleWriteEnabled
  lifecycle_write_ready = $false
  lifecycle = [ordered]@{
    policy = [ordered]@{
      git_frozen = $gitFrozen
      source = $federalAgentsPath
    }
    repository = [ordered]@{
      registered = [bool]($repoMatch -or $bontempsIdentity)
      github_agent_status = $githubAgentStatus
      github_write_status = $githubWriteStatus
      governed_write_capability = $githubWriteGoverned
    }
    participants = [ordered]@{
      github = [ordered]@{
        status = if ($githubWriteGoverned) { "ENABLED_GOVERNED" } else { "NOT_ENABLED" }
        execution = "REQUIRES_REPO_BRANCH_SCOPE_VALIDATORS_AND_POSTCHECK"
      }
      codex_cloud = [ordered]@{
        status = $codexCloudStatus
        execution = "TASK_SCOPED_GOVERNED"
      }
      dataverse = [ordered]@{
        status = if ($dataverseAnchorResolved) { "ANCHOR_RESOLVED_GOVERNED_GATED" } else { "ANCHOR_NOT_RESOLVED" }
        anchor = $dataverseAnchorPath
        execution = "EXACT_ENVIRONMENT_TABLE_OPERATION_AND_POSTCHECK_REQUIRED"
      }
      microsoft_live = [ordered]@{
        status = $microsoftLiveStatus
        execution = "EXACT_TARGET_IDENTITY_ROLLBACK_POSTCHECK_REQUIRED"
      }
      power_platform = [ordered]@{
        status = $powerPlatformStatus
        execution = "EXACT_TARGET_IDENTITY_ROLLBACK_POSTCHECK_REQUIRED"
      }
      production = [ordered]@{
        status = $productionStatus
        execution = "EXPLICIT_PRODUCTION_AUTHORIZATION_REQUIRED"
      }
    }
    readiness = [ordered]@{
      capability_enabled = $lifecycleWriteEnabled
      exact_order_required = $true
      clean_or_classified_worktree_required = $true
      branch_scope_required = $true
      validators_required = $true
      postcheck_required = $true
      execution_ready = $false
      reason = "CAPABILITY_ENABLED__ACTION_REQUIRES_EXACT_ORDER_AND_WORKTREE_CLASSIFICATION"
    }
  }
  authority_transfer = $false
  federal_route = [ordered]@{
    repo_id = if ($repoMatch) {
      $repoMatch.repo_id
    } elseif ($bontempsIdentity) {
      $bontempsIdentity.repo_id
    } else {
      $null
    }
    surface_id = if ($localSurfaceMatch) {
      $localSurfaceMatch.surface.surface_id
    } else {
      $null
    }
    repository = if ($repoMatch) {
      $repoMatch.repository_full_name
    } elseif ($bontempsIdentity) {
      $bontempsIdentity.repo_identity.repository
    } else {
      $null
    }
    workspace_id = if ($bontempsIdentity) {
      $bontempsIdentity.workspace_id
    } elseif ($localSurfaceMatch) {
      $localSurfaceMatch.surface.workspace_id
    } else {
      $null
    }
    evidence = if ($localSurfaceMatch) {
      $localSurfaceMatch.surface.evidence
    } else {
      $null
    }
    registered_path = if ($repoMatch) {
      $repoMatch.local_path
    } elseif ($bontempsIdentity) {
      $bontempsIdentity.canonical_checkout
    } elseif ($localSurfaceMatch) {
      $localSurfaceMatch.surface.local_path
    } else {
      $null
    }
    universe = if ($repoMatch) {
      $repoMatch.universe_id
    } elseif ($bontempsIdentity) {
      $bontempsIdentity.universe
    } elseif ($localSurfaceMatch) {
      $localSurfaceMatch.surface.universe_id
    } else {
      $null
    }
    owner_agent = if ($repoMatch) {
      $repoMatch.owner_agent
    } elseif ($bontempsIdentity) {
      $bontempsIdentity.owner_agent
    } elseif ($localSurfaceMatch) {
      $localSurfaceMatch.surface.owner_agent
    } else {
      $null
    }
    source_matrix = if ($localSurfaceMatch) {
      $localSurfaceMatch.surface.binding_source
    } elseif ($bontempsIdentity) {
      $bontempsResolverPath
    } else {
      $matrixPath
    }
  }
  instruction_chain = @($instructionFiles)
  interpretation_boundary = "Result describes only the resolved target, process environment, and declared metadata sources; absence outside those surfaces is not proven."
  stop_condition = if ($localSurfaceMatch -and -not [string]::IsNullOrWhiteSpace(
      [string]$localSurfaceMatch.surface.stop_condition
    )) {
    [string]$localSurfaceMatch.surface.stop_condition
  } elseif (-not [string]::IsNullOrWhiteSpace($effectiveStopCondition)) {
    $effectiveStopCondition
  } else {
    $null
  }
}

$result | ConvertTo-Json -Depth 7
