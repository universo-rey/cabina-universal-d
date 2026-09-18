from __future__ import annotations

import csv
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
UUID_RE = re.compile(r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b")


def read_csv(path: str) -> list[dict[str, str]]:
    with (ROOT / path).open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def main() -> None:
    manifest_path = ROOT / "teams-app/sdu-agent-chat/dev-package/manifest.dev.template.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest["id"] != "[TEAMS_APP_ID]":
        raise SystemExit("Teams app id must remain a placeholder")
    if manifest["bots"][0]["botId"] != "[BOT_ID]":
        raise SystemExit("Bot id must remain a placeholder")
    if manifest["name"]["short"] != "Seshat SDU Agent":
        raise SystemExit("Unexpected Teams app name")

    bridge = (ROOT / "local-agent-bridge/dev.activation.contract.yml").read_text(encoding="utf-8")
    for token in [
        'bind: "127.0.0.1"',
        "public_bind_allowed: false",
        "full_filesystem_access: false",
        "token_value_in_repo: false",
        "live_enabled: false",
        "writes_allowed: false",
    ]:
        if token not in bridge:
            raise SystemExit(f"Bridge contract missing {token}")
    for forbidden in ["live_enabled: true", "writes_allowed: true", "public_bind_allowed: true"]:
        if forbidden in bridge:
            raise SystemExit(f"Bridge contract enables forbidden surface: {forbidden}")

    teams_rows = read_csv("governance/teams/SDU_TEAMS_IDENTITY_DEV_TARGET_MATRIX_20260603.csv")
    mcp_rows = read_csv("governance/connections/MCP_DEV_ACTIVATION_MATRIX_20260603.csv")
    if not teams_rows or not mcp_rows:
        raise SystemExit("DEV activation matrices must not be empty")
    if any(row["live_write_allowed"] != "false" for row in teams_rows):
        raise SystemExit("Teams DEV matrix must keep live writes disabled")
    if any(row["write_scope"] != "none" and row["requires_approval"] != "yes" for row in mcp_rows):
        raise SystemExit("MCP write scope must require approval")

    combined = "\n".join(
        [
            manifest_path.read_text(encoding="utf-8"),
            bridge,
            (ROOT / "governance/teams/SDU_TEAMS_APP_REGISTRATION_CONTRACT_20260603.md").read_text(encoding="utf-8"),
        ]
    )
    if UUID_RE.search(combined):
        raise SystemExit("Real-looking GUID detected in DEV activation package")

    print("SDU_DEV_ACTIVATION_CONTRACT_TEST_PASS")


if __name__ == "__main__":
    main()
