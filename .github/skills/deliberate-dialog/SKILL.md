---
name: deliberate-dialog
description: >-
  Structured iterative confirmation loop using vscode_askQuestions. Use this skill whenever you
  need to confirm user intent before committing to expensive, destructive, or ambiguous actions —
  deploying code, deleting resources, choosing between competing approaches, or starting a major
  refactor. Also use when presenting plans, designs, or research directions for user approval.
  Triggers on situations where misunderstanding the user's intent would waste significant time or
  tokens, or where the user explicitly asks to discuss something before proceeding. Other skills
  and agents should reference this skill when they need a confirmation checkpoint. Do NOT use for
  simple yes/no confirmations or trivial decisions where a single question suffices.
---

# Deliberate Dialog

A protocol for iterative back-and-forth confirmation between the agent and user. Instead of a one-shot "here's the plan, confirm?" followed by immediate execution, this skill establishes a conversation loop where the user can refine, redirect, or reshape the agent's understanding before any action is taken.

## Why This Exists

LLM agents are eager to act. That eagerness is usually good — it means fast results. But it backfires when the agent misunderstands intent: tokens get burned, wrong files get modified, research goes in the wrong direction. The cost of a 30-second confirmation loop is trivial compared to the cost of undoing 5 minutes of wrong work.

This skill is the structured version of "let's talk about this before you do it." It sits between understanding the request and executing it.

## When to Use

This skill is opt-in — agents and skills that want structured confirmation reference it explicitly. The situations where it pays for itself:

- **Pre-execution confirmation:** Plans, designs, or approaches that will be dispatched to implementation agents. The user should see and shape these before they become work.
- **Destructive or expensive actions:** Deployments, deletions, large refactors, or anything that's hard to reverse. A quick loop catches "wait, not that database" moments.
- **Ambiguous intent:** The user's request could reasonably be interpreted multiple ways. Rather than guessing, loop until the interpretation is clear.
- **Research direction:** Before spending tokens on deep investigation, confirm the scope and angle match what the user actually needs.
- **Design discussions:** Brainstorming sessions where the output is a shared understanding, not a file.

## The Protocol

### Entry

Present your current understanding to the user — a plan, a design, a proposed approach, or a restated interpretation of their request. Use `vscode_askQuestions` to frame it as a discussion point, not a final answer.

The key question is some variant of: "Here's what I'm thinking. What would you change?"

### Loop

Each iteration follows the same cycle:

1. **Present** — Show the current version of whatever you're confirming (plan, approach, interpretation). Keep it concise — the user should be able to react quickly.
2. **Ask** — Use `vscode_askQuestions` to invite feedback. Frame questions to surface disagreement: offer alternatives, ask about specific concerns, or highlight assumptions you're unsure about.
3. **Incorporate** — Apply the user's feedback. If the feedback is vague, ask a focused follow-up rather than guessing.
4. **Loop back** — Return to step 1 with the revised version. Never assume the discussion is over.

The agent stays in this loop until the user explicitly exits. Do not auto-exit based on:
- The user saying "looks good" without an exit trigger (they might have more to add)
- Running out of things to ask about (the user decides when they're done, not you)
- A feeling that "enough" iterations have passed

### Exit

The user ends the loop with an explicit action trigger. Recognize these patterns:

- Direct commands: "implement", "do it", "go ahead", "execute", "proceed"
- Task-oriented: "work", "start", "build it", "ship it"
- Discussion closers: "end discuss", "done discussing", "that's all"
- Goal-oriented: "complete the goal", "finish this"

On receiving an exit trigger, proceed immediately to the next workflow phase. No second confirmation ("Are you sure?") — the explicit trigger is the confirmation.

### Practical Guidelines

**Keep presentations brief.** Each loop iteration should be scannable in seconds. If the plan is long, highlight what changed since the last iteration.

**Use options when possible.** `vscode_askQuestions` supports multiple-choice options — use them to make feedback low-friction. But always allow freeform input alongside options.

**Adapt question depth to context.** A deployment confirmation might need just 1-2 iterations. A design discussion might need 5-6. Don't front-load every possible question — let the conversation flow naturally.

**Don't interrogate.** If the user's feedback is clear and actionable, incorporate it and present the update. Don't add extra questions about things they didn't raise. The goal is confirming alignment, not exhaustive requirements gathering.

## How Other Skills and Agents Reference This

Skills and agents that want deliberate-dialog at a checkpoint include a brief reference in their instructions:

```markdown
#### Confirmation Checkpoint
Enter deliberate-dialog: present [the plan / the active plan / the approach] to the user
and iterate via `vscode_askQuestions` until the user gives an explicit action trigger
(e.g., "implement", "work", "go ahead"). See the `deliberate-dialog` skill for the full protocol.
```

This keeps the referencing skill lean while pointing to a single source of truth for the loop behavior.

## Anti-Patterns

**Using this for trivial decisions.** "Should I name the variable `count` or `total`?" does not need a deliberate dialog loop. Use simple inline questions for low-stakes choices.

**Asking the same question repeatedly.** If the user already answered something, don't ask again in the next iteration. Track what's been settled.

**Turning it into an interview.** Deliberate dialog is a refinement loop, not a requirements-gathering session. If you need to understand the problem from scratch, that's a different activity (brainstorming, research scoping). This skill assumes you already have a draft understanding and are confirming it.
