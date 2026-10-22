---
bc-version: [all]
domain: style
keywords: [folder-structure, source-layout, path, table, codeunit, page, object-type, paris]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Paris Demo Policy: Put AL Objects in Their Type Folders

## Description

This Paris demo company policy organizes AL source files by their declared object type: tables belong under Tables and codeunits under Codeunits. It applies to source paths, not object names or filenames. This is an explicit repository convention, not an AL compiler, runtime, or Microsoft requirement.

## Best Practice

Use the following exact, case-sensitive immediate parent folder for each declared AL object type. Determine type from the declaration, never from a filename suffix, referenced type, subtype, or namespace.

| AL declaration | Immediate parent folder |
| --- | --- |
| `table` | `Tables` |
| `tableextension` | `TableExtensions` |
| `page` | `Pages` |
| `pageextension` | `PageExtensions` |
| `pagecustomization` | `PageCustomizations` |
| `codeunit` | `Codeunits` |
| `report` | `Reports` |
| `reportextension` | `ReportExtensions` |
| `query` | `Queries` |
| `xmlport` | `XmlPorts` |
| `enum` | `Enums` |
| `enumextension` | `EnumExtensions` |
| `interface` | `Interfaces` |
| `permissionset` | `PermissionSets` |
| `permissionsetextension` | `PermissionSetExtensions` |
| `profile` | `Profiles` |
| `profileextension` | `ProfileExtensions` |
| `controladdin` | `ControlAddIns` |

Any app, source, feature, or test folders may precede the type folder. Both `src/Tables/Customer.Table.al` and `Apps/Sales/src/Orders/Tables/Customer.Table.al` comply. A test or install codeunit still belongs in `Codeunits`. API pages still belong in `Pages`. Normalize slash direction before comparing path segments; do not ignore case. Do not require a particular source root or file naming scheme.

For a diff, check only added files, rename destinations (including path-only renames), and files whose object type changes. Do not request moves of unchanged files merely because their bodies were edited. For a folder/file review, check all in-scope authored AL objects. Use the real target repository-relative path supplied by the host, not a temporary download or evaluation path. If that path is unavailable, do not invent it or emit a folder finding.

Exclude dependencies, generated files identified by repository metadata, and knowledge-documentation sample companions; they are not the app's authored source. An unsupported or unrecognized declaration has no inferred mapping. When a file declares several mapped object types, evaluate each declaration; different required folders call for splitting the file, not a misleading single move. Respect the host's review scope.

This policy deliberately chooses type folders even where older files used a feature-only layout. It supersedes contradictory recommendations in `microsoft/knowledge/style/source-organized-by-feature-not-object-type.md` for the scoped files; record that article in `suppressed` only when its guidance actually conflicts. Retain all unrelated shared rules. Do not demand broad migration of legacy files outside the review scope.

## Anti Pattern

A table in `src/Customer.Table.al`, `src/Codeunits/Customer.Table.al`, `src/tables/Customer.Table.al`, or `src/Tables/Archive/Customer.Table.al` violates this convention: the immediate parent is not exactly `Tables`. A codeunit in `src/Tables/Worker.Codeunit.al` belongs in a `Codeunits` folder. A tableextension under `Tables` belongs in `TableExtensions`.

Report at `medium` severity with marker `PARIS-FOLDERS` in the message, state the declared type, actual path, and required parent folder, and recommend a concrete destination without renaming the object. Cite `custom/knowledge/style/paris-object-type-folders.md` with that exact path as both `id` and `references[0].path`. Never append fragments to the ID. Locate the finding on the in-scope object declaration; for a path-only rename with no changed content lines, follow the host's file-level finding support rather than inventing a changed line.

A file move is not a line replacement. Omit `suggested-code` and explain the required move or split in `suggested-code-omission-reason`. Do not emit information-only findings on compliant files merely to show the policy was loaded.
