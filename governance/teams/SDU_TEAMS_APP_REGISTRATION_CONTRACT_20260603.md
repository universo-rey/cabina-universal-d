# SDU Teams App Registration Contract 20260603

Estado: `TEAMS_APP_REGISTRATION_CONTRACT_DEV_READY`

## Identidad DEV

- app display name: `Seshat SDU Agent`
- app short name: `Seshat SDU Agent`
- app package name: `ar.com.sdu.seshat.agent.dev`
- Teams app id: `[TEAMS_APP_ID]`
- bot id: `[BOT_ID]`
- Entra app id: `[ENTRA_APP_ID]`
- tenant id: `[TENANT_ID]`
- bot endpoint: `[BOT_ENDPOINT]`
- DEV tunnel or host: `[DEV_TUNNEL_OR_HOST]`
- client secret placeholder: external governed store only; no value in repo

## Permisos DEV Preparados

- Teams personal scope: prepared, not installed.
- Teams team scope: prepared, not installed.
- Bot messaging endpoint: prepared, not called.
- Graph write: blocked until explicit governed order.
- Admin consent: blocked until explicit governed order.

## Contrato De Registro

The app registration may be created only after a separate order names identity, tenant, exact object, action, rollback, postcheck and evidence. This repository stores placeholders and validation rules only.

## Evidencia Requerida Para Un Gate Futuro

- app id resolved outside the repo;
- bot id resolved outside the repo;
- Entra id resolved outside the repo;
- tenant id resolved outside the repo;
- package validation result;
- no live message result;
- rollback instruction for deleting the DEV registration.

## Stop Conditions

`REAL_TENANT_HARDCODED`, `REAL_APP_ID_HARDCODED`, `TEAMS_APP_INSTALL_ATTEMPTED`, `TEAMS_MESSAGE_SENT`, `GRAPH_WRITE_ATTEMPTED`, `SECRET_DETECTED`.
