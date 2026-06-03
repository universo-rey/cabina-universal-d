from __future__ import annotations

import re

from sdu_runtime_common import main_guard, read_text, require_files


ALLOWED_CANON_IDS = {
    "conn_canon_003503",
    "conn_canon_003504",
    "conn_canon_003505",
    "conn_canon_003736",
    "conn_canon_004172",
    "conn_canon_004173",
}

FILES = [
    "governance/connections/MCP_TEAMS_CANON_RECONCILIATION_REPORT_20260603.md",
    "governance/connections/MCP_TEAMS_CANON_POINTER_20260603.md",
]


def validate() -> None:
    require_files(FILES)
    combined = "\n".join(read_text(path) for path in FILES)

    for canon_id in ALLOWED_CANON_IDS:
        if canon_id not in combined:
            raise AssertionError(f"missing canonical id {canon_id}")

    found_ids = set(re.findall(r"conn_canon_\d{6}", combined))
    unexpected = found_ids - ALLOWED_CANON_IDS
    if unexpected:
        raise AssertionError(f"unexpected canonical ids: {sorted(unexpected)}")

    required_tokens = [
        "YA_CANONIZADO_NO_DUPLICAR",
        "mcp_TeamsServer",
        "HANDSHAKE_PASS_AUTH_REQUIRED",
        "SUPERSEDED_BY_CONNECTION_CANON",
        "NEW_CANONICAL_ID_FOR_EXISTING_MCP_TEAMS",
        "Teams",
        "Entra ID",
    ]
    for token in required_tokens:
        if token not in combined:
            raise AssertionError(f"missing token {token}")

    blocked_phrases = [
        "NEW_CONNECTION_CREATED",
        "create new canonical id",
        "crear nuevo canonical id",
    ]
    lowered = combined.lower()
    for phrase in blocked_phrases:
        if phrase.lower() in lowered and "no puede crear un nuevo canonical id" not in lowered:
            raise AssertionError(f"blocked duplicate phrase found: {phrase}")


if __name__ == "__main__":
    main_guard("MCP_TEAMS_CONNECTION_CANON_POINTER_VALIDATOR", validate)
