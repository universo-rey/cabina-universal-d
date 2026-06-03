# Dataverse Seed Data

These CSV files seed only metadata identifiers, source paths, statuses, row
counts and hashes. They do not carry regulated data, personal data, secrets,
documents, matrix row payloads, or tenant credentials.

Seed import is blocked until the Dataverse DEV environment is explicit,
non-PROD, protected by rollback/postcheck, and the target tables exist.
