# Document Skill Lane

## Purpose

Route document-like requests to the right local skill and agent without opening
Microsoft live, Google Drive import, production, secrets or regulated-data
surfaces by default.

## Lane Matrix

The governing matrix is
`.agents\codex\matrices\DOCUMENT_SKILL_LANE_MATRIX.csv`.

It maps:

- Word and DOCX artifacts to `documents:documents`.
- Workbooks, CSV and TSV artifacts to `spreadsheets:Spreadsheets`.
- PPTX/PPT decks to `presentations:Presentations`.
- PDF artifacts to `pdf`.

## Storage

- Templates and template references: `.agents\codex\templates`.
- Evidence, redlines, previews and sanitized output references:
  `.agents\codex\workpapers\document_skills`.
- Final regulated or secret-bearing documents must not be persisted in the repo.
  Store only sanitized metadata, checklists and readbacks unless a separate
  governed order selects the exact document, destination and retention rule.

## Default Flow

1. Classify document type and extension.
2. Check whether the document is local, selected and non-secret.
3. Stop for separate governed order when content is broad, regulated,
   secret-bearing, live Microsoft/Google, production, or tenant-connected.
4. Use the matching skill only inside the selected local artifact boundary.
5. Record evidence as a sanitized readback or workpaper.

## Validator

Run `.agents\codex\tools\local_validate_document_skill_lane.ps1`.
