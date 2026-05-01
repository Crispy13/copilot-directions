---
name: plan-duck
description: Produce a planning artifact that has been reviewed by both the caller and a separate cross-model RubberDuck critic before the caller commits to it. ANY agent — orchestrator or plain Copilot — should reach for this skill whenever planning is on the table, instead of drafting a plan solo. Trigger when the user asks for a plan, roadmap, phased rollout, or step-by-step approach ("plan this", "make a plan", "outline the steps", "how would you approach X", "design an approach"), AND also when the agent is about to plan on its own initiative for a non-trivial change — refactors, migrations, multi-file features, design changes, or anything where a solo draft might miss assumptions or edge cases. The skill exists because a solo plan draft is often confidently wrong; a Caller Review plus a RubberDuck Review catch direction errors and architectural blind spots before any work starts. Do NOT use for trivial single-step changes that don't need a plan.
context: fork
---

# Plan-Duck

A planning recipe that runs the **Draft → Caller Review → RubberDuck Review** sequence on a single plan file before the caller acts on it. The output is one mutated plan file at a known path; the two review passes leave their marks on the plan itself, not in separate files.

## Why this exists

A solo plan draft tends to produce plans that *look* coherent but quietly skip assumptions, miss edge cases, or take questionable architectural turns. Two cheap, structurally different reviews catch most of these:

- **Caller Review** — the calling agent re-reads the plan against the context it already has (files seen, constraints stated by the user, prior conversation). It catches plans that drift from what the user actually asked for.
- **RubberDuck Review** — a separate cross-model critic that has *not* seen the planning conversation. It catches plans that are internally consistent but architecturally suspect, missing failure modes, or built on shaky assumptions.

The two reviewers see different things. Skipping either is the failure mode this skill exists to prevent.

## When to invoke

The caller invokes plan-duck whenever a plan is needed. The skill handles its own internal sequencing; the caller just writes the plan path it wants and follows the steps below.

## Procedure

### 1. Draft the Plan

Follow the instructions of `$HOME/.vscode-server/data/User/globalStorage/github.copilot-chat/plan-agent/Plan.agent.md`
to write the **full plan** to a known plan-file path (default: `/memories/session/plan.md`).

If you can't resolve the path, then stop and report that you can't find base planning instructions.

The plan must contain:
- A numbered list of steps.
- Per-step **measurable acceptance criteria**.
- The files the step touches (paths) when known.
- Any non-obvious assumptions made.

### 2. Caller Review

The caller — the agent invoking this skill — reads the plan file directly. Validate against:

- The user's stated goal (does each step move toward it?)
- Known constraints from the conversation (anything the user said "not X" or "must Y"?)
- Files and code already inspected (does the plan match the actual structure, or is it imagining a structure?)
- Acceptance criteria (are they actually measurable, or vague?)

Apply fixes **directly to the plan file**. Do not produce a separate review document. If a concern is valid but you choose not to fix it, write a short note inside the plan explaining why (e.g., a `> Note: …` quote line under the affected step).

### 3. RubberDuck Review

Invoke the `rubberduck-review` skill at the `plan` checkpoint with:

- The plan file path.
- Any context the caller wants the duck to weigh (e.g., "this plan must work without breaking the existing CI pipeline").
- **If reviewing a sub-plan against an already-approved parent plan:** include the parent plan path and note the compliance intent — e.g., *"This is a sub-plan for step N of the parent plan at `<parent-path>`. Review for compliance with the parent's scope and constraints, not just standalone direction."*

The skill returns `VERDICT: NO_CONCERNS` or `VERDICT: CONCERNS` with mitigations.

**Handling the response:**

- `VERDICT: NO_CONCERNS` → proceed.
- `VERDICT: CONCERNS` → for each concern, either:
  - **Fix it** by editing the plan file directly, or
  - **Record why it's acceptable** as a short note inside the plan (e.g., `> RubberDuck noted X; accepted because Y`).

Do not produce a separate review document. Everything lives in the plan file.

### 4. Single iteration

This skill runs the cycle exactly once: Draft → Caller Review → RubberDuck Review → done. Do **not** loop the reviews until both reviewers say `NO_CONCERNS`. One pass through both reviewers is the contract; if downstream work reveals the plan was wrong, a fresh plan-duck invocation produces the next plan.

## Output

A single plan file at the agreed path (default `/memories/session/plan.md`) containing:

- The numbered plan with acceptance criteria.
- Inline edits from the Caller Review.
- Inline edits or `> Note:` quote lines reflecting the RubberDuck Review outcome.

No separate review files. The plan file is the artifact.

## Anti-patterns

- **Skipping RubberDuck.** RubberDuck is non-optional. The caller cannot self-review on behalf of the duck; the value comes from the duck not having seen the planning conversation.
- **Producing a separate review file.** Reviews go *into* the plan file. Side files create desync between what the plan says and what the caller actually believes.
- **Looping until quiet.** If both reviewers raised concerns and you fixed them, ship. Do not re-summon RubberDuck on the fixed plan looking for a clean run; that turns plan-duck into a polish loop instead of a sanity check.
- **Treating `NO_CONCERNS` as approval of correctness.** It means RubberDuck did not see direction-level red flags. The plan can still be wrong in ways neither reviewer caught. Plan-duck reduces risk; it does not eliminate it.
- **Calling plan-duck on a one-line change.** If the work is a single trivial edit, just do it. Plan-duck is for plans worth reviewing.

## Caller boilerplate

Skills and agents that want plan-duck at a planning checkpoint can include a short reference:

```markdown
#### Planning
Use the `plan-duck` skill to produce the plan: it will have you draft the plan, then your Caller
Review pass on the plan file, then a RubberDuck Review via the `rubberduck-review` skill. Apply fixes
directly to the plan file. The artifact is one plan file at /memories/session/plan.md.
```
