<#
.SYNOPSIS
  Publish the master agent protocol to DeepSeek Harness as its system-wide AGENTS.md.

.DESCRIPTION
  DeepSeek Harness loads user-global instructions from $DSH_HOME/AGENTS.md
  (default ~/.dsh/AGENTS.md) for every session, in every working directory.
  The master copy stays in this folder; this script regenerates the harness
  mirror so project work never edits the harness copy by hand.

  Run this after editing C:\Users\kazir\.agent-templates\AGENTS.md.
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

$banner = @(
    '<!-- System-wide mirror of C:\Users\kazir\.agent-templates\AGENTS.md (master). Do not edit this copy; edit the master and run: powershell -NoProfile -File C:\Users\kazir\.agent-templates\sync-to-dsh.ps1 -->',
    '<!-- If the master file is newer than this mirror, read and follow the master. -->',
    ''
) -join "`n"

$body = Get-Content -LiteralPath $master -Raw -Encoding utf8
$content = $banner + $body.TrimStart([char]0xFEFF)

New-Item -ItemType Directory -Path $dshHome -Force | Out-Null
[System.IO.File]::WriteAllText($target, $content, (New-Object System.Text.UTF8Encoding($false)))

$masterHash = (Get-FileHash -LiteralPath $master -Algorithm SHA256).Hash
$bodyHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash

[pscustomobject]@{
    Master       = $master
    MasterHash   = $masterHash
    HarnessCopy  = $target
    CopyHash     = $bodyHash
    Bytes        = (Get-Item -LiteralPath $target).Length
    SyncedAt     = (Get-Date).ToString('s')
} | Format-List
