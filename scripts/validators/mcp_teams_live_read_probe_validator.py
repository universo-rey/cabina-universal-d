from __future__ import annotations

import json
import re

from sdu_runtime_common import main_guard, read_json, read_text, require_files


FILES = [
    "scripts/connections/mcp_teams_live_read_probe.py",
    "readbacks/20260603_MCP_TEAMS_LIVE_READ_PROBE_READBACK.md",
    "readbacks/20260603_MCP_TEAMS_CANON_ACTIVE_RECONCILIATION_READBACK.md",
]
EVIDENCE = "readbacks/20260603_MCP_TEAMS_LIVE_READ_PROBE_EVIDENCE.json"


def validate() -> None:
    require_files(FILES + [EVIDENCE])
    script = read_text("scripts/connections/mcp_teams_live_read_probe.py")
    readback = read_text("readbacks/20260603_MCP_TEAMS_LIVE_READ_PROBE_READBACK.md")
    final_readback = read_text("readbacks/20260603_MCP_TEAMS_CANON_ACTIVE_RECONCILIATION_READBACK.md")
    evidence = read_json(EVIDENCE)

    for arg in [
        "--dry-run",
        "--handshake",
        "--list-tools",
        "--target-tenant-label",
        "--connection-id",
        "--auth-companion-id",
        "--no-body-print",
        "--evidence-out",
    ]:
        if arg not in script:
            raise AssertionError(f"probe script missing argument {arg}")

    for token in [
        "conn_canon_003505",
        "conn_canon_003503",
        "conn_canon_004172",
        "mcp_TeamsServer",
        "Tools.ListInvoke.All",
        "TOKEN_PRINT_ATTEMPTED",
        "NEW_CANONICAL_ID_FOR_EXISTING_MCP_TEAMS",
    ]:
        if token not in script + readback + final_readback:
            raise AssertionError(f"missing token {token}")

    blocked_patterns = [
        r"print\([^)]*token",
        r"print\([^)]*body",
        r"response\.read\(\)\.decode",
    ]
    for pattern in blocked_patterns:
        if re.search(pattern, script, flags=re.IGNORECASE):
            raise AssertionError(f"script may print token/body: {pattern}")

    if evidence.get("connection_id") != "conn_canon_003505":
        raise AssertionError("evidence must use conn_canon_003505")
    if evidence.get("auth_companion_id") not in {"conn_canon_003503", "conn_canon_004172"}:
        raise AssertionError("evidence missing auth companion")
    if evidence.get("no_body_print") is not True:
        raise AssertionError("evidence must record no_body_print=true")
    if evidence.get("final_status") not in {
        "PENDING_SECRET_ONLY",
        "PENDING_TENANT_ONLY",
        "PENDING_AUTH_PROFILE_ONLY",
        "HANDSHAKE_EXECUTED_PASS",
        "HANDSHAKE_EXECUTED_FAIL",
        "LIST_TOOLS_EXECUTED_PASS",
        "AUTH_READY",
    }:
        raise AssertionError(f"unexpected evidence final status: {evidence.get('final_status')}")
    for action in ["teams_message_send", "graph_write", "token_print", "response_body_print"]:
        if action not in evidence.get("blocked_actions", []):
            raise AssertionError(f"evidence missing blocked action {action}")


if __name__ == "__main__":
    main_guard("MCP_TEAMS_LIVE_READ_PROBE_VALIDATOR", validate)
