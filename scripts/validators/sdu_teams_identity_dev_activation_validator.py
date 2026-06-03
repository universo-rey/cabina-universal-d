from __future__ import annotations

import re

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_json,
    read_text,
    require_columns,
    require_files,
    require_no_live,
    require_no_materialized_sensitive_values,
    require_statuses,
)


FILES = [
    "governance/teams/SDU_TEAMS_IDENTITY_DEV_ACTIVATION_PLAN_20260603.md",
    "governance/teams/SDU_TEAMS_IDENTITY_DEV_TARGET_MATRIX_20260603.csv",
    "governance/teams/SDU_TEAMS_APP_REGISTRATION_CONTRACT_20260603.md",
    "governance/teams/SDU_TEAMS_FIRST_INTERNAL_MESSAGE_TEST_PLAN_20260603.md",
    "teams-app/sdu-agent-chat/dev-package/README.md",
    "teams-app/sdu-agent-chat/dev-package/manifest.dev.template.json",
]

UUID_RE = re.compile(r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b")
TENANT_RE = re.compile(r"(?i)\b[a-z0-9-]+\.onmicrosoft\.com\b")


def assert_no_real_identifiers(path: str) -> None:
    text = read_text(path)
    if UUID_RE.search(text):
        raise AssertionError(f"{path} contains real-looking GUID")
    if TENANT_RE.search(text):
        raise AssertionError(f"{path} contains real-looking tenant domain")


def validate() -> None:
    require_files(FILES)
    manifest = read_json("teams-app/sdu-agent-chat/dev-package/manifest.dev.template.json")
    if manifest["name"]["short"] != "Seshat SDU Agent":
        raise AssertionError("Teams DEV app name must be Seshat SDU Agent")
    if manifest["id"] != "[TEAMS_APP_ID]":
        raise AssertionError("Teams app id must remain placeholder")
    if manifest["bots"][0]["botId"] != "[BOT_ID]":
        raise AssertionError("Teams bot id must remain placeholder")
    if manifest["webApplicationInfo"]["id"] != "[ENTRA_APP_ID]":
        raise AssertionError("Entra app id must remain placeholder")
    if "[DEV_TUNNEL_OR_HOST]" not in manifest["validDomains"]:
        raise AssertionError("DEV host placeholder missing from validDomains")

    matrix_path = "governance/teams/SDU_TEAMS_IDENTITY_DEV_TARGET_MATRIX_20260603.csv"
    rows = read_csv(matrix_path)
    require_columns(
        rows,
        [
            "target_id",
            "target_surface",
            "identity_placeholder",
            "owner_agent",
            "action_to_prepare",
            "live_write_allowed",
            "requires_human_approval",
            "rollback",
            "postcheck",
            "evidence",
            "validator",
            "status",
        ],
        matrix_path,
    )
    require_no_live(rows, matrix_path)
    require_statuses(rows, {"DEV_TEMPLATE_READY", "READY_FOR_HUMAN_APPROVAL"}, matrix_path)
    expected_placeholders = {"[TEAMS_APP_ID]", "[BOT_ID]", "[ENTRA_APP_ID]", "[TENANT_ID]", "[TARGET_CHAT_OR_CHANNEL_ID]"}
    actual_placeholders = {row["identity_placeholder"] for row in rows}
    if actual_placeholders != expected_placeholders:
        raise AssertionError(f"unexpected Teams DEV placeholders: {sorted(actual_placeholders)}")
    for row in rows:
        if row["live_write_allowed"] != "false":
            raise AssertionError(f"{row['target_id']} allows live writes")
        if row["requires_human_approval"] != "yes":
            raise AssertionError(f"{row['target_id']} must require human approval")
        require_files([row["evidence"], row["validator"]])

    plan = read_text("governance/teams/SDU_TEAMS_IDENTITY_DEV_ACTIVATION_PLAN_20260603.md")
    for token in ["no tenant install", "no live message execution"]:
        if token in plan.lower():
            raise AssertionError(f"plan uses stale wording token {token}")
    for token in [
        "Teams app install",
        "Teams message real",
        "Microsoft Graph write",
        "OpenAI live",
        "Codex Cloud apply",
        "SECRET_DETECTED",
    ]:
        if token not in plan:
            raise AssertionError(f"plan missing boundary token {token}")

    test_plan = read_text("governance/teams/SDU_TEAMS_FIRST_INTERNAL_MESSAGE_TEST_PLAN_20260603.md")
    if "sin enviar ningun mensaje real" not in test_plan:
        raise AssertionError("first internal message plan must stay dry-run")

    for path in FILES:
        assert_no_real_identifiers(path)
    require_no_materialized_sensitive_values(FILES)


if __name__ == "__main__":
    main_guard("SDU_TEAMS_IDENTITY_DEV_ACTIVATION_VALIDATOR", validate)
