---
bc-version: [all]
domain: style
keywords: [var, variables, naming, local, global, parameters, prefix, croissant, baguette, paris]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Paris Demo Policy: French Bakery Variable Names

## Description

This deliberately playful Paris demo company policy requires French bakery prefixes on AL variable declarations, including local and global `var` blocks, procedure parameters, and named return values. It is not a Business Central, Microsoft, or French-localization requirement. It replaces this fork's former ViVeLe alternating-case demo convention; it does not impose alternating case.

## Best Practice

Start each developer-controlled variable identifier with exactly one of `Croissant`, `Baguette`, `Brioche`, `Madeleine`, or `Eclair` (ASCII spelling). Match the prefix case-sensitively, followed immediately by a descriptive suffix beginning with an uppercase ASCII letter and containing only ASCII letters and digits. The exact shape is `^(Croissant|Baguette|Brioche|Madeleine|Eclair)[A-Z][A-Za-z0-9]*$`. A prefix alone is not a variable name. For quoted AL identifiers, apply the same rule to the identifier inside the quotes.

For example, use `CroissantCustomer`, `BaguetteCount`, `BriocheTotalAmount`, `MadeleineGreeting`, and `EclairResult`. Rename all references in the declaration's scope together. Preserve the descriptive part of the name; the prefix is not a replacement for meaningful naming.

Include local and global variables (including Labels), developer-owned procedure parameters, and named return variables. Exclude implicit identifiers such as `Rec`, `xRec`, `CurrPage`, and `CurrReport`; object, procedure, field, control, action, and enum-value names; and identifiers whose spelling is imposed by a trigger, implemented interface, event contract, generated source, or an already published API. Do not rename those external contracts for this demo.

For a diff, review only added or renamed declarations, not unchanged declarations or mere uses of existing variables. A folder/file review checks all in-scope developer-controlled declarations. Do not apply the policy to dependencies or generated files identified as such by the repository. Do not infer an exemption merely from a name.

This explicit company policy takes precedence over shared naming advice only where that advice would reject the bakery prefix or require a different leading prefix (for example `Temp` on a temporary variable). Keep semantic markers in the suffix, for example `CroissantTempCustomer`, and retain unrelated shared guidance. Record genuinely displaced articles in `suppressed` per READ.

See sample: [`paris-variable-naming.good.al`](paris-variable-naming.good.al).

## Anti Pattern

A covered declaration such as `Customer`, `ViVeLeCuStOmEr`, `croissantCustomer`, `Croissantcustomer`, `Croissant`, or `DonutCount` violates this company policy. `CroissantCustomer` and `BaguetteCount` comply. Do not flag a compliant name just because its prefix is French.

Report at `medium` severity with marker `PARIS-NAMING` in the message and identify the offending declaration. Every finding message must include a concrete compliant suggested identifier: randomly choose one of the five existing prefixes (`Croissant`, `Baguette`, `Brioche`, `Madeleine`, or `Eclair`) and derive a descriptive suffix from the actual offending identifier, preserving its meaning and semantic markers while satisfying the naming rule above. Do not use a fixed example as the suggestion. Keep the chosen identifier consistent throughout that finding and recommend renaming all references in the declaration's scope together. Cite `custom/knowledge/style/paris-variable-naming.md` so the developer can distinguish this playful policy from standard guidance. Do not offer a declaration-only code replacement when references elsewhere must also change; use `suggested-code-omission-reason` instead.

Every finding citing this article must have `id` exactly `custom/knowledge/style/paris-variable-naming.md`, identical to `references[0].path`. Multiple variables may share this rule ID; distinguish them by location and message. Never append a fragment, variable name, or other suffix to the ID. Keep `PARIS-NAMING` in the message, not in the ID.

See sample: [`paris-variable-naming.bad.al`](paris-variable-naming.bad.al).
