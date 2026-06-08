from __future__ import annotations

from pathlib import Path

from sdu_runtime_common import main_guard, require_files


ROOT = Path(__file__).resolve().parents[2]
BRIDGE = ROOT / "scripts" / "sharepoint" / "Invoke-SduSharePointDataverseLiveBridge.ps1"


def require_contains(text: str, needle: str) -> None:
    if needle not in text:
        raise AssertionError(f"missing required bridge contract: {needle}")


def validate() -> None:
    require_files(
        [
            "scripts/sharepoint/Invoke-SduSharePointDataverseLiveBridge.ps1",
            "powerplatform/workqueues/workqueue.manifest.yml",
            "powerplatform/workqueues/schemas/agent_dispatch.schema.json",
            "powerplatform/flows/flow-manifest.yml",
            "powerplatform/solution/solution.manifest.yml",
            "matrices/powerautomate/WORK_QUEUE_ENVIRONMENT_BINDING_MATRIX.csv",
            "matrices/dataverse/DATAVERSE_APPLIED_TABLE_MODEL_DEV.csv",
        ]
    )
    text = BRIDGE.read_text(encoding="utf-8")
    required = [
        "GATE_MICROSOFT_LIVE_WRITE+GATE_DATAVERSE_APPLY+GATE_POWER_PLATFORM_APPLY",
        "SDU.Agent.Dispatch.Queue",
        "sdu_agent_dispatch_queue",
        "mon_sdu_source_artifact",
        "mon_sdu_evidence",
        "workqueueitems",
        "IngestSharePointEvent",
        "ProcessOneQueueItem",
        "ProcessNextQueueItem",
        "QueueItemName",
        "WorkerId",
        "Assert-NotProdLike",
        "MaxItems -lt 1 -or $MaxItems -gt 10",
        "BoundedContentChars -lt 256 -or $BoundedContentChars -gt 12000",
        "token_printed = $false",
        "sharepoint_write = $false",
        "flow_dependency = $false",
        "Upsert-SourceArtifact",
        "Add-WorkQueueItem",
        "Publish-AgentResult",
        "Get-WorkQueueExact",
        "Get-QueueItemExact",
        "Assert-AgentDispatchInput",
        "queue_next_item_candidate_count_not_one",
        "queue_input_field_missing",
        "queue_item_wrong_queue",
        "GATE_DATAVERSE_APPLY",
        "QueueQueuedState = 0",
        "QueueProcessingState = 1",
        "QueueProcessedState = 2",
        "QueueExceptionState = 4",
        "Claim-WorkQueueItem",
        "Complete-WorkQueueItem",
        "Fail-WorkQueueItem",
        "Assert-AgentRuntimeAction",
        "ConvertTo-AgentRuntimeCanonicalId",
        "agent_runtime_candidate_count_not_one",
        "agent_runtime_queue_mode_not_allowed",
        "queue_item_not_queued",
        "queue_item_claim_postcheck_failed",
        "queue_item_complete_postcheck_failed",
        "uniqueidbyqueue",
        "workqueueitem_idempotency_candidate_count_not_one",
        "processingstarttime",
        "processingresult",
        "completedon",
    ]
    for needle in required:
        require_contains(text, needle)
    if "Invoke-DataversePost" not in text or "Invoke-DataversePatch" not in text:
        raise AssertionError("bridge must support Dataverse idempotent post/patch")
    if "if ($Apply)" not in text:
        raise AssertionError("bridge writes must be gated by -Apply")
    if "SDU_Work_Queue_Agent_Dispatcher" in text:
        raise AssertionError("bridge must not depend on a Power Automate flow name")
    if "one-flow" in text.lower():
        raise AssertionError("bridge must not retain one-flow pilot terminology")
    if "Connect-PnPOnline" in text and "sharepoint_write = $false" not in text:
        raise AssertionError("SharePoint connector use must remain read-only")


if __name__ == "__main__":
    main_guard("SDU_SHAREPOINT_DATAVERSE_LIVE_BRIDGE_VALIDATOR", validate)
