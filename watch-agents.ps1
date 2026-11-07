<#
.SYNOPSIS
  Real-time background watcher for AGENTS.md across all AI agent harnesses.

.DESCRIPTION
  Monitors:
  - Master         : C:\Users\kazir\.agent-templates\AGENTS.md
  - Antigravity    : C:\Users\kazir\.gemini\config\plugins\topic-manager\rules\AGENTS.md
  - DeepSeek       : C:\Users\kazir\.dsh\AGENTS.md
  - OpenCode       : C:\Users\kazir\.config\opencode\AGENTS.md
  - Command Code   : C:\Users\kazir\.commandcode\AGENTS.md
  - Claude Code    : C:\Users\kazir\.claude\CLAUDE.md

  Whenever any file changes, it automatically runs two-way sync, updates all other harnesses,
  commits the change, and pushes to GitHub.
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir = 'C:\Users\kazir\.agent-templates',
    [int]$IntervalSeconds = 2
)

$syncScript = Join-Path $TemplatesDir 'sync-all.ps1'
if (-not (Test-Path -LiteralPath $syncScript)) {
    throw "Sync script not found: $syncScript"
}

$watchTargets = @(
    (Join-Path $TemplatesDir 'AGENTS.md'),
    (Join-Path $env:USERPROFILE '.gemini\config\plugins\topic-manager\rules\AGENTS.md'),
    (Join-Path $env:USERPROFILE '.dsh\AGENTS.md'),
    (Join-Path $env:USERPROFILE '.config\opencode\AGENTS.md'),
    (Join-Path $env:USERPROFILE '.commandcode\AGENTS.md'),
    (Join-Path $env:USERPROFILE '.claude\CLAUDE.md')
)

$lastKnownTimes = @{}
foreach ($t in $watchTargets) {
    if (Test-Path -LiteralPath $t) {
        $lastKnownTimes[$t] = (Get-Item -LiteralPath $t).LastWriteTimeUtc
    } else {
        $lastKnownTimes[$t] = [DateTime]::MinValue
    }
}

Write-Host "[AGENTS-WATCHER] Active and monitoring 6 harness paths..." -ForegroundColor Cyan

while ($true) {
    Start-Sleep -Seconds $IntervalSeconds

    $changeDetected = $false
    $changedFile = $null

    foreach ($t in $watchTargets) {
        if (Test-Path -LiteralPath $t) {
            $currentTime = (Get-Item -LiteralPath $t).LastWriteTimeUtc
            if ($currentTime -ne $lastKnownTimes[$t]) {
                $changeDetected = $true
                $changedFile = $t
                break
            }
        }
    }

    if ($changeDetected) {
        Write-Host "[AGENTS-WATCHER] Detected modification in $changedFile at $(Get-Date -Format 'HH:mm:ss'). Syncing..." -ForegroundColor Yellow
        try {
            & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $syncScript -TemplatesDir $TemplatesDir
        } catch {
            Write-Warning "[AGENTS-WATCHER] Sync invocation error: $_"
        }

        # Refresh all timestamps after sync completes
        foreach ($t in $watchTargets) {
            if (Test-Path -LiteralPath $t) {
                $lastKnownTimes[$t] = (Get-Item -LiteralPath $t).LastWriteTimeUtc
            }
        }
    }
}
