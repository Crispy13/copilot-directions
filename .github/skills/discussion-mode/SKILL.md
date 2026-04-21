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

**Loop-mechanic invariant.** Every in-loop response you send MUST end with a `vscode_askQuestions` call. The widget is the loop mechanic — it is how the user replies inside the loop. Prose-only responses (no `vscode_askQuestions`) are **implicit exits**: the loop becomes invisible to the user and the mechanic breaks. If you find yourself about to send a response without calling `vscode_askQuestions`, stop — you are either (a) exiting (go through the full Exit Turn A/B/C) or (b) still in-loop and must ask. Acknowledgments, pause acceptances, status updates, and "waiting for you" messages all still require a `vscode_askQuestions` call at the end. Reframe the ask as "ready when you are — anything to refine meanwhile?" or similar.

**Pause / wait replies are in-loop content.** When the user says "wait", "hold on", "pause", "not yet", "let me think", or "good but wait" — they are not exiting and not triggering exit. Acknowledge the pause inside a `vscode_askQuestions` call. Do NOT send a prose-only "waiting for you" message. Example response: call `vscode_askQuestions` with a short acknowledgment header and a question like "Standing by. Anything to refine or inspect while you think?" with options including "Still thinking" / "Inspect X" / a freeform input.

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
- Pause replies like "wait", "hold on", "good but wait", "let me think" — in-loop content; reply with `vscode_askQuestions`, not prose
- Running out of things to ask about — the user decides when they're done, not you
- A feeling that "enough" iterations have passed
- The agent completing an in-loop task — finishing means looping back, not exiting
- Sending a prose-only response without `vscode_askQuestions` — this is an implicit exit and breaks the loop

### Exit

Exit requires two turns — one from the user to trigger it, one from the user to confirm it. The agent never exits on its own, and never collapses both turns into one.

**Exit-gate rule.** You have not exited discussion-mode until BOTH of the following are true:

1. You sent a Turn B confirmation question via `vscode_askQuestions` and nothing else in that turn.
2. The user replied to that Turn B question with an explicit confirmation (see Turn C).

If either is missing, you are still in-loop. Do not resume workflow. Do not dispatch subagents. Do not execute multi-step tasks. Do not "proceed". Skipping Turn B or Turn C — even once — is a protocol violation, not a shortcut. The two-turn handshake is mandatory even when the user's end-phrase looks decisive.

**Self-check before resuming workflow.** Before taking any post-exit action (resuming the paused workflow, dispatching a subagent, running a task tied to the discussion outcome), verify out loud to yourself:

- [ ] Did I send a Turn B `vscode_askQuestions` confirmation in a dedicated turn with no other content?
- [ ] Did the user reply to that confirmation with a clear "yes / confirm / proceed" in a separate message?

If either answer is no, stop. You are still inside the loop. Send the missing Turn B now.

**Turn A — User triggers exit with an explicit end-of-discussion phrase.** Only these phrases qualify:

- "end discussion" / "end discuss" / "done discussing"
- "that's all"
- "complete the goal" / "finish this"

No other phrase triggers exit. Action-words like "implement it", "go ahead", "build it", "ship it", "deploy it", "make the changes", "start work", "proceed", "execute", "do it" are **in-loop content**. If the user says one of those, treat it as refinement or as an in-loop action (see Loop step 4) — do not start the exit path.

If the user wants to exit, they must say one of the explicit end-phrases above. If they repeatedly use action-words, you may gently note in chat "I'll stay in discussion-mode until you say 'end discussion'" — but do not exit.

**Turn B — Agent asks the confirmation question via `vscode_askQuestions`.** Turn B is **mandatory**. When Turn A's trigger arrives, your very next response must be exactly one `vscode_askQuestions` call and nothing else — no accompanying chat text, no other tool calls, no summary, no "I'll now begin". This is the hard gate between discussion-mode and the resumed workflow. Recall the workflow you paused to enter discussion-mode, name the exact next phase or remaining steps, and use that in the question header:

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

**Keep the backing artifact in sync.** If the discussion is about a file-backed artifact (a plan file, a design doc, a spec), every user-agreed change must be written back to the file **before** the next `vscode_askQuestions` turn. The chat transcript is not authoritative; the file is, because downstream subagents will read the file, not the chat. Before exiting discussion-mode (Turn B), re-read the backing file and confirm every agreed change is present. If the discussion is about an unwritten idea (no backing file), this guideline doesn't apply.

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

**Implicit exit via omitted Ask.** Ending an in-loop turn with prose only — no `vscode_askQuestions` call — is an implicit exit even if you mentally think "I'm still in the loop". The loop mechanic is the widget; without it, the user has no in-loop reply surface and the conversation drops out. This failure mode is especially seductive when the user says "wait" or "good but wait": it feels polite to reply "waiting for you" in prose, but that breaks the mechanic. Acknowledge inside a `vscode_askQuestions` call instead (e.g., header: `standby`, question: "Standing by. Anything to refine or inspect while you think?").

**Skipping Turn B.** Receiving an end-phrase and going directly to resumed workflow — dispatching subagents, running tasks, sending the final summary — without first sending a standalone Turn B `vscode_askQuestions` confirmation is a protocol violation, not an optimization. The end-phrase alone does not exit discussion-mode; it only requests the exit gate. Turn B is the gate. Common forms of this violation: (a) replying to the end-phrase with prose plus a subagent dispatch in the same turn; (b) treating a decisive-sounding end-phrase like "finish this now" as permission to skip the gate; (c) bundling the Turn B question together with partial execution "to save a round trip". All three exit the loop illegally. The fix is always the same: your next response after an end-phrase is exactly one `vscode_askQuestions` call, and nothing else, and you wait for Turn C.

**Agreeing in chat but not updating the backing file.** When discussion concerns a file-backed artifact (plan file, design doc, spec), agreeing to a change verbally while leaving the file untouched is a silent desync. Downstream subagents read the file, not the chat — they will work from the stale version and produce wrong output, and you won't notice until implementation review. Every user-agreed change must land in the file before the next turn; before Turn B, re-read the file and confirm every agreed change is present. If you find yourself typing "I'll update the plan when we're done discussing", stop and update it now.
