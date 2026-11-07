<#
.SYNOPSIS
  Registers the AGENTS.md watcher to run silently at Windows startup for the current user.
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir = 'C:\Users\kazir\.agent-templates'
)

$startupFolder = [System.Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupFolder 'StartAgentsWatcher.vbs'

$watcherScript = Join-Path $TemplatesDir 'watch-agents.ps1'

# VBScript runner ensures zero console window pop-up on login
$vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""$watcherScript""", 0, False
"@

[System.IO.File]::WriteAllText($shortcutPath, $vbsContent, [System.Text.Encoding]::ASCII)
Write-Host "Automatic watcher startup runner registered in: $shortcutPath" -ForegroundColor Green
Write-Host "The multi-harness sync watcher will now automatically run silently on Windows login!" -ForegroundColor Green
