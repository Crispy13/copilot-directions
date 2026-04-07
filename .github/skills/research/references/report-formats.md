# Report Formats

Choose the format that matches your query type classification. Every format includes a Confidence Assessment — this section is mandatory.

## Technical Deep-Dive

```markdown
# Research: {Topic}

**Date:** {Date}
**Query Type:** Technical Deep-Dive

## Overview
{What this system/component does and why it matters — 2-3 sentences}

## Architecture
{Component breakdown, how pieces fit together, data flow}
{Use diagrams (Mermaid, ASCII) when the architecture has 3+ interacting components}

## Implementation Details
{Key code paths, important files, notable patterns}
- `path/to/file.ext:L42` — {what this does and why it matters}
- `path/to/other.ext:L15-L30` — {key implementation detail}

## Dependencies and Constraints
{What this system relies on, what constrains future changes}

## Confidence Assessment
- **High confidence:** {claims well-supported by direct evidence}
- **Medium confidence:** {reasonable inferences from limited evidence}
- **Assumptions made:** {what was assumed when evidence was insufficient, and why}

## Open Questions
- {What remains unknown or warrants further investigation}
```

## Comparison

```markdown
# Research: {Topic}

**Date:** {Date}
**Query Type:** Comparison

## Context
{What we're choosing between, why the decision matters now, what happens if we choose wrong}

## Evaluation Criteria
1. {Criterion — why it matters for this specific decision}
2. {Criterion — why it matters}

## Options

### Option A: {Name}
{Description, how it works, maturity/stability}
- **Strengths:** {evaluated against the criteria above}
- **Weaknesses:** {evaluated against the criteria above}
- **Evidence:** {concrete sources — docs, benchmarks, code, community signals}

### Option B: {Name}
{Same structure — keep options parallel so the reader can compare}

## Tradeoff Summary
| Criterion | Option A | Option B |
|---|---|---|
| {Criterion 1} | {Assessment} | {Assessment} |

## Recommendation
{Which option, why it wins given the specific context, and what would flip the recommendation}

## Confidence Assessment
{Same structure as Technical Deep-Dive}
```

## Process / How-To

```markdown
# Research: {Topic}

**Date:** {Date}
**Query Type:** Process / How-To

## Goal
{What the reader will be able to do after following this}

## Prerequisites
- {What's needed before starting — tools, access, knowledge}

## Steps
1. {Step — with file paths, commands, or code references}
2. {Step — explain the why when the step isn't obvious}

## Verification
{How to confirm the process worked — expected output, test to run, state to check}

## Common Pitfalls
- {What goes wrong and how to avoid it}

## Related Resources
- `path/to/relevant/file.ext` — {why it's relevant}
- {Link to documentation}

## Confidence Assessment
{Same structure as Technical Deep-Dive}
```

## Conceptual

```markdown
# Research: {Topic}

**Date:** {Date}
**Query Type:** Conceptual

## Summary
{Core explanation in plain terms — 2-3 sentences that a non-expert could follow}

## Background
{Why this concept exists, what problem it solves, historical context if relevant}

## Detailed Explanation
{Build up from fundamentals to nuance — don't assume prior knowledge}
{Use examples and analogies to make abstract concepts concrete}
{Include diagrams or structured breakdowns where they clarify relationships}

## In Practice
{How this concept manifests in the actual codebase or real-world usage}
- `path/to/example.ext` — {how this file demonstrates the concept}
{Common patterns, idioms, or conventions related to this concept}

## Related Concepts
- {Related concept} — {how it connects, how it differs, when to use which}
- {Related concept} — {relationship}

## Common Misconceptions
- {Misconception} — {why it's wrong and what's actually true}

## Key Takeaways
1. {Takeaway — actionable understanding the reader can apply}
2. {Takeaway}
3. {Takeaway}

## Confidence Assessment
{Same structure as Technical Deep-Dive}
```

## Report Quality Checklist

Before finalizing any report, verify:

- [ ] Every factual claim cites a source (file path, URL, or observed behavior)
- [ ] Confidence Assessment is present and honest — not just "high confidence" for everything
- [ ] Open Questions captures genuine unknowns, not just filler
- [ ] The report is self-contained — a reader without conversation context can follow it
- [ ] Report length matches question complexity — a focused question gets a focused report, not padding
