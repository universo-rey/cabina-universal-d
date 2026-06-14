# Multi-Canon Agentic Execution Graph

Estado: `ACTIVE_REPO_LOCAL_20260614`

```mermaid
flowchart LR
  A["S01 Intake\nrey.control_plane_orchestrator"] --> B["S02 Repo State\nrey.repo_cartographer"]
  B --> C["S03 Frontier\nrey.frontier_guardian"]
  C --> D["S04 Evidence\ncourt.seshat_evidence"]
  D --> E["S05 Schema\ncourt.thot_schema"]
  E --> F["S06 Promotion\nrey.repo_cartographer"]
  F --> G["S07 Review\ncodex.workspace_guardian"]
  G --> H["S08 Merge Gate\nrey.frontier_guardian"]
  H --> I["S09 Learning\ncourt.seshat_evidence"]

  C -. read-only evidence .-> SP["SharePoint\nread governed"]
  C -. read-only evidence .-> DV["Dataverse\nread governed"]
  C -. read-only evidence .-> PP["Power Platform\nread governed"]
  C -. read-only evidence .-> GA["Graph/Admin\nread governed"]
  C -. read-only evidence .-> GH["GitHub\nPR/checks/reviews"]

  H -->|blocked without explicit approval| STOP["Stop condition"]
```

## Handoff rule

Every edge passes a structured result. The next agent receives only the
artifact, evidence pointers and stop condition needed for its role.

## Surface rule

Read-only evidence may be requested from governed information surfaces when it
prevents inference. Live writes require a separate atomic order and are outside
this engine's default execution mode.
