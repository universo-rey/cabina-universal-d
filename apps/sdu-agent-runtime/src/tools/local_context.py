from __future__ import annotations

import hashlib


def summarize_request(text: str) -> dict:
    normalized = " ".join(text.split())
    return {
        "input_length": len(text),
        "summary_hash": hashlib.sha256(normalized.encode("utf-8")).hexdigest()[:16],
    }
