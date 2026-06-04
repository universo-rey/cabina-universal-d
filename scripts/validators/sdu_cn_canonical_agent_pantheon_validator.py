from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_csv,
    read_text,
    require_columns,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "SDU_CN_CANONICAL_AGENT_PANTHEON_VALIDATOR"

CANONICAL_AGENTS = {
    "seshat-normativa": "documentary_governance_evidence_metadata",
    "thot-tecnico": "content_types_metadata_taxonomy_tools_events",
    "anubis-gate": "gates_stop_conditions_rollback_postcheck",
    "maat-cumplimiento": "coherence_proportionality_raci_compliance_recommendation",
    "horus-riesgo": "risk_alerts_contradictions_nucleo_umbral_watch",
    "narrador-normativo": "documentary_narrative_after_approved_evidence",
}

FOCUS_REPOS = {
    "universo-rey/cabina-universal-d",
    "SeshatSgin/torre-gemela-escribania",
    "SeshatSgin/seshat-bootstrap-sdu-cn",
    "SeshatSgin/cdf-soluciones",
    "SeshatSgin/tge-agentic-runtime-control-escribania",
}

REQUIRED_FILES = [
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_DISCOVERY_20260604.md",
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md",
    "02_AUTHORITY_CANON/SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_20260604.md",
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_UNIVERSE_REPO_MATRIX_20260604.csv",
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv",
    "02_AUTHORITY_CANON/REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md",
]


def split_multi(value: str) -> set[str]:
    return {item.strip() for item in value.split("|") if item.strip()}


def require_text(path: str, expected: list[str]) -> None:
    text = read_text(path)
    lowered = text.lower()
    for item in expected:
        if item.lower() not in lowered:
            raise AssertionError(f"{path} missing required text: {item}")


def validate_universe_repo_matrix() -> None:
    path = "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_UNIVERSE_REPO_MATRIX_20260604.csv"
    rows = read_csv(path)
    require_columns(
        rows,
        [
            "canonical_agent_id",
            "domain",
            "universe",
            "repo",
            "repo_role",
            "allowed_actions",
            "gated_actions",
            "operational_agent_mapping",
            "evidence_agent",
            "gate_agent",
            "runtime_agent",
            "openai_allowed",
            "microsoft_live_allowed",
            "stop_condition",
            "status",
        ],
        path,
    )
    if len(rows) != len(CANONICAL_AGENTS) * len(FOCUS_REPOS):
        raise AssertionError(f"{path} must contain 6 canonical agents crossed with 5 repos")

    seen_agents = {row["canonical_agent_id"] for row in rows}
    if seen_agents != set(CANONICAL_AGENTS):
        raise AssertionError(f"{path} canonical agents mismatch: {sorted(seen_agents)}")

    seen_repos = {row["repo"] for row in rows}
    if seen_repos != FOCUS_REPOS:
        raise AssertionError(f"{path} focus repos mismatch: {sorted(seen_repos)}")

    per_agent_universes: dict[str, set[str]] = {agent: set() for agent in CANONICAL_AGENTS}
    per_repo_agents: dict[str, set[str]] = {repo: set() for repo in FOCUS_REPOS}

    for index, row in enumerate(rows, start=2):
        agent = row["canonical_agent_id"]
        if row["domain"] != CANONICAL_AGENTS[agent]:
            raise AssertionError(f"{path}:{index} domain mismatch for {agent}")
        if row["status"] != "ACTIVE_CANONICAL":
            raise AssertionError(f"{path}:{index} status must be ACTIVE_CANONICAL")
        if row["openai_allowed"] != "ENABLED_GOVERNED_BY_TASK":
            raise AssertionError(f"{path}:{index} OpenAI must be governed by task")
        if row["microsoft_live_allowed"] != "ENABLED_GOVERNED_GATED_BY_TARGET":
            raise AssertionError(f"{path}:{index} Microsoft live must be gated by target")
        if "tool" in row["repo_role"].lower():
            raise AssertionError(f"{path}:{index} canonical agent appears reduced to tool")
        if "adapter" in row["repo_role"].lower():
            raise AssertionError(f"{path}:{index} canonical agent appears reduced to adapter")
        if not row["stop_condition"].strip():
            raise AssertionError(f"{path}:{index} missing stop_condition")
        per_agent_universes[agent].update(split_multi(row["universe"]))
        per_repo_agents[row["repo"]].add(agent)

    for agent, universes in per_agent_universes.items():
        if not {"ESCRIBANIA", "MODO_ON"}.issubset(universes):
            raise AssertionError(f"{path} {agent} does not cover both universes")
    for repo, agents in per_repo_agents.items():
        if agents != set(CANONICAL_AGENTS):
            raise AssertionError(f"{path} {repo} does not declare all six agents")


def validate_mapping() -> None:
    path = "02_AUTHORITY_CANON/SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv"
    rows = read_csv(path)
    require_columns(
        rows,
        [
            "canonical_agent_id",
            "canonical_domain",
            "primary_operational_agent",
            "supporting_operational_agent",
            "runtime_agent",
            "gate_agent",
            "evidence_agent",
            "github_operator",
            "microsoft_operator",
            "codex_cloud_operator",
            "agents_sdk_operator",
            "notes",
        ],
        path,
    )
    if {row["canonical_agent_id"] for row in rows} != set(CANONICAL_AGENTS):
        raise AssertionError(f"{path} must map exactly the six canonical agents")
    for index, row in enumerate(rows, start=2):
        agent = row["canonical_agent_id"]
        if row["canonical_domain"] != CANONICAL_AGENTS[agent]:
            raise AssertionError(f"{path}:{index} domain mismatch for {agent}")
        if row["runtime_agent"] != "sdu-triage-agent":
            raise AssertionError(f"{path}:{index} runtime must map to sdu-triage-agent")
        if not row["gate_agent"].strip() or not row["evidence_agent"].strip():
            raise AssertionError(f"{path}:{index} missing gate or evidence mapping")


def validate_text_contracts() -> None:
    require_text(
        "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md",
        [
            "No son herramientas",
            "no son adaptadores",
            "no pertenecen a un solo repo",
            "OpenAI",
            "no son fuente de autoridad",
            "No se crea septimo agente",
            "ESCRIBANIA",
            "MODO_ON",
        ],
    )
    require_text(
        "02_AUTHORITY_CANON/SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_20260604.md",
        [
            "universe.escribania_tower",
            "universe.modo_on_tower",
            "orden humana",
            "rollback",
            "postcheck",
            "stop condition",
        ],
    )
    require_text(
        "02_AUTHORITY_CANON/REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md",
        list(CANONICAL_AGENTS) + ["cadena_mando", "orden_humana", "agentes_canonicos_sdu_cn"],
    )


def validate() -> None:
    require_files(REQUIRED_FILES)
    require_no_materialized_sensitive_values(REQUIRED_FILES)
    validate_text_contracts()
    validate_universe_repo_matrix()
    validate_mapping()


if __name__ == "__main__":
    main_guard(NAME, validate)
