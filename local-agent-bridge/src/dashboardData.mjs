import fs from "node:fs";
import path from "node:path";

function parseCsv(text) {
  const rows = [];
  let row = [];
  let value = "";
  let quoted = false;

  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    const next = text[index + 1];

    if (quoted) {
      if (char === '"' && next === '"') {
        value += '"';
        index += 1;
      } else if (char === '"') {
        quoted = false;
      } else {
        value += char;
      }
      continue;
    }

    if (char === '"') {
      quoted = true;
    } else if (char === ",") {
      row.push(value);
      value = "";
    } else if (char === "\n") {
      row.push(value);
      rows.push(row);
      row = [];
      value = "";
    } else if (char !== "\r") {
      value += char;
    }
  }

  if (value.length > 0 || row.length > 0) {
    row.push(value);
    rows.push(row);
  }

  const [headers, ...records] = rows.filter((line) => line.some((cell) => cell.trim() !== ""));
  if (!headers) return [];

  return records.map((record) => Object.fromEntries(
    headers.map((header, index) => [header, record[index] ?? ""])
  ));
}

function readCsv(repoRoot, relativePath) {
  const fullPath = path.join(repoRoot, relativePath);
  return parseCsv(fs.readFileSync(fullPath, "utf8"));
}

function countBy(rows, field) {
  return rows.reduce((counts, row) => {
    const key = row[field] || "NO_DECLARADO";
    counts[key] = (counts[key] ?? 0) + 1;
    return counts;
  }, {});
}

function firstRows(rows, count) {
  return rows.slice(0, count);
}

export function resolveRepoRoot(startPath = process.cwd()) {
  const normalized = path.resolve(startPath);
  if (path.basename(normalized) === "local-agent-bridge") {
    return path.dirname(normalized);
  }
  return normalized;
}

export function collectDashboardData(startPath = process.cwd()) {
  const repoRoot = resolveRepoRoot(startPath);
  const matricesRoot = ".agents/codex/matrices";
  const paths = {
    operability: `${matricesRoot}/AGENTS_GLOBAL_OPERABILITY_INVENTORY_20260605.csv`,
    semaphore: `${matricesRoot}/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_SEMAPHORE_MATRIX_20260605.csv`,
    gateQueue: `${matricesRoot}/AGENTS_SDK_LIVE_AGENT_GLOBAL_OPERABILITY_GATE_QUEUE_20260605.csv`,
    autonomous: `${matricesRoot}/AUTONOMOUS_AGENT_EXECUTION_MATRIX_20260602.csv`
  };

  const operability = readCsv(repoRoot, paths.operability);
  const semaphore = readCsv(repoRoot, paths.semaphore);
  const gateQueue = readCsv(repoRoot, paths.gateQueue);
  const autonomous = readCsv(repoRoot, paths.autonomous);

  return {
    status: "ok",
    live_executed: false,
    repo_root: repoRoot,
    generated_at: new Date().toISOString(),
    sources: paths,
    summary: {
      operability_records: operability.length,
      autonomous_records: autonomous.length,
      local_task_scoped_agents: autonomous.filter((row) => row.execution_mode === "local_task_scoped_agent").length,
      codex_cloud_ready_records: autonomous.filter((row) => row.status === "ACTIVE_CODEX_CLOUD_READY").length,
      gated_records: gateQueue.length,
      semaphore: countBy(semaphore, "color")
    },
    semaphores: semaphore,
    gate_queue: gateQueue,
    operability: firstRows(operability, 40),
    autonomous: firstRows(autonomous, 60)
  };
}
