import type { GovernedTeamsActivity } from "./types";

export function routeTeamsActivity(activity: GovernedTeamsActivity) {
  const text = activity.text.toLowerCase();
  if (text.includes("codex cloud")) {
    return {
      routeId: "teams.route.codex_cloud",
      assignedAgent: "court.openai_dispatcher",
      action: "prepare_codex_cloud_task_template"
    };
  }
  if (text.includes("tool") || text.includes("mcp")) {
    return {
      routeId: "teams.route.mcp",
      assignedAgent: "court.sdu_gate",
      action: "resolve_mcp_connection"
    };
  }
  if (text.includes("readback") || text.includes("evidence")) {
    return {
      routeId: "teams.route.evidence",
      assignedAgent: "court.seshat_evidence",
      action: "emit_sanitized_evidence"
    };
  }
  return {
    routeId: "teams.route.triage",
    assignedAgent: "sdu-triage-agent",
    action: "parse_intent"
  };
}
