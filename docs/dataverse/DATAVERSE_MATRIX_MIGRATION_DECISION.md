# Dataverse Matrix Migration Decision

Decision: use Dataverse as a governed metadata registry for live matrix
relationships, not as a replacement for GitHub canon or SharePoint evidence.

The V1 migration registers matrix identity, source path, hash, row count,
domain, migrability and gate status. Matrix row payloads are not copied in V1.

Reason: this gives queryable live state and drift detection while preserving
the existing authority model.
