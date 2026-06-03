from sdu_runtime_common import main_guard, read_csv, read_json, require_columns, require_files, require_no_live


def validate() -> None:
    require_files(
        [
            "governance/teams/SDU_AGENTS_TEAMS_CHAT_IDENTITY_MODEL_20260603.md",
            "governance/teams/SDU_AGENT_TEAMS_CHAT_ROUTING_MATRIX_20260603.csv",
            "teams-app/sdu-agent-chat/README.md",
            "teams-app/sdu-agent-chat/manifest.template.json",
            "teams-app/sdu-agent-chat/bot/package.json",
            "teams-app/sdu-agent-chat/bot/src/index.ts",
            "teams-app/sdu-agent-chat/bot/src/sduRouter.ts",
            "teams-app/sdu-agent-chat/bot/src/governance.ts",
            "teams-app/sdu-agent-chat/contracts/activity.contract.json",
            "teams-app/sdu-agent-chat/schemas/teams-command.schema.json",
            "teams-app/sdu-agent-chat/schemas/sdu-agent-chat-evidence.schema.json",
            "teams-app/sdu-agent-chat/matrices/permissions_matrix.csv",
            "teams-app/sdu-agent-chat/matrices/install_scope_matrix.csv",
        ]
    )

    manifest = read_json("teams-app/sdu-agent-chat/manifest.template.json")
    if manifest["id"] != "{{TEAMS_APP_ID_GUID}}":
        raise AssertionError("Teams app id must stay placeholder")
    bot = manifest["bots"][0]
    if bot["botId"] != "{{BOT_APP_ID_GUID}}":
        raise AssertionError("Teams bot id must stay placeholder")
    if set(bot["scopes"]) != {"personal", "team"}:
        raise AssertionError("Teams bot scopes must be personal and team templates")
    if "localhost" not in manifest["validDomains"]:
        raise AssertionError("Teams manifest must include localhost for DEV")

    routes_path = "governance/teams/SDU_AGENT_TEAMS_CHAT_ROUTING_MATRIX_20260603.csv"
    routes = read_csv(routes_path)
    require_columns(routes, ["route_id", "input_surface", "assigned_agent", "blocked_actions", "evidence", "validator", "status"], routes_path)
    require_no_live(routes, routes_path)
    for row in routes:
        require_files([row["evidence"], row["validator"]])
        if row["status"] != "ACTIVE_DEV":
            raise AssertionError(f"{row['route_id']} must be ACTIVE_DEV")
        if "send" not in row["blocked_actions"] and "graph" not in row["blocked_actions"]:
            raise AssertionError(f"{row['route_id']} missing Teams live block")

    permissions = read_csv("teams-app/sdu-agent-chat/matrices/permissions_matrix.csv")
    if not any(row["permission_type"] == "graph_write" and row["status"] == "BLOCKED" for row in permissions):
        raise AssertionError("Graph write permission row must be blocked")


if __name__ == "__main__":
    main_guard("SDU_TEAMS_CHAT_IDENTITY_VALIDATOR", validate)
