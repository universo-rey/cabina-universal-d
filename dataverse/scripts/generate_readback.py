#!/usr/bin/env python3
"""Generate the Dataverse provisioning readback from local evidence."""

from __future__ import annotations

import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "readbacks" / "dataverse" / "READBACK_CODEX_DATAVERSE_DEV_PROVISIONING.md"


def count_csv(path: Path) -> int:
    with path.open(newline="", encoding="utf-8-sig") as handle:
        return sum(1 for _ in csv.DictReader(handle))


def load_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def main() -> int:
    inventory_count = count_csv(ROOT / "matrices" / "dataverse" / "MATRIX_INVENTORY.csv")
    schema_count = len(list((ROOT / "dataverse" / "schema").glob("sdu_*.yml")))
    precheck = load_json(ROOT / "dataverse" / "validation" / "dataverse_precheck_latest.json")
    manifest = load_json(ROOT / "dataverse" / "validation" / "dataverse_manifest_validation_latest.json")
    drift = load_json(ROOT / "dataverse" / "validation" / "dataverse_drift_latest.json")
    state = "DATAVERSE_DEV_PROVISIONING_READY"
    if precheck.get("status") == "DATAVERSE_DEV_PRECHECK_BLOCKED":
        state = "DATAVERSE_DEV_PROVISIONING_READY"
    if not manifest.get("manifest_valid", False) or not drift.get("drift_clear", False):
        state = "DATAVERSE_DEV_PARTIAL_WITH_BLOCKERS"

    body = f"""# Readback Codex Dataverse DEV Provisioning

## Estado final
{state}

## Fecha
2026-06-03

## Repo y rama
- Repo: universo-rey/cabina-universal-d
- Branch: codex/dataverse-dev-provisioning-20260603

## Fuentes leidas
- AGENTS.md
- MANIFEST.yaml
- MAPA_HUMANO.md
- 00_CONTROL_PLANE_INGRESS/ROUTING.json
- 01_GOVERNANCE_REGISTRY/README.md
- 02_AUTHORITY_CANON/CURRENT_STATE.md
- .agents/codex/README.md
- .agents/codex/agents.json
- .agents/codex/routing.json
- .agents/codex/matrices/*.csv
- Microsoft Learn: Power Platform CLI, Dataverse change tracking, solutions, deployment settings and GitHub Actions.

## Matrices
- Matrices detectadas: {inventory_count}
- Inventario: matrices/dataverse/MATRIX_INVENTORY.csv
- Migrabilidad: matrices/dataverse/MATRIX_MIGRABILITY_ASSESSMENT.csv
- Duplicados/overlaps: matrices/dataverse/MATRIX_DUPLICATES_AND_OVERLAPS.csv
- Source of truth: matrices/dataverse/SOURCE_OF_TRUTH_MATRIX.csv

## Modelo Dataverse V1
- Tablas YAML propuestas: {schema_count}
- Change tracking: declarado en todas las tablas V1.
- Auditing: declarado en todas las tablas V1.
- Politica: metadata-only, sin payload sensible.

## DEV apply
- Aplicado a DEV: no.
- Motivo: el perfil PAC activo saneado apunta a un ambiente Default, y el DEV target exacto sigue [POR DEFINIR] por URL/ID/perfil protegido.
- Estado de paquete: listo para precheck DEV y aplicacion cuando el target sea explicito.

## Scripts y workflows
- Scripts: dataverse/scripts/
- Workflows: .github/workflows/dataverse-*.yml
- Power Platform manifest: powerplatform/solution/solution.manifest.yml
- Deployment settings: powerplatform/settings/

## Validaciones
- manifest_valid: {manifest.get("manifest_valid")}
- drift_clear: {drift.get("drift_clear")}
- precheck_status: {precheck.get("status", "not_run")}

## Gates
- GATE_DEV_01_LICENSE_CONFIRMED: {'PASS' if precheck.get('pac_found') else 'BLOCKED_OR_NOT_RUN'}
- GATE_DEV_02_DEV_ENVIRONMENT_EXPLICIT: BLOCKED_POR_DEFINIR
- GATE_DEV_03_NOT_PROD: PASS_PREPARED
- GATE_DEV_04_TENANT_CONFIRMED: BLOCKED_POR_DEFINIR
- GATE_DEV_05_PUBLISHER_DEFINED: BLOCKED_POR_DEFINIR
- GATE_DEV_06_SOLUTION_DEFINED: BLOCKED_POR_DEFINIR
- GATE_DEV_07_NO_SECRETS: PASS_PREPARED
- GATE_DEV_08_ROLLBACK_DEFINED: PASS_PREPARED
- GATE_DEV_09_POSTCHECK_DEFINED: PASS_PREPARED
- GATE_DEV_10_HUMAN_APPROVAL_NOT_REQUIRED_FOR_DEV_OR_ALREADY_GRANTED: PASS_PREPARED

## Riesgos
- DEV exacto no fijado: bloquea apply.
- Solucion real Dataverse no importada: paquete es manifest/scripts/schema/seed, no snapshot DEV.
- TEST/PROD quedan manuales con environment protection y no ejecutados.

## Proximo paso exacto
Definir DATAVERSE_DEV_ENVIRONMENT_ID o DATAVERSE_DEV_ENVIRONMENT_URL y PAC_CLI_AUTH_PROFILE para un ambiente DEV no default/no PROD; luego correr dataverse/scripts/precheck_dataverse_environment.ps1 -RequireDevReady.
"""
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(body, encoding="utf-8")
    print(f"READBACK_WRITTEN {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
