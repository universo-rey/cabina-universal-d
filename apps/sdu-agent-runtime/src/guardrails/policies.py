from __future__ import annotations

import re


FORBIDDEN_SURFACES = {
    "openai_api_live": ("openai api live", "api live", "agents sdk live", "agent builder"),
    "microsoft_live": ("microsoft live", "sharepoint", "teams", "planner", "graph", "power platform", "tenant write"),
    "production": ("production", "produccion", "producción"),
    "permission_change": ("permission", "permiso", "permissions"),
    "secret_materialization": ("secret", "secreto", "token", "credential", "password"),
}

WORD_MARKERS = {
    "production": (re.compile(r"\bprod\b"),),
}


def evaluate_forbidden_surfaces(text: str, metadata: dict | None = None) -> dict:
    haystack = " ".join([text.lower(), " ".join(f"{k}={v}" for k, v in (metadata or {}).items()).lower()])
    blocked = []
    for surface, markers in FORBIDDEN_SURFACES.items():
        literal_match = any(marker in haystack for marker in markers)
        word_match = any(pattern.search(haystack) for pattern in WORD_MARKERS.get(surface, ()))
        if literal_match or word_match:
            blocked.append(surface)
    return {"blocked_surfaces": sorted(set(blocked))}
