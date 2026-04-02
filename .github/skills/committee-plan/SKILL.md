---
name: committee-plan
description: >-
  Plan with committee: orchestrates 4 AI model subagents (Opus, Sonnet, Gemini, GPT)
  to draft plans in parallel, consolidate consensus vs. contested points, and iterate
  through structured discussion rounds (max 3) to produce a final consensus plan.
  Use when: multi-perspective planning, committee review, diverse AI brainstorming,
  consensus planning, plan with committee.
argument-hint: "Describe the topic or problem to plan for"
---

# Committee Planning

Orchestrate a multi-model planning committee using the Structured Delphi Method. Four AI models independently draft plans, then iterate toward consensus through structured discussion rounds.

## Committee Members

| Agent | Model |
|-------|-------|
| `CommitteeOpus` | Claude Opus 4.6 |
| `CommitteeSonnet` | Claude Sonnet 4.6 |
| `CommitteeGemini` | Gemini 3.1 Pro |
| `CommitteeGPT` | GPT 5.4 |

## Procedure

### Phase 1: Parallel Drafting

Dispatch all 4 members in parallel with the same planning brief. Each member independently:
- Researches the codebase via Explore subagent
- Drafts a structured plan
- Self-reviews and iterates before submitting

**Dispatch prompt for each member:**

```
You are drafting a plan as a committee member. Your task:

{user's planning topic/problem — paste the full brief}

Write your plan to: /memories/session/committee/draft-{member-name}.md

Read your instructions from .github/skills/committee-member/SKILL.md and follow Mode 1 (Drafting). Research the codebase thoroughly before drafting.

Use this output format for your draft:

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

Rules: NO code blocks — describe changes, link to files and specific symbols/functions.
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
5. Write the consolidated plan to `/memories/session/committee/consolidated-plan.md`.

**If all points are consensus (no contested points):** Skip to Phase 4 immediately.

### Phase 3: Discussion Rounds (Max 3)

For each round, dispatch all 4 members in parallel to respond to contested points only.

**Dispatch prompt for each member:**

```
You are participating in discussion round {N} of the committee plan.

Read the consolidated plan: /memories/session/committee/consolidated-plan.md

Read your instructions from .github/skills/committee-member/SKILL.md and follow Mode 2 (Discussion). Respond to ONLY the contested points and unique contributions.

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

### Phase 4: Final Plan

Produce the final plan as a markdown file in the workspace.

Read the [final plan format reference](./references/final-plan-format.md) for the exact template.

**Process:**
1. Write the final plan incorporating all resolved consensus.
2. Include a provenance section showing how agreement was reached.
3. Include a discussion summary log.
4. Save to: `{user-specified path or workspace root}/committee-plan-{topic}.md`
5. Present the plan to the user in chat.

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

- The Chief (you, the agent running this skill) does ALL consolidation and convergence checking. Members only draft and discuss.
- Members never communicate with the user. Only the Chief talks to the user.
- Members never communicate with each other. All interaction flows through the Chief via files.
- Use structured formats strictly — they enable convergence tracking.
- Show progress to the user after each phase completes (brief summary, not full content).
