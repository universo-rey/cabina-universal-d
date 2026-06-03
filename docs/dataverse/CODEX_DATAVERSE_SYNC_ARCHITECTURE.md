# Codex Dataverse Sync Architecture

Codex prepares manifests, validates local state, detects drift, and emits
readbacks. It does not infer authority from historical data and does not apply
to ambiguous environments.

DEV sync sequence:

1. Validate manifest.
2. Precheck environment.
3. Export rollback snapshot if target exists.
4. Create/import solution.
5. Import metadata-only seed.
6. Export postcheck snapshot.
7. Generate readback.

If any gate is uncertain, execution widens evidence and blocks apply.
