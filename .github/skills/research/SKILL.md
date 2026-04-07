---
name: research
description: >-
  Deep research and investigation that produces a comprehensive Markdown report. Use this skill
  whenever a question requires thorough investigation rather than a quick answer — codebase
  architecture analysis, technology comparisons, implementation pattern discovery, API deep-dives,
  understanding how systems work, or exploring unfamiliar domains. Triggers on "research this",
  "investigate", "deep dive into", "how does X work", "compare approaches for", "what's the
  architecture of", "explore how", "analyze the implementation of", or when you detect the
  question needs multi-source investigation that a single search can't answer. Also use when
  planning stalls due to unknowns, or when comparing technologies, libraries, or design
  approaches. Produces a saved report artifact, not code changes. Do NOT use for simple
  fact-checking, quick questions, or when the user wants code modifications.
argument-hint: "Describe the question or topic to investigate"
---

# Research

A search finds a piece of information. Research synthesizes multiple sources into understanding and produces a permanent Markdown report with evidence, confidence assessment, and actionable findings.

**Autonomous operation:** Do not interrupt with clarifying questions during research. Make reasonable assumptions, document them in the Confidence Assessment, and keep investigating. If the user's topic is vague, sharpen it yourself — restate the question precisely in the report's opening so the user can course-correct when they read it.

## When to Skip

Not every question needs research. If a single search or file read answers it, just answer. If the user wants code changes, implement directly (or research first, then implement). If prior research artifacts cover the topic, build on them rather than starting over — read the existing report, note what's changed, and update or extend it.

### Anti-Pattern: Research as Procrastination

Research is not a substitute for doing the work. If the answer is straightforward or the implementation is obvious, don't wrap it in a research report to appear thorough. The user asked "how does our auth middleware work" and you can answer in 3 file reads? Just answer. Research is for when the answer genuinely requires sustained investigation across multiple sources.

## Query Type Classification

Classify the question before investigating. The classification determines both the investigation strategy and the report format — a comparison investigated like a deep-dive wastes effort and produces a worse result.

| Type | Signal | Strategy | Report emphasis |
|---|---|---|---|
| **Technical Deep-Dive** | "how does X work", "architecture of" | Trace code paths, follow dependencies, read source | Component breakdowns, data flow, code references |
| **Comparison** | "compare", "which should we use" | Gather facts about each option against shared criteria | Tradeoff matrix, recommendation |
| **Process / How-To** | "how do I", "what's the process for" | Find existing examples, trace steps, identify docs | Step-by-step guidance, verification, pitfalls |
| **Conceptual** | "what is", "explain", "why does" | Read authoritative sources, build mental model | Narrative explanation, analogies, practical application |

Default to **Technical Deep-Dive** when unsure — it produces the most useful output for development work.

See [report formats](./references/report-formats.md) for the template for each query type.

## Investigation Process

### 0. Confirm Intent

Before spending tokens on investigation, enter deliberate-dialog: present your understanding of the research question, proposed scope, and query type to the user and iterate via `vscode_askQuestions` until the user gives an explicit action trigger (e.g., "go ahead", "research it", "investigate"). See the `deliberate-dialog` skill for the full protocol. This prevents wasting effort on a misunderstood direction — a 30-second confirmation loop is cheaper than a wrong report.

### 1. Scope

Define before investigating:

- **Research question** — precise and answerable. "How should we build auth?" is too vague. "What authentication approaches integrate with our Express + PostgreSQL stack given SSO requirements?" is actionable. If the user's question is vague, refine it yourself.
- **Boundaries** — what's in scope, what's out. Without boundaries, investigation expands endlessly into "related" topics.
- **Query type** — classify using the table above.
- **Depth calibration** — match effort to stakes. A library API check: 1-2 page report, 5-10 tool calls. An architecture decision affecting months of work: thorough 4-6 page report, 30+ tool calls.

### 2. Investigate

Go broad first to map the landscape, then deep on what matters.

**Effort budget:** If you've made 20+ tool calls without converging — are you still learning, or circling? If circling, write the report with what you have and flag the gaps. Incomplete findings with honest confidence markers beat exhaustive search with no synthesis.

**Strategic guidance:**

- Prioritize primary sources (code, official docs) over secondary (blogs, summaries) — primary sources are what decisions get built on
- Start from entry points and work inward — reading everything produces noise, not signal
- Document findings as you go — don't rely on memory across many tool calls
- Dead ends are findings — noting what you didn't find is valuable for Confidence Assessment

### 3. Analyze

This is where research becomes more than a collection of facts.

- Look for patterns across sources — what keeps coming up independently?
- Identify contradictions or tensions — these often reveal the most important tradeoffs
- Separate facts (grounded in evidence) from inferences (your reasoning) — this distinction is what makes Confidence Assessment honest
- For comparisons, evaluate all options against the same criteria
- Assess your own confidence — where is the evidence strong vs. thin?

### 4. Write the Report

Follow the [report format](./references/report-formats.md) for your query type. The report should stand on its own — a reader without conversation context should understand the findings, evidence, and reasoning.

Match report length to question complexity: a focused question gets a focused report (1-2 pages), not padding. A complex architecture question earns 4-6 pages.

**Save the report:**

- If a mission folder exists → `<mission>/copilot-desk/research/{topic-slug}.md`
- Otherwise → caller decides where to persist

### 5. Present and Transition

After saving the report:

1. **Summarize** — present key findings (3-5 bullet points), your recommendation if applicable, and a pointer to the full report file.
2. **Surface open questions** — if gaps remain, say so clearly. The user may want to investigate further or accept the uncertainty.
3. **Enable the next step** — research exists to inform action. Based on the findings:
   - If the research answers a planning question → the user can proceed to planning with the constraints and recommendations from the report
   - If the research compares options → present the recommendation and ask if the user wants to proceed with it
   - If the research reveals more unknowns → ask whether another round of research is needed or if the current findings are sufficient

Research that doesn't connect to the next action is just trivia.

## What Good Research Looks Like

**Concrete example — bad vs. good:**

Bad: "React and Vue are both popular frameworks with large communities."

Good: "React's `useEffect` cleanup model (`react/src/hooks.ts:L142`) maps cleanly to our existing subscription teardown in `services/events.ts:L87`, while Vue's `onUnmounted` would require restructuring our event lifecycle — see [Vue Lifecycle docs](https://vuejs.org/guide/essentials/lifecycle)."

The difference: the good version grounds claims in the actual codebase, cites sources, and connects findings to the specific decision.

**Hallmarks:**
- Claims cite sources (file paths, URLs, observed behavior)
- Confidence Assessment is honest — includes "medium" and "low" entries
- Open Questions captures genuine unknowns
- Self-contained — readable without conversation context
- Length matches question complexity

**Red flags:**
- Restates the question without adding understanding
- Lists facts without synthesizing patterns or recommendations
- Claims high confidence on everything
- Scope drifts from the original question

## Principles

- **The report is the artifact.** Unlike a chat message, the report is saved and referenced later. Write for a reader who doesn't have the conversation context.
- **Confidence is a feature.** The Confidence Assessment tells the reader which findings they can act on and which need verification. Documenting assumptions is more valuable than pretending certainty.
- **Know when to stop.** If you've answered the core question with reasonable confidence, write the report. Note open questions for follow-up rather than chasing diminishing returns.
