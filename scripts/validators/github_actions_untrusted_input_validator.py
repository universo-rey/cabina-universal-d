#!/usr/bin/env python3
"""Reject untrusted workflow inputs interpolated directly into shell scripts."""

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
WORKFLOWS = (
    "power-platform-alm-full-dev.yml",
    "power-platform-pack-import-dev.yml",
    "power-platform-check-solution.yml",
    "power-platform-export-unpack.yml",
    "power-platform-whoami.yml",
    "dataverse-import-dev.manual.yml",
)


def run_blocks(lines: list[str]):
    """Yield every YAML run scalar, including inline and chomped forms."""
    number = 0
    while number < len(lines):
        line = lines[number]
        match = re.match(r"""^(\s*)-?\s*(?:run|["']run["'])\s*:\s*(.*?)\s*$""", line)
        if not match:
            number += 1
            continue
        indent = len(match.group(1))
        value = match.group(2)
        if re.fullmatch(r"[|>](?:(?:[1-9][+-]?)|(?:[+-][1-9]?))?(?:\s+#.*)?", value):
            number += 1
            while number < len(lines):
                nested = lines[number]
                stripped = nested.lstrip()
                nested_indent = len(nested) - len(stripped)
                if stripped and nested_indent <= indent:
                    break
                yield number + 1, nested
                number += 1
            continue
        yield number + 1, value
        number += 1


def checkout_errors(lines: list[str]) -> list[int]:
    """Return line numbers for checkout steps that persist credentials."""
    errors: list[int] = []
    for index, line in enumerate(lines):
        match = re.match(r"""^(\s*)-?\s*(?:uses|["']uses["'])\s*:\s*["']?actions/checkout@""", line)
        if not match:
            continue
        uses_indent = len(match.group(1))
        step_indent = uses_indent
        if not line.lstrip().startswith("-"):
            for prior in range(index - 1, -1, -1):
                step_match = re.match(r"^(\s*)-\s+", lines[prior])
                if step_match and len(step_match.group(1)) < uses_indent:
                    step_indent = len(step_match.group(1))
                    break
        end = index + 1
        while end < len(lines):
            candidate = lines[end]
            if re.match(rf"^\s{{{step_indent}}}-\s+", candidate):
                break
            end += 1
        step = lines[index:end]
        with_block: list[str] = []
        for offset, item in enumerate(step):
            with_match = re.match(r"""^(\s*)(?:with|["']with["'])\s*:\s*(?:#.*)?$""", item)
            if not with_match:
                continue
            with_indent = len(with_match.group(1))
            for nested in step[offset + 1 :]:
                stripped = nested.lstrip()
                nested_indent = len(nested) - len(stripped)
                if stripped and nested_indent <= with_indent:
                    break
                with_block.append(nested)
            break
        child_indents = [
            len(item) - len(item.lstrip())
            for item in with_block
            if item.strip() and not item.lstrip().startswith("#")
        ]
        direct_indent = min(child_indents, default=-1)
        if not any(
            len(item) - len(item.lstrip()) == direct_indent
            and re.match(
                r"""^\s*(?:persist-credentials|["']persist-credentials["'])\s*:\s*false\s*(?:#.*)?$""",
                item,
            )
            for item in with_block
        ):
            errors.append(index + 1)
    return errors


def main() -> int:
    errors: list[str] = []
    workflow_root = ROOT / ".github" / "workflows"
    for name in WORKFLOWS:
        path = workflow_root / name
        lines = path.read_text(encoding="utf-8").splitlines()
        for number, line in run_blocks(lines):
            normalized = re.sub(
                r"\[['\"]([A-Za-z_][A-Za-z0-9_-]*)['\"]\]",
                r".\1",
                line,
            )
            if re.search(
                r"\$\{\{[^}]*\b(?:inputs\s*\.|github\s*\.\s*event\s*\.\s*inputs\s*\.)",
                normalized,
                re.IGNORECASE,
            ):
                errors.append(f"{path.relative_to(ROOT)}:{number}: direct inputs interpolation in run block")
        for number in checkout_errors(lines):
            errors.append(
                f"{path.relative_to(ROOT)}:{number}: checkout must disable persisted credentials"
            )

    if errors:
        print("GITHUB_ACTIONS_UNTRUSTED_INPUTS: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    print("GITHUB_ACTIONS_UNTRUSTED_INPUTS: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
