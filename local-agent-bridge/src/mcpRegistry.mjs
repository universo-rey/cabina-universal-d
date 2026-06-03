import fs from "node:fs";
import path from "node:path";

export function loadRegistry(repoRoot = process.cwd()) {
  const registryPath = path.join(repoRoot, "governance", "connections", "MCP_CONNECTION_REGISTRY_20260603.csv");
  const [header, ...lines] = fs.readFileSync(registryPath, "utf8").trim().split(/\r?\n/);
  const columns = header.split(",");
  return lines.map((line) => {
    const values = line.split(",");
    return Object.fromEntries(columns.map((column, index) => [column, values[index] ?? ""]));
  });
}

export function resolveConnection(connectionId, repoRoot = process.cwd()) {
  const connection = loadRegistry(repoRoot).find((row) => row.connection_id === connectionId);
  if (!connection) {
    throw new Error(`missing MCP connection ${connectionId}`);
  }
  if (connection.write_scope !== "none" && connection.requires_approval !== "no") {
    return { ...connection, gated: true };
  }
  return { ...connection, gated: false };
}
