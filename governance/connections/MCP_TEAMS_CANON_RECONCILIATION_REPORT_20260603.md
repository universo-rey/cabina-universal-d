# MCP Teams Canon Reconciliation Report 20260603

Estado: `YA_CANONIZADO_NO_DUPLICAR`

## Decision

`Work IQ MCP Teams / mcp_TeamsServer` ya existe en el canon de conexiones. Esta rama no crea un nuevo canonical ID para Teams MCP. Cabina, TGE y SDU deben consumir los IDs canonicos existentes y registrar cualquier probe live contra esos IDs.

## IDs Canonicos Existentes

| role | canonical_id | status | surface | evidence |
| --- | --- | --- | --- | --- |
| Teams pattern reference | `conn_canon_003504` | `PATTERN_REFERENCE_CANON` | Teams | `D:/10_UNIVERSOS/ESCRIBANIA/10_REPOS/02_ACTIVE/torre-gemela-escribania/07_EVIDENCIA/TGE_MCP_WORKIQ_MAIL_TEAMS_PROBE_20260530.json` |
| Teams real connection | `conn_canon_003505` | `REAL_CONNECTION_CANON` | Teams | `D:/10_UNIVERSOS/ESCRIBANIA/10_REPOS/02_ACTIVE/torre-gemela-escribania/07_EVIDENCIA/TGE_MCP_WORKIQ_MAIL_TEAMS_PROBE_20260530.json` |
| Teams evidence reference | `conn_canon_003736` | `EVIDENCE_REFERENCE_CANON` | Teams | `D:/10_UNIVERSOS/ESCRIBANIA/10_REPOS/02_ACTIVE/torre-gemela-escribania/08_READBACKS/ACTA_TGE_AGENT365_MCP_FRONTIER_CONNECTIONS_20260530.md` |
| Teams readback evidence | `conn_canon_004173` | `EVIDENCE_REFERENCE_CANON` | Teams | `D:/10_UNIVERSOS/ESCRIBANIA/10_REPOS/02_ACTIVE/torre-gemela-escribania/08_READBACKS/GATE_TGE_MCP_WORKIQ_MAIL_TEAMS_READBACK_20260530.md` |

## Companion Auth IDs

| role | canonical_id | status | surface | evidence |
| --- | --- | --- | --- | --- |
| Entra auth companion | `conn_canon_003503` | `AUTH_COMPANION_CANON` | Entra ID | TGE Work IQ Mail/Teams probe |
| Entra auth/readback companion | `conn_canon_004172` | `AUTH_COMPANION_CANON` | Entra ID | TGE Work IQ Mail/Teams readback |

## Canonical Server Data

| field | value |
| --- | --- |
| catalog | Agent 365 |
| server | `mcp_TeamsServer` |
| version | `1.0.5` |
| publisher | Microsoft Corporation |
| url | `https://agent365.svc.cloud.microsoft/agents/servers/mcp_TeamsServer` |
| scope | `Tools.ListInvoke.All` |
| audience | `ce5029ee-c1d3-45c0-bdcc-efb5a4245687` |
| historical status | `HANDSHAKE_PASS_AUTH_REQUIRED` |
| historical Teams live | `NOT_EXECUTED` |

## Source Matrix Reconciliation

The connection matrices under `D:/matrices/connections` already include the active canonical rows:

- `CONNECTION_DEDUP_RESULT_MATRIX.csv`: marks `conn_canon_003505` as `real_connection` and `seed_now`.
- `CONNECTION_CANONICAL_INSTANCE_MATRIX.csv`: retains the canonical instance family.
- `CONNECTION_SECRET_BOUNDARY_MATRIX.csv`: marks Teams rows as `NO_SECRET_IN_REPO_DETECTED` and Entra companion rows as `SECRET_REQUIRED_EXTERNALIZED`.
- `CONNECTION_RISK_MATRIX.csv`: classifies Teams/Entra live surfaces as `high`.
- `DATAVERSE_CONNECTION_SEED_DECISION_MATRIX.csv`: keeps these canonical IDs as seeded, not duplicated.

## Duplicate Handling

PR #80 was inspected before this update. No active duplicate `mcp_TeamsServer` artifact was found in `governance`, `readbacks`, `scripts`, or `.github`. A transient local draft was discarded before this report and is not part of the branch.

If a later artifact attempts to create a new canonical ID for `mcp_TeamsServer`, it must be converted into a pointer with status:

`SUPERSEDED_BY_CONNECTION_CANON`

## Preserve / Pointer / Supersede

| artifact class | decision | handling |
| --- | --- | --- |
| TGE probe evidence | preserve | source evidence remains in TGE |
| TGE readback evidence | preserve | source evidence remains in TGE |
| Cabina pointer | create | references existing canonical IDs only |
| Cabina live gate matrix | create | controls execution without new ID |
| Duplicate canonical rows | supersede | `SUPERSEDED_BY_CONNECTION_CANON` |

## Boundary

Live read/list-tools may run only through the existing canonical ID `conn_canon_003505` and companion auth `conn_canon_003503` or `conn_canon_004172`.

Teams send/write remains `LIVE_WRITE_GATED` until an exact target, owner, approval, rollback, postcheck, and evidence destination exist.

No Teams message, Graph write, production mutation, permission change, or secret materialization is authorized by this report.

## Session Tool Discovery

The current Codex session exposes a Microsoft Teams connector with chat/channel read and send actions. That connector is a real Teams surface, but it is not the same as the Agent 365 Work IQ MCP server. It was not invoked for message read/send because this reconciliation lacks an exact Teams target and remains governed by the `mcp_TeamsServer` canonical IDs above.
