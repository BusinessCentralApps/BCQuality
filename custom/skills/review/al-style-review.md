---
kind: action-skill
id: al-style-review
version: 1
title: AL style review with Paris company policies
description: Reviews AL source changes for style, naming, and folder structure, including the Paris company's custom policies.
inputs: [pr-diff, file-path, folder-path]
outputs: [findings-report]
bc-version: [all]
technologies: [al]
countries: [w1]
application-area: [all]
---

# AL style review with Paris company policies

This Custom-layer leaf replaces the `al-style-review` slot by the existing
skill-ID precedence mechanism. It retains the standard style review and adds
explicit discovery cues for this fork's company policies. It invokes no
sub-skills and produces one report.

## Source

Read `microsoft/skills/review/al-style-review.md` in full as the baseline
instructions for this pass, not as a second invocation. Follow its Source
step and READ's bounded retrieval across every enabled `style` layer.
If the baseline is unavailable, return `failed`, not a policy-only review.
Do not change enabled layers, bypass pruning, or rebuild an index in this leaf.

## Relevance

Apply the baseline Relevance step unchanged. The additions below apply only
to applicable articles present in the live catalog or READ's native path
discovery fallback. A missing or excluded article cannot seed a finding.

## Worklist

Retain the baseline Worklist, including all its high-signal mappings. Before
fuzzy ranking, add these explicit candidates when their source signals exist:

- An AL object declaration and its source path, including an added file,
  rename destination, or object-type change: select
  `custom/knowledge/style/paris-object-type-folders.md`.
- A variable declaration in a local/global `var` block, a procedure parameter,
  or a named return variable: select
  `custom/knowledge/style/paris-variable-naming.md`.

For file/folder inputs, use all declarations in the supplied scope; for diffs,
retain destination paths and declaration changes, not just text tokens.
These cues select articles, not violations. Read their full normative bodies
before deciding scope, exclusions, compliance, severity, or conflict resolution.
Keep both policy candidates even when many other style articles match; do not
allow a fuzzy top-k cutoff to discard an explicitly selected candidate.
Resolve actual conflicts by READ and retain unrelated baseline candidates.

## Action

Execute the baseline Action step over the combined, post-conflict worklist
exactly once. Apply explicit company policies as knowledge-backed guidance,
not uncited general style preferences. The articles own the rules and their
exceptions; do not infer requirements from the dispatch cues.
Use the baseline outcomes and DO acceptance gate, and never claim completion
when retrieval or evaluation was incomplete.

## Output

Use the baseline Output and DO findings-report contract unchanged:
`skill.id` is `al-style-review`, `skill.version` is `1`, and each finding has
`domain: "Style"`. Copy article IDs and references from discovered exact paths.
Keep conflict suppressions in the same single report.
