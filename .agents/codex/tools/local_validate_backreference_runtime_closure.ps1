param(
  [string]$RepoRoot = "C:\Users\enzo1\Documents\GitHub\cabina-universal-d"
)

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
  [pscustomobject]@{
    status = "FAIL"
    validator = "local_validate_backreference_runtime_closure"
    error = $Message
  } | ConvertTo-Json -Depth 4
  exit 1
}

function Read-CsvRequired([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    Fail "missing_required_file:$Path"
  }
  return @(Import-Csv -LiteralPath $Path)
}

$trace = Read-CsvRequired (Join-Path $RepoRoot "matrices\runtime\BACK_REFERENCE_RUNTIME_TRACE_SOURCE_MATRIX.csv")
$decision = Read-CsvRequired (Join-Path $RepoRoot "matrices\runtime\BACK_REFERENCE_RUNTIME_CLOSURE_DECISION_MATRIX.csv")
$write = Read-CsvRequired (Join-Path $RepoRoot "matrices\runtime\BACK_REFERENCE_RUNTIME_WRITE_RESULT.csv")
$second = Read-CsvRequired (Join-Path $RepoRoot "matrices\runtime\BACK_REFERENCE_SECOND_ITEM_VALIDATION_RESULT.csv")
$safePath = Join-Path $RepoRoot "validation\runtime\BACK_REFERENCE_RUNTIME_SAFE_STATE_POSTCHECK.md"
$safe = if (Test-Path -LiteralPath $safePath) { Get-Content -LiteralPath $safePath -Raw } else { Fail "missing_required_file:$safePath" }

$requiredTrace = @{
  "canonical_id" = "expanded_connection_seed_0011"
  "correlation_id" = "corr_connection_seed_0011"
  "idempotency_key" = "20260603_wqexp_v1_connection_seed_0011"
}

foreach ($key in $requiredTrace.Keys) {
  $row = $trace | Where-Object { $_.field -eq $key } | Select-Object -First 1
  if (-not $row -or [string]::IsNullOrWhiteSpace($row.value)) {
    Fail "missing_trace_key:$key"
  }
  if ($row.value -ne $requiredTrace[$key]) {
    Fail "unexpected_trace_value:$key"
  }
}

$decisionRow = $decision | Select-Object -First 1
if (-not $decisionRow) { Fail "missing_decision_row" }
if ($decisionRow.state -ne "NO_TARGET_BUT_CAN_CREATE_MAPPING_RECORD") {
  Fail "unexpected_decision_state:$($decisionRow.state)"
}
if ($decisionRow.target_update_executed -ne "false") {
  Fail "target_update_must_not_execute_without_exact_target"
}
if ([string]::IsNullOrWhiteSpace($decisionRow.mapping_record_id)) {
  Fail "mapping_record_id_missing"
}

$writeRow = $write | Select-Object -First 1
if (-not $writeRow) { Fail "missing_write_row" }
if ($writeRow.status -ne "MAPPING_RECORD_CREATED") {
  Fail "mapping_record_not_created"
}
if ($writeRow.target_update_executed -ne "false") {
  Fail "write_target_update_must_be_false"
}
if ($writeRow.printed_secret -ne "false" -or $writeRow.contains_personal_data -ne "false" -or $writeRow.contains_document -ne "false") {
  Fail "secret_or_sensitive_flag_detected"
}

$secondRow = $second | Select-Object -First 1
if ($secondRow.second_item_processed -ne "0") {
  Fail "additional_item_limit_exceeded"
}

foreach ($needle in @(
  "Flow active count: 0",
  "Additional items processed: 0",
  "PROD: not touched",
  "TEST: not touched",
  "Default: not used",
  "Secrets printed: false",
  "Personal data: false",
  "Documents: false"
)) {
  if ($safe -notlike "*$needle*") {
    Fail "safe_state_missing:$needle"
  }
}

[pscustomobject]@{
  status = "PASS"
  validator = "local_validate_backreference_runtime_closure"
  mapping_record_id = $decisionRow.mapping_record_id
  target_update_executed = $decisionRow.target_update_executed
  second_item_processed = $secondRow.second_item_processed
  no_prod_test_default = $true
  no_secret_personal_document = $true
} | ConvertTo-Json -Depth 4
