from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


CONTRACT = "governance/connections/SDU_AGENT_CONNECTION_SECRETS_VARIABLES_CONTRACT_20260603.md"


def validate() -> None:
    require_files([CONTRACT])
    text = read_text(CONTRACT)
    required_names = [
        "SDU_BRIDGE_BIND_HOST",
        "SDU_BRIDGE_PORT",
        "TEAMS_APP_ID_GUID",
        "BOT_APP_ID_GUID",
        "OPENAI_API_KEY_OPTIONAL_LIVE_GATE",
        "CODEX_CLOUD_ENVIRONMENT_NAME",
    ]
    for name in required_names:
        if name not in text:
            raise AssertionError(f"contract missing variable name {name}")
    if "external governed store" not in text:
        raise AssertionError("contract must require external governed storage for live values")
    require_no_materialized_sensitive_values([CONTRACT])


if __name__ == "__main__":
    main_guard("SDU_AGENT_CONNECTION_VARIABLES_CONTRACT_VALIDATOR", validate)
