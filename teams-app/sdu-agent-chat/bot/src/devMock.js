import assert from "node:assert/strict";

const activity = {
  channel: "msteams",
  synthetic: true,
  conversationId: "dev-conversation",
  fromDisplayName: "Operator",
  requestedBy: "efigueroa",
  text: "Prepare Codex Cloud repo scoped task and readback"
};

function route(text) {
  const lower = text.toLowerCase();
  if (lower.includes("codex cloud")) return "teams.route.codex_cloud";
  if (lower.includes("mcp") || lower.includes("tool")) return "teams.route.mcp";
  if (lower.includes("readback")) return "teams.route.evidence";
  return "teams.route.triage";
}

assert.equal(activity.synthetic, true);
assert.equal(route(activity.text), "teams.route.codex_cloud");
console.log("SDU_TEAMS_CHAT_BOT_DEV_MOCK_PASS");
