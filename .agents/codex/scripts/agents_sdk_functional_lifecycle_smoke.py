#!/usr/bin/env python
"""Governed OpenAI + Agents SDK functional lifecycle smoke.

This script intentionally emits only sanitized status metadata. It never prints
the API key, response bodies, or agent final output.
"""

from __future__ import annotations

import asyncio
import importlib.metadata
import json
import os
from pathlib import Path
from typing import Any


SCRIPT_ID = "agents_sdk_functional_lifecycle_smoke"
EXPECTED_REPO = "universo-rey/cabina-universal-d"
CANON = "CABINA_FULL_LIVE_GOVERNED_GLOBAL_CANON"
RESPONSES_MARKER = "CABINA_RESPONSES_FUNCTIONAL_LIFECYCLE_PASS"
AGENT_MARKER = "CABINA_AGENT_FUNCTIONAL_LIFECYCLE_PASS"
MODEL_CANDIDATES = (
    "gpt-5.5",
    "gpt-5-mini",
    "gpt-5",
    "gpt-4.1-mini",
    "gpt-4o-mini",
)


def repo_root() -> Path:
    return Path(__file__).resolve().parents[3]


def load_openai_key(root: Path) -> str:
    if os.environ.get("OPENAI_API_KEY"):
        return "process_env"

    local_env = root / ".env.local"
    if not local_env.exists():
        raise RuntimeError("OPENAI_API_KEY_MISSING")
    if local_env.is_symlink():
        raise RuntimeError("OPENAI_API_KEY_LOCAL_SOURCE_SYMLINK_BLOCKED")

    for raw_line in local_env.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        name, value = line.split("=", 1)
        if name.strip() != "OPENAI_API_KEY":
            continue
        value = value.strip().strip("\"'")
        if not value:
            break
        os.environ["OPENAI_API_KEY"] = value
        return "local_ignored_env_file"

    raise RuntimeError("OPENAI_API_KEY_MISSING")


def choose_model(model_ids: set[str]) -> str:
    requested = os.environ.get("OPENAI_SMOKE_MODEL")
    candidates = (requested,) + MODEL_CANDIDATES if requested else MODEL_CANDIDATES
    for candidate in candidates:
        if candidate and candidate in model_ids:
            return candidate
    raise RuntimeError("NO_PREFERRED_SMOKE_MODEL_AVAILABLE")


async def run_agent(model: str) -> tuple[bool, str]:
    from agents import Agent, Runner, set_tracing_disabled

    set_tracing_disabled(True)
    agent = Agent(
        name="cabina-agents-sdk-functional-lifecycle",
        instructions=(
            "For this governed synthetic lifecycle smoke, return exactly "
            f"{AGENT_MARKER} and do not add any other text."
        ),
        model=model,
    )
    result = await Runner.run(
        agent,
        "Synthetic non-sensitive lifecycle smoke. No tools. No external writes.",
        max_turns=2,
    )
    final_output = str(getattr(result, "final_output", "") or "")
    last_agent = getattr(getattr(result, "last_agent", None), "name", "UNKNOWN")
    return AGENT_MARKER in final_output, last_agent


def main() -> int:
    summary: dict[str, Any] = {
        "script_id": SCRIPT_ID,
        "repo": EXPECTED_REPO,
        "canon": CANON,
        "status": "FAIL",
        "synthetic_payload_only": True,
        "response_bodies_printed": False,
        "agent_output_printed": False,
        "secrets_printed": False,
        "microsoft_live_executed": False,
        "production_executed": False,
        "propagation_executed": False,
    }

    try:
        root = repo_root()
        summary["credential_source"] = load_openai_key(root)

        import openai  # noqa: F401
        from openai import OpenAI
        import agents  # noqa: F401

        summary["import_openai"] = "PASS"
        summary["import_agents"] = "PASS"
        summary["openai_version"] = importlib.metadata.version("openai")
        summary["openai_agents_version"] = importlib.metadata.version("openai-agents")

        client = OpenAI()
        models_page = client.models.list()
        model_ids = {item.id for item in models_page.data}
        summary["openai_models_list"] = "PASS"
        summary["openai_models_count_present"] = bool(model_ids)

        model = choose_model(model_ids)
        summary["model_used"] = model

        response = client.responses.create(
            model=model,
            input=(
                "Synthetic cabina functional lifecycle smoke. Reply exactly "
                f"{RESPONSES_MARKER} and no other text."
            ),
            max_output_tokens=32,
        )
        response_text = str(getattr(response, "output_text", "") or "")
        summary["responses_api"] = "PASS"
        summary["responses_id_present"] = bool(getattr(response, "id", None))
        summary["responses_marker_verified"] = RESPONSES_MARKER in response_text

        agent_marker_verified, last_agent = asyncio.run(run_agent(model))
        summary["agents_sdk_runner"] = "PASS"
        summary["agents_marker_verified"] = agent_marker_verified
        summary["agents_last_agent_name"] = last_agent

        if not summary["responses_marker_verified"]:
            raise RuntimeError("RESPONSES_MARKER_NOT_VERIFIED")
        if not summary["agents_marker_verified"]:
            raise RuntimeError("AGENTS_MARKER_NOT_VERIFIED")

        summary["status"] = "PASS"
        return 0
    except Exception as exc:  # noqa: BLE001 - sanitize and report compactly.
        summary["status"] = "FAIL"
        summary["error_type"] = exc.__class__.__name__
        summary["error_code"] = str(exc).splitlines()[0][:160]
        return 1
    finally:
        print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    raise SystemExit(main())
