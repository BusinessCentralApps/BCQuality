# Custom layer

This folder is the template for partner- and customer-specific overrides. Use it to add knowledge and skills that apply to your organization but are not appropriate for the shared Microsoft or Community layers.

## Structure

```
custom/
├── knowledge/    # Your organization's knowledge files (same format as /microsoft/knowledge/)
└── skills/       # Your organization's action skills
```

## How to use

Use a fork or organization-controlled copy of BCQuality, not the upstream
repository or your AL app's source folder. Confirm `git remote get-url origin`
points at your repository before adding custom content. Upstream does not
accept custom rules.

Follow [Customizing BCQuality](../docs/customizing-bcquality.md) for a worked
rule, plugin configuration, installing your fork, and keeping it up to date.
Adding a rule here does not update an existing upstream plugin installation;
your host must consume your copy.

Knowledge files follow [READ](../skills/read.md) and action skills follow
[DO](../skills/do.md). With the Custom layer enabled, applicable custom
knowledge overrides contradictory Community or Microsoft guidance. The report
records the displaced article; non-conflicting guidance remains additive.

## Paris demo policies in this fork

This fork deliberately opts into two playful company policies, not Microsoft
or universal AL requirements:

- [Object-type folders](knowledge/style/paris-object-type-folders.md): the
  immediate parent must match the declared type, for example `Tables`,
  `Codeunits`, `Pages`, or `TableExtensions`. Feature/app roots may precede it.
  Matching is case-sensitive. Diff reviews cover added/renamed files and type
  changes, not wholesale moves of legacy files.
- [French bakery variable names](knowledge/style/paris-variable-naming.md):
  `Croissant`, `Baguette`, `Brioche`, `Madeleine`, or `Eclair`, followed by a
  descriptive suffix starting with an uppercase ASCII letter. This replaces
  the former ViVeLe demo policy. Local/global variables, developer-controlled
  parameters, and named returns are covered; implicit and externally imposed
  identifiers are excluded. The article defines exact matching and scope.

The [custom style leaf](skills/review/al-style-review.md) uses the existing
`al-style-review` ID override mechanism, preserving the standard review while
explicitly selecting both custom articles from the live style catalog. No
shared knowledge or super-skill slot is replaced on disk. Disabling the Custom
layer or this leaf restores the Microsoft leaf; disabling only the leaf does
not disable custom knowledge discovery. Disable the Custom layer to opt out
of both policies completely.

Both policies report at `info` severity with `PARIS-FOLDERS` or `PARIS-NAMING`
in the message and the exact custom article path as the finding ID. Whether
informational findings appear in a PR is controlled by the consuming host.
The folder rule needs real target paths; a host that strips paths cannot
evaluate it. Path-only renames require host support for file-level findings.

### Validate before publishing

Run the normal [contribution checks](../docs/contributing.md#before-opening-a-pr),
then prepare the isolated Paris cases in a new directory outside the checkout:

```powershell
pwsh .\custom\evaluation\Test-ParisPolicies.ps1 -RunDirectory C:\Temp\ParisReview
```

Preparation checks the actual skill resolver, fallback with the custom layer
or leaf disabled, unchanged other review slots, and both articles in the full
paginated style catalog. It generates `request.json`, source files with their
real review paths, and catalog pages without expected answers. Give only that
request and its referenced files to a fresh review agent. The request uses the
existing evaluation's reduced finding-ID result shape; save its response as
`result.json` and its article-selection evidence as `trace.json`. Then score:

```powershell
pwsh .\custom\evaluation\Test-ParisPolicies.ps1 -RunDirectory C:\Temp\ParisReview -Score
```

The 16 cases cover table/codeunit placement, nested feature roots, wrong case,
an intervening folder, tableextensions, valid and invalid bakery prefixes,
local/global/parameter/return declarations, the retired prefix, and implicit
`Rec`. Scoring requires exact article IDs and declaration counts, with no
findings on clean controls. This is model evaluation, not AL compilation.
Preparation alone does not prove a model loaded or applied the policies.

The shared fixture harness neutralizes source paths and tests upstream style
expectations. Its clean samples need not satisfy an opt-in bakery policy.
Keep this path-sensitive company-policy suite separate rather than changing
upstream samples to wear demo prefixes; the naming article's narrow coverage
waiver points here. CI runs preparation; live model review remains explicit.

Content tag `v1.16` pairs with version `1.16.0` in both plugin manifests.
Before publication, confirm the tag is still unused, run the checks and live
cases, and tag only the validated commit. Never move an existing tag.
Updating a consuming repository's pinned version is a separate opt-in step.
