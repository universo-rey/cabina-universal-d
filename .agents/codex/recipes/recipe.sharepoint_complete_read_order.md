# recipe.sharepoint_complete_read_order

Execute a governed Microsoft SharePoint complete read directly when the current
capability and binding identify the tenant, exact target and bounded scope.
READ is `ACTIVE_GOVERNED` and does not require a new order or approval packet.

Required fields: surface, authenticated identity, owner, current binding, exact target,
scope, exclusions, minimization limit, rollback (`N/A_READ_ONLY`), postcheck,
evidence, readback and stop condition. Preserve
`NO_WRITE`. A known, bounded mutation is `LOW_BY_DEFAULT` unless an objective
HIGH trigger is present; LOW does not require a new order, allowlist or receipt.
It does require capability, current binding, bounded exact target, precheck,
rollback or idempotency, postcheck and evidence. A missing prerequisite yields
`RESOLUTION_REQUIRED` / `BLOCKED_NOT_EXECUTABLE` while preserving the tier.
