# Teams Workpapers

Estado: `TEAMS_WORKPAPERS_LOCAL_PREP_ACTIVE`.

Esta carpeta agrupa papeles de trabajo locales para gobernar Microsoft Teams
sin abrir Teams live. Los agentes deben usarla para:

- clasificar superficie Teams;
- preparar ordenes gobernadas;
- registrar evidencia saneada;
- documentar stop conditions;
- separar Escribania/TGE, Modo ON/CDF/Jara y Corte/SDU/Seshat.

## Rutas rectoras

- Politica: `D:\02_AUTHORITY_CANON\POLICIES\TEAMS_GOVERNANCE_POLICY_20260602.md`
- Matriz de superficies: `D:\.agents\codex\matrices\TEAMS_GOVERNANCE_SURFACE_MATRIX.csv`
- Matriz de capacidades: `D:\.agents\codex\matrices\TEAMS_AGENT_CAPABILITY_MATRIX.csv`
- Orden draft: `D:\.agents\codex\orders\ORDER_TEAMS_GOVERNANCE_LIVE_READ_DRAFT_20260602.md`
- Readback: `D:\.agents\codex\readbacks\2026-06-02_teams_governance_readback.md`
- Validador: `D:\.agents\codex\tools\local_validate_teams_governance.ps1`

## Stop

Si el trabajo requiere leer o escribir Teams live, detener con
`microsoft_live_requested_without_governed_order` hasta que exista orden
gobernada completa.
