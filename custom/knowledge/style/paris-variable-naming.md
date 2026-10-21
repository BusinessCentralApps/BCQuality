---
bc-version: [all]
domain: style
keywords: [variables, naming, casing, local, prefix, paris, vivele]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Paris Demo Policy: ViVeLe Variable Names

## Description

This deliberately artificial Paris demo policy makes custom knowledge visible in AL code reviews. It is an organization-specific convention, not a Business Central or Microsoft naming requirement. It applies only to variable declarations in procedure-local and trigger-local `var` blocks.

## Best Practice

Start each local variable identifier with the exact prefix `ViVeLe`. After that prefix, alternate uppercase and lowercase letters in the remaining name, starting with uppercase. Restart the alternation after the prefix; do not apply one continuous alternating pattern to the whole identifier. Digits and underscores remain unchanged and do not advance the letter alternation. The suffix must contain at least one letter.

For example, rename `Customer` to `ViVeLeCuStOmEr`, `TotalAmount` to `ViVeLeToTaLaMoUnT`, and `Greeting` to `ViVeLeGrEeTiNg`. Update references to the renamed variable within its scope.

Do not apply this policy to global variables, procedure parameters, named return values, implicit `Rec` or `xRec`, object names, procedure names, or fields. Do not request unrelated changes outside the reviewed diff.

See sample: [`paris-variable-naming.good.al`](paris-variable-naming.good.al).

## Anti Pattern

A locally declared variable without the exact `ViVeLe` prefix, or whose suffix does not follow the alternating letter case, violates this demo policy. For example, `Customer`, `ViveLeCustomer`, and `ViVeLeCustomer` are invalid; `ViVeLeCuStOmEr` is valid.

When reporting a violation, include the marker `PARIS-NAMING` in the finding title, identify the offending declaration, and suggest the correctly transformed identifier. Cite `custom/knowledge/style/paris-variable-naming.md` so the developer can distinguish this custom policy from standard guidance.

See sample: [`paris-variable-naming.bad.al`](paris-variable-naming.bad.al).
