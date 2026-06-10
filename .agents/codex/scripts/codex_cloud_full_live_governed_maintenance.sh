#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_ID="codex_cloud_full_live_governed_maintenance"
EXPECTED_REPO="universo-rey/cabina-universal-d"
RUN_FULL_COVERAGE="false"

usage() {
  cat <<'USAGE'
codex_cloud_full_live_governed_maintenance.sh [--run-full-coverage]

Runs maintenance checks for the PR #56 full-live governed gate without
propagation, Microsoft writes, production writes or secret printing.

Default behavior:
- verify repo identity
- run local unit smoke
- run git diff check
- verify pwsh exists before PowerShell validators
- run operational chain, capability hardening and static change-aware validator

Optional:
--run-full-coverage  Run the Change-Aware Full-Coverage Orchestrator and emit
                     the audit artifact. This still runs no Microsoft write,
                     no production action and no propagation.
USAGE
}

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'ERROR:%s\n' "$*" >&2
  exit 1
}

for arg in "$@"; do
  case "$arg" in
    --run-full-coverage)
      RUN_FULL_COVERAGE="true"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "unknown_argument=$arg"
      ;;
  esac
done

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || fail "not_in_git_repo"
cd "$REPO_ROOT"

REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
case "$REMOTE_URL" in
  *"$EXPECTED_REPO"* ) ;;
  * ) fail "unexpected_origin=$REMOTE_URL" ;;
esac

log "SCRIPT_ID=$SCRIPT_ID"
log "REPO=$EXPECTED_REPO"
log "SDU_TRIAGE_AGENT_IMPLEMENTATION=full_live_governed"
log "LIVE_RUNTIME_VALIDATION=external_governed_smoke"
log "SETUP_SCRIPT_VERSIONED=yes"
log "MAINTENANCE_SCRIPT_VERSIONED=yes"
log "SETUP_SCRIPT_SELF_SUFFICIENT=yes"
log "DEPENDENCY_INSTALL=openai|openai-agents"
log "VENV_ACTIVATION_CROSS_PLATFORM=yes"
log "WINDOWS_GIT_BASH_COMPATIBLE=yes"
log "POSIX_COMPATIBLE=yes"
log "MICROSOFT_WRITE_EXECUTED=False"
log "PRODUCTION_EXECUTED=False"
log "PROPAGATION_EXECUTED=False"

if [[ -d ".venv" ]]; then
  if [[ -f ".venv/bin/activate" ]]; then
    VENV_ACTIVATE_SCRIPT=".venv/bin/activate"
  elif [[ -f ".venv/Scripts/activate" ]]; then
    VENV_ACTIVATE_SCRIPT=".venv/Scripts/activate"
  else
    fail "VENV_ACTIVATE_SCRIPT_MISSING"
  fi

  # shellcheck disable=SC1091
  source "$VENV_ACTIVATE_SCRIPT"
  log "VENV_ACTIVATED=yes"
else
  log "VENV_ACTIVATION_SKIPPED=no_venv_present"
fi

python -m unittest discover -s apps/sdu-agent-runtime/tests
git diff --check

if ! command -v pwsh >/dev/null 2>&1; then
  log "PWSH_PRECHECK=missing"
  log "POWERSHELL_VALIDATORS_SKIPPED=pwsh_missing"
  if [[ "${CABINA_REQUIRE_PWSH_VALIDATORS:-false}" == "true" ]]; then
    fail "PWSH_MISSING_FOR_VALIDATORS"
  fi
  exit 0
fi
log "PWSH_PRECHECK=yes"

pwsh -NoProfile -File .agents/codex/tools/local_validate_operational_chain.ps1
pwsh -NoProfile -File .agents/codex/tools/local_validate_capability_use_hardening.ps1
pwsh -NoProfile -File .agents/codex/tools/local_validate_change_aware_full_coverage_orchestrator.ps1

if [[ "$RUN_FULL_COVERAGE" == "true" ]]; then
  pwsh -NoProfile -File .agents/codex/tools/local_run_change_aware_full_coverage_orchestrator.ps1 \
    -BuildPlan \
    -ExecutePlan \
    -VerifyCoverageEquivalence \
    -EmitAuditArtifact \
    -UseWorkingTreeChanges
fi
