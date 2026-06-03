from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


READBACK = "readbacks/20260603_SDU_TEAMS_MCP_CODEX_CLOUD_DEV_LIVE_SMOKE_READBACK.md"


def validate() -> None:
    require_files([READBACK])
    text = read_text(READBACK)
    for token in [
        "SDU_TEAMS_MCP_CODEX_CLOUD_DEV_LIVE_SMOKE_PARTIAL_READY_FOR_REVIEW",
        "Seshat Normativa",
        "SDU-CN Seshat Teams Connector Pilot",
        "Local bridge DEV smoke: PASS",
        "Agents SDK import smoke",
        "CDF",
        "No se envio en esta pasada",
        "APP_DEVICE_AUTH_REQUIRED",
        "TARGET_CHAT_MISSING",
    ]:
        if token not in text:
            raise AssertionError(f"live smoke readback missing {token}")
    for forbidden in [
        "Teams message sent",
        "FIRST_TEAMS_MESSAGE_SENT",
        "Codex Cloud apply executed",
        "client secret created",
    ]:
        if forbidden in text:
            raise AssertionError(f"live smoke readback overclaims forbidden action: {forbidden}")
    require_no_materialized_sensitive_values([READBACK])


if __name__ == "__main__":
    main_guard("SDU_DEV_LIVE_SMOKE_READBACK_VALIDATOR", validate)
