export function selectRoute(text) {
  const normalized = text.toLowerCase();
  if (normalized.includes("codex cloud")) {
    return {
      route_id: "teams.route.codex_cloud",
      assigned_agent: "court.openai_dispatcher",
      action: "prepare_codex_cloud_task_template",
      connection_id: "mcp.codex.cloud.repo_scoped"
    };
  }
  if (normalized.includes("mcp") || normalized.includes("tool")) {
    return {
      route_id: "teams.route.mcp",
      assigned_agent: "court.sdu_gate",
      action: "resolve_mcp_connection",
      connection_id: "mcp.local.bridge.mock"
    };
  }
  if (normalized.includes("readback") || normalized.includes("evidence")) {
    return {
      route_id: "teams.route.evidence",
      assigned_agent: "court.seshat_evidence",
      action: "emit_sanitized_evidence",
      connection_id: "mcp.local.bridge.mock"
    };
  }
  return {
    route_id: "teams.route.triage",
    assigned_agent: "sdu-triage-agent",
    action: "parse_intent",
    connection_id: "mcp.local.bridge.mock"
  };
}
