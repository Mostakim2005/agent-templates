<#
.SYNOPSIS
  Publish the master agent protocol to DeepSeek Harness.
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir = 'C:\Users\kazir\.agent-templates'
)

$ErrorActionPreference = 'Stop'
$master = Join-Path $TemplatesDir 'AGENTS.md'
if (-not (Test-Path -LiteralPath $master)) {
    throw "Master protocol not found: $master"
}

$dshHome = if ([string]::IsNullOrWhiteSpace($env:DSH_HOME)) {
    Join-Path $env:USERPROFILE '.dsh'
} else {
    $env:DSH_HOME
}

$target = Join-Path $dshHome 'AGENTS.md'
New-Item -ItemType Directory -Path $dshHome -Force | Out-Null
Copy-Item -LiteralPath $master -Destination $target -Force

Write-Host "Synced to DeepSeek Harness: $target" -ForegroundColor Green
