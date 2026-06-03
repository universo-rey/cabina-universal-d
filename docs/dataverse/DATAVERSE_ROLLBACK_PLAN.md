# Dataverse Rollback Plan

Rollback before DEV apply:

- Export current solution if it exists.
- Export metadata snapshot.
- Record target environment and solution version.

Rollback after failed DEV apply:

- Stop further imports.
- Export failure snapshot.
- Restore prior unmanaged solution state through the exported solution where
  available.
- Remove only objects created in the governed solution, never global/default
  objects.

Rollback is not defined for PROD in this package because PROD is not in scope.
