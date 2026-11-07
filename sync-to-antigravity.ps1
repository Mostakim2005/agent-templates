<#
.SYNOPSIS
  Publish the master agent protocol to Antigravity as its global AGENTS.md rule.

.DESCRIPTION
  Antigravity loads system-wide rules from ~/.gemini/config/plugins/topic-manager/rules/AGENTS.md.
  The master copy stays in C:\Users\kazir\.agent-templates\AGENTS.md.
  Run this script after updating the master AGENTS.md.
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

$targetDir = 'C:\Users\kazir\.gemini\config\plugins\topic-manager\rules'
$target = Join-Path $targetDir 'AGENTS.md'

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
Copy-Item -LiteralPath $master -Destination $target -Force

$masterHash = (Get-FileHash -LiteralPath $master -Algorithm SHA256).Hash
$copyHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash

[pscustomobject]@{
    Master          = $master
    MasterHash      = $masterHash
    AntigravityCopy = $target
    CopyHash        = $copyHash
    Bytes           = (Get-Item -LiteralPath $target).Length
    SyncedAt        = (Get-Date).ToString('s')
} | Format-List
