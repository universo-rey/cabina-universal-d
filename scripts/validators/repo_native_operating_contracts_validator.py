from pathlib import Path
import csv
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
MATRIX = ROOT / "02_AUTHORITY_CANON" / "FOCUS_5_REPOS_OPERATING_CONTRACT_MATRIX_20260604.csv"
ROOT_CONTRACT = ROOT / "02_AUTHORITY_CANON" / "REPO_OPERATING_CONTRACT_CABINA_UNIVERSAL_D_20260604.md"

EXPECTED_REPOS = [
    "universo-rey/cabina-universal-d",
    "SeshatSgin/seshat-bootstrap-sdu-cn",
    "SeshatSgin/torre-gemela-escribania",
    "SeshatSgin/cdf-soluciones",
    "SeshatSgin/tge-agentic-runtime-control-escribania",
]

EXPECTED_AGENTS = [
    "seshat-normativa",
    "thot-tecnico",
    "anubis-gate",
    "maat-cumplimiento",
    "horus-riesgo",
    "narrador-normativo",
]

REQUIRED_COLUMNS = [
    "repo",
    "universe",
    "role",
    "issue_contract",
    "operating_contract_file",
    "canonical_agents_declared",
    "chain_of_command_declared",
    "owner_agent",
    "reviewer_agent",
    "gate_agent",
    "evidence_agent",
    "openai_allowed",
    "microsoft_live_allowed",
    "codex_cloud_allowed",
    "agents_sdk_allowed",
    "rollback_declared",
    "postcheck_declared",
    "status",
    "pr_url",
]

SECRET_PATTERNS = [
    re.compile(r"OPENAI" + r"_API" + r"_KEY\s*=", re.I),
    re.compile(r"BEGIN " + r"(RSA |EC |OPENSSH |)PRIVATE KEY", re.I),
    re.compile(r"client" + r"_secret", re.I),
    re.compile(r"pass" + r"word\s*[:=]", re.I),
]


def fail(message: str) -> None:
    print(f"REPO_NATIVE_OPERATING_CONTRACTS_VALIDATOR=FAIL {message}")
    sys.exit(1)


if not MATRIX.exists():
    fail(f"missing_matrix={MATRIX}")
if not ROOT_CONTRACT.exists():
    fail(f"missing_root_contract={ROOT_CONTRACT}")

with MATRIX.open(newline="", encoding="utf-8") as handle:
    reader = csv.DictReader(handle)
    if reader.fieldnames != REQUIRED_COLUMNS:
        fail(f"columns_mismatch={reader.fieldnames}")
    rows = list(reader)

repos = [row["repo"] for row in rows]
if repos != EXPECTED_REPOS:
    fail(f"repos_mismatch={repos}")

for row in rows:
    for field in [
        "issue_contract",
        "operating_contract_file",
        "owner_agent",
        "reviewer_agent",
        "gate_agent",
        "evidence_agent",
        "pr_url",
    ]:
        if not row[field]:
            fail(f"missing_{field}_for={row['repo']}")
    for field in [
        "canonical_agents_declared",
        "chain_of_command_declared",
        "rollback_declared",
        "postcheck_declared",
    ]:
        if row[field] != "yes":
            fail(f"{field}_not_yes_for={row['repo']}")
    if row["status"] != "READY_FOR_REVIEW":
        fail(f"unexpected_status_for={row['repo']} status={row['status']}")
    if row["microsoft_live_allowed"] != "enabled_gated_when_target_exact":
        fail(f"microsoft_live_boundary_bad_for={row['repo']}")

body = ROOT_CONTRACT.read_text(encoding="utf-8")
agent_rows = re.findall(r"^  ([a-z-]+): aplica$", body, flags=re.MULTILINE)
if agent_rows != EXPECTED_AGENTS:
    fail(f"root_contract_agents_mismatch={agent_rows}")

required_root_markers = [
    "repo: universo-rey/cabina-universal-d",
    "universe: BOTH",
    "chain_of_command:",
    "owner_agent: rey.repo_cartographer",
    "reviewer_agent: court.seshat_evidence",
    "gate: anubis-gate",
    "evidencia: seshat-normativa",
    "OpenAI Codex Agents SDK MCP y Microsoft son medios de ejecucion no fuente de autoridad",
    "no absorber repos anidados",
    "rollback:",
    "postcheck:",
    "stop_conditions:",
]

missing = [marker for marker in required_root_markers if marker not in body]
if missing:
    fail(f"missing_root_markers={missing}")

scan_text = MATRIX.read_text(encoding="utf-8") + "\n" + body
for pattern in SECRET_PATTERNS:
    if pattern.search(scan_text):
        fail(f"secret_like_pattern={pattern.pattern}")

for forbidden in [
    "microsoft_live_executed",
    "openai_live_executed",
    "responses_api_live_executed",
    "agents_sdk_live_executed",
    "production_executed",
    "permission_changed",
]:
    if forbidden in scan_text:
        fail(f"forbidden_marker={forbidden}")

print("REPO_NATIVE_OPERATING_CONTRACTS_VALIDATOR=PASS repos=5")
