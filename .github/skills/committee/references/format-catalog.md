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