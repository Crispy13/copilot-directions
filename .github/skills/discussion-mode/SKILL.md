---
name: discussion-mode
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

1. **Present** — Save the current version of whatever you're confirming (plan, approach, interpretation) to memory. Then show the path and summarized content in chat. Don't write this to question title.
<Present-Example>
Here's the content I came up with based on your request. The full details are in `/memories/session/plan-v2.md`.
And the summary:
... markdown summary of the content ...

then use `vscode_askQuestions` with concise questions.
</Present-Example>
2. **Ask** — Use `vscode_askQuestions` to invite feedback. Frame questions to surface disagreement: offer alternatives, ask about specific concerns, or highlight assumptions you're unsure about.
3. **Incorporate** — Apply the user's feedback. If the feedback is vague, ask a focused follow-up rather than guessing.
4. **In-loop actions** — When the user orders a bounded task that informs the discussion — "investigate X", "look into Y", "research this approach", "draft an alternative plan", "check if Z is feasible" — execute that task and return with the results as the next iteration. These tasks deepen the shared understanding; they are not exit signals. After completing the task, present the results and loop back to step 1.
5. **Loop back** — Return to step 1 with the revised version or new findings. Never assume the discussion is over.

The agent stays in this loop until the user explicitly exits. Do not auto-exit based on:
- The user saying "looks good" without an exit trigger (they might have more to add)
- Running out of things to ask about (the user decides when they're done, not you)
- A feeling that "enough" iterations have passed
- The agent completing an in-loop task (finishing a research or investigation task means looping back, not exiting)

### Exit
You MUST not exit the loop without the second confirmation. (see below)

Only **implementation-specific** signals exit the loop. The user is signaling they want code written, files changed, or systems affected:

- Implementation commands: "implement [it]", "build it", "ship it", "write the code", "make the changes", "apply [it]", "code it up", "deploy it"
- Explicit discussion enders: "end discuss", "done discussing", "that's all"
- Goal-oriented: "complete the goal", "finish this"

**Ambiguous phrases** — "do it", "go ahead", "proceed", "work", "start", "execute" — are context-dependent:
- If the user just pointed at a specific sub-task (investigate, research, plan, look into something), treat it as an in-loop action. Execute the task and loop back.
- If it stands alone as a response to a plan or approach presentation with no sub-task in view, treat it as a potential exit and apply the second confirmation.

On receiving a clear exit signal, ask for a second confirmation ("Are you sure to exit discussion-mode and proceed to implementation?"). If the user confirms, proceed immediately to the next workflow phase.

### Behavior After Exit

Discussion-mode is a checkpoint inserted into a larger workflow — not a workflow of its own. When the user exits, **resume the caller's workflow at the exact step that follows the checkpoint.** Do not reinterpret the exit signal as a new instruction or skip ahead in the workflow.

The exit signal means "I approve what we discussed — now continue with your process." It does not mean "do whatever you think is best" or "skip ahead." Whatever the caller's workflow prescribes as the next step after the checkpoint, do that. Re-read your agent instructions if needed to recall where you left off.

This matters because long discussion loops erode the agent's sense of place in the workflow. After several iterations of presenting, asking, and incorporating feedback, the agent can lose track of its caller's process and default to acting on its own. Explicitly returning to the caller's workflow prevents this drift.

### Practical Guidelines

**Keep neutral.** The user may be right or wrong, so may you. Neither follow opinions blindly nor assume that your own perspective is always correct.

**Keep presentations brief.** Each loop iteration should be scannable in seconds. If the content is long, then save it to session memory and show the path to user in chat and highlight what changed since the last iteration in chat also.

**Use options when possible.** `vscode_askQuestions` supports multiple-choice options — use them to make feedback low-friction. But always allow freeform input alongside options.

**Adapt question depth to context.** A deployment confirmation might need just 1-2 iterations. A design discussion might need 5-6. Don't front-load every possible question — let the conversation flow naturally.

**Don't interrogate.** If the user's feedback is clear and actionable, incorporate it and present the update. Don't add extra questions about things they didn't raise. The goal is confirming alignment, not exhaustive requirements gathering.

## How Other Skills and Agents Reference This

Skills and agents that want discussion-mode at a checkpoint include a brief reference in their instructions:

```markdown
#### Confirmation Checkpoint
Enter discussion-mode: present [the plan / the active plan / the approach] to the user
and iterate via `vscode_askQuestions` until the user gives an explicit action trigger
(e.g., "implement", "work", "go ahead"). See the `discussion-mode` skill for the full protocol.
```

This keeps the referencing skill lean while pointing to a single source of truth for the loop behavior.

## Anti-Patterns

**Using this for trivial decisions.** "Should I name the variable `count` or `total`?" does not need a deliberate dialog loop. Use simple inline questions for low-stakes choices.

**Asking the same question repeatedly.** If the user already answered something, don't ask again in the next iteration. Track what's been settled.

**Turning it into an interview.** Deliberate dialog is a refinement loop, not a requirements-gathering session. If you need to understand the problem from scratch, that's a different activity (brainstorming, research scoping). This skill assumes you already have a draft understanding and are confirming it.
