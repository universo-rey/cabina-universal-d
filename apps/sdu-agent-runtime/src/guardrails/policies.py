from __future__ import annotations


FORBIDDEN_SURFACES = {
    "openai_api_live": ("openai api live", "api live", "agents sdk live", "agent builder"),
    "microsoft_live": ("microsoft live", "sharepoint", "teams", "planner", "graph", "power platform", "tenant write"),
    "production": ("production", "produccion", "prod"),
    "permission_change": ("permission", "permiso", "permissions"),
    "secret_materialization": ("secret", "secreto", "token", "credential", "password"),
}


def evaluate_forbidden_surfaces(text: str, metadata: dict | None = None) -> dict:
    haystack = " ".join([text.lower(), " ".join(f"{k}={v}" for k, v in (metadata or {}).items()).lower()])
    blocked = []
    for surface, markers in FORBIDDEN_SURFACES.items():
        if any(marker in haystack for marker in markers):
            blocked.append(surface)
    return {"blocked_surfaces": sorted(set(blocked))}
