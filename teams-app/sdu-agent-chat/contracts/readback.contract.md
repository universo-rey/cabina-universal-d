# SDU Teams Chat Readback Contract

Every routed DEV activity must produce a bounded readback object with:

- `route_id`
- `assigned_agent`
- `gate_agent`
- `action`
- `evidence_id`
- `live_executed=false`
- `blocked_surfaces`
- `next_gate`

No raw Teams transcript, attachment or tenant identifier is stored in this
contract.
