from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_text,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


MATRIX = "governance/teams/SDU_TEAMS_DEV_LIVE_OPTION_RESOLUTION_MATRIX_20260603.csv"
READBACK = "readbacks/20260603_SDU_TEAMS_APP_BOT_DEV_ACTIVATION_READBACK.md"


def validate() -> None:
    require_files([MATRIX, READBACK])
    rows = read_csv(MATRIX)
    require_columns(
        rows,
        [
            "option_id",
            "surface",
            "target",
            "tool",
            "live_result",
            "status",
            "evidence",
            "rollback",
            "postcheck",
            "stop_condition",
        ],
        MATRIX,
    )
    expected = {
        "copilot.seshat_normativa",
        "entra.sdu_cn_seshat_connector",
        "user.efigueroa",
        "user.seshat",
        "teams.connector.codex",
        "graph.azure_cli_chat",
        "graph.azure_cli_chat_token",
        "graph.seshat_app_device_auth",
        "teams.existing_channel",
        "teams.create_chat",
        "cdf.collaboration_notifier",
        "cdf.escribania_operations_channel",
        "local.bridge.dev",
        "agents.sdk.local",
        "codex.cloud.history",
    }
    actual = {row["option_id"] for row in rows}
    if actual != expected:
        raise AssertionError(f"unexpected option ids: {sorted(actual)}")

    by_id = {row["option_id"]: row for row in rows}
    if by_id["entra.sdu_cn_seshat_connector"]["status"] != "LIVE_READ_CONFIRMED":
        raise AssertionError("Entra app must be live read confirmed")
    if by_id["copilot.seshat_normativa"]["status"] != "EXECUTED_PREVIOUSLY_VERIFIED_TGE":
        raise AssertionError("Copilot evidence must acknowledge prior TGE execution")
    if by_id["teams.connector.codex"]["status"] != "BLOCKED_TENANT_CONTEXT_MISMATCH":
        raise AssertionError("generic Teams connector must remain blocked by tenant context")
    if by_id["graph.azure_cli_chat_token"]["status"] != "BLOCKED_PREAUTH_CONSENT_REQUIRED":
        raise AssertionError("Azure CLI chat token must record preauthorization/consent blocker")
    if by_id["cdf.collaboration_notifier"]["status"] != "REFERENCE_PATTERN_ONLY":
        raise AssertionError("CDF notifier must stay reference-only without exact destination")

    text = read_text(READBACK)
    for token in [
        "SDU-CN Seshat Teams Connector Pilot",
        "APP_EXISTS_ENABLED",
        "Seshat Normativa",
        "no se envio mensaje Teams",
        "no se creo client secret",
        "Referencia CDF",
    ]:
        if token not in text:
            raise AssertionError(f"readback missing {token}")
    require_no_materialized_sensitive_values([MATRIX, READBACK])


if __name__ == "__main__":
    main_guard("SDU_TEAMS_APP_BOT_DEV_ACTIVATION_VALIDATOR", validate)
