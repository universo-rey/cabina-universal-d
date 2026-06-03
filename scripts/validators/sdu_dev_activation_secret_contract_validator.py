from __future__ import annotations

import re

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


CHECKLIST = "governance/connections/SDU_DEV_ACTIVATION_SECRETS_CHECKLIST_20260603.md"
SCAN_FILES = [
    CHECKLIST,
    "governance/teams/SDU_TEAMS_APP_REGISTRATION_CONTRACT_20260603.md",
    "teams-app/sdu-agent-chat/dev-package/manifest.dev.template.json",
    "local-agent-bridge/dev.activation.contract.yml",
]

ASSIGNMENT_RE = re.compile(r"(?i)\b(api[_-]?key|secret|password)\s*[:=]\s*['\"]?[^\s\]\[]+")
LIVE_KEY_RE = re.compile(r"sk-[A-Za-z0-9]{20,}")


def validate() -> None:
    require_files(SCAN_FILES)
    checklist = read_text(CHECKLIST)
    required_names = [
        "TEAMS_APP_ID",
        "BOT_ID",
        "ENTRA_APP_ID",
        "TENANT_ID",
        "BOT_ENDPOINT",
        "DEV_TUNNEL_OR_HOST",
        "LOCAL_BRIDGE_TOKEN_REFERENCE",
        "CODEX_CLOUD_ENVIRONMENT_NAME",
        "OPENAI_API_KEY_OPTIONAL_LIVE_GATE",
    ]
    for name in required_names:
        if name not in checklist:
            raise AssertionError(f"checklist missing {name}")
    for token in ["external governed store", "Verify existence without printing values", "not used in this gate"]:
        if token not in checklist:
            raise AssertionError(f"checklist missing rule {token}")

    require_no_materialized_sensitive_values(SCAN_FILES)
    for path in SCAN_FILES:
        text = read_text(path)
        if LIVE_KEY_RE.search(text):
            raise AssertionError(f"live OpenAI-looking key detected in {path}")
        if ASSIGNMENT_RE.search(text):
            raise AssertionError(f"sensitive assignment detected in {path}")


if __name__ == "__main__":
    main_guard("SDU_DEV_ACTIVATION_SECRET_CONTRACT_VALIDATOR", validate)
