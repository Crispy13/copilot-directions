# Consolidation Format

Use this exact format when producing the consolidated plan in Phase 2.

```markdown
# Consolidated Plan: {Topic}

**Date:** {date}
**Members:** Opus, Sonnet, Gemini, GPT
**Status:** CONSOLIDATING | DISCUSSING (Round N) | FINAL
**Confidence:** NORMAL | REDUCED
**Missing / Failed Members:** {none or member names with brief reason}

---

## Consensus Points

Items where members agree. These are settled unless new evidence or a materially stronger synthesis reopens them.

### 1. {Point title}

**Agreement:** FULL (4/4) | STRONG (3/4)
**Summary:** {Merged description combining the best phrasing from agreeing members}
**Why this holds:** {Core reasoning chain that explains the agreement}
**Evidence / Basis:** {Files, functions, constraints, examples, or sources that support the summary}
**Dissent (if STRONG):** {Member X} — {their differing view, briefly}

### 2. {Next point}
...

---

## Contested Points

Items where 2+ members substantively disagree. These are the focus of discussion rounds.

### 1. {Contested topic}

**Split:** 2-2 | 3-1 | 4-way
**Positions:**
- **Position A** ({Members}): {description with reasoning}
- **Position B** ({Members}): {description with reasoning}
- **Position C** ({Members}, if applicable): {description}
**Shared ground:** {What all sides agree on, if anything}
**Resolution needed:** {Specific question to resolve — e.g., "Should we use approach A (faster) or B (more maintainable) for step 3?"}

### 2. {Next contested topic}
...

---

## Unique Contributions

Valuable ideas raised by only one member that others didn't address. Members will vote on these during discussion.

### 1. {Idea title} — raised by {Member}

**Description:** {What was proposed}
**Value:** {Why it merits consideration}
**Evidence / Basis:** {What makes this worth carrying forward}

### 2. {Next unique idea}
...

---

## Resolution Log

Track how contested points are resolved across rounds.

| Point | Round 1 | Round 2 | Round 3 | Reopened? | Final Resolution |
|-------|---------|---------|---------|-----------|------------------|
| {title} | {votes} | {votes} | {votes} | {no or why reopened} | {how resolved} |
```

## Guidelines

- **Be precise about agreement counts.** Don't round up — if 2 members agree and 2 are silent on a point, that's not 4/4.
- **Use a deliberate synthesis method.** Cluster equivalent claims first, preserve the clearest phrasing, and merge only when the underlying rationale is materially compatible.
- **Preserve reasoning.** When summarizing positions, keep the key arguments and evidence — don't reduce them to just "agrees/disagrees."
- **Frame resolution questions sharply.** Instead of "discuss this further," ask a specific question that members can answer directly and compare against evidence.
- **Don't merge prematurely.** If two members say similar things with different nuances, keep them separate until you're sure the nuance does not change the decision.
- **Do not drop draft content silently.** If an idea is important enough to consider but not important enough to keep, note why it was discarded.
- **Keep consensus closed unless something materially changes.** If a later round reopens a settled point, log what changed and why reopening was warranted.
- **Use confidence and missing-member fields honestly.** Reduced coverage is still usable when the reasoning is sound, but readers should be able to see that degraded mode changed the committee shape.
- **Keep contested points decision-oriented.** A good contested point names the real fork in the plan, not a vague area of discomfort.
- **Use unique contributions to protect non-obvious value.** This section exists so a strong minority idea is evaluated on its merits rather than lost because it appeared only once.
- **Keep the resolution log readable.** A future reader should be able to see what moved, what reopened, and what finally won without rereading every round response.
- **Write for Phase 3 reuse.** The consolidated plan should make the next round easy to run, which means members should be able to find the exact open questions and the exact shared ground quickly.
