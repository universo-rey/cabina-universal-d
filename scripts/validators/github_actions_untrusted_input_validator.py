#!/usr/bin/env python3
"""Reject untrusted workflow inputs interpolated directly into shell scripts."""

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
    in_run = False
    run_indent = 0
    for number, line in enumerate(lines, 1):
        stripped = line.lstrip()
        indent = len(line) - len(stripped)
        if stripped in {"run: |", "run: >"}:
            in_run = True
            run_indent = indent
            continue
        if in_run and stripped and indent <= run_indent:
            in_run = False
        if in_run:
            yield number, line


def main() -> int:
    errors: list[str] = []
    workflow_root = ROOT / ".github" / "workflows"
    for name in WORKFLOWS:
        path = workflow_root / name
        lines = path.read_text(encoding="utf-8").splitlines()
        for number, line in run_blocks(lines):
            if "${{ inputs." in line:
                errors.append(f"{path.relative_to(ROOT)}:{number}: direct inputs interpolation in run block")
        text = "\n".join(lines)
        if "uses: actions/checkout" in text and "persist-credentials: false" not in text:
            errors.append(f"{path.relative_to(ROOT)}: checkout must disable persisted credentials")

    if errors:
        print("GITHUB_ACTIONS_UNTRUSTED_INPUTS: FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    print("GITHUB_ACTIONS_UNTRUSTED_INPUTS: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
