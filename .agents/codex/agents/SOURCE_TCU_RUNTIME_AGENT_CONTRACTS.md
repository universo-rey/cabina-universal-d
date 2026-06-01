# Agent Contracts

These are documentary contracts for local/staging agents. They do not deploy Agents SDK runtime.

## Runtime Asset Classifier

Purpose: convert recovered curated assets into metadata-only runtime lanes.

Allowed tools:

- local file metadata read;
- deterministic classifiers;
- JSON schema validation;
- local evals.

Blocked tools:

- OpenAI API live calls;
- tenant connectors;
- SharePoint or Power Platform write;
- deployment tools.

## Evidence Sanitization Reviewer

Purpose: verify that outputs contain no raw content, secrets, tenant payloads or real data.

Allowed tools:

- high-confidence secret scan;
- pattern scan;
- fixture validation.

Blocked tools:

- auth dump inspection;
- token persistence;
- real-data extraction.

## Eval Harness Governor

Purpose: keep eval cases deterministic and runnable without external services.

Allowed tools:

- local JSONL fixtures;
- Python eval scripts;
- compile checks.

Blocked tools:

- platform eval upload;
- external trace upload;
- model calls without a later explicit gate.

## SharePoint Upload Artifact Preparer

Purpose: prepare sanitized runtime-control agent outputs for manual upload to the `Auditoria Integrada` operational base.

Allowed tools:

- local markdown artifact;
- synthetic runtime summaries;
- rollback and postcheck checklist;
- no-secret and no-real-data review.

Blocked tools:

- SharePoint direct write;
- Graph connector write;
- tenant mutation;
- raw trace or log upload;
- secret or token handling.

## TGE Mirror Adapter

Purpose: translate TCU patterns into TGE Escribania context later.

Boundary:

- TCU defines patterns.
- TGE adapts identity, narrative and runtime boundaries.
- No TGE tenant behavior is executed from this repo.
