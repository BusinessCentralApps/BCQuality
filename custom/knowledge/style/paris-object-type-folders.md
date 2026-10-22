---
bc-version: [all]
domain: style
keywords: [folder-structure, source-layout, path, table, codeunit, page, object-type, paris]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Paris Demo Policy: Put AL Objects in Paris Landmark Folders

## Description

This Paris demo company policy places covered AL source files in Paris landmark folders, regardless of their declared object type. It applies to source paths, not object names or filenames. This is an explicit repository convention, not an AL compiler, runtime, or Microsoft requirement.

## Best Practice

Use any one of these exact, case-sensitive immediate parent folder names: `Louvre`, `TourEiffel`, `ArcDeTriomphe`, `NotreDame`, or `SacreCoeur`. Every covered object type may use any of the five folders; there is no type-to-landmark mapping.

Covered AL declarations are `table`, `tableextension`, `page`, `pageextension`, `pagecustomization`, `codeunit`, `report`, `reportextension`, `query`, `xmlport`, `enum`, `enumextension`, `interface`, `permissionset`, `permissionsetextension`, `profile`, `profileextension`, and `controladdin`. Determine type from the declaration, never from a filename suffix, referenced type, subtype, or namespace.

Any app, source, feature, or test folders may precede the landmark folder. Both `src/Louvre/Customer.Table.al` and `Apps/Sales/src/Orders/TourEiffel/Customer.Table.al` comply. Test and install codeunits and API pages may also use any of the five landmark folders. Normalize slash direction before comparing path segments; do not ignore case. Do not require a particular source root or file naming scheme.

For a diff, check only added files, rename destinations (including path-only renames), and files whose object type changes. Do not request moves of unchanged files merely because their bodies were edited. For a folder/file review, check all in-scope authored AL objects. Use the real target repository-relative path supplied by the host, not a temporary download or evaluation path. If that path is unavailable, do not invent it or emit a folder finding.

Exclude dependencies, generated files identified by repository metadata, and knowledge-documentation sample companions; they are not the app's authored source. An unsupported or unrecognized declaration has no inferred folder requirement. When a file declares several covered object types, evaluate each declaration against the same five allowed folders; this policy does not require splitting the file by object type. Keep any destination suggestions for that file consistent. Respect the host's review scope.

This policy deliberately requires an immediate landmark folder even where older files used a feature-only or type-folder layout. It supersedes contradictory recommendations in `microsoft/knowledge/style/source-organized-by-feature-not-object-type.md` for the scoped files; record that article in `suppressed` only when its guidance actually conflicts. Retain all unrelated shared rules. Do not demand broad migration of legacy files outside the review scope.

## Anti Pattern

A covered object in `src/Customer.Table.al`, `src/Tables/Customer.Table.al`, `src/louvre/Customer.Table.al`, or `src/Louvre/Archive/Customer.Table.al` violates this convention: the immediate parent is not exactly one of the five allowed landmark names. Do not flag a file whose immediate parent is any of the five allowed names, regardless of its covered object type.

Report at `medium` severity with marker `PARIS-FOLDERS` in the message and state the declared type and actual path. For each violation, randomly choose one of `Louvre`, `TourEiffel`, `ArcDeTriomphe`, `NotreDame`, or `SacreCoeur` and include a concrete destination path for the actual file in the finding message. Preserve the enclosing app/source/feature path, filename, and object identity, inserting or replacing only the object-grouping folder as appropriate so the chosen landmark is the immediate parent. Do not use a fixed example as the suggestion; keep the chosen destination consistent throughout the finding. Cite `custom/knowledge/style/paris-object-type-folders.md` with that exact path as both `id` and `references[0].path`. Never append fragments to the ID. Locate the finding on the in-scope object declaration; for a path-only rename with no changed content lines, follow the host's file-level finding support rather than inventing a changed line.

A file move is not a line replacement. Omit `suggested-code` and explain the required move in `suggested-code-omission-reason`. Do not emit information-only findings on compliant files merely to show the policy was loaded.
