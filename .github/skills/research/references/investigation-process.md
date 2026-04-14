# Investigation Process

Use this reference when the Chief asks you to conduct deep research as a committee member. Pair it with the committee-member skill's rules: investigate independently, do not edit code, do not talk to the user, do not read other members' draft files, and save your final draft to the Chief-specified path with the memory tool. The Chief provides the report format and destination; your job is to produce evidence-backed analysis that can stand on its own.

## Query Type

The Chief specifies the query type in the dispatch prompt. Use it to calibrate your investigation and draft emphasis:

- **Technical Deep-Dive** → trace code paths, follow dependencies; emphasize component breakdowns and data flow
- **Comparison** → gather facts against shared criteria; emphasize tradeoff matrix and recommendation
- **Process / How-To** → find examples, trace steps; emphasize step-by-step guidance and pitfalls
- **Conceptual** → read authoritative sources; emphasize narrative explanation and practical application

## 1. Scope

Define the investigation before you start searching. A precise frame keeps you from spending effort on interesting but irrelevant branches.

- Restate the research question in concrete, answerable terms.
- Mark clear boundaries: what is in scope, what is out, and what assumptions the Chief has already fixed.
- Calibrate depth to the stakes, deadline, and ambiguity in the brief.
- Let the query type shape the investigation plan. A deep-dive wants traced behavior, while a comparison wants symmetric evidence.
- Decide what would count as a sufficient answer so you know when to stop.

## 2. Investigate

Go broad first, then deep on the threads that change the conclusion. This reduces the risk of overcommitting to the first plausible explanation.

- Start with primary sources such as code, official docs, specifications, and observed behavior.
- Use secondary sources to orient yourself or cross-check terminology, not to replace direct evidence.
- Begin from likely entry points and work inward; reading everything produces noise faster than understanding.
- Launch 2-3 Explore subagents in parallel when the brief spans independent areas. Split by subsystem, option, or source domain so each pass can think clearly.
- Keep notes as you go. Research quality falls off when you expect yourself to remember twenty tool calls later.
- Track dead ends and missing evidence. What you failed to find can narrow the answer or lower confidence in a useful way.
- Treat an effort budget of roughly 20+ tool calls as a prompt to check whether you are still learning or just circling.
- Stay independent. Do not read other members' draft files, even if you suspect overlap, because false consensus weakens the committee.

## 3. Analyze

Turn collected facts into a position. Analysis is where research becomes useful to the Chief instead of turning into a pile of notes.

- Separate direct facts from inferences so confidence stays honest.
- Look for repeated patterns across sources; recurring signals usually matter more than one-off anecdotes.
- Identify contradictions, tensions, and edge cases. Those often reveal the real tradeoffs.
- Compare evidence strength, not just evidence quantity. One direct code path can outweigh several summaries.
- For comparisons, evaluate every option against the same criteria so the conclusion is fair and legible.
- Assess confidence explicitly: where is the evidence strong, where is it thin, and what assumptions are carrying the gap.

## 4. Draft

Follow the exact structure named in the Chief's dispatch prompt. Consistent structure lets the Chief compare drafts cleanly and preserve the intended report shape.

- Address every required heading and every part of the brief.
- Make the draft self-contained so a reader without conversation context can still follow the reasoning.
- Ground claims in concrete evidence: file paths, functions, constraints, observed behavior, official docs, or credible external sources.
- Give examples when they sharpen the claim; evidence beats preference.
- Include explicit tradeoffs and at least one meaningful risk. Research is most useful when it shows what could go wrong, not just what looks attractive.
- Make recommendations actionable: state what to do, why it is preferred, and what effect or limitation follows.
- Distinguish high-confidence conclusions from assumptions, speculation, and open questions.
- Report dead ends when they ruled out a theory, narrowed the space, or explain a confidence limit.

## 5. Self-Review

Review your own draft before saving it. A short critique pass usually finds the weak link faster than another unfocused search.

- Ask whether the investigation is deep enough for the scoped question, not for every adjacent curiosity.
- Check that each major claim is backed by evidence or clearly labeled reasoning.
- Look for missing edge cases, alternative explanations, or asymmetry between compared options.
- Verify that the draft follows the Chief's required format and does not invent new sections.
- Confirm that tradeoffs, risks, confidence, and open questions are all present where the evidence calls for them.
- If a gap would materially change the conclusion, loop back to Investigate with a targeted question.
- When the draft is strong enough, save it to the Chief-specified path using the memory tool.