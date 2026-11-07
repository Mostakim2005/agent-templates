<#
.SYNOPSIS
  Stops any running watch-agents.ps1 background processes.
#>
$procs = Get-CimInstance Win32_Process -Filter "CommandLine LIKE '%watch-agents.ps1%'" -ErrorAction SilentlyContinue
if (-not $procs) {
    Write-Host "No active AGENTS.md watcher background processes found." -ForegroundColor Gray
    return
}

foreach ($p in $procs) {
    Stop-Process -Id $p.ProcessId -Force
    Write-Host "Stopped watcher process (PID: $($p.ProcessId))." -ForegroundColor Green
}
