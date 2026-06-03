from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


FILES = [
    "governance/codex-cloud/SDU_CODEX_CLOUD_DEV_ACTIVATION_PLAN_20260603.md",
    ".codex/cloud/sdu-agents/task_templates/dev_activation_probe.md",
]


def validate() -> None:
    require_files(FILES)
    plan = read_text(FILES[0])
    task = read_text(FILES[1])
    for token in [
        "universo-rey/cabina-universal-d",
        "codex/sdu-agents-teams-identity-mcp-codex-cloud-dev-activation-20260603",
        "codex_cloud_apply",
        "Microsoft live",
        "OpenAI live",
        "SECRET_DETECTED",
    ]:
        if token not in plan:
            raise AssertionError(f"Codex Cloud plan missing {token}")
    for token in [
        "No aplicar cambios automaticos",
        "run validators",
        "codex cloud apply",
        "Teams install",
        "OpenAI live",
        "secret materialization",
    ]:
        if token not in task:
            raise AssertionError(f"Codex Cloud task template missing {token}")
    for forbidden in ["apply_allowed: true", "live_writes: true", "production: true"]:
        if forbidden in plan or forbidden in task:
            raise AssertionError(f"Codex Cloud DEV package enables forbidden token {forbidden}")
    require_no_materialized_sensitive_values(FILES)


if __name__ == "__main__":
    main_guard("SDU_CODEX_CLOUD_DEV_ACTIVATION_VALIDATOR", validate)
