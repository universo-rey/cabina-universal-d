# Workpapers - efigueroa User Governance

Estado: `EFIGUEROA_USER_WORKPAPERS_LOCAL_PREP_ACTIVE`.

Sujeto: `efigueroa@registronotarial8tdf.com.ar`.

Esta carpeta agrupa papeles de trabajo locales para gobernar la identidad sin
abrir Microsoft live.

## Rutas

- Politica: `D:\02_AUTHORITY_CANON\POLICIES\EFIGUEROA_USER_GOVERNANCE_POLICY_20260602.md`
- Matriz: `D:\.agents\codex\matrices\USER_IDENTITY_GOVERNANCE_MATRIX.csv`
- Orden draft: `D:\.agents\codex\orders\ORDER_EFIGUEROA_USER_GOVERNANCE_LIVE_READ_DRAFT_20260602.md`
- Readback: `D:\.agents\codex\readbacks\2026-06-02_efigueroa_user_governance_readback.md`
- Validador: `D:\.agents\codex\tools\local_validate_user_identity_governance.ps1`

## Stop

Si el trabajo requiere consultar o modificar Microsoft live, detener con
`microsoft_live_requested_without_governed_order` hasta que exista orden
gobernada completa.
