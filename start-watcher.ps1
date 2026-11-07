<#
.SYNOPSIS
  Launches watch-agents.ps1 in the background as a silent, independent process.
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir = 'C:\Users\kazir\.agent-templates'
)

$scriptPath = Join-Path $TemplatesDir 'watch-agents.ps1'
$processName = "powershell"

# Check if already running
$existing = Get-CimInstance Win32_Process -Filter "CommandLine LIKE '%watch-agents.ps1%'" -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "AGENTS.md watcher is already running in background (PID: $($existing.ProcessId))." -ForegroundColor Yellow
    return
}

$startInfo = New-Object System.Diagnostics.ProcessStartInfo
$startInfo.FileName = "powershell.exe"
$startInfo.Arguments = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
$startInfo.CreateNoWindow = $true
$startInfo.UseShellExecute = $false

$proc = [System.Diagnostics.Process]::Start($startInfo)
Write-Host "AGENTS.md automatic sync watcher started in background (PID: $($proc.Id))!" -ForegroundColor Green
