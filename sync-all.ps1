<#
.SYNOPSIS
  Publish the master agent protocol to all local AI harnesses (Antigravity & DeepSeek Harness).

.DESCRIPTION
  Syncs C:\Users\kazir\.agent-templates\AGENTS.md to:
  1. DeepSeek Harness: ~/.dsh/AGENTS.md
  2. Antigravity: ~/.gemini/config/plugins/topic-manager/rules/AGENTS.md
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir = 'C:\Users\kazir\.agent-templates'
)

$ErrorActionPreference = 'Stop'

Write-Host "Syncing to DeepSeek Harness..." -ForegroundColor Cyan
& (Join-Path $TemplatesDir 'sync-to-dsh.ps1') -TemplatesDir $TemplatesDir

Write-Host "Syncing to Antigravity..." -ForegroundColor Cyan
& (Join-Path $TemplatesDir 'sync-to-antigravity.ps1') -TemplatesDir $TemplatesDir

Write-Host "All agent harnesses successfully synced with master protocol!" -ForegroundColor Green
