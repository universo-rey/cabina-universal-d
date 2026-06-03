# Toolchain Real Discovery Report

## Estado
TOOLCHAIN_REAL_DISCOVERY_PASS_WITH_API_FLOW_CREATION

## Target
- Repo: universo-rey/cabina-universal-d
- Branch: codex/postmerge-dev-operational-expansion-20260603
- Dataverse DEV URL: https://org084965d9.crm.dynamics.com
- Dataverse DEV environment ID: 7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- Dataverse organization ID: f982db28-49e3-f011-aa23-000d3a5ca83f

## Herramientas confirmadas
- pac_cli: AVAILABLE
- dataverse_web_api: AVAILABLE
- power_automate_list_flows: GET_FLOW_AVAILABLE_FLOW_COUNT_0
- power_automate_create_disabled_flows: AVAILABLE_USED_PASS_DISABLED_OFF
- workqueue_create_items: AVAILABLE_WITH_IDEMPOTENT_PREFIX_GATE
- openai_batch_submit: BLOCKED_OPENAI_API_KEY_ENV_MISSING

## Identidad y frontera
- Dataverse/Power Platform identity: ef****@registronotarial8tdf.com.ar (masked)
- Tenant ID: 858a0852-44a1-413e-a0fe-f053949797d6
- Solution: SDUCapabilityControlPlane
- Environment: DEV sandbox only

## API aplicada por orden posterior
- Power Automate disabled flows: created via Dataverse Web API workflows.
- Official reference: https://learn.microsoft.com/en-us/power-automate/manage-flows-with-code
- Result: 9 workflows created, statecode=0, in solution, no activation.

## Bloqueos explícitos restantes
- OpenAI Batch live submit: blocked because OPENAI_API_KEY is not present in process env and .env.local was not read.

## Reglas aplicadas
- No PROD.
- No TEST.
- No Default.
- No deletes.
- No secrets printed.
- No .env.local read.
- No simulation of live pass.

## Stop Condition
wrong_environment_or_secret_or_active_trigger_or_cost_gate_missing
