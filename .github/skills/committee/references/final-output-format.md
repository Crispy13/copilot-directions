# Final Output Format

Use this format when producing the final consensus document in Phase 4. The main body uses whichever topic format was selected in Phase 1.

```markdown
# Committee Report: {Topic}

**Date:** {date}
**Committee:** Opus (Claude Opus 4.6), Sonnet (Claude Sonnet 4.6), Gemini (Gemini 3.1 Pro), GPT (GPT 5.4)
**Rounds:** {N} discussion round(s)

---

{Main body — use the same topic format from Phase 1, populated with the committee's consensus}

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

## Discussion Log

### Round 1
{Brief summary: what was contested, key arguments, what was resolved}

### Round 2 (if applicable)
{Brief summary}

### Round 3 (if applicable)
{Brief summary}
```

## Guidelines

- **The main body is the deliverable.** It should stand alone — a reader should not need to read the provenance or discussion log to understand the conclusions.
- **Preserve dissenting wisdom.** If a minority position had merit (e.g., noted a real risk), incorporate it into the main body as a caveat or concern, even if the majority went a different direction.
- **Be specific.** Vague consensus is worse than no consensus. Every conclusion should be grounded in the committee's reasoning.
- **The provenance section is for transparency.** It shows how much natural agreement existed vs. how much was negotiated.
