<#
.SYNOPSIS
  Symlink-first synchronization for master AGENTS.md across all AI agent harnesses with Section 8 rescue and safe Git push.

.DESCRIPTION
  Links (or copies as fallback when run without Admin/Developer Mode) master AGENTS.md to:
  1. Antigravity       : %USERPROFILE%\.gemini\AGENTS.md
  2. DeepSeek Harness  : %USERPROFILE%\.dsh\AGENTS.md
  3. OpenCode          : %USERPROFILE%\.config\opencode\AGENTS.md
  4. Command Code      : %USERPROFILE%\.commandcode\AGENTS.md
  5. Claude Code       : %USERPROFILE%\.claude\CLAUDE.md
  6. Codex / ChatGPT   : %USERPROFILE%\.codex\AGENTS.md
  7. Freebuff          : %USERPROFILE%\.AGENTS.md

  How It Works:
  - Before linking/updating, scans any non-symlink (detached) harness file for new Section 8 `- [PREF: ...]`
    entries not yet in Master and rescues them into Master AGENTS.md so no preferences are lost.
  - Creates Windows symbolic links pointing every harness directly to Master AGENTS.md (true single source of truth).
  - If symlink creation is blocked (no Admin rights and Windows Developer Mode is off), falls back cleanly to
    writing an exact UTF-8 (no BOM) copy and prints a 1-line tip.
  - Commits, pulls with rebase, and pushes non-interactively (GIT_TERMINAL_PROMPT=0) with exit-code verification.
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir,
    [switch]$NoGitPush,
    [switch]$CopyOnly
)

$ErrorActionPreference = 'Stop'
$env:GIT_TERMINAL_PROMPT = '0'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not $TemplatesDir) {
    $TemplatesDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
}
if (-not $TemplatesDir) {
    $TemplatesDir = (Join-Path $env:USERPROFILE '.agent-templates')
}

$masterPath = (Resolve-Path -LiteralPath (Join-Path $TemplatesDir 'AGENTS.md')).Path
if (-not (Test-Path -LiteralPath $masterPath)) {
    throw "Master protocol not found: $masterPath"
}

$harnesses = [ordered]@{
    'Antigravity'     = (Join-Path $env:USERPROFILE '.gemini\AGENTS.md')
    'DeepSeekHarness' = (Join-Path $env:USERPROFILE '.dsh\AGENTS.md')
    'OpenCode'        = (Join-Path $env:USERPROFILE '.config\opencode\AGENTS.md')
    'CommandCode'     = (Join-Path $env:USERPROFILE '.commandcode\AGENTS.md')
    'ClaudeCode'      = (Join-Path $env:USERPROFILE '.claude\CLAUDE.md')
    'Codex'           = (Join-Path $env:USERPROFILE '.codex\AGENTS.md')
    'Freebuff'        = (Join-Path $env:USERPROFILE '.AGENTS.md')
}

function Get-TextHash([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Test-PointsToMaster([string]$Path, [string]$MasterFullPath) {
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.LinkType -ne 'SymbolicLink') { return $false }
    $targets = @($item.Target)
    if ($targets.Count -eq 0 -or -not $targets[0]) { return $false }
    try {
        $resolvedTarget = (Resolve-Path -LiteralPath $targets[0] -ErrorAction Stop).Path
        return ($resolvedTarget -ieq $MasterFullPath)
    } catch {
        return $false
    }
}

function Get-Section8Prefs([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    $lines = [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)
    $inSection8 = $false
    $prefs = @()
    foreach ($line in $lines) {
        if ($line -match '^##\s+8\.') {
            $inSection8 = $true
            continue
        }
        if ($inSection8 -and $line -match '^##\s+') {
            break
        }
        if ($inSection8 -and $line -match '^\s*-\s+\[PREF:') {
            $prefs += $line.Trim()
        }
    }
    return $prefs
}

function Invoke-Git([string[]]$GitArgs) {
    $prevEAP = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & git -C $TemplatesDir @GitArgs 2>&1
    } finally {
        $ErrorActionPreference = $prevEAP
    }
    if ($LASTEXITCODE -ne 0) {
        throw "git $($GitArgs -join ' ') failed (exit $LASTEXITCODE):`n$($output -join "`n")"
    }
    return $output
}

# Step 1: Rescue any unique Section 8 preferences from detached/non-symlink harness copies
$masterPrefs = Get-Section8Prefs $masterPath
$rescuedPrefs = New-Object System.Collections.Generic.List[string]

foreach ($entry in $harnesses.GetEnumerator()) {
    $hName = $entry.Key
    $hPath = $entry.Value
    if ((Test-Path -LiteralPath $hPath) -and -not (Test-PointsToMaster $hPath $masterPath)) {
        $hPrefs = Get-Section8Prefs $hPath
        foreach ($pref in $hPrefs) {
            if (($masterPrefs -notcontains $pref) -and (-not $rescuedPrefs.Contains($pref))) {
                $rescuedPrefs.Add($pref)
                Write-Host "[RESCUE] Found new Section 8 preference in detached '$hName': $pref" -ForegroundColor Cyan
            }
        }
    }
}

if ($rescuedPrefs.Count -gt 0) {
    $masterText = [System.IO.File]::ReadAllText($masterPath, [System.Text.Encoding]::UTF8).TrimEnd()
    $appendBlock = ($rescuedPrefs -join "`n")
    [System.IO.File]::WriteAllText($masterPath, "$masterText`n$appendBlock`n", $utf8NoBom)
    Write-Host "[RESCUE] Appended $($rescuedPrefs.Count) preference(s) into Master AGENTS.md Section 8." -ForegroundColor Green
}

$masterContent = [System.IO.File]::ReadAllText($masterPath, [System.Text.Encoding]::UTF8)
$masterHash = Get-TextHash $masterPath
$symlinkFallbackHit = $false

# Step 2: Ensure every harness is symlinked to Master (or fall back cleanly to copy if unprivileged)
foreach ($entry in $harnesses.GetEnumerator()) {
    $hName = $entry.Key
    $hPath = $entry.Value
    $hDir = Split-Path -Parent $hPath
    if (-not (Test-Path -LiteralPath $hDir)) {
        New-Item -ItemType Directory -Path $hDir -Force | Out-Null
    }

    if (-not $CopyOnly -and (Test-PointsToMaster $hPath $masterPath)) {
        Write-Host "  = $hName is symlinked to Master." -ForegroundColor Gray
        continue
    }

    if (-not $CopyOnly) {
        try {
            if (Test-Path -LiteralPath $hPath) {
                Remove-Item -LiteralPath $hPath -Force
            }
            New-Item -ItemType SymbolicLink -Path $hPath -Target $masterPath -Force | Out-Null
            Write-Host "  -> Linked $hName ($hPath -> Master)" -ForegroundColor Green
            continue
        } catch {
            $symlinkFallbackHit = $true
        }
    }

    # Copy fallback (or explicit -CopyOnly mode)
    $currentHash = Get-TextHash $hPath
    if ($currentHash -ne $masterHash) {
        [System.IO.File]::WriteAllText($hPath, $masterContent, $utf8NoBom)
        Write-Host "  -> Copied Master to $hName ($hPath)" -ForegroundColor Yellow
    } else {
        Write-Host "  = $hName copy is in sync." -ForegroundColor Gray
    }
}

if ($symlinkFallbackHit) {
    Write-Host "[TIP] Symlink creation needs a one-time 'Run as Administrator' (or Windows Developer Mode). Used safe file copy instead." -ForegroundColor Yellow
}

# Step 3: Non-interactive Git commit, rebase, and push
if (-not $NoGitPush) {
    $gitStatus = Invoke-Git @('status', '--porcelain')
    if ($gitStatus) {
        Write-Host "[GIT] Committing and pushing changes to GitHub..." -ForegroundColor Yellow
        Invoke-Git @('add', '-A') | Out-Null
        $commitMsg = if ($rescuedPrefs.Count -gt 0) {
            "chore(agents): rescue $($rescuedPrefs.Count) Section 8 pref(s) and sync AGENTS.md"
        } else {
            "chore(agents): sync AGENTS.md across all agent harnesses"
        }
        Invoke-Git @('commit', '-m', $commitMsg) | Out-Null
        Invoke-Git @('pull', '--rebase', 'origin', 'main') | Out-Null
        Invoke-Git @('push', 'origin', 'main') | Out-Null
        Write-Host "[GIT] Successfully pushed to origin main." -ForegroundColor Green
    } else {
        Write-Host "[GIT] Master repository working tree clean. Everything up to date." -ForegroundColor Gray
    }
}

Write-Host "[DONE] All $($harnesses.Count) agent harnesses + Master are in sync!" -ForegroundColor Green
