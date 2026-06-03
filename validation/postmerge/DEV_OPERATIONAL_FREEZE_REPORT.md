# DEV Operational Freeze Report

## Estado
DEV_OPERATIONAL_FREEZE_PASS_AFTER_EXPANSION

## Target
- DATAVERSE_DEV_ENVIRONMENT_URL=https://org084965d9.crm.dynamics.com
- DATAVERSE_DEV_ENVIRONMENT_ID=7f65fc04-c27a-ea0d-bd2d-266aa9203c1e
- DATAVERSE_ORGANIZATION_ID=f982db28-49e3-f011-aa23-000d3a5ca83f
- SOLUTION_UNIQUE_NAME=SDUCapabilityControlPlane
- Environment type: Espacio aislado

## Resultado
- Dataverse tables counted: 22
- Work queues counted: 8
- Work queue items counted: 250
- DEV disabled flows counted: 9
- DEV disabled flows off: 9
- Data access mode: count/state-only, no record/clientdata dump
- PROD/TEST/Default: not used
- Secrets printed: no

## Dataverse Tables
- mon_sdu_agent_connection_mapping: ﻿11
- mon_sdu_apply_log: ﻿0
- mon_sdu_connection_gate: ﻿6
- mon_sdu_connection_instance: ﻿5000
- mon_sdu_connection_reference_registry: ﻿0
- mon_sdu_connection_risk: ﻿5000
- mon_sdu_connection_secret_boundary: ﻿5000
- mon_sdu_connection_surface: ﻿15
- mon_sdu_deployment_profile: ﻿0
- mon_sdu_environment: ﻿0
- mon_sdu_environment_variable_registry: ﻿0
- mon_sdu_evidence: ﻿5000
- mon_sdu_import_export_job: ﻿0
- mon_sdu_publisher: ﻿0
- mon_sdu_readback: ﻿0
- mon_sdu_repository: ﻿0
- mon_sdu_snapshot: ﻿0
- mon_sdu_solution: ﻿0
- mon_sdu_solution_component: ﻿0
- mon_sdu_source_artifact: ﻿0
- mon_sdu_stop_condition: ﻿0
- mon_sdu_validation_gate: ﻿0

## Work Queues
- SDU.Matrix.Intake.Queue: queue_count=1, item_count=0
- SDU.Connection.Seed.Queue: queue_count=1, item_count=100
- SDU.Dataverse.Apply.Queue: queue_count=1, item_count=0
- SDU.Drift.Detection.Queue: queue_count=1, item_count=50
- SDU.Gate.Review.Queue: queue_count=1, item_count=50
- SDU.Exception.Remediation.Queue: queue_count=1, item_count=25
- SDU.Evidence.Publish.Queue: queue_count=1, item_count=25
- SDU.Agent.Dispatch.Queue: queue_count=1, item_count=0

## Disabled Flows
- SDU_Dispatch_Matrix_Items_To_Work_Queues: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Process_Connection_Seed_Work_Items: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Process_Dataverse_Apply_Work_Items: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Process_Drift_Detection_Work_Items: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Work_Queue_Gate_Review_Handler: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Work_Queue_Exception_Handler: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Work_Queue_Evidence_Closeout: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_Work_Queue_Agent_Dispatcher: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS
- SDU_OpenAI_Assisted_Metadata_Classifier: count=1, statecode=0, status=FREEZE_DISABLED_FLOW_PASS

## Stop Condition
wrong_environment_or_prod_test_default_or_secret_or_record_dump_or_active_flow
