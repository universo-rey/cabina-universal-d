from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


GATE = "governance/teams/SDU_TEAMS_FIRST_INTERNAL_MESSAGE_EXECUTION_GATE_20260603.md"


def validate() -> None:
    require_files([GATE])
    text = read_text(GATE)
    for token in [
        "FIRST_INTERNAL_MESSAGE_LIVE_GATE_RESOLVED_BLOCKED_BY_CHAT_SCOPE",
        "efigueroa@registronotarial8tdf.com.ar",
        "Seshat SDU Agent activo en modo DEV",
        "No se envio el mensaje",
        "CHAT_SCOPE_MISSING",
        "APP_DEVICE_AUTH_REQUIRED",
        "TENANT_CONTEXT_MISMATCH",
        "PREAUTHORIZATION_OR_CONSENT_MISSING",
        "CDF_REFERENCE_WITHOUT_EXACT_DESTINATION",
    ]:
        if token not in text:
            raise AssertionError(f"gate missing {token}")
    forbidden_claims = [
        "FIRST_TEAMS_MESSAGE_SENT",
        "messageId:",
        "message_id:",
        "secretCreated = true",
    ]
    for token in forbidden_claims:
        if token in text:
            raise AssertionError(f"gate overclaims live send: {token}")
    require_no_materialized_sensitive_values([GATE])


if __name__ == "__main__":
    main_guard("SDU_FIRST_INTERNAL_MESSAGE_GATE_VALIDATOR", validate)
