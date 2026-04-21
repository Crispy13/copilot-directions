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

**Loop invariant.** You are inside discussion-mode. You cannot leave this loop on your own. The only way out is the explicit Exit trigger defined below (an end-of-discussion phrase like "end discussion") followed by a dedicated confirmation reply from the user. Any other user message — no matter how action-like it sounds — is in-loop content. Treat "implement it", "go ahead", "build it", "ship it", "do it", "proceed", "start", "execute" as refinement or as in-loop actions, not as exit signals.

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
4. **In-loop actions** — When the user orders a bounded task that informs the discussion — "investigate X", "look into Y", "research this approach", "draft an alternative plan", "check if Z is feasible", or even "try a small implementation to test this idea" — execute that task and return with the results as the next iteration. These tasks deepen the shared understanding; they are not exit signals. Small, scoped implementation work is allowed inside discussion-mode when it helps validate an idea; it still does not end the loop. After completing the task, present the results and loop back to step 1.
5. **Loop back** — Return to step 1 with the revised version or new findings. Never assume the discussion is over.

Stay in this loop until the user triggers Exit explicitly. Do not auto-exit based on:
- The user saying "looks good" or "that works" — feedback, not an exit signal
- Action-words like "implement it", "go ahead", "build it" — in-loop content, not exit signals
- Running out of things to ask about — the user decides when they're done, not you
- A feeling that "enough" iterations have passed
- The agent completing an in-loop task — finishing means looping back, not exiting

### Exit

Exit requires two turns — one from the user to trigger it, one from the user to confirm it. The agent never exits on its own, and never collapses both turns into one.

**Turn A — User triggers exit with an explicit end-of-discussion phrase.** Only these phrases qualify:

- "end discussion" / "end discuss" / "done discussing"
- "that's all"
- "complete the goal" / "finish this"

No other phrase triggers exit. Action-words like "implement it", "go ahead", "build it", "ship it", "deploy it", "make the changes", "start work", "proceed", "execute", "do it" are **in-loop content**. If the user says one of those, treat it as refinement or as an in-loop action (see Loop step 4) — do not start the exit path.

If the user wants to exit, they must say one of the explicit end-phrases above. If they repeatedly use action-words, you may gently note in chat "I'll stay in discussion-mode until you say 'end discussion'" — but do not exit.

**Turn B — Agent asks the confirmation question via `vscode_askQuestions`.** When Turn A's trigger arrives, your very next message is the confirmation question and nothing else. Recall the workflow you paused to enter discussion-mode, name the exact next phase or remaining steps, and use that in the question header:

```
"Are you sure to exit discussion mode and proceed to {next workflow step} with the discussed {plan / design / result}?"
```

Example: workflow is Plan → Review → Implement, checkpoint sits after Plan:
`"Are you sure to exit discussion mode and proceed to Review → Implement with the discussed plan?"`

Calling `vscode_askQuestions` ends your turn and waits for the user's reply. Do not write anything after the question — no "I'll now begin...", no summary, no partial execution. The question is the entire message.

**Turn C — User replies; agent acts on the reply.** If the reply is a clear confirmation ("yes", "confirm", "exit", a restatement of the next step), exit discussion-mode and resume the workflow. Any other reply — refinement, a bounded task, hesitation, an action-word — cancels the pending exit. Treat it as a normal loop iteration and loop back to Loop step 1.

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
and iterate via `vscode_askQuestions`. The only way out is an explicit end-of-discussion
phrase from the user such as "end discussion", "done discussing", "that's all",
"complete the goal", or "finish this". Action-words like "implement it", "go ahead",
"build it", or "ship it" are in-loop content and never exit the loop — treat them as
refinement or in-loop tasks. When the user does use an end-of-discussion phrase, your
very next message is a `vscode_askQuestions` confirmation naming the next workflow step
(derive it from your own workflow context), and nothing else — end the message there.
Exit only after the user explicitly confirms that follow-up question in a separate
reply. See the `discussion-mode` skill for the full protocol.
```

This keeps the referencing skill lean while pointing to a single source of truth for the loop behavior.

## Anti-Patterns

**Using this for trivial decisions.** "Should I name the variable `count` or `total`?" does not need a deliberate dialog loop. Use simple inline questions for low-stakes choices.

**Asking the same question repeatedly.** If the user already answered something, don't ask again in the next iteration. Track what's been settled.

**Turning it into an interview.** Deliberate dialog is a refinement loop, not a requirements-gathering session. If you need to understand the problem from scratch, that's a different activity (brainstorming, research scoping). This skill assumes you already have a draft understanding and are confirming it.

**Treating action-words as exit signals.** "Implement it", "go ahead", "build it", "ship it", "start work", "proceed", "execute", "do it" are NOT exit signals. They are in-loop content. Exiting the loop when the user says one of these — even after asking a confirmation question — is a protocol violation. Only the explicit end-of-discussion phrases trigger the exit path.

**Collapsing Turn B and Turn C into one turn.** Your confirmation question in Turn B ends your turn. Writing anything after the `vscode_askQuestions` call — a summary, an "I'll now begin", a partial step — skips the user's reply and defeats the handshake. If you find yourself typing past the question, stop and delete what you wrote.
