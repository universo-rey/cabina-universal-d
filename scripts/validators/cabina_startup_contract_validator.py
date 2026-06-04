from __future__ import annotations

from sdu_runtime_common import (
    main_guard,
    read_text,
    require_files,
    require_no_materialized_sensitive_values,
)


NAME = "CABINA_STARTUP_CONTRACT_VALIDATOR"

CANONICAL_FILES = [
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_DISCOVERY_20260604.md",
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md",
    "02_AUTHORITY_CANON/SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_20260604.md",
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_AGENT_UNIVERSE_REPO_MATRIX_20260604.csv",
    "02_AUTHORITY_CANON/SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv",
    "02_AUTHORITY_CANON/REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md",
]

STARTUP_FILES = [
    "AGENTS.md",
    "MANIFEST.yaml",
    "02_AUTHORITY_CANON/CURRENT_STATE.md",
]

REQUIRED_AGENTS = [
    "seshat-normativa",
    "thot-tecnico",
    "anubis-gate",
    "maat-cumplimiento",
    "horus-riesgo",
    "narrador-normativo",
]


def validate_startup_text(path: str) -> None:
    text = read_text(path)
    lowered = " ".join(text.lower().split())
    for token in [
        "SDU_CN_CANONICAL_AGENTS_MULTI_REPO_MULTI_UNIVERSE_READY_FOR_REVIEW",
        "SDU_CN_CANONICAL_AGENT_PANTHEON_20260604.md",
        "SDU_CN_MULTI_UNIVERSE_OPERATING_MODEL_20260604.md",
        "SDU_CN_CANONICAL_AGENT_UNIVERSE_REPO_MATRIX_20260604.csv",
        "SDU_CN_CANONICAL_TO_OPERATIONAL_AGENT_MAPPING_20260604.csv",
        "REPO_NATIVE_CONTRACT_TEMPLATE_20260604.md",
        "ESCRIBANIA",
        "MODO_ON",
        "no son herramientas",
        "no son adaptadores",
        "OpenAI",
        "no fuente de autoridad",
    ]:
        if token.lower() not in lowered:
            raise AssertionError(f"{path} missing startup token {token}")
    for agent in REQUIRED_AGENTS:
        if agent.lower() not in lowered:
            raise AssertionError(f"{path} missing canonical agent {agent}")


def validate() -> None:
    require_files(CANONICAL_FILES + STARTUP_FILES)
    require_no_materialized_sensitive_values(CANONICAL_FILES + STARTUP_FILES)
    for path in STARTUP_FILES:
        validate_startup_text(path)


if __name__ == "__main__":
    main_guard(NAME, validate)
