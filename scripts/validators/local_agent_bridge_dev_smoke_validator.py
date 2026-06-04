from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


READBACK = "readbacks/20260603_LOCAL_AGENT_BRIDGE_DEV_SMOKE_READBACK.md"


def validate() -> None:
    require_files([READBACK])
    text = read_text(READBACK)
    for token in [
        "LOCAL_AGENT_BRIDGE_DEV_SMOKE_EXECUTED_PASS",
        "127.0.0.1:8787",
        "route id: `teams.route.codex_cloud`",
        "evidence sanitized: `true`",
        "El proceso local fue detenido",
    ]:
        if token not in text:
            raise AssertionError(f"Local bridge readback missing {token}")
    require_no_materialized_sensitive_values([READBACK])


if __name__ == "__main__":
    main_guard("LOCAL_AGENT_BRIDGE_DEV_SMOKE_VALIDATOR", validate)
