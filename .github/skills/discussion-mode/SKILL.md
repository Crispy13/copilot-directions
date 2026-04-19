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

A protocol for iterative back-and-forth confirmation between the agent and user. Instead of a one-shot "here's the plan, confirm?" followed by immediate execution, this skill creates a conversation loop where the user can refine, redirect, or reshape the agent's understanding before any action is taken.

## Why This Exists

LLM agents are eager to act. That eagerness is usually good — it means fast results. But it backfires when the agent misunderstands intent: tokens get burned, wrong files get modified, research goes in the wrong direction. The cost of a 30-second confirmation loop is trivial compared to the cost of undoing 5 minutes of wrong work.

This skill is the structured version of "let's talk about this before you do it." Use it between understanding the request and executing it.

## When to Use

This skill is opt-in — agents and skills that want structured confirmation reference it explicitly. Use it when the extra loop prevents avoidable mistakes:

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

Stay in this loop until the user explicitly exits. Do not auto-exit based on:
- The user saying "looks good" without an exit trigger (they might have more to add)
- Running out of things to ask about (the user decides when they're done, not you)
- A feeling that "enough" iterations have passed
- The agent completing an in-loop task (finishing a research or investigation task means looping back, not exiting)

### Exit

Use a strict second confirmation before leaving the loop. That extra pause matters because phrases like "implement" or "go ahead" can blur together after several iterations, and the user should see exactly what workflow resumes next.

Treat exit as a two-step handshake:

1. **Potential exit signal** — the user gives an implementation-specific or explicit discussion-ending instruction.
2. **Explicit confirmation** — you ask the second-confirmation question and stay in discussion-mode.

The first message never exits by itself. It only arms a pending-exit state and causes you to ask the second-confirmation question.

Only **implementation-specific** signals exit the loop. The user is signaling they want code written, files changed, or systems affected:

- Implementation commands: "implement [it]", "build it", "ship it", "write the code", "make the changes", "apply [it]", "code it up", "deploy it"
- Explicit discussion enders: "end discuss", "done discussing", "that's all"
- Goal-oriented: "complete the goal", "finish this"

**Ambiguous phrases** — "do it", "go ahead", "proceed", "work", "start", "execute" — are context-dependent:
- If the user just pointed at a specific sub-task (investigate, research, plan, look into something), treat it as an in-loop action. Execute the task and loop back.
- If it stands alone as a response to a plan or approach presentation with no sub-task in view, treat it as a potential exit and apply the second confirmation.

On receiving a clear exit signal, recall the workflow you paused to enter discussion-mode. Identify the exact next phase or remaining steps after this checkpoint and use that in the second confirmation. You already have this context from your own instructions, so do not ask the caller to pass an extra parameter.

Use the confirmation in this shape: "Are you sure to exit discussion mode and proceed to {next workflow step or remaining steps} with the discussed {plan / design / result}?"

Example: suppose your workflow is Plan → Review → Implement and the discussion checkpoint sits after Plan. The confirmation becomes: "Are you sure to exit discussion mode and proceed to Review → Implement with the discussed plan?"

Only an explicit reply to that second-confirmation question exits the loop. Accept clear confirmations like "yes", "confirm", "exit discussion mode", or a restatement of the exact next step. Do not treat the original exit signal as both the trigger and the confirmation, even if the wording was strong.

If the user answers the second-confirmation question with anything other than a clear confirmation, cancel the pending exit and continue the loop:
- If they refine the plan, incorporate the change and present the update.
- If they ask for a bounded task, run it as an in-loop action and return with results.
- If they answer ambiguously, ask a focused follow-up and remain in discussion-mode.

Never combine the second-confirmation question with resumed execution in the same message. Ask the confirmation, wait for the explicit second reply, then resume at the next workflow step immediately. Treat the exit as approval to continue the caller's process, not as license to improvise, reinterpret the goal, or skip ahead.

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
and iterate via `vscode_askQuestions` until the user gives an explicit action trigger.
Treat that trigger as the first step of a two-step exit: ask the second-confirmation question,
stay in discussion-mode, and exit only after the user explicitly confirms the follow-up
question. Derive the confirmation message from your own workflow context so the user sees what
happens next. See the `discussion-mode` skill for the full protocol.
```

This keeps the referencing skill lean while pointing to a single source of truth for the loop behavior.

## Anti-Patterns

**Using this for trivial decisions.** "Should I name the variable `count` or `total`?" does not need a deliberate dialog loop. Use simple inline questions for low-stakes choices.

**Asking the same question repeatedly.** If the user already answered something, don't ask again in the next iteration. Track what's been settled.

**Turning it into an interview.** Deliberate dialog is a refinement loop, not a requirements-gathering session. If you need to understand the problem from scratch, that's a different activity (brainstorming, research scoping). This skill assumes you already have a draft understanding and are confirming it.
