from __future__ import annotations

from datetime import datetime, timezone


def trace_event(agent_id: str, decision: str) -> dict:
    return {
        "agent_id": agent_id,
        "decision": decision,
        "timestamp_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "trace_sink": "local_in_memory",
    }
