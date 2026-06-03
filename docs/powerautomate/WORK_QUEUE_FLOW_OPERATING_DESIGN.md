# Work Queue Flow Operating Design

## Estado
WORK_QUEUE_FLOW_DESIGN_READY_NOT_ACTIVE

## Policy
- DEV only.
- No production.
- No TEST.
- No Default.
- No flow is created or activated by this lane.
- OpenAI usage is metadata-only and AI_ASSISTED_NOT_CANON_UNTIL_VALIDATED.

## Flows
### SDU_Dispatch_Matrix_Items_To_Work_Queues
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Matrix.Intake.Queue
- Dataverse source: matrices/dataverse and MATRIX_INDEX
- target: workqueueitem
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: no

### SDU_Process_Connection_Seed_Work_Items
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Connection.Seed.Queue
- Dataverse source: mon_sdu_connection_instance
- target: mon_sdu_apply_log/evidence
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: optional_metadata_only

### SDU_Process_Dataverse_Apply_Work_Items
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Dataverse.Apply.Queue
- Dataverse source: mon_sdu_apply_log
- target: mon_sdu_apply_log/evidence
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: no

### SDU_Process_Drift_Detection_Work_Items
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Drift.Detection.Queue
- Dataverse source: mon_sdu_snapshot
- target: mon_sdu_evidence
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: optional_metadata_only

### SDU_Work_Queue_Gate_Review_Handler
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Gate.Review.Queue
- Dataverse source: mon_sdu_validation_gate/mon_sdu_connection_gate
- target: mon_sdu_evidence
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: optional_metadata_only

### SDU_Work_Queue_Exception_Handler
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Exception.Remediation.Queue
- Dataverse source: mon_sdu_connection_risk
- target: mon_sdu_evidence
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: optional_metadata_only

### SDU_Work_Queue_Evidence_Closeout
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Evidence.Publish.Queue
- Dataverse source: mon_sdu_evidence/mon_sdu_readback
- target: readbacks/evidence pointers
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: no

### SDU_Work_Queue_Agent_Dispatcher
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: SDU.Agent.Dispatch.Queue
- Dataverse source: mon_sdu_agent_connection_mapping
- target: agent dispatch readback
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: no

### SDU_OpenAI_Assisted_Metadata_Classifier
- trigger: manual_or_scheduled_dev_only_disabled_by_default
- queue/source: manual_or_scheduled_dev_only
- Dataverse source: sanitized metadata-only sample
- target: OPENAI_ASSISTED_WORK_QUEUE_CLASSIFICATION.csv
- connection references: Dataverse current environment; OpenAI only for classifier if key present
- retry policy: bounded_retry_3_then_exception_queue
- error handling: write processing result and evidence pointer; no automatic destructive retry
- rollback: disable flow and cancel pilot batch items
- postcheck: queue item status and readback evidence
- evidence: WORK_QUEUE_OPERATIONAL_POSTCHECK.md
- stop_condition: secret_or_prod_or_default_or_missing_gate
- recommended_state: disabled_dev_only
- openai_usage: responses_api_structured_outputs
