from __future__ import annotations

from pathlib import Path

from sdu_runtime_common import (
    main_guard,
    read_csv,
    rel,
    require_columns,
    require_no_materialized_sensitive_values,
)


NAME = "ACTIVE_EXECUTION_CAPABILITY_MATRIX_VALIDATOR"
MATRIX = "governance/canon/ACTIVE_EXECUTION_CAPABILITY_MATRIX_20260603.csv"

REQUIRED_COLUMNS = [
    "capability_id",
    "surface",
    "current_status",
    "active_status",
    "execute_now",
    "execution_mode",
    "required_target",
    "required_identity",
    "required_owner",
    "required_secret",
    "required_secret_condition",
    "cost_boundary",
    "data_scope",
    "approval_ref",
    "required_rollback",
    "required_postcheck",
    "required_evidence",
    "command_or_workflow",
    "fallback_if_missing",
    "stop_condition",
    "validator",
    "canonical_status",
]

REQUIRED_CAPABILITIES = {
    "teams.identity.dev",
    "teams.app.package.dev",
    "teams.app.install.dev",
    "teams.first_message.dev",
    "graph.read.dev",
    "graph.write.dev",
    "sharepoint.evidence.write.dev",
    "planner.task.write.dev",
    "dataverse.dev.sync",
    "power_platform.dev.alm",
    "mcp.read_only_probe",
    "mcp.write.dev_gate",
    "codex_cloud.smoke",
    "codex_cloud.apply",
    "codex_cloud.pr_packet_local",
    "codex_cloud.pr_create_gated",
    "local_agent_bridge.mock",
    "openai_api.smoke.dev",
    "agents_sdk.local",
    "agents_sdk.live_gated",
    "github.local_branch_commit",
    "github.remote_push_gated",
    "github.pr_create_gated",
    "github.admin_bypass",
    "production.change",
}

ALLOWED_ACTIVE_STATUS = {
    "EXECUTE_LOCAL_NOW",
    "EXECUTE_MOCK_NOW",
    "EXECUTE_DEV_NOW",
    "EXECUTE_LIVE_READ_NOW",
    "EXECUTE_LIVE_WRITE_GATED_NOW",
    "EXECUTE_CODEX_CLOUD_SMOKE_NOW",
    "EXECUTE_MCP_READ_PROBE_NOW",
    "EXECUTE_TEAMS_DEV_TEST_NOW",
    "READY_FOR_PROD_HUMAN_GATE",
    "PENDING_TARGET_ONLY",
    "PENDING_SECRET_ONLY",
    "PENDING_IDENTITY_ONLY",
    "PENDING_OWNER_ONLY",
    "PENDING_COST_BOUNDARY_ONLY",
    "BLOCKED_SECURITY_RISK",
    "BLOCKED_SECRET_EXPOSURE",
    "BLOCKED_TENANT_AMBIGUOUS",
    "BLOCKED_PRODUCTION_UNAPPROVED",
    "BLOCKED_COST_BOUNDARY_MISSING",
}

PASSIVE_STATUS = {"disabled", "blocked", "not executed", "prepared", "pending"}
ALLOWED_SECRET_VALUES = {"yes", "no", "conditional"}
REMOTE_WRITE_PATTERNS = [
    "git push",
    "gh pr create",
    "gh pr merge",
    "codex cloud apply",
]
MANDATORY_NONEMPTY_FIELDS = [
    "surface",
    "current_status",
    "execution_mode",
    "required_target",
    "required_identity",
    "required_owner",
    "required_secret",
    "required_secret_condition",
    "cost_boundary",
    "data_scope",
    "approval_ref",
    "required_rollback",
    "required_postcheck",
    "required_evidence",
    "command_or_workflow",
    "fallback_if_missing",
    "stop_condition",
    "validator",
]


def validate_validator_path(path_value: str, row_number: int) -> None:
    path = Path(path_value)
    if path.suffix != ".py":
        raise AssertionError(f"{MATRIX}:{row_number} validator must be a python validator")
    if not rel(path_value).exists():
        raise AssertionError(f"{MATRIX}:{row_number} validator does not exist: {path_value}")


def validate() -> None:
    rows = read_csv(MATRIX)
    require_columns(rows, REQUIRED_COLUMNS, MATRIX)
    found = set()

    for row_number, row in enumerate(rows, start=2):
        capability_id = row["capability_id"].strip()
        found.add(capability_id)
        active_status = row["active_status"].strip()
        execute_now = row["execute_now"].strip().lower()
        canonical_status = row["canonical_status"].strip()
        command = row["command_or_workflow"].strip().lower()
        required_secret = row["required_secret"].strip().lower()

        if active_status not in ALLOWED_ACTIVE_STATUS:
            raise AssertionError(f"{MATRIX}:{row_number} invalid active_status {active_status!r}")
        if canonical_status != "ACTIVE_GOVERNED_EXECUTION_BY_DEFAULT":
            raise AssertionError(f"{MATRIX}:{row_number} invalid canonical_status {canonical_status!r}")
        if execute_now not in {"yes", "no"}:
            raise AssertionError(f"{MATRIX}:{row_number} execute_now must be yes or no")
        if required_secret not in ALLOWED_SECRET_VALUES:
            raise AssertionError(f"{MATRIX}:{row_number} required_secret must be yes/no/conditional")
        if required_secret == "conditional" and row["required_secret_condition"].strip() == "not_required":
            raise AssertionError(f"{MATRIX}:{row_number} conditional secret must name condition")
        if required_secret == "no" and row["required_secret_condition"].strip() != "not_required":
            raise AssertionError(f"{MATRIX}:{row_number} no secret rows must use required_secret_condition=not_required")

        for field in MANDATORY_NONEMPTY_FIELDS:
            if not row[field].strip():
                raise AssertionError(f"{MATRIX}:{row_number} empty required field {field}")

        if active_status.startswith("EXECUTE_") and execute_now != "yes":
            raise AssertionError(f"{MATRIX}:{row_number} executable status must execute_now=yes")
        if not active_status.startswith("EXECUTE_") and execute_now != "no":
            raise AssertionError(f"{MATRIX}:{row_number} non-executable status must execute_now=no")

        if active_status in {"PENDING_TARGET_ONLY", "PENDING_SECRET_ONLY", "PENDING_IDENTITY_ONLY", "PENDING_OWNER_ONLY"}:
            if "PENDING_" not in row["fallback_if_missing"]:
                raise AssertionError(f"{MATRIX}:{row_number} pending row must name exact pending fallback")
        if active_status == "READY_FOR_PROD_HUMAN_GATE":
            if "production" not in row["required_rollback"].lower() or "production" not in row["required_postcheck"].lower():
                raise AssertionError(f"{MATRIX}:{row_number} production gate must name production rollback and postcheck")

        if active_status == "EXECUTE_LIVE_WRITE_GATED_NOW":
            for field in ["required_target", "required_identity", "required_owner", "required_rollback", "required_postcheck"]:
                if "[" in row[field] and "]" in row[field]:
                    raise AssertionError(f"{MATRIX}:{row_number} live write now cannot keep placeholder in {field}")

        if active_status == "EXECUTE_LOCAL_NOW" and any(pattern in command for pattern in REMOTE_WRITE_PATTERNS):
            raise AssertionError(f"{MATRIX}:{row_number} EXECUTE_LOCAL_NOW cannot include remote write command")
        if active_status == "EXECUTE_CODEX_CLOUD_SMOKE_NOW" and any(pattern in command for pattern in ["codex cloud apply", "git push", "gh pr create", "gh pr merge"]):
            raise AssertionError(f"{MATRIX}:{row_number} Codex Cloud smoke cannot include apply push or PR")
        if capability_id in {"github.lifecycle", "codex_cloud.pr"}:
            raise AssertionError(f"{MATRIX}:{row_number} deprecated mixed capability must be split: {capability_id}")
        if capability_id == "github.local_branch_commit" and "git push" in command:
            raise AssertionError(f"{MATRIX}:{row_number} local git capability cannot push")
        if capability_id == "codex_cloud.pr_packet_local" and any(pattern in command for pattern in ["git push", "gh pr create"]):
            raise AssertionError(f"{MATRIX}:{row_number} local PR packet cannot write remotely")

        if row["current_status"].strip().lower() in PASSIVE_STATUS:
            raise AssertionError(f"{MATRIX}:{row_number} current_status uses passive generic wording")
        if active_status.lower() in PASSIVE_STATUS:
            raise AssertionError(f"{MATRIX}:{row_number} active_status uses passive generic wording")

        validate_validator_path(row["validator"].strip(), row_number)

    missing = sorted(REQUIRED_CAPABILITIES - found)
    if missing:
        raise AssertionError(f"{MATRIX} missing required capabilities: {', '.join(missing)}")

    require_no_materialized_sensitive_values([MATRIX])


if __name__ == "__main__":
    main_guard(NAME, validate)
