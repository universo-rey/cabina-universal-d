from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


CONTRACT = "local-agent-bridge/dev.activation.contract.yml"


def validate() -> None:
    require_files([CONTRACT])
    text = read_text(CONTRACT)
    required = [
        'bind: "127.0.0.1"',
        "public_bind_allowed: false",
        "required: true",
        "token_reference: \"[LOCAL_BRIDGE_TOKEN_REFERENCE]\"",
        "token_value_in_repo: false",
        "full_filesystem_access: false",
        "live_enabled: false",
        "writes_allowed: false",
        "PUBLIC_LOCAL_BRIDGE_WITHOUT_AUTH",
        "MCP_REMOTE_WRITE_ATTEMPTED",
    ]
    for token in required:
        if token not in text:
            raise AssertionError(f"bridge DEV contract missing {token}")
    for forbidden in [
        "public_bind_allowed: true",
        "full_filesystem_access: true",
        "live_enabled: true",
        "writes_allowed: true",
        "0.0.0.0",
    ]:
        if forbidden in text:
            raise AssertionError(f"bridge DEV contract enables {forbidden}")
    require_no_materialized_sensitive_values([CONTRACT])


if __name__ == "__main__":
    main_guard("SDU_LOCAL_BRIDGE_DEV_ACTIVATION_VALIDATOR", validate)
