from __future__ import annotations

from sdu_runtime_common import main_guard, read_text, require_files, require_no_materialized_sensitive_values


READBACK = "readbacks/20260603_CODEX_CLOUD_SDU_DEV_SMOKE_READBACK.md"


def validate() -> None:
    require_files([READBACK])
    text = read_text(READBACK)
    for token in [
        "CODEX_CLOUD_SDU_DEV_SMOKE_READY_HISTORY_CONFIRMED",
        "universo-rey/cabina-universal-d",
        "task_e_6a1f119843d4832e9ed821834222c003",
        "no `codex cloud apply`",
        "no OpenAI API live",
        "No se creo una nueva tarea Codex Cloud",
    ]:
        if token not in text:
            raise AssertionError(f"Codex Cloud readback missing {token}")
    require_no_materialized_sensitive_values([READBACK])


if __name__ == "__main__":
    main_guard("CODEX_CLOUD_SDU_DEV_SMOKE_VALIDATOR", validate)
