from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_text,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "FOCUS_5_REPO_CONTRACTS_VALIDATOR"

CANONICAL_AGENTS = {
    "seshat-normativa",
    "thot-tecnico",
    "anubis-gate",
    "maat-cumplimiento",
    "horus-riesgo",
    "narrador-normativo",
}

FOCUS_REPOS = {
    "universo-rey/cabina-universal-d",
    "SeshatSgin/torre-gemela-escribania",
    "SeshatSgin/seshat-bootstrap-sdu-cn",
    "SeshatSgin/cdf-soluciones",
    "SeshatSgin/tge-agentic-runtime-control-escribania",
}

REQUIRED_FILES = [
    "02_AUTHORITY_CANON/FOCUS_5_REPOS_CONTRACT_INVENTORY_20260604.md",
    "02_AUTHORITY_CANON/FOCUS_5_REPOS_CANONICAL_AGENT_ASSIGNMENT_MATRIX_20260604.csv",
    "02_AUTHORITY_CANON/FOCUS_5_REPOS_CHAIN_OF_COMMAND_MATRIX_20260604.csv",
    "02_AUTHORITY_CANON/REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md",
]


def split_multi(value: str) -> set[str]:
    return {item.strip() for item in value.split("|") if item.strip()}


def validate_inventory() -> None:
    path = "02_AUTHORITY_CANON/FOCUS_5_REPOS_CONTRACT_INVENTORY_20260604.md"
    text = read_text(path)
    for repo in FOCUS_REPOS:
        if repo not in text:
            raise AssertionError(f"{path} missing repo {repo}")
    for token in ["issues/87", "issues/88", "READY_FOR_REVIEW", "sin septimo agente", "sin secretos"]:
        if token not in text:
            raise AssertionError(f"{path} missing token {token}")


def validate_assignment_matrix() -> None:
    path = "02_AUTHORITY_CANON/FOCUS_5_REPOS_CANONICAL_AGENT_ASSIGNMENT_MATRIX_20260604.csv"
    rows = read_csv(path)
    require_columns(
        rows,
        [
            "repo",
            "universe",
            "canonical_agent_id",
            "domain",
            "applies",
            "repo_role",
            "operational_mapping",
            "evidence",
            "validator",
            "rollback",
            "postcheck",
            "stop_condition",
            "status",
        ],
        path,
    )
    if len(rows) != len(CANONICAL_AGENTS) * len(FOCUS_REPOS):
        raise AssertionError(f"{path} must contain six agent rows per focus repo")
    by_repo: dict[str, set[str]] = {repo: set() for repo in FOCUS_REPOS}
    universe_seen = set()
    for index, row in enumerate(rows, start=2):
        repo = row["repo"]
        agent = row["canonical_agent_id"]
        if repo not in FOCUS_REPOS:
            raise AssertionError(f"{path}:{index} unexpected repo {repo}")
        if agent not in CANONICAL_AGENTS:
            raise AssertionError(f"{path}:{index} unexpected canonical agent {agent}")
        if row["applies"].lower() != "true":
            raise AssertionError(f"{path}:{index} canonical agent must apply")
        if row["status"] != "ACTIVE_CANONICAL":
            raise AssertionError(f"{path}:{index} status must be ACTIVE_CANONICAL")
        if not row["rollback"].strip() or not row["postcheck"].strip():
            raise AssertionError(f"{path}:{index} missing rollback or postcheck")
        if "scripts/validators/" not in row["validator"]:
            raise AssertionError(f"{path}:{index} validator must be explicit")
        if "tool" in row["repo_role"].lower() or "adapter" in row["repo_role"].lower():
            raise AssertionError(f"{path}:{index} canonical agent reduced to tool or adapter")
        by_repo[repo].add(agent)
        universe_seen.update(split_multi(row["universe"]))
    for repo, agents in by_repo.items():
        if agents != CANONICAL_AGENTS:
            raise AssertionError(f"{path} {repo} does not declare all six canonical agents")
    if not {"ESCRIBANIA", "MODO_ON"}.issubset(universe_seen):
        raise AssertionError(f"{path} does not cover both universes")


def validate_chain_matrix() -> None:
    path = "02_AUTHORITY_CANON/FOCUS_5_REPOS_CHAIN_OF_COMMAND_MATRIX_20260604.csv"
    rows = read_csv(path)
    require_columns(
        rows,
        [
            "repo",
            "issue",
            "universe",
            "order_agent",
            "canonical_agents_required",
            "operational_lead",
            "delegated_agent",
            "runtime_agent",
            "gate_agent",
            "evidence_agent",
            "narrative_agent",
            "rollback",
            "postcheck",
            "validator",
            "stop_condition",
            "status",
        ],
        path,
    )
    if {row["repo"] for row in rows} != FOCUS_REPOS:
        raise AssertionError(f"{path} must include exactly the five focus repos")
    for index, row in enumerate(rows, start=2):
        if split_multi(row["canonical_agents_required"]) != CANONICAL_AGENTS:
            raise AssertionError(f"{path}:{index} chain does not require all six canonical agents")
        if row["order_agent"] != "rey.control_plane_orchestrator":
            raise AssertionError(f"{path}:{index} order agent must be rey.control_plane_orchestrator")
        if row["runtime_agent"] != "sdu-triage-agent":
            raise AssertionError(f"{path}:{index} runtime agent must be sdu-triage-agent")
        if "anubis-gate" not in row["gate_agent"]:
            raise AssertionError(f"{path}:{index} gate must include anubis-gate")
        if "seshat-normativa" not in row["evidence_agent"]:
            raise AssertionError(f"{path}:{index} evidence must include seshat-normativa")
        if row["narrative_agent"] != "narrador-normativo":
            raise AssertionError(f"{path}:{index} narrative agent must be narrador-normativo")
        if not row["rollback"].strip() or not row["postcheck"].strip():
            raise AssertionError(f"{path}:{index} missing rollback or postcheck")
        if row["status"] != "READY_FOR_REVIEW":
            raise AssertionError(f"{path}:{index} status must be READY_FOR_REVIEW")


def validate_template() -> None:
    path = "02_AUTHORITY_CANON/REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md"
    text = read_text(path)
    for token in CANONICAL_AGENTS | {"cadena_mando", "orden_humana", "rollback", "postcheck"}:
        if token not in text:
            raise AssertionError(f"{path} missing {token}")


def validate() -> None:
    require_files(REQUIRED_FILES)
    require_no_materialized_sensitive_values(REQUIRED_FILES)
    validate_inventory()
    validate_assignment_matrix()
    validate_chain_matrix()
    validate_template()


if __name__ == "__main__":
    main_guard(NAME, validate)
