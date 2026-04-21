---
name: research
description: >-
  Deep research and investigation that produces a comprehensive Markdown report. Use for
  architecture analysis, technology comparisons, API deep-dives, implementation pattern discovery,
  and other multi-source questions a single search cannot answer. Triggers on "research this",
  "investigate", "deep dive into", "how does X work", or "compare approaches for". Also use
  when the user requests committee or multi-model research, or when planning stalls on unknowns.
  Not for simple fact-checking, quick questions, or code modifications.
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

Before spending tokens on investigation, enter discussion-mode: present your understanding of the research question, proposed scope, and query type to the user and iterate via `vscode_askQuestions`. The only way out is an explicit end-of-discussion phrase from the user such as "end discussion", "done discussing", "that's all", "complete the goal", or "finish this". Action-words like "investigate it", "go ahead", or "start the research" are in-loop content and never exit the loop — treat them as refinement or in-loop tasks. When the user does use an end-of-discussion phrase, your very next message is a `vscode_askQuestions` confirmation naming the next step (begin the research investigation with the confirmed scope), and nothing else — end the message there. Investigate only after the user explicitly confirms that follow-up question in a separate reply. See the `discussion-mode` skill for the full protocol. This prevents wasting effort on a misunderstood direction — a 30-second confirmation loop is cheaper than a wrong report.

### 1–4. Investigate and Write

Follow the [investigation process](./references/investigation-process.md) for the core workflow: Scope, Investigate, Analyze, Draft, and Self-Review. The process covers depth calibration, effort budgets, primary-source priority, and honest confidence assessment.

Use the [report format](./references/report-formats.md) matching your query type for the draft structure.

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

## Committee Mode

When the topic benefits from independent lines of inquiry — contested interpretations, ambiguous evidence, or high enough stakes that four parallel investigators surface more than one — use committee mode instead of single-agent research. Skip it when one researcher can answer cleanly; committee overhead only pays off when diverse perspectives change the outcome.

### How It Works

Run step 0 (Confirm Intent) normally, then hand off the investigation to the `committee` skill's Delphi process (Phases 1–4). Return to step 5 (Present and Transition) after the committee finishes.

Load the `committee` skill and apply these research-specific overrides:

| Setting | Override | Why |
|---------|----------|-----|
| **Format** | Custom → `.github/skills/research/references/report-formats.md`, section = classified query type | Preserves the report shapes readers already expect from research artifacts |
| **Member mode** | Mode: Custom (`committee-member` skill), workflow reference → `./references/investigation-process.md` | Members follow the custom mode with the research investigation workflow, without loading the full research skill (avoids recursive committee invocation) |
| **Deadlocks** | No user escalation — Chief resolves by evidence, records minority view and confidence limits | Research consumed its user checkpoint in step 0; mid-run tie-breaking stalls autonomous investigation |
| **Save location** | Research convention (`<mission>/copilot-desk/research/{topic-slug}.md` or caller-specified) | Where the report lives should not change because four models wrote it instead of one |

Follow the committee skill's procedure for everything not listed above — dispatch prompts, consolidation, discussion rounds, and final output format.

### Dispatch Prompt Template

```text
You are a committee member conducting research on the following topic:

Research question: {precise research question}
Boundaries: {what is in scope; what is out of scope}
Query type: {Technical Deep-Dive | Comparison | Process / How-To | Conceptual}
Depth calibration: {focused | moderate | exhaustive}
Known constraints: {codebase limits, deadlines, environment facts, or "none"}

Write your response to: /memories/session/committee/draft-{member-name}.md

Load the `committee-member` skill and follow Mode: Custom. Your workflow reference is `.github/skills/research/references/investigation-process.md` — read it and follow its full process (Scope → Investigate → Analyze → Draft → Self-Review).

Custom format reference: .github/skills/research/references/report-formats.md
Use the "{query type}" section from that file as the required structure for this draft.

Rules: Do NOT read other members' draft files. Investigate independently.
```

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
