# Final Plan Format

Use this exact format when producing the final consensus plan in Phase 4. The plan section follows the default Plan agent's `plan_style_guide`.

```markdown
# Committee Plan: {Topic}

**Date:** {date}
**Committee:** Opus (Claude Opus 4.6), Sonnet (Claude Sonnet 4.6), Gemini (Gemini 3.1 Pro), GPT (GPT 5.4)
**Rounds:** {N} discussion round(s)
**Confidence:** NORMAL | REDUCED

---

## Plan: {Title (2-10 words)}

{TL;DR - what, why, and how (the committee's recommended approach).}

**Steps**
1. {Implementation step-by-step — note dependency ("*depends on N*") or parallelism ("*parallel with step N*") when applicable}
2. {For plans with 5+ steps, group steps into named phases with enough detail to be independently actionable}

**Relevant files**
- `{full/path/to/file}` — {what to modify or reuse, referencing specific functions/patterns}

**Verification**
1. {Verification steps for validating the implementation (**Specific** tasks, tests, commands, MCP tools, etc; not generic statements)}

**Decisions** (if applicable)
- {Decision, assumptions, and includes/excluded scope}

**Further Considerations** (if applicable, 1-3 items)
1. {Open question with recommendation. Option A / Option B / Option C}

---

## Minority Wisdom / Caveats (if applicable)

- {Important minority concern, constraint, or unresolved tradeoff that the majority did not adopt outright but the reader should still factor into execution}

---

## Provenance

How consensus was reached:

| Category | Count |
|----------|-------|
| Full consensus (4/4) | {N} points |
| Strong consensus (3/4) | {N} points |
| Resolved via discussion | {N} points |
| Resolved by supermajority | {N} points |
| Resolved by Chief decision | {N} points |
| Escalated to user | {N} points |
| Missing / failed members | {N} |

## Discussion Log

### Round 1
{Brief summary: what was contested, key arguments, what was resolved}

### Round 2 (if applicable)
{Brief summary}

### Round 3 (if applicable)
{Brief summary}
```

## Guidelines

- **The Plan section is the deliverable.** It should stand alone — a reader should not need to read the provenance or discussion log to understand the plan.
- **Make every recommendation decision-quality.** State what to do, why it wins on the current constraints, and the practical impact if the reader follows it.
- **Preserve dissenting wisdom.** If a minority position had merit (e.g., noted a real risk), incorporate it as a risk/mitigation even if the majority approach was chosen.
- **Be specific in verification.** "Run the tests" is not a verification step. "Run `npm test -- --filter=auth`" is.
- **The provenance section is for transparency.** It shows the user how much natural agreement existed vs. how much was negotiated, including degraded mode when members were missing.
- **Run this standalone checkpoint before saving.** If you removed the provenance and discussion log, the remaining plan should still tell the reader what to do and what to watch out for.

## Depth Guidance

- **TL;DR:** Say what the committee recommends, why this path is preferred, and what kind of implementation or rollout shape the reader should expect.
- **Steps:** Make each step independently actionable. If a step depends on prior discovery, migration work, or stakeholder input, say that directly.
- **Relevant files:** Prefer the smallest set of files or directories that actually anchor the implementation path. This section should make the plan feel attached to the codebase.
- **Verification:** Cover the key claims from the chosen plan, including risk-heavy areas, not just the happy path.
- **Decisions:** Record meaningful scope or architecture choices that explain the plan. Avoid turning this into a duplicate of `Steps`.
- **Further Considerations:** Keep open questions narrow and decision-ready. If the reader answers them, the plan should become more executable rather than more ambiguous.
- **Minority Wisdom / Caveats:** Include only the concerns that materially change sequencing, safety, rollout, or expectations.
- **Provenance:** Use it to explain how agreement emerged and whether degraded mode affected confidence, not to carry essential instructions.
- **Discussion Log:** Keep the log short and high-signal. It should show movement across rounds without retelling the entire debate.

## Final Checkpoint

- Confirm the plan still reads like one coherent recommendation rather than a stitched summary of committee votes.
- Confirm the confidence level matches the actual committee coverage and any degraded-mode conditions.
- Confirm the provenance and discussion log add transparency without becoming required reading.
