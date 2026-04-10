---
name: committee
description: >-
  General-purpose committee for multi-perspective deliberation: orchestrates 4 AI model
  subagents (Opus, Sonnet, Gemini, GPT) to investigate independently, debate through structured
  rounds, and return a consensus report. Use this whenever the user needs several expert
  viewpoints, a second-opinion architecture review, design-decision or RFC analysis, bug or
  root-cause analysis, research synthesis, or a side-by-side comparison of tools, vendors, or
  approaches, even if they do not explicitly say "committee." Best for ambiguous, high-stakes,
  or contested questions where diverse reasoning matters. Not for simple code generation,
  straightforward edits, single-perspective answers, or step-by-step planning; use committee-plan
  when the main need is a plan.
argument-hint: "Describe the topic or question for the committee to deliberate"
---

# General Committee

Orchestrate a multi-model committee using the Structured Delphi Method. Four AI models independently research and draft responses, then iterate toward consensus through structured discussion rounds.

## Committee Members

| Agent | Model |
|-------|-------|
| `GCOpus` | Claude Opus 4.6 |
| `GCSonnet` | Claude Sonnet 4.6 |
| `GCGemini` | Gemini 3.1 Pro |
| `GCGPT` | GPT 5.4 |

## Topic Format Selection

Select the format before dispatching members. The format choice matters because it determines which kinds of evidence, tradeoffs, and open questions members will surface early instead of retrofitting them during consolidation.

### Selection Rubric

| Format | Use it when the topic is mainly about | Watch for this mismatch |
|--------|---------------------------------------|-------------------------|
| **Default** | a position, recommendation, or judgment call that does not need a specialized frame | Avoid it when the real task is comparing options, isolating a failure, or reviewing an existing design. |
| **Bug / Root-Cause Analysis** | explaining what is likely broken, what evidence supports each theory, and what to investigate next | Avoid it when the issue is already understood and the hard part is choosing a remediation design. |
| **Architecture / Design Review** | evaluating an existing system, proposal, or implementation approach | Avoid it when the work is mostly discovery or the output should be a ranked decision between options. |
| **Research / Investigation** | gathering facts, mapping the landscape, and explaining what is known versus unknown | Avoid it when the user needs a concrete decision rather than a research brief. |
| **Design Decision / RFC** | choosing a direction under constraints with explicit pros, cons, and rationale | Avoid it when the committee should compare options without forcing a single decision yet. |
| **Comparative Analysis** | evaluating competing tools, approaches, or vendors against shared criteria | Avoid it when the options are not yet concrete enough to compare side by side. |
| **Plan** | sequencing, dependency ordering, phased implementation, or verification strategy | Avoid it when the deliverable is analysis or judgment rather than an executable step-by-step sequence; use **Design Decision / RFC** instead. |

### Hybrid Topics

Use the format that matches the primary deliverable, then pull supporting material from another format as subsections. This keeps the report readable while still capturing the right evidence shape.

- Research feeding a decision: use **Design Decision / RFC** and let research appear inside `Evidence / Basis` and `Open Questions`.
- Bug plus remediation design: use **Bug / Root-Cause Analysis** if diagnosis is the hard part, or **Architecture / Design Review** if the diagnosis is settled and the debate is about the fix.
- Tool comparison that ends with a recommendation: use **Comparative Analysis** if the comparison itself is the value; use **Design Decision / RFC** if the recommendation and constraints are the center of gravity.
- Analysis feeding a plan: use **Plan** when the deliverable is an actionable execution sequence; use the analytical format (Architecture / Design Review, Research, etc.) if the hard part is the analysis and the plan is secondary.

## Topic Format Catalog

Before dispatching members, select one format from this catalog and name it explicitly in the dispatch prompt.

### Default

```
## Response: {Title}

{Summary — your position in 2-3 sentences}

**Key Arguments**
1. {Argument with supporting evidence or reasoning}
2. ...

**Evidence / Basis**
- {Files, functions, observed constraints, examples, or external sources that support the position}

**Risks / Concerns**
- {Risk and why it matters}

**Recommendation**
{Your recommended course of action or conclusion}
```

- `Summary`: State the position plainly enough that a reader knows the answer before reading the details. Name the decision frame, the strongest reason, and any assumption that the recommendation depends on.
- `Key Arguments`: Separate the major reasons instead of blending them into one paragraph. Each argument should explain why it matters, not just what the committee noticed.
- `Evidence / Basis`: Ground claims in something concrete such as files, functions, observed behavior, constraints, experiments, or credible external sources. When evidence is indirect, say that clearly so the reader can judge confidence.
- `Risks / Concerns`: Call out downside, trigger, and likely impact. This prevents a smooth recommendation from hiding the cost of being wrong.
- `Recommendation`: Say what to do next, why it is the best move now, and the practical effect if the reader follows it. If there is a key caveat, include it here instead of burying it later.

### Bug / Root-Cause Analysis

```
## Analysis: {Bug/Issue Title}

**Hypotheses** (ranked by likelihood)
1. {Hypothesis} — Evidence: {what supports this}
2. ...

**Evidence / Basis**
- {Observed symptoms, relevant code paths, logs, reproductions, or prior incidents}

**Eliminated**
- {Hypothesis ruled out} — Why: {evidence against}

**Recommended Investigation**
1. {Next step to confirm/deny top hypothesis}
```

- `Hypotheses`: Rank by likelihood and say why each one is plausible. Good hypotheses connect symptom, mechanism, and scope instead of naming a vague failure area.
- `Evidence / Basis`: Prefer direct observations such as logs, stack traces, reproductions, file paths, or code paths. If the evidence is circumstantial, explain what would strengthen or weaken it.
- `Eliminated`: Show what you ruled out and the evidence that ruled it out. This keeps later rounds from reopening dead ends without new information.
- `Recommended Investigation`: List concrete checks or experiments in priority order. Each step should say what result would confirm or falsify the leading theory.

### Architecture / Design Review

```
## Review: {Component/System}

**Strengths**
- {What works well and why}

**Weaknesses**
- {Problem and its impact}

**Evidence / Basis**
- {Design constraints, file-level grounding, operational signals, benchmarks, or comparable patterns}

**Recommendations**
1. {Change with rationale}

**Tradeoffs**
- {What we gain vs. what we lose}
```

- `Strengths`: Name strengths that matter to the decision, not generic praise. Explain why the current design helps correctness, maintainability, cost, delivery speed, or user experience.
- `Weaknesses`: Describe the specific failure mode or design debt and the consequence if it stays in place. Focus on the issues that change the recommendation rather than cataloging every imperfection.
- `Evidence / Basis`: Tie each claim to architecture facts, file paths, interfaces, incidents, performance characteristics, or prior patterns. This keeps the review from turning into taste-based opinion.
- `Recommendations`: Make each recommendation actionable enough that a reader could turn it into implementation work. State the expected benefit and any dependency or migration concern.
- `Tradeoffs`: Show what the recommendation costs in complexity, runtime, delivery speed, or flexibility. Strong reviews make the downside legible instead of pretending there is a free win.

### Research / Investigation

```
## Findings: {Topic}

**Key Findings**
1. {Finding with source/evidence}
2. ...

**Synthesis**
{How findings connect — narrative summary}

**Evidence / Basis**
- {Primary sources, code observations, experiments, examples, or constraints that shaped the findings}

**Open Questions**
- {What remains unknown}

**Conclusion**
{Overall assessment and recommendation}
```

- `Key Findings`: Treat findings as claims that deserve evidence, not as notes. Explain what each finding means and why it matters to the user’s decision surface.
- `Synthesis`: Connect the findings into a coherent story about the landscape, the constraints, or the likely direction. Use this section to explain patterns, tensions, and inflection points.
- `Evidence / Basis`: Cite the observations, files, examples, experiments, or external sources that materially shaped the findings. Readers should be able to tell which conclusions are well grounded and which are provisional.
- `Open Questions`: Name the unknowns that would materially change the conclusion. This helps the Chief distinguish between healthy uncertainty and missing work.
- `Conclusion`: State the best current judgment and what the reader should do with it. Conclusions are stronger when they name confidence and the next decisive step.

### Design Decision / RFC

```
## Decision: {Topic}

**Options**
1. **{Option A}** — {description}
  - Pros: {advantages}
  - Cons: {disadvantages}
2. **{Option B}** — {description}
  - Pros: {advantages}
  - Cons: {disadvantages}

**Evidence / Basis**
- {Constraints, prior art, file-level grounding, experiments, or operating assumptions}

**Recommendation:** {Option X}
**Rationale:** {Why this option wins given the constraints}
```

- `Options`: Make the options genuinely comparable by using the same frame for each one. Good options explain what changes, who owns the cost, and where the risk shifts.
- `Evidence / Basis`: Name the constraints, prior incidents, codebase realities, experiments, or external references that matter to the choice. This makes the decision legible even to someone who did not follow the full discussion.
- `Recommendation`: Pick a direction rather than summarizing the debate. If the answer depends on a condition, say the condition explicitly.
- `Rationale`: Explain why the chosen option wins on the actual constraints, not abstract pros and cons. Include the most important tradeoff so the decision does not read as costless.

### Comparative Analysis

```
## Comparison: {Topic}

**Criteria**
1. {Criterion and why it matters}
2. ...

**Option Comparison**
- **{Option A}** — {How it performs against the criteria}
- **{Option B}** — {How it performs against the criteria}

**Evidence / Basis**
- {Benchmarks, examples, file-level constraints, operational needs, or external references}

**Recommendation Threshold**
{What would make one option clearly preferable, or whether the current evidence is still too thin}

**Unknowns / Caveats**
- {What could still change the outcome}
```

- `Criteria`: Pick the criteria before arguing for a winner. This keeps the comparison honest and makes tradeoffs easier to inspect.
- `Option Comparison`: Compare each option against the same criteria and call out where the evidence is strong versus assumed. A useful comparison shows both absolute quality and fit for the user’s constraints.
- `Evidence / Basis`: Cite benchmarks, source code constraints, operational requirements, vendor facts, examples, or experiments. The point is to show why the ranking exists, not just what the ranking is.
- `Recommendation Threshold`: Explain what evidence or condition would justify a recommendation. This is useful when the committee can narrow the field but should not pretend the final call is settled yet.
- `Unknowns / Caveats`: Surface the uncertainties that could flip the ranking. That makes later validation work targeted instead of broad and fuzzy.

### Plan

```
## Plan: {Title (2-10 words)}

{TL;DR — what, why, and recommended approach.}

**Steps**
1. {Step — note dependency ("*depends on step N*") or parallelism ("*parallel with step N*") when applicable}
2. {For plans with 5+ steps, group steps into named phases that are each independently verifiable}

**Relevant files**
- `{full/path/to/file}` — {what to modify or reuse, referencing specific functions/patterns}

**Verification**
1. {Specific verification steps — tests, commands, checks; not generic statements}

**Decisions** (if applicable)
- {Decision, assumptions, and included/excluded scope}

**Risks**
- {Risk and mitigation or why it is acceptable}
```

- `TL;DR`: State the plan recommendation plainly. Name the intended outcome, the reason this path wins, and any major assumption the plan depends on.
- `Steps`: Sequence work so a reader can execute it without reverse-engineering dependencies. Mark steps that can run in parallel or depend on a prior step. For plans with 5+ steps, group into named phases that are each independently verifiable.
- `Relevant files`: Ground the plan in real code locations, interfaces, commands, or documents. List specific functions or patterns to reuse, not just file names.
- `Verification`: Cover the key claims from the chosen path, including risk-heavy areas, not just the happy path. Each check should be concrete enough that someone can tell whether the step worked or failed.
- `Decisions`: Record meaningful scope or architecture choices that explain the plan shape. State what is in scope, what is excluded, and the assumption that would force a change.
- `Risks`: Name the downside, the trigger condition, and either the mitigation or an explanation of why the risk is acceptable. Strong plans make risks legible instead of smoothing them over.

If the topic does not fit any category, use **Default**.

## Procedure

### Phase 1: Parallel Drafting

Dispatch all 4 members in parallel with the same brief. Independent drafting matters because it gives the committee genuine diversity of reasoning before convergence begins.

Each member independently:
- Researches the codebase and external sources via Explore subagent
- Analyzes the topic and forms a position
- Drafts a structured response
- Self-reviews and iterates before submitting

**Dispatch prompt for each member:**

**When Plan format is selected**, use this dispatch prompt instead:

```
You are a committee member drafting a plan for the following topic:

{user's planning topic/problem — paste the full brief}

Write your plan to: /memories/session/committee/draft-{member-name}.md

Load the `committee-member` skill and follow Mode 3 (Planning). If the skill cannot be loaded, report the failure and stop. Research the codebase thoroughly before drafting.

Use the Topic Format Catalog section named: Plan
Required headings for this plan: Plan title, TL;DR, Steps, Relevant files, Verification, Decisions, Risks

Quality bar:
- Ground the steps in concrete evidence such as files, functions, existing patterns, observed constraints, or user-provided requirements.
- Make verification specific enough that someone could tell whether the plan worked or failed.
- State assumptions, dependencies, and risks instead of smoothing them over.
- Prefer plans that are executable and reviewable, not just plausible at a high level.

Rules: NO code blocks — describe changes, link to files and specific symbols/functions. Do NOT read other members' draft files (`draft-*.md`) — research independently using only the codebase and external sources.
```

**For all other formats**, use the default dispatch prompt:

```
You are a committee member deliberating on the following topic:

{user's topic/question — paste the full brief}

Write your response to: /memories/session/committee/draft-{member-name}.md

Load the `committee-member` skill and follow Mode 1 (Drafting). If the skill cannot be loaded, report the failure and stop. Research thoroughly before drafting.

Use the Topic Format Catalog section named: {selected format name}
Required headings for this draft: {selected heading list from that section}

Quality bar:
- Ground claims in concrete evidence such as files, functions, observed constraints, examples, or credible external sources.
- Include explicit tradeoffs, at least one meaningful risk, and at least one counterpoint or alternative considered before settling.
- Make the recommendation actionable: say what to do, why, and what practical effect it should have.
- State assumptions instead of filling gaps silently.

Rules: no code blocks unless the topic specifically requires code to make the reasoning legible. Do NOT read other members' draft files (`draft-*.md`) — research independently using only the codebase and external sources.
```

Replace `{member-name}` with: `opus`, `sonnet`, `gemini`, `gpt`.

#### Quality Check

Before moving to Phase 2, verify that:

- All expected draft files exist, or any missing file is explicitly recorded.
- Each available draft is substantive, uses the selected headings, includes evidence, and reaches a recommendation or conclusion.
- Weak drafts are not empty shells. If one draft is mechanically incomplete, give it one targeted retry when that is cheaper than carrying avoidable ambiguity forward.

#### Degraded Mode

Continue with 3 available members when the topic still has enough coverage to synthesize responsibly. Mark confidence as reduced, record the missing or failed member in the provenance trail, and escalate to the user only when the missing output materially blocks the topic.

#### Progress Update

Use this template after Phase 1 completes:

```markdown
Phase 1 complete. Drafts received: {N}/4. Format: {selected format name}. Confidence: {normal|reduced}.
Main themes: {1-2 sentence summary}. Gaps or failures: {missing member, thin draft, or none}.
Next: consolidate consensus, contested points, and unique contributions.
```

### Phase 2: Chief Consolidation

You (the Chief) read the available draft files and produce a single consolidated document. Do not use automated diffing; manual synthesis matters because you need to preserve reasoning quality, not just overlap in wording.

Read the [consolidation format reference](./references/consolidation-format.md) for the exact template.

**Process:**
1. Read all available drafts from `/memories/session/committee/draft-*.md`.
2. Cluster equivalent claims before writing anything. Preserve the clearest phrasing, merge only when the underlying rationale is materially compatible, and carry forward meaningful nuance instead of averaging it away.
3. Identify points where members agree (consensus) and disagree (contested).
4. Note unique contributions — valuable ideas raised by only one member.
5. Count agreement levels: FULL (4/4), STRONG (3/4), SPLIT (2/2), MINORITY (1/4), or the equivalent ratios under degraded mode.
6. Write the consolidated document to `/memories/session/committee/consolidated-report.md`.

Consensus points stay closed by default. Reopen a settled point only when new evidence, a sharper synthesis, or a newly surfaced dependency materially changes the decision surface, then log why it was reopened.

**If all points are consensus (no contested points):** Skip to Phase 4 immediately.

#### Quality Check

Before moving to Phase 3 or Phase 4, verify that:

- No material draft content was silently dropped. Each important idea appears in `Consensus Points`, `Contested Points`, `Unique Contributions`, or a brief discard note with rationale.
- Consensus summaries preserve the reasoning chain, not just the conclusion label.
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
You are participating in discussion round {N} of the committee deliberation.

Read the consolidated document: /memories/session/committee/consolidated-report.md

Load the `committee-member` skill and follow Mode 2 (Discussion). If the skill cannot be loaded, report the failure and stop. Respond to ONLY the contested points and unique contributions.

Quality bar:
- Accept, counter, or propose with concrete reasoning instead of preference language.
- Cite the evidence or constraint that changed your position, if any.
- Keep focus on the current resolution question; do not rewrite settled areas unless new evidence materially changes them.

Rules: no code blocks unless they are required to explain the reasoning clearly. Do NOT read other members' round response files (`round-*.md`) — read ONLY the consolidated document above.

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

#### Round Update

Update `/memories/session/committee/consolidated-report.md` with:
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
Next: {another round | final report | user escalation}.
```

### Phase 4: Final Output

Produce the final consensus document as a markdown file.

Read the [final output format reference](./references/final-output-format.md) for the exact template.

**Process:**
1. Write the final document incorporating all resolved consensus.
2. Use the same topic format selected in Phase 1 for the main body.
3. Make the main body stand on its own: each recommendation or conclusion should tell the reader what to do, why it is preferred, and what impact or caveat follows from it.
4. Include minority wisdom when a non-winning position surfaced a real risk, constraint, or unresolved tradeoff.
5. Include a provenance section showing how agreement was reached, including any missing members and confidence reduction under degraded mode.
6. Include a discussion summary log.
7. Save to: `{user-specified path or workspace root}/committee-{topic-slug}.md`
8. Present the output to the user in chat.

#### Quality Check

Before presenting the final report, verify that a reader could act on the main body without reading the provenance or discussion log. If the report only makes sense when paired with the process notes, the synthesis is still too thin.

#### Progress Update

Use this template after Phase 4 completes:

```markdown
Committee complete. Final report saved to: {path}. Rounds used: {N}. Confidence: {normal|reduced}.
Outcome: {1-2 sentence summary}. Minority wisdom included: {yes|no}.
```

## Runtime File Layout

```
/memories/session/committee/
  draft-opus.md              # Phase 1
  draft-sonnet.md            # Phase 1
  draft-gemini.md            # Phase 1
  draft-gpt.md               # Phase 1
  consolidated-report.md     # Phase 2 (updated in Phase 3)
  round-1-opus.md            # Phase 3, Round 1
  round-1-sonnet.md
  round-1-gemini.md
  round-1-gpt.md
  round-2-*.md               # Phase 3, Round 2 (if needed)
  round-3-*.md               # Phase 3, Round 3 (if needed)
```

## Rules

- The Chief (you, the agent running this skill) does all consolidation and convergence checking. Keeping synthesis centralized preserves a single reasoning trail and avoids members negotiating outside the recorded process.
- Members never communicate with the user. Only the Chief talks to the user, which keeps the committee legible instead of turning it into four competing conversations.
- Members never communicate with each other. All interaction flows through the Chief via files so agreement levels and contested points stay auditable.
- Members should not edit code files or run implementation commands. Deliberation stays cleaner when members focus on analysis instead of drifting into execution.
- Use the selected format consistently. Structured outputs make convergence tracking, evidence comparison, and final synthesis much easier.
- Show progress to the user after each phase completes using the templates above. Short, high-signal updates make the process easier to trust and easier to interrupt if the user wants to redirect it.
- If subagent call fails, try it again but up to 3 total attempts. If it still fails, record the failure and proceed with the remaining members instead of blocking the whole process.
