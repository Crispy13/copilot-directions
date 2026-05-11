---
name: rubberduck-review
description: "Use when: you want a second opinion, want to rubber duck a plan or implementation, want to critique my work, want a review before I run something, need a post-implementation check, need a post-tests pre-run check, feel stuck or looping, or want an on-demand cross-family critique. Trigger for plan, implementation, tests, and stuck checkpoints, plus explicit on-demand review requests. Do not invoke this skill from inside an active rubberduck-review run; once this skill is loaded, dispatch directly to G-Claude or G-GPT instead of calling rubberduck-review again."
# context: fork
---

# Rubberduck Review

## Execution Boundary

Only the outer caller invokes this skill. Once this `SKILL.md` is loaded, you are already inside `rubberduck-review`; do not invoke `rubberduck-review` again, even if the task still sounds like a second-opinion trigger. Select the opposite-family reviewer agent and call `runSubagent` directly using the matching prompt below.

Prompts sent to `G-Claude` or `G-GPT` should not ask those agents to invoke this skill. They are reviewers only: read the artifacts, apply the scan list, and return the verdict format.

## Why This Exists

Confident mistakes compound. A second opinion from a different model family catches blind spots the primary caller can miss, especially when the work already looks plausible. This skill exists to get that short cross-family critique before you commit to a direction, ship an implementation, trust a test slice, or keep grinding in a loop.

## When To Trigger

Use this skill at these checkpoints and on demand:

- `plan`: lightweight ad-hoc critique of a plan or draft approach
- `implementation`: post-implementation review before considering the slice done
- `tests`: post-tests, pre-run or pre-ship review of the test strategy and assertions
- `stuck`: when progress is looping and you need a different angle
- on-demand: any explicit request for a second opinion, rubber duck, critique, or focused review


## Cross-Family Agent Selection

Dispatch the opposite family from the current caller:

- Claude-family caller -> `G-GPT`
- GPT-family caller -> `G-Claude`
- Other family or unknown -> default to `G-GPT`

## Invocation Pattern

`G-Claude` and `G-GPT` are thin model-only agents — they carry no reviewer role. Every prompt sent to them must therefore be **self-contained**: it must establish the reviewer role, name the mode, point at the artifacts, list what to scan for, and fix the output format. The per-checkpoint sections below provide ready-to-use prompts. Copy the matching one and fill in `<...>` placeholders.

All prompts follow this shape:

1. Reviewer-role framing (one sentence).
2. `Mode:` line.
3. `Artifacts:` block — paths the agent must read in full before responding.
4. `Scan for:` block — checkpoint-specific concerns.
5. `Expected output:` block — verdict line + 3-7 concrete concern bullets, no restatement of the artifact.

## Per-Checkpoint Guidance

### Plan

```javascript
runSubagent({
  agentName,
  prompt: `
You are a cross-family second-opinion reviewer. You are not the author. Read the artifact in full, then surface concrete concerns the author may have missed. Do not restate or rewrite the artifact.

Important: You are already inside rubberduck-review; do not invoke rubberduck-review again. 

Mode: plan

Artifacts:
- <plan-path>

Scan for:
- missed assumptions
- ambiguous steps
- unscoped edge cases
- ordering or dependency errors
- architectural blind spots

Expected output (exact format):
- First line: "VERDICT: CONCERNS" or "VERDICT: NO_CONCERNS"
- Then 3-7 short bullets, each a concrete concern (missed details, questionable assumptions, edge cases)
- After the concerns, a "Suggested mitigations:" block with one short bullet per concern (in the same order)
- Include file/line references where applicable
- No preamble, no summary of the plan, no rewritten plan
`
})
```

### Implementation

Include the changed-files list and the subplan path when available.

```javascript
runSubagent({
  agentName,
  prompt: `
You are a cross-family second-opinion reviewer. You are not the author. Read every changed file and the subplan in full, then surface concrete concerns the author may have missed. Do not restate or rewrite the code.

Important: You are already inside rubberduck-review; do not invoke rubberduck-review again. 

Mode: implementation

Artifacts:
- <changed-file-paths>
- <subplan-path>

Scan for:
- cross-file conflicts
- silent breakage of existing callers
- missed edge cases
- error-handling gaps
- security or regression risk versus the subplan

Expected output (exact format):
- First line: "VERDICT: CONCERNS" or "VERDICT: NO_CONCERNS"
- Then 3-7 short bullets, each a concrete concern (missed details, questionable assumptions, edge cases)
- After the concerns, a "Suggested mitigations:" block with one short bullet per concern (in the same order)
- Include file/line references where applicable
- No preamble, no diff summary, no rewritten code
`
})
```

### Tests

Include the test paths and the relevant acceptance criteria.

```javascript
runSubagent({
  agentName,
  prompt: `
You are a cross-family second-opinion reviewer. You are not the author. Read every test file and the acceptance criteria in full, then surface concrete concerns about the test strategy and assertions. Do not restate or rewrite the tests.

Important: You are already inside rubberduck-review; do not invoke rubberduck-review again. 

Mode: tests

Artifacts:
- <test-paths>
- <acceptance-criteria-path-or-summary>

Scan for:
- coverage gaps versus acceptance criteria
- flawed or tautological assertions
- missing failure-mode tests
- brittle fixtures

Expected output (exact format):
- First line: "VERDICT: CONCERNS" or "VERDICT: NO_CONCERNS"
- Then 3-7 short bullets, each a concrete concern (coverage gaps, flawed assertions, missing failure modes)
- After the concerns, a "Suggested mitigations:" block with one short bullet per concern (in the same order)
- Include file/line references where applicable
- No preamble, no test summary, no rewritten tests
`
})
```

### Stuck

Include a short stuck-state brief that says what was tried and what is failing.

```javascript
runSubagent({
  agentName,
  prompt: `
You are a cross-family second-opinion reviewer. You are not the author. Read the stuck-state brief and any referenced artifacts in full, then surface concrete alternatives and missed angles. Do not restate the brief.

Important: You are already inside rubberduck-review; do not invoke rubberduck-review again. 

Mode: stuck

Artifacts:
- <short stuck-state brief, inline or path>

Scan for:
- alternative approaches
- missed angles
- wrong abstraction
- environment or setup causes
- when to escalate versus retry

Expected output (exact format):
- First line: "VERDICT: CONCERNS" or "VERDICT: NO_CONCERNS"
- Then 3-7 short bullets, each a concrete concern or alternative
- After the concerns, a "Suggested mitigations:" block with one short bullet per concern (in the same order)
- Include file/line references where applicable
- No preamble, no restatement of the brief
`
})
```

## Incorporating Feedback

Read the verdict and concerns, decide which ones to act on, and then briefly tell the user what changed or what you chose not to change. Keep that summary tied to the concrete concerns rather than rehashing the whole artifact.

## What NOT To Do

- Do not use this skill as a replacement for `CodeReviewer`; `CodeReviewer` checks implementation compliance against the subplan.
- Do not loop indefinitely; run one review round per checkpoint unless genuinely new information appears.
- Do not use this skill for trivial tasks where a second-opinion pass adds no value.