from sdu_runtime_common import main_guard, read_csv, read_text, require_columns, require_files, require_no_live


TASKS = [
    ".codex/cloud/sdu-agents/tasks/01_repo_scoped_review.md",
    ".codex/cloud/sdu-agents/tasks/02_validator_repair.md",
    ".codex/cloud/sdu-agents/tasks/03_teams_scaffold_review.md",
    ".codex/cloud/sdu-agents/tasks/04_mcp_registry_review.md",
    ".codex/cloud/sdu-agents/tasks/05_evidence_closeout.md",
]


def validate() -> None:
    require_files(
        [
            "governance/codex-cloud/SDU_AGENTS_CODEX_CLOUD_OPERATING_MODEL_20260603.md",
            "governance/codex-cloud/SDU_AGENT_CODEX_CLOUD_ASSIGNMENT_MATRIX_20260603.csv",
            ".codex/cloud/sdu-agents/README.md",
            ".codex/cloud/sdu-agents/profile.yml",
            ".codex/cloud/sdu-agents/setup.sh",
            ".codex/cloud/sdu-agents/maintenance.sh",
            *TASKS,
        ]
    )
    profile = read_text(".codex/cloud/sdu-agents/profile.yml")
    required_profile_tokens = [
        "repo: universo-rey/cabina-universal-d",
        "live_writes: false",
        "production: false",
        "remote_persistent_agent: false",
        "codex_cloud_apply",
    ]
    for token in required_profile_tokens:
        if token not in profile:
            raise AssertionError(f"profile missing {token}")

    matrix_path = "governance/codex-cloud/SDU_AGENT_CODEX_CLOUD_ASSIGNMENT_MATRIX_20260603.csv"
    rows = read_csv(matrix_path)
    require_columns(rows, ["assignment_id", "task_template", "owner_agent", "repo", "allowed_actions", "blocked_actions", "validator", "status"], matrix_path)
    require_no_live(rows, matrix_path)
    if len(rows) != 5:
        raise AssertionError("expected five Codex Cloud task assignments")
    for row in rows:
        require_files([row["task_template"], row["validator"]])
        if row["repo"] != "universo-rey/cabina-universal-d":
            raise AssertionError("Codex Cloud assignment must stay repo scoped")
        if row["status"] != "TEMPLATE_READY":
            raise AssertionError(f"{row['assignment_id']} must be TEMPLATE_READY")
        if "apply" in row["allowed_actions"]:
            raise AssertionError(f"{row['assignment_id']} allows apply")
        if "codex_cloud_apply" not in row["blocked_actions"] and "remote_live_write" not in row["blocked_actions"]:
            raise AssertionError(f"{row['assignment_id']} missing cloud live block")


if __name__ == "__main__":
    main_guard("SDU_CODEX_CLOUD_ASSIGNMENT_VALIDATOR", validate)
