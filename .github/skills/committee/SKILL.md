---
name: committee
description: >-
  General-purpose committee: orchestrates 4 AI model subagents (Opus, Sonnet, Gemini, GPT)
  to deliberate on any topic — workflow design, bug root-cause analysis, architecture review,
  research, design decisions, and more. Produces a consensus document through structured
  discussion rounds (max 3). Use when: multi-perspective discussion, committee deliberation,
  diverse AI brainstorming, consensus building, research with committee.
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

## Topic Format Catalog

Before dispatching members, select the output format that best fits the topic. Include the format in the dispatch prompt.

### Default (general discussion)
```
## Response: {Title}

{Summary — your position in 2-3 sentences}

**Key Arguments**
1. {Argument with supporting evidence or reasoning}
2. ...

**Risks / Concerns**
- {Risk and why it matters}

**Recommendation**
{Your recommended course of action or conclusion}
```

### Bug / Root-Cause Analysis
```
## Analysis: {Bug/Issue Title}

**Hypotheses** (ranked by likelihood)
1. {Hypothesis} — Evidence: {what supports this}
2. ...

**Eliminated**
- {Hypothesis ruled out} — Why: {evidence against}

**Recommended Investigation**
1. {Next step to confirm/deny top hypothesis}
```

### Architecture / Design Review
```
## Review: {Component/System}

**Strengths**
- {What works well and why}

**Weaknesses**
- {Problem and its impact}

**Recommendations**
1. {Change with rationale}

**Tradeoffs**
- {What we gain vs. what we lose}
```

### Research / Investigation
```
## Findings: {Topic}

**Key Findings**
1. {Finding with source/evidence}
2. ...

**Synthesis**
{How findings connect — narrative summary}

**Open Questions**
- {What remains unknown}

**Conclusion**
{Overall assessment and recommendation}
```

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

**Recommendation:** {Option X}
**Rationale:** {Why this option wins given the constraints}
```

If the topic doesn't fit any category, use the **Default** format.

## Procedure

### Phase 1: Parallel Drafting

Dispatch all 4 members in parallel with the same brief. Each member independently:
- Researches the codebase and external sources via Explore subagent
- Analyzes the topic and forms a position
- Drafts a structured response
- Self-reviews and iterates before submitting

**Dispatch prompt for each member:**

```
You are a committee member deliberating on the following topic:

{user's topic/question — paste the full brief}

Write your response to: /memories/session/committee/draft-{member-name}.md

Load the `committee-member` skill and follow Mode 1 (Drafting). If the skill cannot be loaded, report the failure and stop. Research thoroughly before drafting.

Use this output format for your draft:

{paste the selected format from the Topic Format Catalog above}
```

Replace `{member-name}` with: `opus`, `sonnet`, `gemini`, `gpt`.

After all 4 drafts are saved, proceed to Phase 2.

### Phase 2: Chief Consolidation

You (the Chief) read all 4 draft files and produce a single consolidated document. Do NOT use automated diffing — read and synthesize using your own judgment.

Read the [consolidation format reference](./references/consolidation-format.md) for the exact template.

**Process:**
1. Read all 4 drafts from `/memories/session/committee/draft-*.md`.
2. Identify points where members agree (consensus) and disagree (contested).
3. Note unique contributions — valuable ideas raised by only one member.
4. Count agreement levels: FULL (4/4), STRONG (3/4), SPLIT (2/2), MINORITY (1/4).
5. Write the consolidated document to `/memories/session/committee/consolidated-plan.md`.

**If all points are consensus (no contested points):** Skip to Phase 4 immediately.

### Phase 3: Discussion Rounds (Max 3)

For each round, dispatch all 4 members in parallel to respond to contested points only.

**Dispatch prompt for each member:**

```
You are participating in discussion round {N} of the committee deliberation.

Read the consolidated document: /memories/session/committee/consolidated-plan.md

Load the `committee-member` skill and follow Mode 2 (Discussion). If the skill cannot be loaded, report the failure and stop. Respond to ONLY the contested points and unique contributions.

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

Update `/memories/session/committee/consolidated-plan.md` with:
- Newly resolved points moved to consensus
- Updated framing for remaining contested points
- Resolution notes for deadlocked points

**Early exit:** If all contested points are resolved, skip remaining rounds and go to Phase 4.

### Phase 4: Final Output

Produce the final consensus document as a markdown file.

Read the [final output format reference](./references/final-output-format.md) for the exact template.

**Process:**
1. Write the final document incorporating all resolved consensus.
2. Use the same topic format selected in Phase 1 for the main body.
3. Include a provenance section showing how agreement was reached.
4. Include a discussion summary log.
5. Save to: `{user-specified path or workspace root}/committee-{topic-slug}.md`
6. Present the output to the user in chat.

## Runtime File Layout

```
/memories/session/committee/
  draft-opus.md              # Phase 1
  draft-sonnet.md            # Phase 1
  draft-gemini.md            # Phase 1
  draft-gpt.md               # Phase 1
  consolidated-plan.md       # Phase 2 (updated in Phase 3)
  round-1-opus.md            # Phase 3, Round 1
  round-1-sonnet.md
  round-1-gemini.md
  round-1-gpt.md
  round-2-*.md               # Phase 3, Round 2 (if needed)
  round-3-*.md               # Phase 3, Round 3 (if needed)
```

## Rules

- The Chief (you, the agent running this skill) does ALL consolidation and convergence checking. Members only draft and discuss.
- Members never communicate with the user. Only the Chief talks to the user.
- Members never communicate with each other. All interaction flows through the Chief via files.
- Members must NOT edit code files or run commands — deliberation only.
- Use structured formats strictly — they enable convergence tracking.
- Show progress to the user after each phase completes (brief summary, not full content).
