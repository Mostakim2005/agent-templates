<#
.SYNOPSIS
  Local CI verification runner for Top-Secret Local-Only repositories (no GitHub remote).

.DESCRIPTION
  Runs modular verification stages locally on Windows without pushing or uploading anything externally.
  On any failure, writes a git-patch-compatible Title Case Markdown report directly into
  %USERPROFILE%\Downloads\<Repo Title Case> - Local CI Failure Report.md.
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$env:GIT_TERMINAL_PROMPT = '0'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$repoRoot = (Get-Location).Path
$folderName = Split-Path -Leaf $repoRoot

function ConvertTo-TitleCaseName {
    param([string]$RawName)
    $parts = ($RawName -split '[-_\s]+') | Where-Object { $_ -ne '' }
    $titled = foreach ($p in $parts) {
        if ($p.Length -gt 1) {
            $p.Substring(0, 1).ToUpperInvariant() + $p.Substring(1)
        } else {
            $p.ToUpperInvariant()
        }
    }
    return ($titled -join ' ')
}

function Invoke-GitCapture {
    param([string[]]$GitArgs)
    $prevEAP = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $out = & git @GitArgs 2>&1
        return ($out -join "`n").Trim()
    } finally {
        $ErrorActionPreference = $prevEAP
    }
}

# Safety guard: warn if a GitHub remote is configured (those repos should use GitHub-First CI)
$remotes = Invoke-GitCapture @('remote', '-v')
if ($remotes -and -not $Force) {
    Write-Host "[WARN] Git remote detected. Public/remote repos should use GitHub Actions CI." -ForegroundColor Yellow
    Write-Host "       Re-run with -Force if you intentionally want local verification." -ForegroundColor Yellow
    exit 2
}

$repoTitle = ConvertTo-TitleCaseName -RawName $folderName
$downloadsDir = Join-Path $env:USERPROFILE 'Downloads'
if (-not (Test-Path -LiteralPath $downloadsDir)) {
    New-Item -ItemType Directory -Path $downloadsDir -Force | Out-Null
}

# Customize each stage command for this local-only project. Leave Command empty ($null) to skip a stage.
$stages = @(
    [ordered]@{ Name = '01 Format & Lint';         Command = $null } # e.g., 'npm run lint'
    [ordered]@{ Name = '02 Static Type Check';     Command = $null } # e.g., 'npx tsc --noEmit'
    [ordered]@{ Name = '03 Unit Tests';            Command = $null } # e.g., 'npm run test:unit'
    [ordered]@{ Name = '04 Integration Tests';     Command = $null } # e.g., 'npm run test:integration'
    [ordered]@{ Name = '05 E2E & UI Tests';        Command = $null } # e.g., 'npx playwright test'
    [ordered]@{ Name = '06 Security & Secrets';    Command = $null } # e.g., 'npm audit --audit-level=high'
    [ordered]@{ Name = '07 Build & Smoke Test';    Command = $null } # e.g., 'npm run build'
    [ordered]@{ Name = '08 Structure & Doc Check'; Command = $null } # e.g., 'python scripts/check_docs.py'
)

$results = New-Object System.Collections.Generic.List[object]
$failedStage = $null

foreach ($stage in $stages) {
    $stageName = $stage.Name
    $cmd = $stage.Command
    if (-not $cmd) {
        Write-Host "[SKIP] $stageName (no command configured)" -ForegroundColor DarkGray
        $results.Add([pscustomobject]@{ Stage = $stageName; Status = 'SKIPPED'; Command = '(none)'; Output = '' })
        continue
    }

    Write-Host "[RUN]  $stageName -> $cmd" -ForegroundColor Cyan
    $prevEAP = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $outputLines = & cmd.exe /c $cmd 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $prevEAP
    }

    $outputText = ($outputLines -join "`n").Trim()
    if ($exitCode -ne 0) {
        Write-Host "[FAIL] $stageName (exit $exitCode)" -ForegroundColor Red
        $failedStage = [pscustomobject]@{
            Stage    = $stageName
            Status   = "FAILED (exit $exitCode)"
            Command  = $cmd
            Output   = $outputText
        }
        $results.Add($failedStage)
        break
    }

    Write-Host "[PASS] $stageName" -ForegroundColor Green
    $results.Add([pscustomobject]@{ Stage = $stageName; Status = 'PASSED'; Command = $cmd; Output = $outputText })
}

if ($failedStage) {
    $branch = Invoke-GitCapture @('rev-parse', '--abbrev-ref', 'HEAD')
    $sha = Invoke-GitCapture @('rev-parse', 'HEAD')
    $shortSha = if ($sha.Length -ge 8) { $sha.Substring(0, 8) } else { $sha }
    $diffStat = Invoke-GitCapture @('diff', '--stat', '--no-color')
    $diffPatch = Invoke-GitCapture @('diff', '--no-color')
    if ($diffPatch.Length -gt 12000) {
        $diffPatch = $diffPatch.Substring(0, 12000) + "`n... [diff truncated] ..."
    }

    $timestamp = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ss UTC')
    $reportPath = Join-Path $downloadsDir "$repoTitle - Local CI Failure Report.md"

    $md = New-Object System.Collections.Generic.List[string]
    $md.Add("# $repoTitle - Local CI Failure Report")
    $md.Add('')
    $md.Add('## Metadata')
    $md.Add('| Field | Value |')
    $md.Add('| :--- | :--- |')
    $md.Add("| **Repository** | ``$repoTitle`` (Top-Secret Local-Only) |")
    $md.Add("| **Branch** | ``$branch`` |")
    $md.Add("| **Commit** | ``$shortSha`` (``$sha``) |")
    $md.Add("| **Failed Stage** | ``$($failedStage.Stage)`` - ``$($failedStage.Command)`` |")
    $md.Add("| **Generated** | $timestamp |")
    $md.Add('')
    $md.Add('## Stage Ledger')
    $md.Add('| Stage | Status | Command |')
    $md.Add('| :--- | :--- | :--- |')
    foreach ($r in $results) {
        $md.Add("| $($r.Stage) | $($r.Status) | ``$($r.Command)`` |")
    }
    $md.Add('')
    $md.Add('## Failing Stage Output')
    $md.Add('```text')
    $md.Add($(if ($failedStage.Output) { $failedStage.Output } else { '(no output captured)' }))
    $md.Add('```')
    $md.Add('')
    $md.Add('## Working Tree Diff Summary (`git diff --stat`)')
    $md.Add('```text')
    $md.Add($(if ($diffStat) { $diffStat } else { '(working tree clean; inspect HEAD commit)' }))
    $md.Add('```')
    $md.Add('')
    $md.Add('## Working Tree Diff Excerpt')
    $md.Add('```diff')
    $md.Add($(if ($diffPatch) { $diffPatch } else { '(no unstaged diff)' }))
    $md.Add('```')
    $md.Add('')
    $md.Add('## Git-Patch Handoff Checklist')
    $md.Add('- Identify exact failing file paths and symbols (`path/to/file.ext :: symbolName`) from the output above.')
    $md.Add('- Generate minimal, verified `.patch` file(s) (`git apply --check`) targeting the exact failing symbols.')

    [System.IO.File]::WriteAllText($reportPath, ($md -join "`n") + "`n", $utf8NoBom)
    Write-Host "[REPORT] Saved patch-ready failure report to: $reportPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "[DONE] All configured local CI stages passed for $repoTitle." -ForegroundColor Green
