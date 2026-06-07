export const blockedSurfaces = [
  "teams_send",
  "graph_write",
  "openai_live",
  "codex_cloud_apply",
  "production",
  "permission_change",
  "external_write"
];

export function isLoopbackHost(host) {
  return host === "127.0.0.1" || host === "localhost" || host === "::1";
}

export function assertLoopbackReadSurface(host) {
  if (!isLoopbackHost(host)) {
    throw new Error("loopback host required for local dashboard data");
  }
}

export function assertSyntheticRequest(payload) {
  if (!payload || payload.synthetic !== true) {
    throw new Error("synthetic payload required");
  }
  if (payload.channel !== "msteams") {
    throw new Error("msteams channel required for this DEV bridge");
  }
  if (!payload.text || payload.text.length > 1200) {
    throw new Error("bounded text required");
  }
}
