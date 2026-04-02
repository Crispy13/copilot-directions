# Consolidation Format

Use this exact format when producing the consolidated plan in Phase 2.

```markdown
# Consolidated Plan: {Topic}

**Date:** {date}
**Members:** Opus, Sonnet, Gemini, GPT
**Status:** CONSOLIDATING | DISCUSSING (Round N) | FINAL

---

## Consensus Points

Items where members agree. These are settled unless a discussion round reopens them.

### 1. {Point title}

**Agreement:** FULL (4/4) | STRONG (3/4)
**Summary:** {Merged description combining the best phrasing from agreeing members}
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
**Resolution needed:** {Specific question to resolve — e.g., "Should we use approach A (faster) or B (more maintainable) for step 3?"}

### 2. {Next contested topic}
...

---

## Unique Contributions

Valuable ideas raised by only one member that others didn't address. Members will vote on these during discussion.

### 1. {Idea title} — raised by {Member}

**Description:** {What was proposed}
**Value:** {Why it merits consideration}

### 2. {Next unique idea}
...

---

## Resolution Log

Track how contested points are resolved across rounds.

| Point | Round 1 | Round 2 | Round 3 | Final Resolution |
|-------|---------|---------|---------|------------------|
| {title} | {votes} | {votes} | {votes} | {how resolved} |
```

## Guidelines

- **Be precise about agreement counts.** Don't round up — if 2 members agree and 2 are silent on a point, that's not 4/4.
- **Preserve reasoning.** When summarizing positions, keep the key arguments — don't reduce to just "agrees/disagrees."
- **Frame resolution questions sharply.** Instead of "discuss this further," ask a specific either/or question that members can respond to directly.
- **Don't merge prematurely.** If two members say similar things with different nuances, keep them separate until you're sure the nuance doesn't matter.
