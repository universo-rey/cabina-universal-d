#!/usr/bin/env sh
set -eu

python scripts/validators/sdu_codex_cloud_assignment_validator.py
python tests/sdu-agent-runtime/simulate_sdu_agent_chat_to_tool_to_readback.py
git diff --check
