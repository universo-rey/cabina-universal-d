import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { assertSyntheticRequest } from "./policy.mjs";
import { selectRoute } from "./router.mjs";
import { buildEvidence } from "./evidenceAdapter.mjs";
import { collectDashboardData } from "./dashboardData.mjs";

const host = process.env.SDU_BRIDGE_BIND_HOST || "127.0.0.1";
const port = Number(process.env.SDU_BRIDGE_PORT || "8787");
const devAuth = process.env.SDU_BRIDGE_DEV_AUTH || "DEV_AUTH_PLACEHOLDER_ONLY";
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(packageRoot, "..");
const dashboardPath = path.join(packageRoot, "public", "index.html");

function json(res, status, body) {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(body));
}

function html(res, status, body) {
  res.writeHead(status, { "Content-Type": "text/html; charset=utf-8" });
  res.end(body);
}

function assertDevAuth(req) {
  if (req.headers["x-sdu-bridge-auth"] !== devAuth) {
    throw new Error("dev bridge auth required");
  }
}

const server = http.createServer((req, res) => {
  if (req.method === "GET" && req.url === "/") {
    html(res, 200, fs.readFileSync(dashboardPath, "utf8"));
    return;
  }

  if (req.method === "GET" && req.url === "/health") {
    json(res, 200, { status: "ok", live_executed: false });
    return;
  }

  if (req.method === "GET" && req.url === "/api/dashboard") {
    try {
      json(res, 200, collectDashboardData(repoRoot));
    } catch (error) {
      json(res, 500, { status: "blocked", reason: error.message, live_executed: false });
    }
    return;
  }

  if (req.method === "POST" && req.url === "/v1/sdu/route") {
    let body = "";
    req.on("data", (chunk) => {
      body += chunk;
      if (body.length > 4096) req.destroy();
    });
    req.on("end", () => {
      try {
        assertDevAuth(req);
        const payload = JSON.parse(body);
        assertSyntheticRequest(payload);
        const route = selectRoute(payload.text);
        json(res, 200, {
          status: "ok",
          ...route,
          live_executed: false,
          evidence: buildEvidence(route, payload)
        });
      } catch (error) {
        json(res, 400, { status: "blocked", reason: error.message, live_executed: false });
      }
    });
    return;
  }

  json(res, 404, { status: "not_found", live_executed: false });
});

server.listen(port, host, () => {
  console.log(`SDU local agent bridge DEV listening on ${host}:${port}`);
});
