<#
.SYNOPSIS
  Removes the AGENTS.md watcher from Windows startup.
#>
$startupFolder = [System.Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder 'StartAgentsWatcher.vbs'

if (Test-Path -LiteralPath $shortcutPath) {
    Remove-Item -LiteralPath $shortcutPath -Force
    Write-Host "Removed watcher startup runner from: $shortcutPath" -ForegroundColor Green
} else {
    Write-Host "Watcher startup runner was not registered." -ForegroundColor Gray
}

& (Join-Path $PSScriptRoot 'stop-watcher.ps1')
