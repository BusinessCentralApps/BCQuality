#Requires -Version 7.5
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $RunDirectory,
    [switch] $Score
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$cases = @((Get-Content (Join-Path $PSScriptRoot 'paris-policies.json') -Raw | ConvertFrom-Json).cases)

if ($Score) {
    $result = Get-Content (Join-Path $RunDirectory 'result.json') -Raw | ConvertFrom-Json
    $actualCases = @($result.cases)
    if ($actualCases.Count -ne $cases.Count -or
        @($actualCases.id | Sort-Object -Unique).Count -ne $cases.Count) {
        throw 'Results must contain every case exactly once.'
    }
    foreach ($case in $cases) {
        $actual = @($actualCases | Where-Object id -CEQ $case.id)
        if ($actual.Count -ne 1) { throw "Missing result: $($case.id)" }
        $expectedIds = @($case.expected | Sort-Object -CaseSensitive)
        $actualIds = @($actual[0].findings | ForEach-Object id | Sort-Object -CaseSensitive)
        if (($expectedIds | ConvertTo-Json -AsArray -Compress) -cne
            ($actualIds | ConvertTo-Json -AsArray -Compress)) {
            throw "$($case.id): expected [$($expectedIds -join ', ')], got [$($actualIds -join ', ')]."
        }
    }
    Write-Host "PASS: $($cases.Count) model cases, exact article IDs/counts, and no findings on clean controls."
    return
}

if (Test-Path -LiteralPath $RunDirectory) {
    throw 'Use a new run directory; prior review evidence is never overwritten.'
}
New-Item -ItemType Directory -Path $RunDirectory | Out-Null
$RunDirectory = (Resolve-Path -LiteralPath $RunDirectory).Path
$indexPath = Join-Path $RunDirectory 'knowledge-index.json'
$skillIndexPath = Join-Path $RunDirectory 'skill-index.json'
& (Join-Path $root 'tools\Build-KnowledgeIndex.ps1') -BCQualityRoot $root -IndexPath $indexPath | Out-Null
& (Join-Path $root 'tools\Build-SkillIndex.ps1') -BCQualityRoot $root -IndexPath $skillIndexPath | Out-Null
$resolverArgs = @{
    BCQualityRoot = $root
    IndexPath = $skillIndexPath
    SuperSkillPath = 'microsoft/skills/review/al-code-review.md'
}
$composition = & (Join-Path $root 'tools\Resolve-SkillWorklist.ps1') @resolverArgs
$baseline = & (Join-Path $root 'tools\Resolve-SkillWorklist.ps1') @resolverArgs -EnabledLayers @('microsoft', 'community')
$disabled = & (Join-Path $root 'tools\Resolve-SkillWorklist.ps1') @resolverArgs -DisabledSkills @('custom/skills/review/al-style-review.md')
$style = @($composition.subSkills | Where-Object id -CEQ 'al-style-review')
if ($style.Count -ne 1 -or $style[0].path -cne 'custom/skills/review/al-style-review.md') {
    throw 'Custom style leaf was not selected in the existing review slot.'
}
foreach ($fallback in @($baseline, $disabled)) {
    if (@($fallback.subSkills | Where-Object id -CEQ 'al-style-review')[0].path -cne
        'microsoft/skills/review/al-style-review.md') {
        throw 'Disabling custom policy must restore the standard style leaf.'
    }
    $otherLeaves = @($fallback.subSkills | Where-Object id -CNE 'al-style-review')
    $currentLeaves = @($composition.subSkills | Where-Object id -CNE 'al-style-review')
    if (($otherLeaves | ConvertTo-Json -Depth 5 -Compress) -cne
        ($currentLeaves | ConvertTo-Json -Depth 5 -Compress)) {
        throw 'Custom policy changed an unrelated review slot.'
    }
}
$composition | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $RunDirectory 'composition.json') -Encoding utf8NoBOM

$catalog = [Collections.Generic.List[object]]::new()
$searchArgs = @{ BCQualityRoot = $root; IndexPath = $indexPath; Domain = 'style'; Technologies = @('al') }
$pageNumber = 0
do {
    $rawPage = & (Join-Path $root 'tools\Search-Knowledge.ps1') @searchArgs
    $rawPage | Set-Content (Join-Path $RunDirectory "catalog-$pageNumber.json") -Encoding utf8NoBOM
    $page = $rawPage | ConvertFrom-Json
    foreach ($row in $page.candidates) { $catalog.Add($row) }
    if (-not $page.complete) {
        $searchArgs.Offset = $page.continuation.offset
        $searchArgs.Snapshot = $page.continuation.snapshot
    }
    $pageNumber++
} while (-not $page.complete)
foreach ($path in @('custom/knowledge/style/paris-object-type-folders.md', 'custom/knowledge/style/paris-variable-naming.md')) {
    if (@($catalog | Where-Object path -CEQ $path).Count -ne 1) {
        throw "Policy absent from the complete style catalog: $path"
    }
}

$requests = foreach ($case in $cases) {
    $caseRoot = Join-Path $RunDirectory $case.id
    $file = Join-Path $caseRoot $case.path
    New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force | Out-Null
    $source = if ($case.PSObject.Properties.Name -contains 'sample') {
        Get-Content (Join-Path $root $case.sample) -Raw
    } else { [string]$case.source }
    $source | Set-Content -LiteralPath $file -Encoding utf8NoBOM -NoNewline
    [pscustomobject]@{ id = $case.id; sourceRoot = $caseRoot; file = $case.path }
}
[pscustomobject]@{
    goal = 'Review each independent AL file for style using the resolved leaf. These are newly authored source files, not documentation samples or published contracts.'
    bcqualityRoot = $root
    skillPath = $style[0].path
    knowledgeIndex = $indexPath
    catalogPages = @(0..($pageNumber - 1) | ForEach-Object { "catalog-$_.json" })
    cases = @($requests)
    output = 'Use the evaluation result shape: {"cases":[{"id":"case-01","findings":[{"id":"exact article path"}]}]}. Include every case, repeat IDs for distinct declaration findings, and use [] for clean cases. Save result.json. Save selected article paths and retrieval evidence separately in trace.json. Do not inspect the fixture manifest or scoring expectations.'
} | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $RunDirectory 'request.json') -Encoding utf8NoBOM
Write-Host "PASS: routing, disabled-layer/skill fallback, unchanged other leaves, and both catalog entries. Prepared $($cases.Count) cases in $RunDirectory. Model review and -Score are still required."
