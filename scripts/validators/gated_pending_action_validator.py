#!/usr/bin/env python3
from __future__ import annotations

import argparse
import sys


BLOCKED_LIVE_FLAGS = {
    "--execute-live",
    "--write-live",
    "--apply",
    "--production",
    "--print-secret",
}


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a gated pending action without live execution.")
    parser.add_argument("--capability", required=True)
    parser.add_argument("--required-target", required=True)
    parser.add_argument("--approval-ref", required=True)
    parser.add_argument("--rollback", required=True)
    parser.add_argument("--postcheck", required=True)
    parser.add_argument("--stop-condition", required=True)
    parser.add_argument("--no-live", action="store_true", required=True)
    parser.add_argument("extra", nargs=argparse.REMAINDER)
    args = parser.parse_args()

    blocked = BLOCKED_LIVE_FLAGS.intersection(args.extra)
    if blocked:
        print(f"GATED_PENDING_ACTION_VALIDATOR=FAIL blocked_flags={sorted(blocked)}", file=sys.stderr)
        return 1

    missing_placeholders = [
        value
        for value in [args.required_target, args.approval_ref, args.rollback, args.postcheck]
        if "[" not in value or "]" not in value
    ]
    if missing_placeholders:
        print("GATED_PENDING_ACTION_VALIDATOR=FAIL gate_fields_must_remain_placeholders", file=sys.stderr)
        return 1

    print(f"GATED_PENDING_ACTION_VALIDATOR=PASS capability={args.capability} mode=no_live")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
