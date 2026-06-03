# recipe.one-flow-one-item-runtime-test

## Purpose
Run the smallest useful governed DEV runtime test: one exact flow and one exact metadata-only item.

## Preconditions
- DEV environment is exact and not Default.
- Flow id and item id are exact.
- Rollback and postcheck are declared.
- Payload is synthetic metadata-only.

## Steps
1. Freeze current flow and queue state.
2. Enable only the selected flow if the order permits.
3. Process only the selected item.
4. Restore the selected flow to disabled safe state.
5. Verify all manifest flows are disabled.
6. Version sanitized evidence through GitHub.

## Gates
- No PROD, TEST, Default.
- No secrets, personal data, documents, SharePoint, Planner or broad Graph.
- No OpenAI API or Batch API unless separately ordered.

## Validators
- Runtime one-flow/one-item validator when available.
- Change-Aware Full-Coverage Orchestrator for repo gate.

## Rollback
Restore flow disabled state and cancel/mark the exact pilot item only under a governed order.

## Stop Condition
`more_than_one_item_or_active_flow`
