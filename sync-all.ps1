<#
.SYNOPSIS
  Two-way synchronization for master AGENTS.md across all AI agent harnesses with automated Git commit and push.

.DESCRIPTION
  Synchronizes AGENTS.md across:
  1. Master Repository : C:\Users\kazir\.agent-templates\AGENTS.md
  2. Antigravity       : C:\Users\kazir\.gemini\config\plugins\topic-manager\rules\AGENTS.md
  3. DeepSeek Harness  : C:\Users\kazir\.dsh\AGENTS.md
  4. OpenCode          : C:\Users\kazir\.config\opencode\AGENTS.md
  5. Command Code      : C:\Users\kazir\.commandcode\AGENTS.md
  6. Claude Code       : C:\Users\kazir\.claude\CLAUDE.md
  7. Codex             : C:\Users\kazir\.codex\AGENTS.md

  Two-Way Sync Logic:
  - Compares timestamps and SHA256 hashes across all targets.
  - If any target harness is newer than the Master and differs, Master is updated from that harness.
  - If Master is newer, all harnesses are updated from Master.
  - When changes occur, changes are automatically committed to Git and pushed to GitHub.
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir = 'C:\Users\kazir\.agent-templates',
    [switch]$NoGitPush
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$masterPath = Join-Path $TemplatesDir 'AGENTS.md'
if (-not (Test-Path -LiteralPath $masterPath)) {
    throw "Master protocol not found: $masterPath"
}

$harnesses = [ordered]@{
    'Antigravity'       = (Join-Path $env:USERPROFILE '.gemini\config\plugins\topic-manager\rules\AGENTS.md')
    'DeepSeekHarness'   = (Join-Path $env:USERPROFILE '.dsh\AGENTS.md')
    'OpenCode'          = (Join-Path $env:USERPROFILE '.config\opencode\AGENTS.md')
    'CommandCode'       = (Join-Path $env:USERPROFILE '.commandcode\AGENTS.md')
    'ClaudeCode'        = (Join-Path $env:USERPROFILE '.claude\CLAUDE.md')
    'Codex'             = (Join-Path $env:USERPROFILE '.codex\AGENTS.md')
}

function Get-TextHash([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) { return $null }
    return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
}

$masterHash = Get-TextHash $masterPath
$masterTime = (Get-Item -LiteralPath $masterPath).LastWriteTimeUtc

# Check if any harness has newer edits than Master
$newestHarnessName = $null
$newestHarnessTime = $masterTime
$newestHarnessPath = $null

foreach ($entry in $harnesses.GetEnumerator()) {
    $hName = $entry.Key
    $hPath = $entry.Value
    if (Test-Path -LiteralPath $hPath) {
        $hHash = Get-TextHash $hPath
        $hTime = (Get-Item -LiteralPath $hPath).LastWriteTimeUtc
        if ($hHash -ne $masterHash -and $hTime -gt $newestHarnessTime) {
            $newestHarnessTime = $hTime
            $newestHarnessName = $hName
            $newestHarnessPath = $hPath
        }
    }
}

$sourceOfTruth = "Master ($masterPath)"
$changed = $false

if ($newestHarnessName) {
    Write-Host "[SYNC] Target '$newestHarnessName' has newer changes than Master. Promoting to Master..." -ForegroundColor Cyan
    $sourceContent = [System.IO.File]::ReadAllText($newestHarnessPath, [System.Text.Encoding]::UTF8)
    $sourceContent = $sourceContent -replace '<!--[\s\S]*?-->\r?\n?', ''
    [System.IO.File]::WriteAllText($masterPath, $sourceContent.TrimStart(), $utf8NoBom)
    $masterHash = Get-TextHash $masterPath
    $sourceOfTruth = "$newestHarnessName ($newestHarnessPath)"
    $changed = $true
} else {
    Write-Host "[SYNC] Using Master AGENTS.md as source of truth." -ForegroundColor Cyan
}

$masterContent = [System.IO.File]::ReadAllText($masterPath, [System.Text.Encoding]::UTF8)

# Replicate to all harnesses
foreach ($entry in $harnesses.GetEnumerator()) {
    $hName = $entry.Key
    $hPath = $entry.Value
    $hDir = Split-Path -Parent $hPath
    if (-not (Test-Path -LiteralPath $hDir)) {
        New-Item -ItemType Directory -Path $hDir -Force | Out-Null
    }

    $currentHash = Get-TextHash $hPath
    if ($currentHash -ne $masterHash) {
        [System.IO.File]::WriteAllText($hPath, $masterContent, $utf8NoBom)
        Write-Host "  -> Updated $hName ($hPath)" -ForegroundColor Green
        $changed = $true
    } else {
        Write-Host "  = $hName is in sync." -ForegroundColor Gray
    }
}

# Git commit and push if changes occurred or if repository has uncommitted changes
if (-not $NoGitPush) {
    $gitStatus = git -C $TemplatesDir status --porcelain
    if ($gitStatus) {
        Write-Host "[GIT] Committing and pushing changes to GitHub..." -ForegroundColor Yellow
        git -C $TemplatesDir add -A
        $commitMsg = if ($newestHarnessName) {
            "chore(agents): auto-sync AGENTS.md updates from $newestHarnessName"
        } else {
            "chore(agents): sync AGENTS.md across all agent harnesses"
        }
        git -C $TemplatesDir commit -m $commitMsg
        git -C $TemplatesDir push origin main
        Write-Host "[GIT] Successfully pushed to origin main." -ForegroundColor Green
    } else {
        Write-Host "[GIT] Master repository working tree clean. Everything up to date." -ForegroundColor Gray
    }
}

Write-Host "[DONE] All 6 agent harnesses + Master are fully in sync!" -ForegroundColor Green
