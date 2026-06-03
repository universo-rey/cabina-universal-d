#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_ID="codex_cloud_full_live_governed_setup"
EXPECTED_REPO="universo-rey/cabina-universal-d"
RUN_OPENAI_SMOKE="false"

usage() {
  cat <<'USAGE'
codex_cloud_full_live_governed_setup.sh [--run-openai-smoke]

Prepares and verifies the PR #56 full-live governed gate in a repo-scoped
Codex Cloud or local shell context.

Default behavior is non-live:
- verify repo identity
- verify required files are present
- create or reuse .venv
- install/upgrade openai and openai-agents inside .venv
- verify Python imports for openai and agents
- never print or persist secrets

Optional:
--run-openai-smoke  Run governed synthetic OpenAI models.list, Responses API
                    and Agents SDK Runner smokes without printing response
                    bodies. Requires OPENAI_API_KEY already present in the
                    process environment.
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
    --run-openai-smoke)
      RUN_OPENAI_SMOKE="true"
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

required_files=(
  ".agents/codex/scripts/codex_cloud_full_live_governed_setup.sh"
  ".agents/codex/scripts/codex_cloud_full_live_governed_maintenance.sh"
  "apps/sdu-agent-runtime/README.md"
  "governance/agents/AGENTS_SDK_BASELINE_POLICY.md"
  "governance/agents/AGENTS_SDK_AGENT_REGISTRY.md"
  ".agents/codex/readbacks/2026-06-03_full_live_governed_activation_readback.md"
)

for path in "${required_files[@]}"; do
  [[ -f "$path" ]] || fail "missing_required_file=$path"
done

if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="${PYTHON_BIN:-python3}"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="${PYTHON_BIN:-python}"
else
  fail "PYTHON_MISSING_FOR_SETUP"
fi

if [[ ! -d ".venv" ]]; then
  "$PYTHON_BIN" -m venv .venv
  log "VENV_CREATED=yes"
else
  log "VENV_REUSED=yes"
fi

# shellcheck disable=SC1091
source ".venv/bin/activate"

python -m pip install --upgrade pip setuptools wheel
python -m pip install --upgrade openai openai-agents

log "SETUP_SCRIPT_SELF_SUFFICIENT=yes"
log "DEPENDENCY_INSTALL=openai|openai-agents"

python - <<'PY'
import importlib.metadata
import openai  # noqa: F401
import agents  # noqa: F401

print("IMPORT_OPENAI=PASS")
print("IMPORT_AGENTS=PASS")
print("openai_version=" + importlib.metadata.version("openai"))
print("openai_agents_version=" + importlib.metadata.version("openai-agents"))
print("SECRETS_PRINTED=False")
PY

log "SCRIPT_ID=$SCRIPT_ID"
log "REPO=$EXPECTED_REPO"
log "SDU_TRIAGE_AGENT_IMPLEMENTATION=local_no_live"
log "LIVE_RUNTIME_VALIDATION=external_governed_smoke"
log "SETUP_SCRIPT_VERSIONED=yes"
log "MAINTENANCE_SCRIPT_VERSIONED=yes"
log "SETUP_SCRIPT_SELF_SUFFICIENT=yes"
log "DEPENDENCY_INSTALL=openai|openai-agents"
log "MICROSOFT_WRITE_EXECUTED=False"
log "PRODUCTION_EXECUTED=False"
log "PROPAGATION_EXECUTED=False"

if [[ "$RUN_OPENAI_SMOKE" != "true" ]]; then
  log "OPENAI_LIVE_SMOKE_SKIPPED=default_non_live_mode"
  exit 0
fi

python - <<'PY'
import asyncio
import os

if not os.environ.get("OPENAI_API_KEY"):
    raise SystemExit("OPENAI_API_KEY_MISSING")

from openai import OpenAI
from agents import Agent, Runner

client = OpenAI()
models_page = client.models.list()
model_ids = {item.id for item in models_page.data}
print("OPENAI_MODELS_LIST_SMOKE=PASS")
print("OPENAI_MODELS_LIST_BODY_PRINTED=False")

preferred = []
if os.environ.get("OPENAI_SMOKE_MODEL"):
    preferred.append(os.environ["OPENAI_SMOKE_MODEL"])
preferred.extend(["gpt-5.5", "gpt-5-mini", "gpt-5", "gpt-4.1-mini", "gpt-4o-mini"])
model = next((candidate for candidate in preferred if candidate in model_ids), None)
if model is None:
    raise SystemExit("NO_PREFERRED_SMOKE_MODEL_AVAILABLE")
print("OPENAI_SMOKE_MODEL=" + model)

response = client.responses.create(
    model=model,
    input="Synthetic cabina setup smoke. Reply with exactly CABINA_SETUP_SMOKE_PASS.",
    max_output_tokens=16,
)
print("RESPONSES_API_LIVE_SMOKE=PASS")
print("RESPONSES_BODY_PRINTED=False")
print("RESPONSES_ID_PRESENT=" + str(bool(getattr(response, "id", None))))

async def main() -> None:
    agent = Agent(
        name="cabina-full-live-governed-setup-smoke",
        instructions="Return exactly CABINA_AGENT_SETUP_SMOKE_PASS for this synthetic smoke.",
        model=model,
    )
    result = await Runner.run(agent, "Synthetic setup smoke only. No tools. No external writes.")
    print("AGENTS_SDK_RUNNER_LIVE_SMOKE=PASS")
    print("AGENTS_RUNNER_BODY_PRINTED=False")
    print("AGENTS_FINAL_OUTPUT_PRESENT=" + str(bool(getattr(result, "final_output", None))))
    print("AGENTS_LAST_AGENT_NAME=" + getattr(result.last_agent, "name", "UNKNOWN"))

asyncio.run(main())
PY
