from __future__ import annotations

import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read_csv(path: str) -> list[dict[str, str]]:
    with (ROOT / path).open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def select_route(text: str) -> str:
    lowered = text.lower()
    if "codex cloud" in lowered:
        return "teams.route.codex_cloud"
    if "mcp" in lowered or "tool" in lowered:
        return "teams.route.mcp"
    if "readback" in lowered or "evidence" in lowered:
        return "teams.route.evidence"
    return "teams.route.triage"


def main() -> None:
    activity = json.loads((ROOT / "tests/sdu-agent-runtime/fixtures/mock_teams_activity.json").read_text(encoding="utf-8"))
    if activity["synthetic"] is not True or activity["channel"] != "msteams":
        raise SystemExit("fixture must be synthetic Teams activity")

    route_id = select_route(activity["text"])
    routes = {row["route_id"]: row for row in read_csv("governance/teams/SDU_AGENT_TEAMS_CHAT_ROUTING_MATRIX_20260603.csv")}
    route = routes[route_id]

    unified_rows = read_csv("governance/agents/SDU_AGENT_TEAMS_MCP_CODEX_CLOUD_MATRIX_20260603.csv")
    lane = next(row for row in unified_rows if row["teams_route"] == route_id)

    registry = {row["connection_id"]: row for row in read_csv("governance/connections/MCP_CONNECTION_REGISTRY_20260603.csv")}
    connection = registry[lane["mcp_connection"]]

    evidence = {
        "evidence_id": "sdu-e2e-synthetic-20260603",
        "route_id": route_id,
        "assigned_agent": route["assigned_agent"],
        "gate_agent": route["gate_agent"],
        "mcp_connection": connection["connection_id"],
        "codex_cloud_assignment": lane["codex_cloud_assignment"],
        "live_executed": False,
        "sanitized": True,
        "blocked_surfaces": [
            "teams_send",
            "graph_write",
            "openai_live",
            "codex_cloud_apply",
            "production"
        ],
        "next_gate": "human_review_before_live"
    }

    if evidence["live_executed"] is not False:
        raise SystemExit("live execution flag must stay false")
    if connection["status"] not in {"TEMPLATE_ONLY", "CONTRACT_ONLY", "ACTIVE_MOCK", "ACTIVE_GOVERNED"}:
        raise SystemExit("unexpected MCP connection status")

    print(json.dumps({"status": "PASS", "evidence": evidence}, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
