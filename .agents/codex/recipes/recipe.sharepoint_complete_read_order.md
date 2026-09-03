# recipe.sharepoint_complete_read_order

Execute a governed Microsoft SharePoint complete read directly when the current
capability and binding identify the tenant, exact target and bounded scope.
READ is `ACTIVE_GOVERNED` and does not require a new order or approval packet.

Required fields: surface, authenticated identity, current binding, exact target,
scope, exclusions, minimization limit, evidence and stop condition. Preserve
`NO_WRITE`; any mutation is classified independently as LOW only when
explicitly preauthorized, otherwise HIGH.
