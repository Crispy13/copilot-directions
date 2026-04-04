# Final Output Format

Use this format when producing the final consensus document in Phase 4. The main body uses whichever topic format was selected in Phase 1.

```markdown
# Committee Report: {Topic}

**Date:** {date}
**Committee:** Opus (Claude Opus 4.6), Sonnet (Claude Sonnet 4.6), Gemini (Gemini 3.1 Pro), GPT (GPT 5.4)
**Rounds:** {N} discussion round(s)
**Confidence:** NORMAL | REDUCED

---

{Main body — use the same topic format from Phase 1, populated with the committee's consensus. Make each recommendation or conclusion tell the reader what to do, why it is preferred, and what impact or caveat follows from it.}

---

## Minority Wisdom / Caveats (if applicable)

- {Important minority concern, constraint, or unresolved tradeoff that the majority did not adopt outright but the reader should still factor into the decision}

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

- **The main body is the deliverable.** A reader should be able to act on it without reading the provenance or discussion log.
- **Make every recommendation decision-quality.** State what to do, why it wins on the current constraints, and the practical impact if the reader follows it.
- **Preserve dissenting wisdom.** If a minority position surfaced a real risk, constraint, or unresolved tradeoff, include it in `Minority Wisdom / Caveats` and reflect it in the main body where relevant.
- **Be specific.** Vague consensus is worse than no consensus. Ground conclusions in the committee's reasoning and evidence.
- **Use the provenance section for transparency, not for core meaning.** It should explain how agreement emerged, including degraded mode, rather than carrying the actual decision.
- **Run this checkpoint before saving:** if you removed the provenance and discussion log, would the report still tell the reader what to do and what to watch out for? If not, strengthen the main body.
