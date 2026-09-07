import { blockedSurfaces } from "./policy.mjs";

export function buildEvidence(route, payload) {
  return {
    evidence_id: `sdu-dev-${route.route_id}`,
    route_id: route.route_id,
    assigned_agent: route.assigned_agent,
    gate_agent: "court.sdu_gate",
    action: route.action,
    requested_by: payload.requestedBy,
    live_executed: false,
    execution_admitted: false,
    admission_status: "OPERATION_NOT_RESOLVED",
    sanitized: true,
    blocked_surfaces: blockedSurfaces,
    blocked_surfaces_scope: "THIS_MOCK_BRIDGE_ONLY",
    next_gate: "not_required_for_advisory_routing",
    next_action: "resolve_operation_before_dispatch"
  };
}
