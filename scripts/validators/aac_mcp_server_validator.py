from sdu_runtime_common import main_guard, read_csv, read_json, read_text, require_files


def validate() -> None:
    require_files(
        [
            "aac-mcp-server/package.json",
            "aac-mcp-server/README.md",
            "aac-mcp-server/src/index.mjs",
            "aac-mcp-server/tests/mock_mcp_flow.mjs",
            ".vscode/mcp.json",
            ".agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv",
            ".agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv",
            ".agents/codex/matrices/CABINA_GOVERNANCE_AGENTS_FOR_VSI_20260608.csv",
        ]
    )

    package = read_json("aac-mcp-server/package.json")
    if package["name"] != "aac-mcp-server":
        raise AssertionError("AAC MCP package name mismatch")
    if package["scripts"]["test"] != "node tests/mock_mcp_flow.mjs":
        raise AssertionError("AAC MCP test script mismatch")
    if package.get("dependencies") != {}:
        raise AssertionError("AAC MCP server must stay dependency-free for local activation")

    mcp_config = read_json(".vscode/mcp.json")
    server = mcp_config.get("servers", {}).get("aac-direct")
    if not server:
        raise AssertionError(".vscode/mcp.json missing aac-direct server")
    if server.get("type") != "stdio" or server.get("command") != "node":
        raise AssertionError("aac-direct must be local stdio node server")
    args = server.get("args", [])
    if "${workspaceFolder}/aac-mcp-server/src/index.mjs" not in args:
        raise AssertionError("aac-direct must point to repo-local AAC MCP server")
    env = server.get("env", {})
    if env.get("AAC_MCP_REPO_ROOT") != "${workspaceFolder}":
        raise AssertionError("aac-direct must set AAC_MCP_REPO_ROOT to workspace")

    source = read_text("aac-mcp-server/src/index.mjs")
    for token in (
        "aac_list_native_agents",
        "aac_get_board_context",
        "aac_get_extension_capabilities",
        "aac_prepare_native_invocation",
        "aac_write_artifact_gated",
        "ALLOWED_WRITE_TARGETS",
        "target_path",
        "owner",
        "rollback",
        "postcheck",
        "gate",
        "APPROVED_EXPLICIT",
        "PENDING_APPROVAL_ONLY",
        "direct_invocation_from_codex: false",
        "PREPARED_NOT_EXECUTED",
        "EXECUTED_LOCAL_WRITE",
        "tools/list",
        "tools/call",
        "fs.existsSync",
        "AAC_MCP_FORCE_MATRIX_FALLBACK",
        "repo_local_aac_native_agents_matrix_fallback",
        "local_extension_path_unavailable",
        "extension_package_available",
        "capabilities_source",
    ):
        if token not in source:
            raise AssertionError(f"AAC MCP source missing {token}")
    forbidden = ("exec(", "spawn(", "OPENAI_API_KEY", "MICROSOFT_CLIENT_SECRET", "fetch(", "https://", "Authorization")
    for token in forbidden:
        if token in source:
            raise AssertionError(f"AAC MCP source must not contain live or process token {token}")

    native_agents = read_csv(".agents/codex/matrices/AAC_NATIVE_AGENTS_20260608.csv")
    if len(native_agents) != 21:
        raise AssertionError("AAC native roster must contain 21 agents")
    if any(row.get("activation_status") != "ACTIVE_AAC_NATIVE_TEAM_GOVERNED" for row in native_agents):
        raise AssertionError("All AAC native agents must be active governed team")
    if any(row.get("direct_invocation_from_codex") != "false" for row in native_agents):
        raise AssertionError("AAC native roster must not claim direct Codex invocation")

    native_use = read_csv(".agents/codex/matrices/AAC_NATIVE_AGENT_USE_FOR_VSI_20260608.csv")
    if len(native_use) != 6:
        raise AssertionError("AAC native use matrix must contain EPIC-6 plus five S-6 rows")
    if any(row.get("status") != "ACTIVE_AAC_NATIVE_TEAM_GOVERNED" for row in native_use):
        raise AssertionError("AAC native use rows must be active governed team")
    if any(row.get("callable_from_codex_now") != "NO_DISPONIBLE_DIRECT_EXTENSION_CALL" for row in native_use):
        raise AssertionError("AAC native use must keep direct extension-call boundary")


if __name__ == "__main__":
    main_guard("AAC_MCP_SERVER_VALIDATOR", validate)
