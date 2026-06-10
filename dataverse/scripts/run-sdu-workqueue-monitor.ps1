param(
    [int]$MaxLogSizeMB = 5,
    [int]$MaxRetainedFiles = 14
)

$scriptPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) 'monitor-sdu-workqueue-daily.ps1'
$repoRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
$logDir = Join-Path $repoRoot 'monitoring'
$logPath = Join-Path $logDir 'monitor.log'

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Resolve-LogRetention {
    param(
        [string]$Path,
        [int]$MaxSizeMB,
        [int]$MaxFiles
    )

    if ($MaxFiles -lt 1) { $MaxFiles = 1 }
    if ($MaxSizeMB -lt 1) { $MaxSizeMB = 1 }

    if (Test-Path $Path) {
        $file = Get-Item $Path
        if ($file.Length -gt ($MaxSizeMB * 1MB)) {
            $archive = '{0}.{1}' -f $Path, (Get-Date -Format 'yyyyMMdd_HHmmss')
            Move-Item -Path $Path -Destination $archive -Force
        }
    }

    $existing = Get-ChildItem -Path $logDir -File | Where-Object { $_.Name -like 'monitor.log.*' } | Sort-Object LastWriteTime -Descending
    if ($existing.Count -gt $MaxFiles) {
        $existing | Select-Object -Skip $MaxFiles | Remove-Item -Force
    }
}

try {
    Resolve-LogRetention -Path $logPath -MaxSizeMB $MaxLogSizeMB -MaxFiles $MaxRetainedFiles
    & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -SummaryOnly -Json >> $logPath 2>&1
}
catch {
    $message = "[{0}] monitor-run-failed: {1}" -f (Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'), $_.Exception.Message
    Add-Content -Path $logPath -Value $message
    throw
}
