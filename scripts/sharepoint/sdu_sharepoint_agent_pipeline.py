from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_SITE_FILTER = "SeshatHubRegistroN.8"
AGENT_ORDER = [
    "seshat-normativa",
    "thot-tecnico",
    "anubis-gate",
    "maat-cumplimiento",
    "horus-riesgo",
]
NARRATOR_AGENT = "narrador-normativo"

AGENT_RELATIONSHIP_TYPES: dict[str, set[str]] = {
    "seshat-normativa": {"Document->NormativeRule", "NormativeRule->Obligation"},
    "thot-tecnico": {"Site->Library", "Library->Document", "Library->ContentType", "Document->MetadataField"},
    "anubis-gate": {"Document->ExpectedControl", "ExpectedControl->ControlState"},
    "maat-cumplimiento": {"Document->ComplianceRequirement", "Document->ComplianceEvidence"},
    "horus-riesgo": {"Document->Risk", "Risk->Cause"},
}

ACT_PATTERNS = {
    "Compraventa": ["compraventa", "venta", "boleto"],
    "Donacion": ["donacion", "donación"],
    "Poder": ["poder", "apoderado", "mandato"],
    "Escritura": ["escritura", "protocolo", "protocolar"],
    "Acta": ["acta"],
    "Dictamen": ["dictamen"],
    "Resolucion": ["resolucion", "resolución"],
    "Certificacion": ["certificacion", "certificación", "certificado"],
}

NORMATIVE_PATTERNS = {
    "UIF": ["uif", "sujeto obligado", "reporte sospechoso", "rsm"],
    "KYC": ["kyc", "conocimiento del cliente", "beneficiario final", "debida diligencia"],
    "Cumplimiento operativo": ["cumplimiento", "compliance", "control interno", "auditoria", "auditoría"],
    "Gobernanza documental": ["canon", "normativa", "protocolo", "politica", "política", "estandar", "estándar"],
}

COMPLIANCE_PATTERNS = {
    "Requisito UIF": ["uif", "reporte sospechoso", "rsm", "sujeto obligado"],
    "Requisito KYC": ["kyc", "conocimiento del cliente", "beneficiario final", "debida diligencia"],
    "Evidencia de cumplimiento": ["evidencia", "trazabilidad", "auditoria", "auditoría", "readback"],
}

CONTROL_PATTERNS = {
    "Evidencia suficiente": ["evidencia", "prueba", "verificable", "recuperable"],
    "Rollback": ["rollback", "reversion", "reversión", "revertir"],
    "Postcheck": ["postcheck", "validacion", "validación", "validator", "check"],
    "Autorizacion expresa": ["autorizacion", "autorización", "approval", "aprobacion", "aprobación"],
    "No secretos": ["secreto", "secret", "token", "credencial"],
    "No produccion sin gate": ["produccion", "producción", "production", "gate"],
}

RISK_PATTERNS = {
    "Datos regulados o secretos": {
        "terms": ["secreto", "secret", "token", "credencial", "dato regulado", "datos regulados"],
        "severity": "high",
        "cause": "Exposicion de material sensible o regulado",
    },
    "Produccion o live sin gate": {
        "terms": ["produccion", "producción", "production", "live", "sin autorizacion", "sin autorización"],
        "severity": "high",
        "cause": "Operacion live o produccion sin autorizacion suficiente",
    },
    "Trazabilidad incompleta": {
        "terms": ["sin evidencia", "falta evidencia", "pendiente", "bloqueo", "gap", "brecha"],
        "severity": "medium",
        "cause": "Cierre o decision sin evidencia suficiente",
    },
    "Inconsistencia documental": {
        "terms": ["contradiccion", "contradicción", "inconsistencia", "desvio", "desvío"],
        "severity": "medium",
        "cause": "Contradiccion o desvio entre evidencia y estado declarado",
    },
}

BATCH_ID = "20260608_sharepoint_inventory_agent_dataverse_plan_v1"
PIPELINE_SYSTEM_ID = "sdu_sharepoint_agent_pipeline"
DATAVERSE_APPLY_GATE = "GATE_DATAVERSE_APPLY"
DATAVERSE_APPLY_STOP_CONDITION = "human_validation_required_before_dataverse_apply"
QUEUE_ITEM_TYPE = "AGENT_DISPATCH"
QUEUE_OPERATION = "sharepoint_inventory_agent_analysis_to_dataverse_plan"

QUEUE_REQUIRED_FIELDS = [
    "queue_item_type",
    "canonical_id",
    "correlation_id",
    "idempotency_key",
    "batch_id",
    "source_table",
    "source_matrix",
    "source_path",
    "source_hash",
    "operation",
    "target_environment_id",
    "target_environment_url",
    "gate_required",
    "gate_id",
    "risk_level",
    "priority",
    "stop_condition",
    "rollback_strategy",
    "evidence_required",
    "created_by_system",
    "ai_assisted",
    "ai_validation_status",
]

DATAVERSE_OPERATING_MODEL: dict[str, Any] = {
    "mode": "metadata_only_local_plan",
    "live_apply": False,
    "solution": {
        "unique_name": "SDUCapabilityControlPlane",
        "publisher_prefix": "mon",
        "manifest": "powerplatform/solution/solution.manifest.yml",
    },
    "environment": {
        "scope": "DEV_SANDBOX",
        "environment_id": "7f65fc04-c27a-ea0d-bd2d-266aa9203c1e",
        "environment_url": "https://org084965d9.crm.dynamics.com",
        "profile": "SDU-DATAVERSE-DEV",
        "blocked_targets": ["prod", "test", "default"],
    },
    "queue": {
        "name": "SDU.Agent.Dispatch.Queue",
        "workqueuekey": "sdu_agent_dispatch_queue",
        "queue_id": "310d36ee-3f5f-f111-a826-00224805f8f9",
        "manifest": "powerplatform/workqueues/workqueue.manifest.yml",
        "schema": "powerplatform/workqueues/schemas/gate_review.schema.json",
        "processing_active": False,
    },
    "dispatcher_flow": {
        "name": "SDU_Work_Queue_Agent_Dispatcher",
        "state": "disabled_dev_only",
        "manifest": "powerplatform/flows/flow-manifest.yml",
    },
    "tables": {
        "source_artifact": "mon_sdu_source_artifact",
        "evidence": "mon_sdu_evidence",
        "agent_mapping": "mon_sdu_agent_connection_mapping",
        "connection_instance": "mon_sdu_connection_instance",
        "connection_risk": "mon_sdu_connection_risk",
        "validation_gate": "mon_sdu_validation_gate",
        "apply_log": "mon_sdu_apply_log",
        "readback": "mon_sdu_readback",
    },
    "model_sources": [
        "matrices/dataverse/DATAVERSE_APPLIED_TABLE_MODEL_DEV.csv",
        "matrices/dataverse/DATAVERSE_APPLIED_FIELD_MODEL_DEV.csv",
        "matrices/dataverse/DATAVERSE_APPLIED_KEY_MODEL_DEV.csv",
        "matrices/dataverse/DATAVERSE_APPLIED_RELATIONSHIP_MODEL_DEV.csv",
    ],
    "relationship_strategy": "canonical_id_reference_fields_no_lookup_relationships_v1",
}

AGENT_DATAVERSE_ASSIGNMENTS: dict[str, dict[str, Any]] = {
    "seshat-normativa": {
        "read_tables": ["mon_sdu_source_artifact", "mon_sdu_connection_instance"],
        "write_plan_tables": ["mon_sdu_evidence", "mon_sdu_validation_gate", "mon_sdu_readback"],
        "priority": "high",
        "risk_level": "medium",
        "domain_operation": "normative_rule_and_obligation_mapping",
    },
    "thot-tecnico": {
        "read_tables": ["mon_sdu_source_artifact"],
        "write_plan_tables": ["mon_sdu_connection_instance", "mon_sdu_evidence"],
        "priority": "high",
        "risk_level": "medium",
        "domain_operation": "technical_metadata_and_library_mapping",
    },
    "anubis-gate": {
        "read_tables": ["mon_sdu_source_artifact", "mon_sdu_connection_instance"],
        "write_plan_tables": ["mon_sdu_validation_gate", "mon_sdu_evidence"],
        "priority": "high",
        "risk_level": "high",
        "domain_operation": "control_gap_and_gate_validation",
    },
    "maat-cumplimiento": {
        "read_tables": ["mon_sdu_source_artifact", "mon_sdu_evidence"],
        "write_plan_tables": ["mon_sdu_evidence", "mon_sdu_validation_gate"],
        "priority": "high",
        "risk_level": "high",
        "domain_operation": "compliance_requirement_and_evidence_mapping",
    },
    "horus-riesgo": {
        "read_tables": ["mon_sdu_source_artifact", "mon_sdu_connection_instance"],
        "write_plan_tables": ["mon_sdu_connection_risk", "mon_sdu_evidence"],
        "priority": "high",
        "risk_level": "high",
        "domain_operation": "risk_classification_and_cause_mapping",
    },
    "narrador-normativo": {
        "read_tables": ["mon_sdu_source_artifact", "mon_sdu_evidence", "mon_sdu_connection_risk"],
        "write_plan_tables": ["mon_sdu_readback", "mon_sdu_apply_log"],
        "priority": "medium",
        "risk_level": "medium",
        "domain_operation": "executive_readback_and_state_synthesis",
    },
}

EXPEDIENTE_PATTERN = re.compile(r"\b(?:expediente|exp|e)[\s._-]*(\d{2,6}[A-Za-z0-9_-]*)\b", re.IGNORECASE)
PERSON_CANDIDATE_PATTERN = re.compile(
    r"\b([A-ZÁÉÍÓÚÑ][a-záéíóúñ]+(?:\s+[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+){1,3})\b"
)
PERSON_STOP_WORDS = {
    "Hub Seshat",
    "SharePoint",
    "Documentos",
    "Microsoft",
    "Power Platform",
    "Copilot Studio",
    "Torre Gemela",
    "Escribania Bitsch",
    "Escribanía Bitsch",
}


AGENT_RULES: dict[str, dict[str, Any]] = {
    "seshat-normativa": {
        "domain": "reglas_estandares_definiciones_canonicas",
        "keywords": [
            "canon",
            "canonic",
            "norma",
            "normativa",
            "estandar",
            "standard",
            "definicion",
            "politica",
            "protocolo",
            "procedimiento",
            "criterio",
            "rector",
            "gobernanza",
            "manual",
        ],
        "lens": "regla, estandar, definicion o pieza canonica presente en la fuente",
    },
    "thot-tecnico": {
        "domain": "arquitectura_estructuras_componentes_tecnicos",
        "keywords": [
            "arquitectura",
            "metadata",
            "metadato",
            "taxonomia",
            "taxonomy",
            "content type",
            "tipo de contenido",
            "schema",
            "json",
            "csv",
            "api",
            "script",
            "tool",
            "biblioteca",
            "lista",
            "campo",
            "columna",
            "componente",
        ],
        "lens": "estructura, componente tecnico, taxonomia o metadata presente en la fuente",
    },
    "anubis-gate": {
        "domain": "validaciones_controles_gaps_estructurales",
        "keywords": [
            "gate",
            "gated",
            "control",
            "validacion",
            "validator",
            "check",
            "approval",
            "aprobacion",
            "rollback",
            "postcheck",
            "stop condition",
            "gap",
            "brecha",
            "pendiente",
            "bloqueo",
            "permiso",
        ],
        "lens": "control, validacion, gate, gap o condicion de cierre presente en la fuente",
    },
    "maat-cumplimiento": {
        "domain": "cumplimiento_normativo_uif_kyc",
        "keywords": [
            "cumplimiento",
            "compliance",
            "uif",
            "kyc",
            "aml",
            "plaft",
            "lavado",
            "debida diligencia",
            "sujeto obligado",
            "beneficiario final",
            "legajo",
            "raci",
            "auditoria",
            "control interno",
        ],
        "lens": "obligacion, evidencia o practica de cumplimiento presente en la fuente",
    },
    "horus-riesgo": {
        "domain": "identificacion_clasificacion_riesgos",
        "keywords": [
            "riesgo",
            "risk",
            "alerta",
            "amenaza",
            "incidente",
            "vulnerabilidad",
            "exposicion",
            "contradiccion",
            "inconsistencia",
            "critico",
            "alto",
            "medio",
            "bajo",
            "bloqueo",
            "brecha",
        ],
        "lens": "riesgo, alerta, contradiccion o exposicion presente en la fuente",
    },
}


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def normalize_text(value: Any) -> str:
    text = "" if value is None else str(value)
    return re.sub(r"\s+", " ", text).strip()


def as_list(payload: Any) -> list[dict[str, Any]]:
    if isinstance(payload, list):
        return [item for item in payload if isinstance(item, dict)]
    if isinstance(payload, dict):
        for key in ("documents", "Documents", "items", "records"):
            value = payload.get(key)
            if isinstance(value, list):
                return [item for item in value if isinstance(item, dict)]
    raise ValueError("inventory JSON must be an array or contain a documents/items/records array")


def load_inventory(path: Path) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8-sig") as handle:
        return as_list(json.load(handle))


def record_site_matches(record: dict[str, Any], site_filter: str | None) -> bool:
    if not site_filter:
        return True
    haystack = " ".join(
        normalize_text(record.get(key))
        for key in ("site_url", "site_title", "file_url", "file_path", "library_title")
    )
    return site_filter.lower() in haystack.lower()


def evidence_text(record: dict[str, Any], max_chars: int) -> str:
    parts = [
        record.get("file_name"),
        record.get("library_title"),
        record.get("content_type"),
        record.get("mime_type"),
        record.get("summary"),
        record.get("content_text"),
        record.get("file_path"),
    ]
    text = normalize_text(" ".join(normalize_text(part) for part in parts if part is not None))
    if len(text) > max_chars:
        return text[:max_chars].rstrip()
    return text


def source_trace(record: dict[str, Any]) -> dict[str, Any]:
    return {
        "site_title": record.get("site_title", ""),
        "site_url": record.get("site_url", ""),
        "library_title": record.get("library_title", ""),
        "file_name": record.get("file_name", ""),
        "file_path": record.get("file_path", ""),
        "file_url": record.get("file_url", ""),
        "file_extension": record.get("file_extension", ""),
        "mime_type": record.get("mime_type", ""),
        "content_type": record.get("content_type", ""),
        "created_utc": record.get("created_utc", ""),
        "modified_utc": record.get("modified_utc", ""),
        "content_read_status": record.get("content_read_status", ""),
    }


def stable_hash(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()[:16]


def full_hash(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def hash_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def slug(value: Any) -> str:
    text = normalize_text(value)
    if not text:
        return "unknown"
    normalized = re.sub(r"[^A-Za-z0-9._-]+", "_", text)
    return normalized.strip("_")[:120] or "unknown"


def document_node_id(record: dict[str, Any]) -> str:
    key = "|".join(
        normalize_text(record.get(name))
        for name in ("site_url", "library_title", "file_path", "file_name")
    )
    return f"Document:{stable_hash(key)}"


def source_document_canonical_id(source: dict[str, Any]) -> str:
    key = "|".join(
        normalize_text(source.get(name))
        for name in ("site_url", "library_title", "file_path", "file_name")
    )
    return f"spdoc.{stable_hash(key)}"


def record_source_path(record: dict[str, Any]) -> str:
    return normalize_text(record.get("file_url")) or normalize_text(record.get("file_path")) or normalize_text(record.get("file_name"))


def source_payload_hash(payload: Any) -> str:
    return full_hash(json.dumps(payload, sort_keys=True, ensure_ascii=False, default=str))


def all_agent_ids() -> list[str]:
    return [*AGENT_ORDER, NARRATOR_AGENT]


def upsert_record(table: str, canonical_id: str, payload: dict[str, Any], source: dict[str, Any] | None = None) -> dict[str, Any]:
    return {
        "table": table,
        "alternate_key": {"mon_canonical_id": canonical_id},
        "canonical_id": canonical_id,
        "mode": "metadata_only_local_plan",
        "live_apply": False,
        "inferred": True,
        "source": source or {},
        "payload": payload,
    }


def base_dataverse_payload(
    canonical_id: str,
    display_name: str,
    *,
    source_path: str,
    source_hash: str,
    status: str,
    owner: str,
    risk_level: str,
    notes: str,
    gate_required: bool = True,
) -> dict[str, Any]:
    return {
        "mon_canonical_id": canonical_id,
        "mon_display_name": display_name[:240],
        "mon_environment_scope": DATAVERSE_OPERATING_MODEL["environment"]["scope"],
        "mon_gate_required": gate_required,
        "mon_last_reconciled_at": utc_now(),
        "mon_notes": notes[:1800],
        "mon_owner": owner,
        "mon_risk_level": risk_level,
        "mon_seed_batch_id": BATCH_ID,
        "mon_source_hash": source_hash,
        "mon_source_path": source_path[:900],
        "mon_source_system": "sharepoint_inventory_json",
        "mon_status": status,
        "mon_stop_condition": DATAVERSE_APPLY_STOP_CONDITION,
        "mon_tenant_scope": "ESCRIBANIA",
    }


def add_node(
    nodes: dict[str, dict[str, Any]],
    node_type: str,
    label: str,
    evidence: str,
    *,
    inferred: bool,
    node_id: str | None = None,
    properties: dict[str, Any] | None = None,
) -> str:
    resolved_id = node_id or f"{node_type}:{slug(label)}"
    if resolved_id not in nodes:
        nodes[resolved_id] = {
            "id": resolved_id,
            "type": node_type,
            "label": label or "unknown",
            "inferred": inferred,
            "evidence": evidence,
            "properties": properties or {},
        }
    return resolved_id


def relationship_type(source_id: str, target_id: str) -> str:
    return f"{source_id.split(':', 1)[0]}->{target_id.split(':', 1)[0]}"


def add_edge(
    edges: list[dict[str, Any]],
    source: str,
    target: str,
    relationship: str,
    evidence: str,
    *,
    confidence: float,
    inferred: bool,
    agent_id: str,
) -> None:
    edge = {
        "source": source,
        "target": target,
        "relationship": relationship,
        "relationship_type": relationship_type(source, target),
        "confidence": round(confidence, 2),
        "inferred": inferred,
        "evidence": evidence,
        "agent_id": agent_id,
    }
    if edge not in edges:
        edges.append(edge)


def evidence_for_terms(text: str, terms: list[str], fallback: str) -> str:
    lowered = text.lower()
    for term in terms:
        index = lowered.find(term.lower())
        if index >= 0:
            start = max(0, index - 80)
            end = min(len(text), index + len(term) + 140)
            return text[start:end].strip()
    return fallback[:240].strip()


def extract_pattern_hits(text: str, patterns: dict[str, list[str]]) -> list[tuple[str, list[str], str]]:
    hits = []
    lowered = text.lower()
    for label, terms in patterns.items():
        matched = [term for term in terms if term.lower() in lowered]
        if matched:
            hits.append((label, matched, evidence_for_terms(text, matched, text)))
    return hits


def extract_people(text: str) -> list[tuple[str, str]]:
    people: list[tuple[str, str]] = []
    for match in PERSON_CANDIDATE_PATTERN.finditer(text):
        candidate = match.group(1).strip()
        if candidate in PERSON_STOP_WORDS:
            continue
        if any(word in PERSON_STOP_WORDS for word in candidate.split("  ")):
            continue
        if candidate.lower() in {"dictamen rector", "hub seshat", "documentos compartidos"}:
            continue
        evidence = text[max(0, match.start() - 60) : min(len(text), match.end() + 80)].strip()
        people.append((candidate, evidence))
    unique: dict[str, str] = {}
    for label, evidence in people:
        unique.setdefault(label, evidence)
    return list(unique.items())[:8]


def control_state_for(text: str, terms: list[str]) -> str:
    lowered = text.lower()
    missing_markers = ["falta", "missing", "sin ", "pendiente", "bloqueo", "gap", "brecha"]
    ok_markers = ["ok", "cerrado", "validado", "suficiente", "verificable", "aprobado"]
    if any(marker in lowered for marker in missing_markers):
        return "parcial"
    if any(marker in lowered for marker in ok_markers) or terms:
        return "ok_or_expected"
    return "missing"


def confidence_from_text(record: dict[str, Any], matched_terms: list[str], *, metadata_only: bool = False) -> float:
    if metadata_only:
        return 0.95
    if normalize_text(record.get("content_text")) and matched_terms:
        return 0.82
    if normalize_text(record.get("summary")) and matched_terms:
        return 0.68
    if matched_terms:
        return 0.55
    return 0.35


def build_dataverse_graph(records: list[dict[str, Any]], max_evidence_chars: int) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, list[str]]]:
    nodes: dict[str, dict[str, Any]] = {}
    edges: list[dict[str, Any]] = []
    record_entities: dict[str, list[str]] = {}

    for record in records:
        text = evidence_text(record, max_evidence_chars)
        doc_id = document_node_id(record)
        record_entities[doc_id] = []
        site_label = normalize_text(record.get("site_title")) or normalize_text(record.get("site_url")) or "unknown site"
        library_label = normalize_text(record.get("library_title")) or "unknown library"
        content_type_label = normalize_text(record.get("content_type")) or "unknown content type"

        site_id = add_node(
            nodes,
            "Site",
            site_label,
            normalize_text(record.get("site_url")),
            inferred=False,
            node_id=f"Site:{slug(record.get('site_url') or site_label)}",
        )
        library_id = add_node(
            nodes,
            "Library",
            library_label,
            normalize_text(record.get("library_url")) or library_label,
            inferred=False,
            node_id=f"Library:{stable_hash(normalize_text(record.get('site_url')) + '|' + library_label)}",
        )
        doc_id = add_node(
            nodes,
            "Document",
            normalize_text(record.get("file_name")) or normalize_text(record.get("file_path")) or "unknown document",
            normalize_text(record.get("file_path")) or normalize_text(record.get("file_url")),
            inferred=False,
            node_id=doc_id,
            properties=source_trace(record),
        )
        content_type_id = add_node(
            nodes,
            "ContentType",
            content_type_label,
            content_type_label,
            inferred=False,
            node_id=f"ContentType:{slug(content_type_label)}",
        )
        add_edge(edges, site_id, library_id, "contains", normalize_text(record.get("site_url")), confidence=0.98, inferred=False, agent_id="thot-tecnico")
        add_edge(edges, library_id, doc_id, "contains", normalize_text(record.get("file_path")), confidence=0.98, inferred=False, agent_id="thot-tecnico")
        add_edge(edges, library_id, content_type_id, "declares_content_type", content_type_label, confidence=0.9, inferred=False, agent_id="thot-tecnico")
        add_edge(edges, doc_id, content_type_id, "has_content_type", content_type_label, confidence=0.9, inferred=False, agent_id="thot-tecnico")

        for field_name in ("file_extension", "mime_type", "created_utc", "modified_utc", "content_read_status"):
            value = normalize_text(record.get(field_name))
            if not value:
                continue
            field_id = add_node(
                nodes,
                "MetadataField",
                field_name,
                f"{field_name}={value}",
                inferred=False,
                node_id=f"MetadataField:{field_name}",
            )
            add_edge(edges, doc_id, field_id, "has_metadata_field", f"{field_name}={value}", confidence=0.93, inferred=False, agent_id="thot-tecnico")

        conceptual_entities = 0
        for label, terms, evidence in extract_pattern_hits(text, ACT_PATTERNS):
            act_id = add_node(nodes, "Act", label, evidence, inferred=True)
            add_edge(edges, doc_id, act_id, "relates_to", evidence, confidence=confidence_from_text(record, terms), inferred=True, agent_id="seshat-normativa")
            conceptual_entities += 1
            record_entities[doc_id].append(act_id)
            for person_label, person_evidence in extract_people(text):
                person_id = add_node(nodes, "Person", person_label, person_evidence, inferred=True, node_id=f"Person:{stable_hash(person_label)}")
                add_edge(edges, act_id, person_id, "mentions_intervening_person", person_evidence, confidence=0.45, inferred=True, agent_id="maat-cumplimiento")

        for match in EXPEDIENTE_PATTERN.finditer(text):
            expediente_label = match.group(1)
            evidence = text[max(0, match.start() - 80) : min(len(text), match.end() + 120)].strip()
            expediente_id = add_node(nodes, "Expediente", expediente_label, evidence, inferred=True, node_id=f"Expediente:{slug(expediente_label)}")
            add_edge(edges, doc_id, expediente_id, "belongs_to", evidence, confidence=0.62, inferred=True, agent_id="thot-tecnico")
            conceptual_entities += 1
            record_entities[doc_id].append(expediente_id)

        for label, terms, evidence in extract_pattern_hits(text, NORMATIVE_PATTERNS):
            rule_id = add_node(nodes, "NormativeRule", label, evidence, inferred=True)
            obligation_id = add_node(nodes, "Obligation", f"Obligacion {label}", evidence, inferred=True, node_id=f"Obligation:{slug(label)}")
            add_edge(edges, doc_id, rule_id, "relates_to", evidence, confidence=confidence_from_text(record, terms), inferred=True, agent_id="seshat-normativa")
            add_edge(edges, rule_id, obligation_id, "imposes", evidence, confidence=0.64, inferred=True, agent_id="seshat-normativa")
            conceptual_entities += 1
            record_entities[doc_id].append(rule_id)

        for label, terms, evidence in extract_pattern_hits(text, CONTROL_PATTERNS):
            control_id = add_node(nodes, "ExpectedControl", label, evidence, inferred=True)
            state_label = control_state_for(text, terms)
            state_id = add_node(nodes, "ControlState", state_label, evidence, inferred=True, node_id=f"ControlState:{slug(state_label)}")
            add_edge(edges, doc_id, control_id, "expects_control", evidence, confidence=confidence_from_text(record, terms), inferred=True, agent_id="anubis-gate")
            add_edge(edges, control_id, state_id, "has_state", evidence, confidence=0.58, inferred=True, agent_id="anubis-gate")
            conceptual_entities += 1
            record_entities[doc_id].append(control_id)

        for label, terms, evidence in extract_pattern_hits(text, COMPLIANCE_PATTERNS):
            req_id = add_node(nodes, "ComplianceRequirement", label, evidence, inferred=True)
            ev_id = add_node(nodes, "ComplianceEvidence", f"Evidencia {label}", evidence, inferred=True, node_id=f"ComplianceEvidence:{slug(label)}")
            add_edge(edges, doc_id, req_id, "requires", evidence, confidence=confidence_from_text(record, terms), inferred=True, agent_id="maat-cumplimiento")
            add_edge(edges, doc_id, ev_id, "provides_evidence_for", evidence, confidence=0.56, inferred=True, agent_id="maat-cumplimiento")
            conceptual_entities += 1
            record_entities[doc_id].append(req_id)

        lowered_text = text.lower()
        for label, spec in RISK_PATTERNS.items():
            terms = [term for term in spec["terms"] if term.lower() in lowered_text]
            if not terms:
                continue
            evidence = evidence_for_terms(text, terms, text)
            risk_id = add_node(nodes, "Risk", f"{label} ({spec['severity']})", evidence, inferred=True, properties={"severity": spec["severity"]})
            cause_id = add_node(nodes, "Cause", spec["cause"], evidence, inferred=True, node_id=f"Cause:{slug(spec['cause'])}")
            add_edge(edges, doc_id, risk_id, "has_risk", evidence, confidence=confidence_from_text(record, terms), inferred=True, agent_id="horus-riesgo")
            add_edge(edges, risk_id, cause_id, "has_cause", evidence, confidence=0.6, inferred=True, agent_id="horus-riesgo")
            conceptual_entities += 1
            record_entities[doc_id].append(risk_id)

        if conceptual_entities == 0:
            unknown_id = add_node(
                nodes,
                "Classification",
                "sin_clasificar",
                text or normalize_text(record.get("file_path")),
                inferred=True,
                node_id="Classification:sin_clasificar",
            )
            add_edge(
                edges,
                doc_id,
                unknown_id,
                "classification_unknown",
                text or normalize_text(record.get("file_path")),
                confidence=0.35,
                inferred=True,
                agent_id="anubis-gate",
            )
            record_entities[doc_id].append(unknown_id)

    return list(nodes.values()), edges, record_entities


def build_agent_dataverse_contract() -> dict[str, Any]:
    return {
        "mode": "local_contract_only_no_live_binding",
        "queue": DATAVERSE_OPERATING_MODEL["queue"],
        "dispatcher_flow": DATAVERSE_OPERATING_MODEL["dispatcher_flow"],
        "dataverse_solution": DATAVERSE_OPERATING_MODEL["solution"],
        "relationship_strategy": DATAVERSE_OPERATING_MODEL["relationship_strategy"],
        "gate_required": DATAVERSE_APPLY_GATE,
        "agents": {
            agent_id: {
                **AGENT_DATAVERSE_ASSIGNMENTS[agent_id],
                "queue_name": DATAVERSE_OPERATING_MODEL["queue"]["name"],
                "queue_key": DATAVERSE_OPERATING_MODEL["queue"]["workqueuekey"],
                "live_write": False,
                "stop_condition": DATAVERSE_APPLY_STOP_CONDITION,
            }
            for agent_id in all_agent_ids()
        },
    }


def build_dataverse_upsert_plan(
    records: list[dict[str, Any]],
    outputs: dict[str, dict[str, Any]],
    inventory_path: Path,
    relationships: list[dict[str, Any]],
    narrator: str,
) -> dict[str, Any]:
    tables = DATAVERSE_OPERATING_MODEL["tables"]
    upserts: list[dict[str, Any]] = []
    document_canonical_by_node: dict[str, str] = {}

    for record in records:
        source = source_trace(record)
        canonical_id = source_document_canonical_id(source)
        document_canonical_by_node[document_node_id(record)] = canonical_id
        source_path = record_source_path(record)
        source_hash = source_payload_hash(source)
        payload = base_dataverse_payload(
            canonical_id,
            normalize_text(record.get("file_name")) or "SharePoint document",
            source_path=source_path,
            source_hash=source_hash,
            status="sharepoint_reference_detected_pending_validation",
            owner="universe.escribania_tower",
            risk_level="medium",
            notes=(
                "SharePoint remains documentary surface. This row is a local Dataverse reference plan "
                f"for library={normalize_text(record.get('library_title'))}; content_type={normalize_text(record.get('content_type'))}; "
                f"read_status={normalize_text(record.get('content_read_status'))}."
            ),
        )
        payload.update(
            {
                "mon_connection_canonical_id": "conn_canon_sharepoint_documentary_reference",
                "mon_drift_status": "not_checked_local_inventory_only",
                "mon_environment_id": DATAVERSE_OPERATING_MODEL["environment"]["environment_id"],
                "mon_environment_url": DATAVERSE_OPERATING_MODEL["environment"]["environment_url"],
                "mon_import_phase": "sharepoint_inventory_reference_plan",
                "mon_publisher_unique_name": DATAVERSE_OPERATING_MODEL["solution"]["publisher_prefix"],
                "mon_solution_unique_name": DATAVERSE_OPERATING_MODEL["solution"]["unique_name"],
                "mon_snapshot_path": str(inventory_path),
            }
        )
        upserts.append(upsert_record(tables["source_artifact"], canonical_id, payload, source))

    for index, relationship in enumerate(relationships):
        relationship_hash = stable_hash(source_payload_hash(relationship))
        source_node = normalize_text(relationship.get("source"))
        target_node = normalize_text(relationship.get("target"))
        relationship_kind = normalize_text(relationship.get("relationship_type")) or normalize_text(relationship.get("relationship"))
        table = tables["connection_risk"] if "Risk" in {source_node.split(":", 1)[0], target_node.split(":", 1)[0]} else tables["connection_instance"]
        canonical_id = f"sprel.{relationship_hash}"
        source_path = normalize_text(relationship.get("evidence"))[:900] or str(inventory_path)
        payload = base_dataverse_payload(
            canonical_id,
            f"{source_node} -> {target_node}",
            source_path=source_path,
            source_hash=source_payload_hash(relationship),
            status="inferred_pending_human_validation",
            owner=normalize_text(relationship.get("agent_id")) or "unassigned",
            risk_level="high" if table == tables["connection_risk"] else "medium",
            notes=(
                f"Local inferred relationship from SharePoint inventory. relationship={normalize_text(relationship.get('relationship'))}; "
                f"confidence={relationship.get('confidence')}; inferred={relationship.get('inferred')}; index={index}."
            ),
        )
        if table == tables["connection_risk"]:
            payload.update(
                {
                    "mon_connection_canonical_id": document_canonical_by_node.get(source_node, source_node),
                    "mon_provider": "Microsoft",
                    "mon_surface": "SharePoint|Dataverse",
                    "mon_mitigation": "manual_review_before_dataverse_apply",
                }
            )
        else:
            payload.update(
                {
                    "mon_canonical_class": "sharepoint_document_graph_relationship",
                    "mon_connection_type": relationship_kind,
                    "mon_evidence_hash": source_payload_hash(relationship),
                    "mon_provider": "Microsoft",
                    "mon_repo": "universo-rey/cabina-universal-d",
                    "mon_secret_required": "false",
                    "mon_secret_status": "not_required",
                    "mon_surface": "SharePoint|Dataverse",
                }
            )
        upserts.append(upsert_record(table, canonical_id, payload, {"relationship": relationship}))

    for agent_id, output in outputs.items():
        assignment = AGENT_DATAVERSE_ASSIGNMENTS[agent_id]
        for index, finding in enumerate(output.get("findings", [])):
            source = finding.get("source", {})
            document_canonical_id = source_document_canonical_id(source) if isinstance(source, dict) else "spdoc.unknown"
            canonical_id = f"agentfinding.{slug(agent_id)}.{stable_hash(document_canonical_id + '|' + str(index))}"
            evidence_excerpt = normalize_text(finding.get("evidence_excerpt"))
            payload = base_dataverse_payload(
                canonical_id,
                f"{agent_id} finding {index + 1}",
                source_path=normalize_text(source.get("file_url")) or normalize_text(source.get("file_path")) if isinstance(source, dict) else str(inventory_path),
                source_hash=source_payload_hash(finding),
                status="agent_finding_pending_human_validation",
                owner=agent_id,
                risk_level=assignment["risk_level"],
                notes=(
                    f"Agent domain={output.get('domain')}; confidence={finding.get('confidence')}; "
                    f"matched_terms={', '.join(finding.get('matched_terms', []))}; evidence={evidence_excerpt[:900]}"
                ),
            )
            payload.update(
                {
                    "mon_connection_canonical_id": document_canonical_id,
                    "mon_evidence_hash": source_payload_hash(finding),
                    "mon_evidence_type": f"sharepoint_inventory_{agent_id}_finding",
                }
            )
            upserts.append(upsert_record(tables["evidence"], canonical_id, payload, source if isinstance(source, dict) else {}))

    for agent_id in all_agent_ids():
        assignment = AGENT_DATAVERSE_ASSIGNMENTS[agent_id]
        canonical_id = f"agentmap.{slug(agent_id)}.sharepoint_inventory_dataverse_plan"
        payload = base_dataverse_payload(
            canonical_id,
            f"{agent_id} SharePoint inventory Dataverse contract",
            source_path="scripts/sharepoint/sdu_sharepoint_agent_pipeline.py",
            source_hash=source_payload_hash(assignment),
            status="local_contract_ready_pending_gate",
            owner=agent_id,
            risk_level=assignment["risk_level"],
            notes=(
                f"read_tables={', '.join(assignment['read_tables'])}; "
                f"write_plan_tables={', '.join(assignment['write_plan_tables'])}; "
                f"queue={DATAVERSE_OPERATING_MODEL['queue']['name']}."
            ),
        )
        upserts.append(upsert_record(tables["agent_mapping"], canonical_id, payload, {"agent_id": agent_id}))

    gate_payload = base_dataverse_payload(
        f"gate.{BATCH_ID}",
        "Human validation before Dataverse apply",
        source_path=str(inventory_path),
        source_hash=hash_file(inventory_path),
        status="gate_required",
        owner="anubis-gate",
        risk_level="high",
        notes="No Dataverse live apply is performed by this pipeline. Human gate required before any Power Platform apply.",
    )
    upserts.append(upsert_record(tables["validation_gate"], gate_payload["mon_canonical_id"], gate_payload, {"inventory_json": str(inventory_path)}))

    readback_payload = base_dataverse_payload(
        f"readback.{BATCH_ID}",
        "SharePoint inventory agent Dataverse synthesis",
        source_path=str(inventory_path),
        source_hash=full_hash(narrator),
        status="local_readback_ready",
        owner=NARRATOR_AGENT,
        risk_level="medium",
        notes=narrator[:1800],
    )
    upserts.append(upsert_record(tables["readback"], readback_payload["mon_canonical_id"], readback_payload, {"narrator": NARRATOR_AGENT}))

    apply_log_payload = base_dataverse_payload(
        f"applylog.{BATCH_ID}",
        "No-live Dataverse apply log for SharePoint inventory pipeline",
        source_path=str(inventory_path),
        source_hash=hash_file(inventory_path),
        status="local_plan_only_no_apply",
        owner=PIPELINE_SYSTEM_ID,
        risk_level="medium",
        notes="Pipeline emitted local upsert plan and queue payloads only. live_apply=false for every planned operation.",
    )
    upserts.append(upsert_record(tables["apply_log"], apply_log_payload["mon_canonical_id"], apply_log_payload, {"inventory_json": str(inventory_path)}))

    counts_by_table: dict[str, int] = {}
    for item in upserts:
        table = item["table"]
        counts_by_table[table] = counts_by_table.get(table, 0) + 1

    return {
        "mode": "LOCAL_PLAN_ONLY_NO_DATAVERSE_WRITE",
        "live_apply": False,
        "batch_id": BATCH_ID,
        "generated_at_utc": utc_now(),
        "inventory_json": str(inventory_path),
        "operating_model": DATAVERSE_OPERATING_MODEL,
        "alternate_key": "mon_canonical_id",
        "relationship_strategy": DATAVERSE_OPERATING_MODEL["relationship_strategy"],
        "counts_by_table": counts_by_table,
        "upsert_count": len(upserts),
        "upserts": upserts,
    }


def build_power_automate_queue_items(inventory_path: Path, outputs: dict[str, dict[str, Any]]) -> dict[str, Any]:
    inventory_hash = hash_file(inventory_path)
    environment = DATAVERSE_OPERATING_MODEL["environment"]
    items = []
    for agent_id in all_agent_ids():
        assignment = AGENT_DATAVERSE_ASSIGNMENTS[agent_id]
        canonical_id = f"queue.sdu_agent_dispatch.{slug(agent_id)}.{stable_hash(inventory_hash)}"
        items.append(
            {
                "queue_item_type": QUEUE_ITEM_TYPE,
                "canonical_id": canonical_id,
                "correlation_id": f"{PIPELINE_SYSTEM_ID}:{stable_hash(str(inventory_path) + inventory_hash)}",
                "idempotency_key": f"{canonical_id}.{BATCH_ID}",
                "batch_id": BATCH_ID,
                "source_table": DATAVERSE_OPERATING_MODEL["tables"]["source_artifact"],
                "source_matrix": "scripts/sharepoint/sdu_sharepoint_agent_pipeline.py",
                "source_path": str(inventory_path),
                "source_hash": inventory_hash,
                "operation": f"{QUEUE_OPERATION}.{assignment['domain_operation']}",
                "target_environment_id": environment["environment_id"],
                "target_environment_url": environment["environment_url"],
                "gate_required": True,
                "gate_id": DATAVERSE_APPLY_GATE,
                "risk_level": assignment["risk_level"],
                "priority": assignment["priority"],
                "stop_condition": DATAVERSE_APPLY_STOP_CONDITION,
                "rollback_strategy": "delete_or_deactivate_by_batch_id_and_mon_canonical_id",
                "evidence_required": [
                    "inventory_json",
                    "dataverse_upsert_plan_json",
                    "agent_output_json_or_narrator_txt",
                    "manual_sample_validation_before_apply",
                ],
                "created_by_system": PIPELINE_SYSTEM_ID,
                "ai_assisted": False,
                "ai_validation_status": "deterministic_local_rules_pending_human_validation",
            }
        )

    missing_by_item = {
        item["canonical_id"]: [field for field in QUEUE_REQUIRED_FIELDS if field not in item]
        for item in items
    }
    missing_by_item = {key: value for key, value in missing_by_item.items() if value}
    return {
        "mode": "LOCAL_QUEUE_PAYLOAD_ONLY_NO_POWER_AUTOMATE_WRITE",
        "live_apply": False,
        "queue": DATAVERSE_OPERATING_MODEL["queue"],
        "dispatcher_flow": DATAVERSE_OPERATING_MODEL["dispatcher_flow"],
        "required_schema_fields": QUEUE_REQUIRED_FIELDS,
        "schema_validation": {
            "status": "PASS" if not missing_by_item else "FAIL",
            "missing_by_item": missing_by_item,
        },
        "items": items,
    }


def relationships_for_agent(relationships: list[dict[str, Any]], agent_id: str) -> list[dict[str, Any]]:
    allowed = AGENT_RELATIONSHIP_TYPES.get(agent_id, set())
    return [
        relationship
        for relationship in relationships
        if relationship.get("agent_id") == agent_id or relationship.get("relationship_type") in allowed
    ]


def match_terms(text: str, keywords: list[str]) -> list[str]:
    lowered = text.lower()
    hits = []
    for keyword in keywords:
        if keyword.lower() in lowered:
            hits.append(keyword)
    return hits


def confidence_for(record: dict[str, Any], hits: list[str]) -> str:
    if hits and normalize_text(record.get("content_text")):
        return "content_keyword_match"
    if hits and normalize_text(record.get("summary")):
        return "summary_keyword_match"
    if hits:
        return "metadata_keyword_match"
    return "metadata_context_only"


def classify_record(agent_id: str, record: dict[str, Any], max_evidence_chars: int) -> dict[str, Any] | None:
    rules = AGENT_RULES[agent_id]
    text = evidence_text(record, max_evidence_chars)
    hits = match_terms(text, rules["keywords"])

    extension = normalize_text(record.get("file_extension")).lower()
    content_type = normalize_text(record.get("content_type")).lower()
    library = normalize_text(record.get("library_title")).lower()
    metadata_context_hit = False

    if agent_id == "seshat-normativa" and ("pagina" in content_type or "canonical" in library or "canonic" in library):
        metadata_context_hit = True
    if agent_id == "thot-tecnico" and extension in {"json", "csv", "xml", "aspx"}:
        metadata_context_hit = True
    if agent_id == "anubis-gate" and ("gate" in library or "control" in library):
        metadata_context_hit = True
    if agent_id == "maat-cumplimiento" and ("cumplimiento" in library or "auditoria" in library):
        metadata_context_hit = True
    if agent_id == "horus-riesgo" and ("risk" in library or "riesgo" in library):
        metadata_context_hit = True

    if not hits and not metadata_context_hit:
        return None

    basis = rules["lens"]
    if not hits:
        basis = f"{basis}; coincidencia por metadata"

    return {
        "source": source_trace(record),
        "matched_terms": hits,
        "confidence": confidence_for(record, hits),
        "agent_interpretation": basis,
        "evidence_excerpt": text,
    }


def agent_output(
    agent_id: str,
    records: list[dict[str, Any]],
    inventory_path: Path,
    max_evidence_chars: int,
    relationships: list[dict[str, Any]],
) -> dict[str, Any]:
    findings = []
    for record in records:
        item = classify_record(agent_id, record, max_evidence_chars)
        if item:
            findings.append(item)

    rules = AGENT_RULES[agent_id]
    status_counts: dict[str, int] = {}
    for record in records:
        status = normalize_text(record.get("content_read_status")) or "unknown"
        status_counts[status] = status_counts.get(status, 0) + 1

    return {
        "agent_id": agent_id,
        "domain": rules["domain"],
        "generated_at_utc": utc_now(),
        "input": {
            "inventory_json": str(inventory_path),
            "source_record_count": len(records),
            "records_considered": len(records),
            "content_read_status_counts": status_counts,
        },
        "governance": {
            "network_used": False,
            "sharepoint_write": False,
            "dataverse_write": False,
            "power_automate_write": False,
            "source_documents_modified": False,
            "body_reading_scope": "bounded_input_json_only",
            "no_inference_beyond_source": True,
        },
        "dataverse_persistence": {
            "mode": "local_plan_only_no_live_write",
            "assignment": AGENT_DATAVERSE_ASSIGNMENTS[agent_id],
            "queue_name": DATAVERSE_OPERATING_MODEL["queue"]["name"],
            "queue_key": DATAVERSE_OPERATING_MODEL["queue"]["workqueuekey"],
            "dispatcher_flow": DATAVERSE_OPERATING_MODEL["dispatcher_flow"]["name"],
            "gate_required": DATAVERSE_APPLY_GATE,
            "stop_condition": DATAVERSE_APPLY_STOP_CONDITION,
        },
        "rules": {
            "keywords": rules["keywords"],
            "evidence_fields": [
                "file_name",
                "library_title",
                "content_type",
                "mime_type",
                "summary",
                "content_text",
                "file_path",
            ],
        },
        "dataverse_connections": relationships_for_agent(relationships, agent_id),
        "findings": findings,
        "limitations": build_limitations(records),
    }


def build_limitations(records: list[dict[str, Any]]) -> list[str]:
    statuses = {normalize_text(record.get("content_read_status")) for record in records}
    limitations = [
        "No external network or live SharePoint read is performed by this pipeline.",
        "The pipeline only uses metadata, summaries, and bounded content already present in the inventory JSON.",
    ]
    if "unsupported_type" in statuses:
        limitations.append("Some files have unsupported readable content types and were treated from metadata/summary only.")
    if "not_requested" in statuses:
        limitations.append("Some records did not request content extraction and were treated from metadata/summary only.")
    if "error" in statuses:
        limitations.append("Some records have read errors in the source inventory and were not re-read.")
    return limitations


def narrator_text(
    outputs: dict[str, dict[str, Any]],
    records: list[dict[str, Any]],
    inventory_path: Path,
    entity_count: int,
    relationship_count: int,
    upsert_count: int = 0,
    queue_item_count: int = 0,
) -> str:
    lines = [
        "Narrador normativo - sintesis ejecutiva",
        "",
        f"Generado UTC: {utc_now()}",
        f"Inventario base: {inventory_path}",
        f"Registros considerados: {len(records)}",
        f"Entidades Dataverse inferidas/directas: {entity_count}",
        f"Relaciones Dataverse inferidas/directas: {relationship_count}",
        f"Upserts Dataverse planeados localmente: {upsert_count}",
        f"Items de cola Power Automate planeados localmente: {queue_item_count}",
        "",
        "Lectura gobernada:",
        "- No se ejecuto red externa desde este pipeline.",
        "- No se modificaron documentos fuente.",
        "- La lectura se limita al JSON de inventario, sus resumenes y fragmentos acotados.",
        "- SharePoint queda como superficie documental; Dataverse se modela como nucleo estructurado por referencias.",
        "- Power Automate queda como orquestador por cola, sin activar flows ni crear work items live.",
        "",
        "Resultados por dominio:",
    ]

    for agent_id in AGENT_ORDER:
        output = outputs[agent_id]
        lines.append(
            f"- {agent_id}: {len(output['findings'])} hallazgos trazables; "
            f"{len(output['dataverse_connections'])} conexiones asignadas."
        )

    lines.extend(["", "Lectura transversal:"])
    if records:
        libraries = sorted({normalize_text(record.get("library_title")) for record in records if record.get("library_title")})
        extensions = sorted({normalize_text(record.get("file_extension")).lower() for record in records if record.get("file_extension")})
        lines.append(f"- Bibliotecas observadas: {', '.join(libraries[:12]) if libraries else 'sin biblioteca informada'}.")
        lines.append(f"- Tipos/extensiones observadas: {', '.join(extensions[:20]) if extensions else 'sin extension informada'}.")
    else:
        lines.append("- El dataset filtrado no contiene registros.")

    lines.extend(
        [
            "",
            "Limites:",
            "- No se infiere contenido no presente.",
            "- PDFs y binarios dependen de metadata/resumen si el inventario no trajo texto.",
            "- Las relaciones conceptuales se marcan con inferred=true y no equivalen a escrituras Dataverse.",
            "- Los planes Dataverse y Power Automate generados son payloads locales; requieren gate humano antes de aplicar.",
            "- La validacion manual debe muestrear fuentes contra SharePoint antes de cualquier decision institucional.",
        ]
    )
    return "\n".join(lines) + "\n"


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def run_pipeline(args: argparse.Namespace) -> dict[str, Any]:
    inventory_path = Path(args.inventory_json).resolve()
    output_dir = Path(args.output_dir).resolve()
    records = load_inventory(inventory_path)
    if args.site_url_contains:
        records = [record for record in records if record_site_matches(record, args.site_url_contains)]
    if args.max_records and len(records) > args.max_records:
        records = records[: args.max_records]

    output_dir.mkdir(parents=True, exist_ok=True)
    dataverse_entities, dataverse_relationships, record_entities = build_dataverse_graph(records, args.max_evidence_chars)
    outputs = {
        agent_id: agent_output(agent_id, records, inventory_path, args.max_evidence_chars, dataverse_relationships)
        for agent_id in AGENT_ORDER
    }
    for agent_id, payload in outputs.items():
        write_json(output_dir / f"{agent_id}.json", payload)

    write_json(output_dir / "dataverse_entities.json", dataverse_entities)
    write_json(output_dir / "dataverse_relationships.json", dataverse_relationships)

    preliminary_narrator = narrator_text(outputs, records, inventory_path, len(dataverse_entities), len(dataverse_relationships))
    dataverse_upsert_plan = build_dataverse_upsert_plan(
        records,
        outputs,
        inventory_path,
        dataverse_relationships,
        preliminary_narrator,
    )
    power_automate_queue_items = build_power_automate_queue_items(inventory_path, outputs)
    agent_dataverse_contract = build_agent_dataverse_contract()
    narrator = narrator_text(
        outputs,
        records,
        inventory_path,
        len(dataverse_entities),
        len(dataverse_relationships),
        dataverse_upsert_plan["upsert_count"],
        len(power_automate_queue_items["items"]),
    )
    (output_dir / f"{NARRATOR_AGENT}.txt").write_text(narrator, encoding="utf-8")
    dataverse_upsert_plan = build_dataverse_upsert_plan(
        records,
        outputs,
        inventory_path,
        dataverse_relationships,
        narrator,
    )

    write_json(output_dir / "dataverse_operating_model.json", DATAVERSE_OPERATING_MODEL)
    write_json(output_dir / "agent_dataverse_contract.json", agent_dataverse_contract)
    write_json(output_dir / "dataverse_upsert_plan.json", dataverse_upsert_plan)
    write_json(output_dir / "power_automate_queue_items.json", power_automate_queue_items)

    run_summary = {
        "status": "SDU_SHAREPOINT_AGENT_PIPELINE_EXPORTED",
        "generated_at_utc": utc_now(),
        "inventory_json": str(inventory_path),
        "output_dir": str(output_dir),
        "site_url_contains": args.site_url_contains,
        "record_count": len(records),
        "dataverse_entities_output": str(output_dir / "dataverse_entities.json"),
        "dataverse_relationships_output": str(output_dir / "dataverse_relationships.json"),
        "dataverse_operating_model_output": str(output_dir / "dataverse_operating_model.json"),
        "agent_dataverse_contract_output": str(output_dir / "agent_dataverse_contract.json"),
        "dataverse_upsert_plan_output": str(output_dir / "dataverse_upsert_plan.json"),
        "power_automate_queue_items_output": str(output_dir / "power_automate_queue_items.json"),
        "dataverse_entity_count": len(dataverse_entities),
        "dataverse_relationship_count": len(dataverse_relationships),
        "dataverse_upsert_plan_count": dataverse_upsert_plan["upsert_count"],
        "power_automate_queue_item_count": len(power_automate_queue_items["items"]),
        "live_apply": False,
        "live_apply_gate": DATAVERSE_APPLY_GATE,
        "documents_without_conceptual_classification": sum(
            1
            for entities in record_entities.values()
            if entities == ["Classification:sin_clasificar"]
        ),
        "agents": {
            agent_id: {
                "output": str(output_dir / f"{agent_id}.json"),
                "finding_count": len(outputs[agent_id]["findings"]),
                "connection_count": len(outputs[agent_id]["dataverse_connections"]),
                "dataverse_assignment": AGENT_DATAVERSE_ASSIGNMENTS[agent_id],
            }
            for agent_id in AGENT_ORDER
        },
        "narrator_output": str(output_dir / f"{NARRATOR_AGENT}.txt"),
    }
    write_json(output_dir / "run_summary.json", run_summary)
    return run_summary


def self_test() -> None:
    temp_dir = Path(tempfile.mkdtemp(prefix="sdu-sharepoint-agent-pipeline-"))
    try:
        inventory_path = temp_dir / "inventory.json"
        output_dir = temp_dir / "outputs"
        synthetic = [
            {
                "site_title": "Hub Seshat",
                "site_url": "https://escribaniabitsch.sharepoint.com/sites/SeshatHubRegistroN.8",
                "library_title": "HUB_PaginasCanonicas",
                "file_name": "home-canonica-escribania.aspx",
                "file_path": "/sites/SeshatHubRegistroN.8/SitePages/home-canonica-escribania.aspx",
                "file_url": "https://example.invalid/home-canonica-escribania.aspx",
                "file_extension": "aspx",
                "mime_type": "text/html",
                "content_type": "Pagina del sitio",
                "created_utc": "2026-06-01T00:00:00Z",
                "modified_utc": "2026-06-02T00:00:00Z",
                "content_read_status": "read",
                "summary": "Canon rector, normativa, metadata y gobernanza del hub.",
                "content_text": "Dictamen canon rector con protocolo, taxonomia, metadata, gate, cumplimiento UIF, KYC y riesgo operativo.",
            },
            {
                "site_title": "Hub Seshat",
                "site_url": "https://escribaniabitsch.sharepoint.com/sites/SeshatHubRegistroN.8",
                "library_title": "Documentos",
                "file_name": "evidencia.pdf",
                "file_path": "/sites/SeshatHubRegistroN.8/Documentos/evidencia.pdf",
                "file_url": "https://example.invalid/evidencia.pdf",
                "file_extension": "pdf",
                "mime_type": "application/pdf",
                "content_type": "Documento",
                "created_utc": "2026-06-01T00:00:00Z",
                "modified_utc": "2026-06-02T00:00:00Z",
                "content_read_status": "unsupported_type",
                "summary": "Auditoria con pendiente de postcheck.",
                "content_text": "",
            },
        ]
        write_json(inventory_path, synthetic)
        args = argparse.Namespace(
            inventory_json=str(inventory_path),
            output_dir=str(output_dir),
            site_url_contains=DEFAULT_SITE_FILTER,
            max_records=0,
            max_evidence_chars=700,
        )
        summary = run_pipeline(args)
        expected = [output_dir / f"{agent_id}.json" for agent_id in AGENT_ORDER]
        expected.append(output_dir / "dataverse_entities.json")
        expected.append(output_dir / "dataverse_relationships.json")
        expected.append(output_dir / "dataverse_operating_model.json")
        expected.append(output_dir / "agent_dataverse_contract.json")
        expected.append(output_dir / "dataverse_upsert_plan.json")
        expected.append(output_dir / "power_automate_queue_items.json")
        expected.append(output_dir / f"{NARRATOR_AGENT}.txt")
        expected.append(output_dir / "run_summary.json")
        missing = [str(path) for path in expected if not path.exists()]
        if missing:
            raise AssertionError("missing expected outputs: " + ", ".join(missing))
        if summary["record_count"] != 2:
            raise AssertionError("self-test did not preserve the synthetic dataset")
        for agent_id in AGENT_ORDER:
            payload = json.loads((output_dir / f"{agent_id}.json").read_text(encoding="utf-8"))
            if payload["input"]["source_record_count"] != 2:
                raise AssertionError(f"{agent_id} did not receive the same dataset")
            if "findings" not in payload or not isinstance(payload["findings"], list):
                raise AssertionError(f"{agent_id} missing structured findings")
            if "dataverse_connections" not in payload or not isinstance(payload["dataverse_connections"], list):
                raise AssertionError(f"{agent_id} missing dataverse connections")
        entities = json.loads((output_dir / "dataverse_entities.json").read_text(encoding="utf-8"))
        relationships = json.loads((output_dir / "dataverse_relationships.json").read_text(encoding="utf-8"))
        operating_model = json.loads((output_dir / "dataverse_operating_model.json").read_text(encoding="utf-8"))
        upsert_plan = json.loads((output_dir / "dataverse_upsert_plan.json").read_text(encoding="utf-8"))
        queue_payload = json.loads((output_dir / "power_automate_queue_items.json").read_text(encoding="utf-8"))
        if not entities or not relationships:
            raise AssertionError("dataverse graph outputs must not be empty")
        if operating_model["queue"]["name"] != "SDU.Agent.Dispatch.Queue":
            raise AssertionError("pipeline must use the existing SDU.Agent.Dispatch.Queue")
        if upsert_plan.get("live_apply") is not False:
            raise AssertionError("upsert plan must remain local and non-live")
        if not any(item.get("table") == "mon_sdu_source_artifact" for item in upsert_plan.get("upserts", [])):
            raise AssertionError("upsert plan must map documents to mon_sdu_source_artifact")
        if queue_payload.get("live_apply") is not False:
            raise AssertionError("queue payload export must remain local and non-live")
        if queue_payload.get("schema_validation", {}).get("status") != "PASS":
            raise AssertionError("queue items must satisfy required schema fields")
        queued_agents = {
            item["operation"].split(".")[-1]
            for item in queue_payload.get("items", [])
        }
        expected_domain_ops = {
            AGENT_DATAVERSE_ASSIGNMENTS[agent_id]["domain_operation"]
            for agent_id in all_agent_ids()
        }
        if queued_agents != expected_domain_ops:
            raise AssertionError("queue items must cover all agent domain operations")
        if any(item.get("live_apply") for item in upsert_plan.get("upserts", [])):
            raise AssertionError("individual upserts must not request live apply")
        document_ids = {entity["id"] for entity in entities if entity.get("type") == "Document"}
        classified_documents = {
            relationship["source"]
            for relationship in relationships
            if str(relationship.get("source", "")).startswith("Document:")
        }
        missing_classification = sorted(document_ids - classified_documents)
        if missing_classification:
            raise AssertionError("documents without entity or classification: " + ", ".join(missing_classification))
        if not any(edge.get("target") == "Act:Dictamen" for edge in relationships):
            raise AssertionError("expected Dictamen act relation was not inferred")
        print("SDU_SHAREPOINT_AGENT_PIPELINE_SELF_TEST=PASS")
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run local SDU-CN agent views over a SharePoint inventory JSON.")
    parser.add_argument("--inventory-json", help="Path to sharepoint_document_inventory_*.json")
    parser.add_argument("--output-dir", default="outputs", help="Directory for agent outputs")
    parser.add_argument("--site-url-contains", default=DEFAULT_SITE_FILTER, help="Optional site URL/title/path filter")
    parser.add_argument("--max-records", type=int, default=0, help="Optional safety cap after filtering; 0 means all")
    parser.add_argument("--max-evidence-chars", type=int, default=1200, help="Max chars per evidence excerpt")
    parser.add_argument("--self-test", action="store_true", help="Run a synthetic local self-test without SharePoint")
    args = parser.parse_args()
    if args.self_test:
        return args
    if not args.inventory_json:
        parser.error("--inventory-json is required unless --self-test is used")
    if args.max_evidence_chars < 128:
        parser.error("--max-evidence-chars must be at least 128")
    if args.max_records < 0:
        parser.error("--max-records cannot be negative")
    return args


def main() -> None:
    args = parse_args()
    if args.self_test:
        self_test()
        return
    summary = run_pipeline(args)
    print(json.dumps(summary, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
