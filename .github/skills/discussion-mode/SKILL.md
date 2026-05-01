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

## Vocabulary

Two fixed lists are referenced throughout the protocol:

- **End-of-discussion phrases** (the only phrases that trigger Exit Turn A): *"end discussion"*, *"end discuss"*, *"done discussing"*, *"that's all"*, *"complete the goal"*, *"finish this"*.
- **Action-words** (always in-loop content, never exit): *"implement it"*, *"go ahead"*, *"build it"*, *"ship it"*, *"deploy it"*, *"make the changes"*, *"start work"*, *"proceed"*, *"execute"*, *"do it"*.
- **DMAF aliases** ("discussion-mode after finish"): *"DMAF"*, *"dmaf"*, *"discuss after"*, *"discuss results"*, *"discuss when done"*. This means after the post-Turn-C work completes, enter discussion-mode again using this skill. **On DMAF re-entry, re-read this skill file before calling `vscode_askQuestions` for the first time** — context compression during the preceding task may have eroded the loop invariants.

## The Protocol

### Entry

> **DMAF re-entry:** If you are returning to discussion-mode after completing work (triggered by a DMAF alias), re-read this skill file *now* — before calling `vscode_askQuestions` — to restore the loop invariants and exit protocol in context.

Present your current understanding — a plan, a design, a proposed approach, or a restated interpretation of their request — via `vscode_askQuestions`. Frame it as a discussion point, not a final answer. The key question is some variant of: "Here's what I'm thinking. What would you change?"

### Loop

The loop has two invariants. They exist because without them the loop becomes invisible: the user loses their reply surface and the agent drifts into acting without confirmation.

**Invariant 1 — You cannot leave on your own.** The only way out is the explicit Exit protocol below. Feelings that "enough iterations have passed", or the user saying something decisive-sounding, or running out of questions — none of those exit the loop. Only an end-phrase followed by a Turn B/C handshake does.

**Invariant 2 — Every in-loop response ends with `vscode_askQuestions`.** The widget is the loop mechanic; it is how the user replies inside the loop. A prose-only response has no in-loop reply surface, so the user drops out and you've implicitly exited without the handshake. This holds even for acknowledgments and pauses: when the user says "wait", "hold on", "let me think", "good but wait", do not reply in prose — call `vscode_askQuestions` with a short acknowledgment (e.g., header `standby`, question *"Standing by. Anything to refine or inspect while you think?"*).

Each iteration follows the same cycle:

1. **Present.** Save the current version (plan, approach, interpretation) to memory. Show the path and a summarized content in chat — don't write long content into question titles.
   > Example preamble:
   > *Here's what I'm thinking based on your request. Full details: `/memories/session/plan-v2.md`.*
   > *Summary: … markdown summary …*

   Then call `vscode_askQuestions` with concise questions.
2. **Ask.** Frame questions to surface disagreement: offer alternatives, name assumptions you're unsure about, highlight specific concerns. Use options when they lower friction, but always allow freeform.
3. **Incorporate.** Apply feedback. If it's vague, ask a focused follow-up rather than guessing.
4. **In-loop actions.** When the user orders a bounded task that informs the discussion — "investigate X", "research this approach", "draft an alternative plan", "check if Z is feasible", even "try a small implementation to test this idea" — execute it and return with results as the next iteration. Small, scoped implementation work is allowed inside discussion-mode when it validates an idea. Finishing the task means looping back, not exiting.
5. **Loop back.** Return to step 1 with the revised version or new findings.

**Keep the backing artifact in sync.** If the discussion is about a file-backed artifact (plan file, design doc, spec), every user-agreed change must be written to the file **before** the next `vscode_askQuestions` turn. Downstream subagents read the file, not the chat — a verbal-only agreement is a silent desync that doesn't surface until implementation produces the wrong output. Before Turn B, re-read the file and confirm every agreed change is present. (If the discussion is about an unwritten idea with no backing file, this doesn't apply.)

### Exit

Exit requires two turns — one from the user to trigger it, one from the user to confirm it. Collapsing them, or skipping Turn B, exits the loop illegally and defeats the whole purpose of the handshake.

**Turn A — User triggers exit with an end-phrase.** Only the end-of-discussion phrases listed in Vocabulary qualify. Action-words don't. If the user uses action-words repeatedly, you may gently note in chat *"I'll stay in discussion-mode until you say 'end discussion'"* — but do not exit.

**Turn B — Agent sends a standalone confirmation question.** Your very next response after a Turn A trigger is exactly one `vscode_askQuestions` call and nothing else: no chat text, no other tool calls, no summary, no "I'll now begin". Recall the workflow you paused to enter discussion-mode, name the exact next phase or remaining steps, and use that as the question:

> `"Are you sure to exit discussion mode and proceed to {next workflow step} with the discussed {plan / design / result}?"`

Example: workflow is Plan → Review → Implement, checkpoint sits after Plan → *"Are you sure to exit discussion mode and proceed to Review → Implement with the discussed plan?"*

Calling `vscode_askQuestions` ends your turn. The reason Turn B is standalone is that bundling anything after it — a summary, a partial step, a subagent dispatch — skips the user's reply and defeats the handshake. The two-turn structure exists so the user has one clean opportunity to say "actually, wait".

**Turn C — User replies.** A clear confirmation ("yes", "confirm", "exit", a restatement of the next step) exits the loop and resumes the workflow. Any other reply — refinement, a bounded task, hesitation, an action-word — cancels the pending exit. Loop back to step 1.

**Self-check before resuming workflow.** Before dispatching a subagent, running a workflow step, or sending the final summary, verify: Turn B standalone confirmation sent ✓, Turn C user approval received ✓. If either is missing, you are still in-loop — send Turn B now.

### Practical Guidelines

- **Stay neutral.** The user may be right or wrong; so may you. Don't follow opinions blindly; don't assume your own is always correct.
- **Keep presentations brief.** Each iteration should be scannable in seconds. If content is long, save to session memory, show the path in chat, and highlight what changed.
- **Adapt question depth.** A deployment confirmation may need 1-2 iterations; a design discussion may need 5-6. Don't front-load every possible question; let the conversation flow.
- **Don't interrogate.** If feedback is clear and actionable, incorporate it and present the update. Extra questions about things the user didn't raise turn the loop into a requirements-gathering interview.

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

This keeps referencing skills lean while pointing to a single source of truth for the loop behavior.

## Anti-Patterns

These are failure modes that recur in practice. They all stem from the loop's invariants breaking down, usually because an agent felt a rule "didn't apply this time".

- **Trivial decisions.** "Should I name the variable `count` or `total`?" does not need a deliberate dialog. Use inline questions for low-stakes choices.
- **Repeated questions.** If the user already answered something, don't re-ask in the next iteration. Track what's been settled.
- **Requirements-gathering interview.** Discussion-mode refines a draft understanding; it doesn't gather requirements from scratch. If you need the problem defined, use brainstorming or research scoping first, then enter discussion-mode with a draft.
- **Acting on action-words.** "Implement it", "go ahead", "ship it", "proceed", "do it" are in-loop content. Treating any of them as an exit signal — even after a confirmation question — is a protocol violation.
- **Implicit exit via prose-only response.** Pause replies feel polite to answer with "waiting for you" in prose, but that drops the widget and breaks the mechanic. Acknowledge inside `vscode_askQuestions` instead.
- **Skipping or bundling Turn B.** Receiving an end-phrase and going directly to workflow — dispatching, running tasks, or bundling the Turn B question with partial execution "to save a round trip" — exits the loop illegally. The end-phrase alone does not exit; Turn B is the gate.
- **Agreeing in chat without updating the backing file.** "I'll update the plan when we're done discussing" is a desync. Downstream subagents read the file; update it before the next turn.
