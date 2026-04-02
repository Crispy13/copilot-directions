# Final Plan Format

Use this exact format when producing the final consensus plan in Phase 4. The plan section follows the default Plan agent's `plan_style_guide`.

```markdown
# Committee Plan: {Topic}

**Date:** {date}
**Committee:** Opus (Claude Opus 4.6), Sonnet (Claude Sonnet 4.6), Gemini (Gemini 3.1 Pro), GPT (GPT 5.4)
**Rounds:** {N} discussion round(s)

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

- **The Plan section is the deliverable.** It should stand alone — a reader should not need to read the provenance or discussion log to understand the plan.
- **Preserve dissenting wisdom.** If a minority position had merit (e.g., noted a real risk), incorporate it as a risk/mitigation even if the majority approach was chosen.
- **Be specific in verification.** "Run the tests" is not a verification step. "Run `npm test -- --filter=auth`" is.
- **The provenance section is for transparency.** It shows the user how much natural agreement existed vs. how much was negotiated.
