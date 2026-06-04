from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


READBACK = "readbacks/20260603_MCP_DEV_READONLY_PROBES_READBACK.md"


def validate() -> None:
    require_files([READBACK])
    text = read_text(READBACK)
    for token in [
        "MCP_DEV_READONLY_PROBES_PARTIAL_PASS",
        "mcp.local.bridge.dev",
        "mcp.teams.dev",
        "mcp.codex.cloud.dev",
        "no Teams message",
        "no Graph write",
        "no OpenAI live",
        "no Codex Cloud apply",
    ]:
        if token not in text:
            raise AssertionError(f"MCP readback missing {token}")
    require_no_materialized_sensitive_values([READBACK])


if __name__ == "__main__":
    main_guard("MCP_DEV_READONLY_PROBES_VALIDATOR", validate)
