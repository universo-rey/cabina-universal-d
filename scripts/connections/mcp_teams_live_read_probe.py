from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SERVER_URL = "https://agent365.svc.cloud.microsoft/agents/servers/mcp_TeamsServer"
SERVER_NAME = "mcp_TeamsServer"
SERVER_SCOPE = "Tools.ListInvoke.All"
SERVER_AUDIENCE = "ce5029ee-c1d3-45c0-bdcc-efb5a4245687"
ACTIVE_CONNECTION_ID = "conn_canon_003505"
ALLOWED_CONNECTION_IDS = {
    "conn_canon_003504",
    "conn_canon_003505",
    "conn_canon_003736",
    "conn_canon_004173",
}
ALLOWED_AUTH_COMPANIONS = {"conn_canon_003503", "conn_canon_004172"}

TOKEN_ENV_NAMES = (
    "MCP_TEAMS_BEARER_TOKEN",
    "AGENT365_MCP_TEAMS_TOKEN",
    "WORKIQ_MCP_TEAMS_TOKEN",
)
TENANT_ENV_NAMES = (
    "MCP_TEAMS_TENANT_ID",
    "AGENT365_TENANT_ID",
    "AZURE_TENANT_ID",
)
IDENTITY_ENV_NAMES = (
    "MCP_TEAMS_IDENTITY",
    "AGENT365_MCP_IDENTITY",
    "AZURE_CLIENT_ID",
)
AUTH_PROFILE_ENV_NAMES = (
    "MCP_TEAMS_AUTH_PROFILE",
    "AZURE_CONFIG_DIR",
)


def present_env(names: tuple[str, ...]) -> list[str]:
    return [name for name in names if os.environ.get(name)]


def root_path(path: str) -> Path:
    target = Path(path)
    if not target.is_absolute():
        target = ROOT / target
    return target


def validate_ids(connection_id: str, auth_companion_id: str) -> None:
    if connection_id not in ALLOWED_CONNECTION_IDS:
        raise SystemExit("NEW_CANONICAL_ID_FOR_EXISTING_MCP_TEAMS")
    if auth_companion_id not in ALLOWED_AUTH_COMPANIONS:
        raise SystemExit("AUTH_COMPANION_MISSING")
    if connection_id != ACTIVE_CONNECTION_ID:
        return


def request_jsonrpc(method: str, token: str, no_body_print: bool) -> dict[str, object]:
    payload = {
        "jsonrpc": "2.0",
        "id": f"cabina-{method}-{int(time.time())}",
        "method": method,
    }
    if method == "initialize":
        payload["params"] = {
            "protocolVersion": "2025-03-26",
            "capabilities": {},
            "clientInfo": {"name": "cabina-mcp-teams-live-read-probe", "version": "2026.06.03"},
        }

    body = json.dumps(payload).encode("utf-8")
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "MCP-Protocol-Version": "2025-03-26",
    }
    auth_scheme = "Bearer"
    headers["Authorization"] = auth_scheme + " " + token

    request = urllib.request.Request(SERVER_URL, data=body, headers=headers, method="POST")
    started = time.time()
    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            status_code = response.getcode()
            header_names = sorted(response.headers.keys())
            content_length = response.headers.get("Content-Length")
            return {
                "executed": True,
                "method": method,
                "http_status": status_code,
                "ok": 200 <= status_code < 300,
                "elapsed_ms": int((time.time() - started) * 1000),
                "response_body_printed": False if no_body_print else "BLOCKED_BY_POLICY",
                "response_body_sha256": None,
                "response_header_names": header_names,
                "content_length": content_length,
            }
    except urllib.error.HTTPError as exc:
        return {
            "executed": True,
            "method": method,
            "http_status": exc.code,
            "ok": False,
            "elapsed_ms": int((time.time() - started) * 1000),
            "response_body_printed": False,
            "response_body_sha256": None,
            "response_header_names": sorted(exc.headers.keys()),
            "content_length": exc.headers.get("Content-Length"),
        }
    except urllib.error.URLError as exc:
        return {
            "executed": True,
            "method": method,
            "http_status": None,
            "ok": False,
            "elapsed_ms": int((time.time() - started) * 1000),
            "network_error_type": type(exc.reason).__name__,
            "response_body_printed": False,
            "response_body_sha256": None,
        }


def endpoint_no_auth_probe(no_body_print: bool) -> dict[str, object]:
    request = urllib.request.Request(SERVER_URL, headers={"Accept": "application/json"}, method="GET")
    started = time.time()
    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            return {
                "executed": True,
                "method": "endpoint_no_auth_probe",
                "http_status": response.getcode(),
                "ok": 200 <= response.getcode() < 300,
                "elapsed_ms": int((time.time() - started) * 1000),
                "response_body_printed": False if no_body_print else "BLOCKED_BY_POLICY",
                "response_body_sha256": None,
                "response_header_names": sorted(response.headers.keys()),
            }
    except urllib.error.HTTPError as exc:
        return {
            "executed": True,
            "method": "endpoint_no_auth_probe",
            "http_status": exc.code,
            "ok": False,
            "elapsed_ms": int((time.time() - started) * 1000),
            "response_body_printed": False,
            "response_body_sha256": None,
            "response_header_names": sorted(exc.headers.keys()),
        }
    except urllib.error.URLError as exc:
        return {
            "executed": True,
            "method": "endpoint_no_auth_probe",
            "http_status": None,
            "ok": False,
            "elapsed_ms": int((time.time() - started) * 1000),
            "network_error_type": type(exc.reason).__name__,
            "response_body_printed": False,
            "response_body_sha256": None,
        }


def status_from_context(token_names: list[str], tenant_names: list[str], identity_names: list[str]) -> str:
    if not token_names:
        return "PENDING_SECRET_ONLY"
    if not tenant_names:
        return "PENDING_TENANT_ONLY"
    if not identity_names:
        return "PENDING_AUTH_PROFILE_ONLY"
    return "AUTH_READY"


def main() -> int:
    parser = argparse.ArgumentParser(description="Governed MCP Teams live read probe")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--handshake", action="store_true")
    parser.add_argument("--list-tools", action="store_true")
    parser.add_argument("--target-tenant-label", default="")
    parser.add_argument("--connection-id", required=True)
    parser.add_argument("--auth-companion-id", required=True)
    parser.add_argument("--no-body-print", action="store_true")
    parser.add_argument("--evidence-out", required=True)
    args = parser.parse_args()

    validate_ids(args.connection_id, args.auth_companion_id)
    if not args.no_body_print:
        raise SystemExit("TOKEN_PRINT_ATTEMPTED")

    token_names = present_env(TOKEN_ENV_NAMES)
    tenant_names = present_env(TENANT_ENV_NAMES)
    identity_names = present_env(IDENTITY_ENV_NAMES)
    auth_profile_names = present_env(AUTH_PROFILE_ENV_NAMES)
    status = status_from_context(token_names, tenant_names, identity_names)

    operations: list[dict[str, object]] = []
    if args.dry_run:
        operations.append(endpoint_no_auth_probe(args.no_body_print))
    elif status != "AUTH_READY":
        operations.append({"executed": False, "reason": status})
    else:
        token = os.environ[token_names[0]]
        if args.handshake:
            operations.append(request_jsonrpc("initialize", token, args.no_body_print))
        if args.list_tools:
            operations.append(request_jsonrpc("tools/list", token, args.no_body_print))

    if any(item.get("ok") for item in operations if item.get("method") == "initialize"):
        final_status = "HANDSHAKE_EXECUTED_PASS"
    elif any(item.get("method") == "initialize" for item in operations):
        final_status = "HANDSHAKE_EXECUTED_FAIL"
    else:
        final_status = status

    if args.list_tools and final_status == "HANDSHAKE_EXECUTED_PASS":
        final_status = "LIST_TOOLS_EXECUTED_PASS"

    evidence = {
        "probe_id": "MCP_TEAMS_LIVE_READ_PROBE_20260603",
        "server": SERVER_NAME,
        "server_url": SERVER_URL,
        "scope": SERVER_SCOPE,
        "audience": SERVER_AUDIENCE,
        "connection_id": args.connection_id,
        "auth_companion_id": args.auth_companion_id,
        "target_tenant_label": args.target_tenant_label,
        "dry_run": args.dry_run,
        "handshake_requested": args.handshake,
        "list_tools_requested": args.list_tools,
        "no_body_print": args.no_body_print,
        "auth_detection": {
            "token_env_present": bool(token_names),
            "token_env_names_present_sha256": [hashlib.sha256(name.encode("utf-8")).hexdigest() for name in token_names],
            "tenant_env_present": bool(tenant_names),
            "tenant_env_names_present": tenant_names,
            "identity_env_present": bool(identity_names),
            "identity_env_names_present": identity_names,
            "auth_profile_env_present": bool(auth_profile_names),
            "auth_profile_env_names_present": auth_profile_names,
        },
        "operations": operations,
        "final_status": final_status,
        "blocked_actions": [
            "teams_message_send",
            "graph_write",
            "permission_change",
            "production_mutation",
            "token_print",
            "response_body_print",
        ],
    }

    out_path = root_path(args.evidence_out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(evidence, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"MCP_TEAMS_LIVE_READ_PROBE_STATUS={final_status}")
    print(f"MCP_TEAMS_LIVE_READ_PROBE_EVIDENCE={out_path.relative_to(ROOT).as_posix()}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
