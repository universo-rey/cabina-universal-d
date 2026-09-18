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
    sanitized: true,
    blocked_surfaces: blockedSurfaces,
    next_gate: "human_review_before_live"
  };
}
