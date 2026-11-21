<#
.SYNOPSIS
  Extracts and deduplicates Section 8 `- [PREF: ...]` entries across Master AGENTS.md and all 7 harnesses.

.DESCRIPTION
  Generates a clean, gitignored Markdown report (`SECTION8_REVIEW.md`) listing:
  - Link status of each harness (Symlinked, Detached Copy, or Missing)
  - All unique Section 8 preference entries across Master and any detached harness copies
  - A ready-to-paste prompt for consolidating Section 8 into Sections 1-7 with a frontier LLM
#>
[CmdletBinding()]
param(
    [string]$TemplatesDir,
    [string]$OutputFile
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not $TemplatesDir) {
    $TemplatesDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
}
if (-not $TemplatesDir) {
    $TemplatesDir = (Join-Path $env:USERPROFILE '.agent-templates')
}
if (-not $OutputFile) {
    $OutputFile = Join-Path $TemplatesDir 'SECTION8_REVIEW.md'
}

$masterPath = (Resolve-Path -LiteralPath (Join-Path $TemplatesDir 'AGENTS.md')).Path

$targets = [ordered]@{
    'Master'          = $masterPath
    'Antigravity'     = (Join-Path $env:USERPROFILE '.gemini\AGENTS.md')
    'DeepSeekHarness' = (Join-Path $env:USERPROFILE '.dsh\AGENTS.md')
    'OpenCode'        = (Join-Path $env:USERPROFILE '.config\opencode\AGENTS.md')
    'CommandCode'     = (Join-Path $env:USERPROFILE '.commandcode\AGENTS.md')
    'ClaudeCode'      = (Join-Path $env:USERPROFILE '.claude\CLAUDE.md')
    'Codex'           = (Join-Path $env:USERPROFILE '.codex\AGENTS.md')
    'Freebuff'        = (Join-Path $env:USERPROFILE '.AGENTS.md')
}

function Get-Section8Pref([string]$Path) {
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

function Get-TargetStatus([string]$Name, [string]$Path, [string]$MasterFullPath) {
    if ($Name -eq 'Master') { return 'Master' }
    if (-not (Test-Path -LiteralPath $Path)) { return 'Missing' }
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.LinkType -eq 'SymbolicLink') {
        $linkTargets = @($item.Target)
        if ($linkTargets.Count -gt 0 -and $linkTargets[0]) {
            try {
                if ((Resolve-Path -LiteralPath $linkTargets[0] -ErrorAction Stop).Path -ieq $MasterFullPath) {
                    return 'Symlinked to Master'
                }
            } catch {
                return 'Broken Symlink'
            }
        }
        return 'Symlink (Other Target)'
    }
    return 'Detached Copy'
}

$prefSources = [ordered]@{}
$statusRows = New-Object System.Collections.Generic.List[string]

foreach ($entry in $targets.GetEnumerator()) {
    $name = $entry.Key
    $path = $entry.Value
    $status = Get-TargetStatus $name $path $masterPath
    $prefs = Get-Section8Pref $path
    $statusRows.Add("| $name | $status | $($prefs.Count) |")

    foreach ($pref in $prefs) {
        if (-not $prefSources.Contains($pref)) {
            $prefSources[$pref] = New-Object System.Collections.Generic.List[string]
        }
        if (-not $prefSources[$pref].Contains($name)) {
            $prefSources[$pref].Add($name)
        }
    }
}

$timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm')
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('# Section 8 Preference Extraction Report')
[void]$sb.AppendLine("Generated: $timestamp")
[void]$sb.AppendLine('')
[void]$sb.AppendLine('## Harness Link Status')
[void]$sb.AppendLine('| Harness | Status | Section 8 Entries |')
[void]$sb.AppendLine('| --- | --- | --- |')
foreach ($row in $statusRows) {
    [void]$sb.AppendLine($row)
}
[void]$sb.AppendLine('')
[void]$sb.AppendLine("## Unique Section 8 Preferences ($($prefSources.Count))")

if ($prefSources.Count -eq 0) {
    [void]$sb.AppendLine('*(No Section 8 preferences found across Master or any harness.)*')
} else {
    foreach ($kv in $prefSources.GetEnumerator()) {
        $sources = ($kv.Value -join ', ')
        $flag = if (-not $kv.Value.Contains('Master')) { ' **[NOT IN MASTER YET]**' } else { '' }
        [void]$sb.AppendLine("$($kv.Key) *(from: $sources)*$flag")
    }
}

[void]$sb.AppendLine('')
[void]$sb.AppendLine('## Frontier LLM Consolidation Prompt')
[void]$sb.AppendLine('> Consolidate the unique Section 8 preferences above into Sections 1-7 of master `AGENTS.md` without duplicating existing rules, clear the consolidated bullets from Section 8, and run `run-sync.bat` to push to GitHub.')

[System.IO.File]::WriteAllText($OutputFile, $sb.ToString(), $utf8NoBom)
Write-Host "[DONE] Extracted $($prefSources.Count) unique Section 8 preference(s) -> $OutputFile" -ForegroundColor Green
