$scriptPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) 'monitor-sdu-workqueue-daily.ps1'
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
$logDir = Join-Path $repoRoot 'monitoring'
$logPath = Join-Path $logDir 'monitor.log'
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -SummaryOnly -Json >> $logPath 2>&1
}
catch {
    Add-Content -Path $logPath -Value ("[{0}] monitor-run-failed: {1}" -f (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'), $_.Exception.Message)
    throw
}
