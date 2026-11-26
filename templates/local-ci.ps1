<#
.SYNOPSIS
  Local CI verification runner for Top-Secret Local-Only repositories (no GitHub remote).

.DESCRIPTION
  Runs modular verification stages locally on Windows without pushing or uploading anything externally,
  including built-in UTF-8 no-BOM, doc header, [TYPE: Slug] cross-link, and path :: symbol anchor checks.
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
$utf8Strict = New-Object System.Text.UTF8Encoding($false, $true)

$repoRoot = (Get-Location).Path
$folderName = Split-Path -Leaf $repoRoot

function Resolve-RepoTitle {
    param(
        [string]$RepoPath,
        [string]$FallbackName
    )
    $agentsFile = Join-Path $RepoPath 'AGENTS.md'
    if (Test-Path -LiteralPath $agentsFile) {
        $lines = [System.IO.File]::ReadAllLines($agentsFile, [System.Text.Encoding]::UTF8)
        foreach ($line in $lines) {
            if ($line -match '^\s*[-*]\s+\*\*Project Name:\*\*\s*(.+)$') {
                $candidate = ($Matches[1] -replace '\s*\(`[^`]+`\)\s*$', '').Trim().Trim('`')
                if ($candidate -and -not $candidate.StartsWith('[')) {
                    return $candidate
                }
            }
        }
    }
    if (($FallbackName -notmatch '[-_\s]') -and ($FallbackName.Length -gt 1) -and ($FallbackName.Substring(1) -cmatch '[A-Z]')) {
        return $FallbackName
    }
    $parts = ($FallbackName -split '[-_\s]+') | Where-Object { $_ -ne '' }
    $titled = foreach ($p in $parts) {
        if ($p.Length -gt 1) {
            if ($p.Substring(1) -cmatch '[A-Z]') {
                $p
            } else {
                $p.Substring(0, 1).ToUpperInvariant() + $p.Substring(1)
            }
        } else {
            $p.ToUpperInvariant()
        }
    }
    if ($titled) { return ($titled -join ' ') }
    return $FallbackName
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

function Test-RepoStructureAndDocParity {
    param([string]$RootPath)

    $errors = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]

    $trackedRaw = Invoke-GitCapture @('ls-files')
    $trackedFiles = if ($trackedRaw) { $trackedRaw -split "`r?`n" } else { @() }

    $disposableRx = [regex]::new(' - (Local )?CI Failure Report| - (Code|Security|UIUX) Audit', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $textExts = @('.json', '.md', '.yml', '.yaml', '.ps1', '.toml')

    foreach ($rel in $trackedFiles) {
        if (-not $rel) { continue }
        $fullPath = Join-Path $RootPath $rel
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { continue }
        $ext = [System.IO.Path]::GetExtension($fullPath).ToLowerInvariant()
        $leaf = [System.IO.Path]::GetFileName($fullPath)

        if ($rel.StartsWith('.ci-logs/') -or $rel.StartsWith('.ci-report/') -or ($ext -eq '.md' -and $disposableRx.IsMatch($leaf))) {
            $errors.Add("Disposable report or CI artifact committed to git: $rel")
        }
        if (($rel.StartsWith('docs/') -or $rel.StartsWith('docs\')) -and ($ext -eq '.html' -or $ext -eq '.htm')) {
            $errors.Add("HTML file inside docs/ (move visual previews to preview/): $rel")
        }
        if ($textExts -contains $ext) {
            $bytes = [System.IO.File]::ReadAllBytes($fullPath)
            if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
                $errors.Add("UTF-8 BOM detected (must be UTF-8 without BOM): $rel")
            }
            try {
                $decoded = $utf8Strict.GetString($bytes)
            } catch {
                $errors.Add("Invalid UTF-8 encoding in ${rel}: $($_.Exception.Message)")
                continue
            }
            if ($ext -eq '.json' -and $decoded.Trim().Length -gt 0) {
                try {
                    $null = $decoded | ConvertFrom-Json -ErrorAction Stop
                } catch {
                    $errors.Add("Invalid JSON in ${rel}: $($_.Exception.Message)")
                }
            }
        }
    }

    $headerRx = [regex]::new('^### \[(FEATURE|WISHLIST|SUBSYSTEM|FLOW|DECISION|TRAP): ([^\]]+)\] \| Aliases: .+\S')
    $refRx = [regex]::new('\[(FEATURE|WISHLIST|SUBSYSTEM|FLOW|DECISION|TRAP): ([^\]]+)\]')
    $colonAnchorRx = [regex]::new('`([^`\r\n]+?\.[A-Za-z0-9_+-]+)\s*::\s*([A-Za-z_][A-Za-z0-9_.:$]*)`|`([^`\r\n]+?\.[A-Za-z0-9_+-]+)`\s*::\s*`([A-Za-z_][A-Za-z0-9_.:$]*)`')
    $legacyBulletRx = [regex]::new('^\s*[-*]\s+`([^`\r\n]+?\.[A-Za-z0-9_+-]+)`\s*->\s*(.+)$')
    $backtickIdentRx = [regex]::new('`([A-Za-z_][A-Za-z0-9_.:$]*)`')

    $definedIds = @{}
    $docsDir = Join-Path $RootPath 'docs'
    $docFiles = @()
    if (Test-Path -LiteralPath $docsDir -PathType Container) {
        $docFiles = @(Get-ChildItem -LiteralPath $docsDir -Filter '*.md' -Recurse -File | Sort-Object FullName)
    }

    foreach ($doc in $docFiles) {
        $rel = $doc.FullName.Substring($RootPath.Length).TrimStart('\', '/') -replace '\\', '/'
        $lines = [System.IO.File]::ReadAllLines($doc.FullName, [System.Text.Encoding]::UTF8)
        if (($doc.DirectoryName -ieq $docsDir) -and ($lines.Count -gt 250)) {
            $warnings.Add("[WARN] $rel has $($lines.Count) lines (>250); split details into docs/modules/<topic>.md")
        }
        $inFence = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line.TrimStart().StartsWith('```')) {
                $inFence = -not $inFence
                continue
            }
            if ($inFence) { continue }
            if ($line.StartsWith('### [')) {
                $hm = $headerRx.Match($line)
                if (-not $hm.Success) {
                    $errors.Add("${rel}:$($i + 1) invalid doc header format: $line")
                } else {
                    $tagId = "$($hm.Groups[1].Value): $($hm.Groups[2].Value)"
                    if ($definedIds.ContainsKey($tagId)) {
                        $errors.Add("${rel}:$($i + 1) duplicate [$tagId] (already in $($definedIds[$tagId]))")
                    } else {
                        $definedIds[$tagId] = "${rel}:$($i + 1)"
                    }
                }
                $nextLine = if (($i + 1) -lt $lines.Count) { $lines[$i + 1] } else { '' }
                if (-not $nextLine.StartsWith('> **1-Line Summary:**')) {
                    $errors.Add("${rel}:$($i + 2) missing immediate '> **1-Line Summary:**' after header")
                }
            }
        }
    }

    $scanTargets = New-Object System.Collections.Generic.List[System.IO.FileInfo]
    foreach ($df in $docFiles) { $scanTargets.Add($df) }
    $agentsRootFile = Join-Path $RootPath 'AGENTS.md'
    if (Test-Path -LiteralPath $agentsRootFile -PathType Leaf) {
        $scanTargets.Add((Get-Item -LiteralPath $agentsRootFile))
    }

    $fileCache = @{}
    $placeholderPrefixes = @('src/path/', 'path/to/', 'tests/feature.test.', 'fileA', 'fileB')

    foreach ($md in $scanTargets) {
        $rel = $md.FullName.Substring($RootPath.Length).TrimStart('\', '/') -replace '\\', '/'
        $lines = [System.IO.File]::ReadAllLines($md.FullName, [System.Text.Encoding]::UTF8)
        $inFence = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line.TrimStart().StartsWith('```')) {
                $inFence = -not $inFence
                continue
            }
            if ($inFence) { continue }

            if ((Test-Path -LiteralPath $docsDir -PathType Container) -and (-not $line.StartsWith('### ['))) {
                foreach ($rm in $refRx.Matches($line)) {
                    $slug = $rm.Groups[2].Value
                    $tagId = "$($rm.Groups[1].Value): $slug"
                    if (($slug -eq 'Slug') -or ($slug -match '<') -or ($slug.StartsWith('Descriptive-') -and (-not $definedIds.ContainsKey($tagId)))) { continue }
                    if (-not $definedIds.ContainsKey($tagId)) {
                        $errors.Add("${rel}:$($i + 1) broken cross-link [$tagId] (not defined in docs/)")
                    }
                }
            }

            if ($line -match '^\s*[-*]\s+\*\*Verified By:\*\*\s*(.*)$') {
                if (-not $Matches[1].Trim()) {
                    $errors.Add("${rel}:$($i + 1) empty 'Verified By:' field")
                }
            }

            $anchorsToCheck = New-Object System.Collections.Generic.List[object]
            foreach ($cm in $colonAnchorRx.Matches($line)) {
                $tPath = if ($cm.Groups[1].Success) { $cm.Groups[1].Value } else { $cm.Groups[3].Value }
                $tSym = if ($cm.Groups[2].Success) { $cm.Groups[2].Value } else { $cm.Groups[4].Value }
                $anchorsToCheck.Add([pscustomobject]@{ Path = $tPath; Symbol = $tSym })
            }
            $lm = $legacyBulletRx.Match($line)
            if ($lm.Success) {
                $tPath = $lm.Groups[1].Value
                foreach ($sm in $backtickIdentRx.Matches($lm.Groups[2].Value)) {
                    $anchorsToCheck.Add([pscustomobject]@{ Path = $tPath; Symbol = $sm.Groups[1].Value })
                }
            }

            foreach ($anc in $anchorsToCheck) {
                $norm = ($anc.Path.Trim() -replace '\\', '/')
                $isPlaceholder = $false
                foreach ($pfx in $placeholderPrefixes) {
                    if ($norm.StartsWith($pfx)) { $isPlaceholder = $true; break }
                }
                if ($isPlaceholder -or ($norm -match '[<>\[\]*%$]')) { continue }

                $targetFull = Join-Path $RootPath ($norm -replace '/', '\')
                if (-not (Test-Path -LiteralPath $targetFull -PathType Leaf)) {
                    $errors.Add("${rel}:$($i + 1) anchor file not found: $norm")
                    continue
                }
                if (-not $fileCache.ContainsKey($norm)) {
                    $fileCache[$norm] = [System.IO.File]::ReadAllText($targetFull, [System.Text.Encoding]::UTF8)
                }
                $targetBody = $fileCache[$norm]
                $parts = ($anc.Symbol.Trim() -split '(?:\.|::)+') | Where-Object { $_ -ne '' }
                foreach ($part in $parts) {
                    if (-not $targetBody.Contains($part)) {
                        $errors.Add("${rel}:$($i + 1) anchor symbol '$part' (from '$($anc.Symbol)') not found in $norm")
                    }
                }
            }
        }
    }

    $logLines = New-Object System.Collections.Generic.List[string]
    foreach ($w in $warnings) { $logLines.Add($w) }
    if ($errors.Count -gt 0) {
        foreach ($e in $errors) { $logLines.Add("[ERROR] $e") }
        return [pscustomobject]@{ Passed = $false; Output = ($logLines -join "`n") }
    }
    $logLines.Add("Structure, UTF-8, cross-link ($($definedIds.Count) doc node(s)), and code/test anchor checks passed.")
    return [pscustomobject]@{ Passed = $true; Output = ($logLines -join "`n") }
}

# Safety guard: warn if a GitHub remote is configured (those repos should use GitHub-First CI)
$remotes = Invoke-GitCapture @('remote', '-v')
if ($remotes -and -not $Force) {
    Write-Host '[WARN] Git remote detected. Public/remote repos should use GitHub Actions CI.' -ForegroundColor Yellow
    Write-Host '       Re-run with -Force if you intentionally want local verification.' -ForegroundColor Yellow
    exit 2
}

$repoTitle = Resolve-RepoTitle -RepoPath $repoRoot -FallbackName $folderName
$downloadsDir = Join-Path $env:USERPROFILE 'Downloads'
if (-not (Test-Path -LiteralPath $downloadsDir)) {
    New-Item -ItemType Directory -Path $downloadsDir -Force | Out-Null
}

# Customize stages 01-07 for this local-only project ($null skips unconfigured stages).
# Stage 08 runs built-in UTF-8 no-BOM, doc header, [TYPE: Slug] cross-link, and path :: symbol anchor checks out of the box.
$stages = @(
    [ordered]@{ Name = '01 Format & Lint';         Command = $null } # e.g., 'npm run lint'
    [ordered]@{ Name = '02 Static Type Check';     Command = $null } # e.g., 'npx tsc --noEmit'
    [ordered]@{ Name = '03 Unit Tests';            Command = $null } # e.g., 'npm run test:unit'
    [ordered]@{ Name = '04 Integration Tests';     Command = $null } # e.g., 'npm run test:integration'
    [ordered]@{ Name = '05 E2E & UI Tests';        Command = $null } # e.g., 'npx playwright test'
    [ordered]@{ Name = '06 Security & Secrets';    Command = $null } # e.g., 'npm audit --audit-level=high'
    [ordered]@{ Name = '07 Build & Smoke Test';    Command = $null } # e.g., 'npm run build'
    [ordered]@{ Name = '08 Structure & Doc Check'; Command = '__BUILTIN_DOC_PARITY__' }
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

    if ($cmd -eq '__BUILTIN_DOC_PARITY__') {
        Write-Host "[RUN]  $stageName -> Built-in UTF-8, Doc Header, Cross-Link & Anchor Validator" -ForegroundColor Cyan
        $parity = Test-RepoStructureAndDocParity -RootPath $repoRoot
        $exitCode = if ($parity.Passed) { 0 } else { 1 }
        $outputText = $parity.Output
        $displayCmd = 'Built-in Test-RepoStructureAndDocParity'
    } else {
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
        $displayCmd = $cmd
    }

    if ($exitCode -ne 0) {
        Write-Host "[FAIL] $stageName (exit $exitCode)" -ForegroundColor Red
        $failedStage = [pscustomobject]@{
            Stage   = $stageName
            Status  = "FAILED (exit $exitCode)"
            Command = $displayCmd
            Output  = $outputText
        }
        $results.Add($failedStage)
        break
    }

    Write-Host "[PASS] $stageName" -ForegroundColor Green
    $results.Add([pscustomobject]@{ Stage = $stageName; Status = 'PASSED'; Command = $displayCmd; Output = $outputText })
}

if ($failedStage) {
    $branch = Invoke-GitCapture @('rev-parse', '--abbrev-ref', 'HEAD')
    $sha = Invoke-GitCapture @('rev-parse', 'HEAD')
    $shortSha = if ($sha.Length -ge 8) { $sha.Substring(0, 8) } else { $sha }

    $diffHeading = 'Uncommitted & Staged Changes (`git diff HEAD`)'
    $diffStat = Invoke-GitCapture @('diff', 'HEAD', '--stat', '--no-color')
    $diffPatch = Invoke-GitCapture @('diff', 'HEAD', '--no-color')
    if (-not $diffStat) {
        $diffHeading = 'Latest Commit (`git show HEAD`)'
        $diffStat = Invoke-GitCapture @('show', '--stat', '--no-color', '--format=', 'HEAD')
        $diffPatch = Invoke-GitCapture @('show', '--no-color', '--format=', 'HEAD')
    }
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
    $md.Add("## $diffHeading Summary")
    $md.Add('```text')
    $md.Add($(if ($diffStat) { $diffStat } else { '(no diff available)' }))
    $md.Add('```')
    $md.Add('')
    $md.Add("## $diffHeading Excerpt")
    $md.Add('```diff')
    $md.Add($(if ($diffPatch) { $diffPatch } else { '(no diff available)' }))
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
