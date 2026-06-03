from sdu_runtime_common import main_guard, read_json, read_text, require_files


SCHEMAS = [
    "governance/observability/runtime-event.schema.json",
    "governance/observability/tool-call.schema.json",
    "governance/observability/gate-decision.schema.json",
    "governance/observability/readback-evidence.schema.json",
    "local-agent-bridge/schemas/evidence.schema.json",
    "teams-app/sdu-agent-chat/schemas/sdu-agent-chat-evidence.schema.json",
]


def validate() -> None:
    require_files(
        [
            "governance/observability/SDU_AGENT_RUNTIME_EVIDENCE_MODEL_20260603.md",
            "readbacks/20260603_SDU_AGENT_RUNTIME_CONNECTIONS_TEAMS_CODEX_CLOUD_READBACK.md",
            *SCHEMAS,
        ]
    )
    for schema_path in SCHEMAS:
        schema = read_json(schema_path)
        if "required" not in schema:
            raise AssertionError(f"{schema_path} missing required fields")
        if "live_executed" in schema.get("properties", {}):
            live_prop = schema["properties"]["live_executed"]
            if live_prop.get("const") is not False:
                raise AssertionError(f"{schema_path} must require live_executed false")

    readback = read_text("readbacks/20260603_SDU_AGENT_RUNTIME_CONNECTIONS_TEAMS_CODEX_CLOUD_READBACK.md")
    for token in [
        "SDU_AGENTS_RUNTIME_CONNECTIONS_TEAMS_CHAT_CODEX_CLOUD_DEV_READY_FOR_REVIEW",
        "No Teams live install",
        "No material sensible",
        "rollback",
        "proximo gate",
    ]:
        if token not in readback:
            raise AssertionError(f"final readback missing {token}")


if __name__ == "__main__":
    main_guard("SDU_AGENT_RUNTIME_EVIDENCE_VALIDATOR", validate)
