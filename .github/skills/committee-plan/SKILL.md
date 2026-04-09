---
name: committee-plan
description: >-
  Plan with committee: use this when the main deliverable is an actionable execution
  plan and you want 4 AI model subagents (Opus, Sonnet, Gemini, GPT) to draft in
  parallel, consolidate consensus vs. contested steps, and iterate through structured
  discussion rounds (max 3) before producing one final plan. Best for multi-step
  implementation planning, sequencing tradeoffs, or scoping work under uncertainty.
  Not for general deliberation, architecture review without a planning deliverable,
  root-cause analysis, or broad comparison work; use committee for those.
argument-hint: "Describe the topic or problem to plan for"
---

# Committee Planning

Orchestrate a multi-model planning committee using the Structured Delphi Method. Four AI models independently draft plans, then iterate toward consensus through structured discussion rounds.

Use this skill when the real question is "what should we do, in what order, and how will we verify it" rather than "what do we think about this topic." The planning frame matters because members should optimize for sequence, dependencies, verification, and execution risk instead of broad deliberation.

## Committee Members

| Agent | Model |
|-------|-------|
| `CommitteeOpus` | Claude Opus 4.6 |
| `CommitteeSonnet` | Claude Sonnet 4.6 |
| `CommitteeGemini` | Gemini 3.1 Pro |
| `CommitteeGPT` | GPT 5.4 |

## When To Use This Skill

Reach for `committee-plan` when the outcome should be a plan someone can execute with minimal translation.

- The user wants implementation sequencing, dependency ordering, or phase breakdowns.
- The work has multiple plausible execution paths and the hard part is choosing the plan shape.
- Verification strategy matters enough that it should be debated up front instead of bolted on later.
- Scope boundaries, assumptions, or rollout order need several independent perspectives.

Use the general `committee` skill instead when the main need is analysis rather than a plan.

- Architecture review without a request for an execution plan.
- Root-cause analysis, bug triage, or investigative synthesis.
- Comparative evaluation of tools, vendors, or design options where the deliverable is a judgment call rather than a step-by-step plan.
- Broad debate or second-opinion reasoning that might end in several viable options instead of one execution path.

## Fixed Output Format

`committee-plan` has one fixed output format: `Plan`. Keeping the format fixed helps members converge on the same decision surface early, so the Chief can compare sequence, verification, risks, and assumptions directly rather than normalizing several incompatible structures later.

Use this format for every member draft and for the final plan:

```markdown
## Plan: {Title (2-10 words)}

{TL;DR - what, why, and how (your recommended approach).}

**Steps**
1. {Implementation step-by-step — note dependency ("depends on N") or parallelism ("parallel with step N") when applicable}
2. {For plans with 5+ steps, group steps into named phases with enough detail to be independently actionable}

**Relevant files**
- `{full/path/to/file}` — {what to modify or reuse, referencing specific functions/patterns}

**Verification**
1. {Verification steps for validating the implementation (Specific tasks, tests, commands — not generic statements)}

**Decisions** (if applicable)
- {Decision, assumptions, and includes/excluded scope}

**Further Considerations** (if applicable, 1-3 items)
1. {Clarifying question with recommendation. Option A / Option B / Option C}
```

### Format Guidance

- `TL;DR`: State the plan recommendation plainly. Name the intended outcome, the reason this path wins, and any major assumption the plan depends on.
- `Steps`: Sequence work so a reader can execute it without reverse-engineering dependencies. If a step can run in parallel or depends on a prior step, say so explicitly.
- `Relevant files`: Ground the plan in real code locations, interfaces, commands, or documents. Planning gets much sharper when it points to actual reuse and actual change surfaces.
- `Verification`: Treat verification as part of the plan, not a closing ritual. Specific checks expose whether the plan is operational or still hand-wavy.
- `Decisions`: Capture scope boundaries, assumptions, or notable tradeoffs that explain why the plan looks the way it does.
- `Further Considerations`: Keep this section small and useful. It should surface real forks, not defer obvious thinking.

## Planning Quality Lens

Use this lens when judging whether a draft is worth carrying forward. Strong planning drafts do not just sound sensible; they make execution easier.

- **Actionability:** A competent implementer should be able to start from the plan without first rewriting it into a task list.
- **Dependency clarity:** Steps should reveal ordering constraints, parallelism, and prerequisite work instead of forcing the Chief to infer them later.
- **Verification fidelity:** A plan is stronger when it names the checks that prove success and the checks that would reveal failure early.
- **Scope discipline:** Good drafts state what is in scope, what is intentionally excluded, and what assumption would force the plan to change.
- **Risk visibility:** Plans should surface migration risk, rollout risk, or information gaps where they matter, not hide them in optimistic wording.
- **Codebase grounding:** The best drafts point to real files, commands, symbols, or patterns rather than planning in an abstract vacuum.

### Common Planning Failure Modes

Watch for these failure modes during drafting, consolidation, and final synthesis:

- A plan that lists tasks but never explains why this sequence is the right one.
- A plan that names files but does not connect them to the actual change or verification surface.
- A plan that postpones every hard decision into `Further Considerations`, which usually means the core plan is underspecified.
- A plan that sounds complete but has no explicit success checks, making execution impossible to evaluate.
- A plan that proposes parallel work without acknowledging hidden dependencies or coordination cost.
- A plan that merges incompatible rationales into one "consensus" step and loses the condition under which each version works.

## Chief Synthesis Lens

When consolidating or resolving rounds, prefer the plan shape that best balances execution clarity with realism.

- Favor steps that reduce uncertainty earlier when the cost of early validation is low.
- Favor reuse of proven patterns when it meaningfully lowers delivery or correctness risk.
- Favor explicit tradeoffs over vague compromise language. If two member plans disagree for a real reason, preserve the reason until it is resolved.
- Favor concrete verification over rhetorical confidence. A weaker-looking plan with crisp checks is often better than a smoother plan with none.
- Favor small, composable phases when the work can be staged safely; favor broader grouped phases only when fragmentation would hide the actual workflow.
- Favor the clearest explanation of assumptions and stop conditions when the user may need to approve scope or sequencing.

### Escalation Heuristic

Escalate to the user when the remaining disagreement is genuinely about preference, product direction, or risk appetite rather than reasoning quality. Do not escalate just because the committee surfaced a hard tradeoff; escalate when the tradeoff depends on a choice only the user can legitimately make.

When escalating, present:

- the exact decision that needs input,
- the best-supported option on each side,
- what changes in the plan if the user chooses either path,
- and whether the rest of the plan can proceed while that decision remains open.

Keep escalation short and decision-ready. The goal is to let the user unblock the plan quickly, not to hand them the entire committee transcript.

## Procedure

### Phase 1: Parallel Drafting

Dispatch all 4 members in parallel with the same planning brief. Independent drafting matters because it produces genuinely different plan shapes before the committee starts converging, which makes hidden assumptions, sequencing disagreements, and verification gaps much easier to spot early.

Each member independently:
- Researches the codebase via Explore subagent
- Drafts a structured plan
- Self-reviews and iterates before submitting

**Dispatch prompt for each member:**

```
You are drafting a plan as a committee member. Your task:

{user's planning topic/problem — paste the full brief}

Write your plan to: /memories/session/committee/draft-{member-name}.md

Load the `committee-member` skill and follow Mode 1 (Drafting). If the skill cannot be loaded, report the failure and stop. Research the codebase thoroughly before drafting.

Use the fixed `Plan` output format exactly as defined in the `Fixed Output Format` section above.

Quality bar:
- Ground the steps in concrete evidence such as files, functions, existing patterns, observed constraints, or user-provided requirements.
- Make verification specific enough that someone could tell whether the plan worked or failed.
- State assumptions, dependencies, and rollout risks instead of smoothing them over.
- Prefer plans that are executable and reviewable, not just plausible at a high level.

Rules: NO code blocks — describe changes, link to files and specific symbols/functions. Do NOT read other members' draft files (`draft-*.md`) — research independently using only the codebase and user requirements.
```

Replace `{member-name}` with: `opus`, `sonnet`, `gemini`, `gpt`.

After all 4 drafts are saved, proceed to Phase 2.

#### Quality Check

Before moving to Phase 2, verify that:

- All expected draft files exist, or any missing file is explicitly recorded.
- Each available draft uses the fixed `Plan` headings and reaches a real recommendation rather than stopping at options.
- Steps, relevant files, and verification are substantive enough to compare across members.
- If one draft is mechanically thin or incomplete, give it one targeted retry when that is cheaper than carrying avoidable ambiguity into consolidation.

#### Degraded Mode

Continue with 3 available members when the topic still has enough coverage to synthesize responsibly. Mark confidence as reduced, record the missing or failed member in the provenance trail, and escalate to the user only when the missing draft materially blocks the plan.

#### Progress Update

Use this template after Phase 1 completes:

```markdown
Phase 1 complete. Drafts received: {N}/4. Confidence: {normal|reduced}.
Main plan themes: {1-2 sentence summary}. Gaps or failures: {missing member, thin draft, or none}.
Next: consolidate consensus steps, contested choices, and unique contributions into one plan frame.
```

### Phase 2: Chief Consolidation

You (the Chief) read the available draft files and produce a single consolidated document. Do not use automated diffing; manual synthesis matters here because planning quality depends on preserving why a sequence works, not merely spotting overlapping wording.

Read the [consolidation format reference](./references/consolidation-format.md) for the exact template.

**Process:**
1. Read all available drafts from `/memories/session/committee/draft-*.md`.
2. Cluster equivalent claims before writing anything. Preserve the clearest phrasing, merge only when the underlying rationale is materially compatible, and carry meaningful nuance forward instead of averaging it away.
3. Identify points where members agree (consensus) and disagree (contested).
4. Note unique contributions — valuable ideas raised by only one member.
5. Count agreement levels: FULL (4/4), STRONG (3/4), SPLIT (2/2), MINORITY (1/4), or the equivalent ratios under degraded mode.
6. Write the consolidated plan to `/memories/session/committee/consolidated-plan.md`.

Consensus points stay closed by default. Reopen a settled point only when new evidence, a sharper synthesis, or a newly surfaced dependency materially changes the decision surface, then log why it was reopened.

**If all points are consensus (no contested points):** Skip to Phase 4 immediately.

#### Quality Check

Before moving to Phase 3 or Phase 4, verify that:

- No material draft content was silently dropped. Each important idea appears in `Consensus Points`, `Contested Points`, `Unique Contributions`, or a brief discard note with rationale.
- Consensus summaries preserve the reasoning chain, not just the resulting step list.
- Contested points use specific resolution questions instead of generic requests for more discussion.
- Any reopened consensus point is logged with the trigger for reopening.

#### Progress Update

Use this template after Phase 2 completes:

```markdown
Phase 2 complete. Consensus points: {N}. Contested points: {N}. Unique contributions: {N}. Confidence: {normal|reduced}.
Most important consensus: {1 sentence}. Main contested question: {1 sentence or none}.
Next: discussion rounds for contested points only, unless everything is already settled.
```

### Phase 3: Discussion Rounds (Max 3)

For each round, dispatch all 4 members in parallel to respond to contested points only.

**Dispatch prompt for each member:**

```
You are participating in discussion round {N} of the committee plan.

Read the consolidated plan: /memories/session/committee/consolidated-plan.md

Load the `committee-member` skill and follow Mode 2 (Discussion). If the skill cannot be loaded, report the failure and stop. Respond to ONLY the contested points and unique contributions.

Quality bar:
- Accept, counter, or propose with concrete reasoning instead of preference language.
- Cite the evidence, dependency, or constraint that changed your position, if any.
- Keep focus on the current resolution question; do not rewrite settled areas unless new evidence materially changes them.

Rules: NO code blocks. Do NOT read other members' round response files (`round-*.md`) — read ONLY the consolidated plan above.

Write your response to: /memories/session/committee/round-{N}-{member-name}.md
```

After collecting all 4 responses:

#### Convergence Check

For each contested point, evaluate the 4 responses:

| Result | Condition | Action |
|--------|-----------|--------|
| **Resolved** | 3/4 or 4/4 now agree on a position | Move to consensus |
| **Narrowed** | Positions reduced but no supermajority | Update framing, carry to next round |
| **Deadlocked** | Same positions, no movement | Apply resolution strategy |

#### Deadlock Resolution (tiered)

1. **Supermajority:** If 3/4 agree, that position wins.
2. **Chief decides:** Pick the position with strongest reasoning, cite why.
3. **Escalate to user:** Present both positions with arguments, ask the user to decide.

Use deadlock resolution sparingly. The point is to stop circular debate once the committee has surfaced the real tradeoff, not to manufacture agreement where none exists.

#### Round Update

Update `/memories/session/committee/consolidated-plan.md` with:
- Newly resolved points moved to consensus
- Updated framing for remaining contested points
- Resolution notes for deadlocked points
- Reopening notes for any consensus point that had to be revisited

**Early exit:** If all contested points are resolved, skip remaining rounds and go to Phase 4.

#### Quality Check

Before starting another round, verify that each unresolved point has become sharper, not just longer. If a point is no longer moving and the committee has already surfaced the real tradeoff, resolve it with the deadlock policy instead of forcing extra churn.

#### Progress Update

Use this template after each discussion round:

```markdown
Discussion round {N} complete. Resolved this round: {N}. Still contested: {N}. Confidence: {normal|reduced}.
Movement: {1-2 sentence summary of what changed}. Deadlocks or reopenings: {summary or none}.
Next: {another round | final plan | user escalation}.
```

### Phase 4: Final Plan

Produce the final plan as a markdown file in the workspace.

Read the [final plan format reference](./references/final-plan-format.md) for the exact template.

**Process:**
1. Write the final plan incorporating all resolved consensus.
2. Keep the main `Plan` section unchanged in structure: `TL;DR`, `Steps`, `Relevant files`, `Verification`, `Decisions`, and `Further Considerations` stay as the delivery surface.
3. Include minority wisdom when a non-winning position surfaced a real risk, dependency, or caveat that should still influence execution.
4. Include a provenance section showing how agreement was reached.
5. Include degraded-mode provenance when any member was missing or failed, including the resulting confidence reduction.
6. Include a discussion summary log.
7. Save to: `{user-specified path or workspace root}/committee-plan-{topic}.md`
8. Present the plan to the user in chat.

#### Quality Check

Before presenting the final plan, verify that a reader could execute the main `Plan` section without reading the provenance or discussion log. If the plan only makes sense when paired with process notes, the synthesis is still too thin.

Also verify that:

- `Steps` still reflect the winning rationale instead of a stitched compromise that no longer has a coherent order.
- `Verification` covers the main success claims from the chosen path.
- `Decisions` and `Further Considerations` carry only the remaining judgment calls, not work that should have stayed in the core steps.
- Minority wisdom is included only when it changes execution awareness, risk handling, or user choice.

#### Progress Update

Use this template after Phase 4 completes:

```markdown
Committee planning complete. Final plan saved to: {path}. Rounds used: {N}. Confidence: {normal|reduced}.
Outcome: {1-2 sentence summary}. Minority wisdom included: {yes|no}.
```

## Runtime File Layout

```
/memories/session/committee/
  draft-opus.md              # Phase 1
  draft-sonnet.md            # Phase 1
  draft-gemini.md            # Phase 1
  draft-gpt.md               # Phase 1
  consolidated-plan.md       # Phase 2 (updated in Phase 3)
  round-1-opus.md            # Phase 3, Round 1
  round-1-sonnet.md          # ...
  round-1-gemini.md          # ...
  round-1-gpt.md             # ...
  round-2-*.md               # Phase 3, Round 2 (if needed)
  round-3-*.md               # Phase 3, Round 3 (if needed)
```

## Rules

- The Chief (you, the agent running this skill) does all consolidation and convergence checking. Keeping synthesis centralized preserves one reasoning trail instead of several overlapping ones.
- Members never communicate with the user. Only the Chief talks to the user, which keeps the process legible and prevents four parallel conversations from drifting apart.
- Members never communicate with each other. All interaction flows through the Chief via files so agreement levels, reopenings, and contested points stay auditable.
- Members should not edit code files or run implementation commands. Planning stays cleaner when members focus on reasoning, scope, and sequencing instead of drifting into execution.
- Use the fixed `Plan` format consistently. Structured outputs make convergence tracking, evidence comparison, and final synthesis much easier.
- Show progress to the user after each phase completes using the templates above. Short, high-signal updates make the process easier to trust and easier to redirect.
