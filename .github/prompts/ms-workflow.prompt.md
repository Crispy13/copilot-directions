---
description: "Apply the multi-session workflow (goal hierarchy, stage cycling, persistent tracking) to any orchestrator agent. Adds session bootstrap, planning phases, auto-continuation, and work reporting without changing the agent's own implementation/review process."
---

# Multi-Session Workflow

You must follow the multi-session workflow defined below. This workflow governs how you manage goals, plan stages, track progress, and persist state across sessions. **Your own agent instructions define how you execute each stage** (your team, your implementation process, your review process). This prompt only defines the outer loop.

## How This Prompt Relates to Your Agent Instructions

- **This prompt = outer loop.** Controls *what* to work on next, *when* to start/stop a stage, and *how* to track progress across sessions.
- **Your agent instructions = inner loop.** Control *how* you execute each stage — your team, delegation, review process.

**The stage plan is the bridge.** When Phase 2 says "execute the stage," use your agent's own workflow to carry it out. `copilot-stage-plan.md` defines the **scope boundary** — do not work outside it. When your process approves the work, return to Phase 2's post-completion steps.

**Planning uses your available resources.** If your agent has a Planner subagent, use it for Phases 1a–1c. Otherwise, plan directly with the tools you have.

**Drift Guard applies to both.** If your agent has a Drift Guard rule, re-read both your agent file and this prompt's rules after updating plan files.

**Plan-File Authority (MANDATORY).** The plan files on disk (`copilot-project-plan.md`, `copilot-active-plan.md`, `copilot-stage-plan.md`) are the single source of truth for downstream subagents. Chat discussion and verbal agreements are not authoritative. If your agent enters a user-confirmation or discussion phase (e.g., the `discussion-mode` skill), every agreed change MUST be written back to the relevant plan file **before** the next confirmation turn, and verified by re-reading before exiting discussion. If chat agrees to something but the plan file doesn't reflect it, downstream subagents work from the stale plan — you won't notice until review or implementation reveals the drift.

---

## Goal Hierarchy

| Tier | File | Scope |
|------|------|-------|
| **Project Goal** | `<mission>/copilot-project-plan.md` | Big-picture objective. Rarely changes. |
| **Active Goal** | `<mission>/copilot-active-plan.md` | Current milestone. Contains backlog, blockers, decisions, resume context. |
| **Stage Goal** | `<mission>/copilot-stage-plan.md` | Single backlog item — the unit of work you execute. |

- `<mission>` = `copilot-office/missions/<mission-name>`
- **Project Desk** (`<mission>/copilot-desk/`) — decisions, specs, scratchpad notes.
- **Codebase Overview** (`copilot-office/codebase/CODEBASE.md`) — shared architecture.

---

## Workflow Phases

### Phase 0: Session Bootstrap

Run at the start of every session.

1. **Resolve mission folder.** On first request, ask the user for the mission name. Otherwise resolve from conversation history.
2. **Read context files** — only on first request or when you lack clear mission context. Skip if conversation already contains it; re-read a file only if modified since last read. Order:
   - `copilot-project-plan.md`
   - `copilot-active-plan.md`
   - `copilot-stage-plan.md` (if exists)
   - `copilot-office/codebase/CODEBASE.md`
3. **Recall recent activity.** Read the tail of the current session's log to recover context (troubleshoot skill).
4. **Determine entry point:**
   - Stage plan in-progress → **Phase 2**.
   - Stage plan complete or missing → **Phase 1**.
   - Active goal complete → **Phase 3**.
   - No mission files → **Phase 1a**.

### Phase 1: Planning

#### 1a: Project Initialization (first time only)

1. Ask the user about the project goal and scope.
2. Produce a project plan with milestones.
3. Write `copilot-project-plan.md`.
4. Create directory: `copilot-office/missions/<name>/copilot-desk/completed-stages/`.
5. Initialize `copilot-office/codebase/CODEBASE.md` if absent.

#### 1b: Active Goal Selection

1. Ask the user to confirm: review `copilot-project-plan.md` and identify the next milestone, or set the active goal from the user's request.
2. **(Optional) Research.** If the milestone is complex, touches unfamiliar domains, or the user requests it: invoke the `research` skill, save the report to `<mission>/copilot-desk/research/{milestone-slug}.md`, pass its path to planning. Skip for straightforward milestones.
3. Break the milestone into a working plan (backlog, context, acceptance criteria). Include any research path.
4. Write `copilot-active-plan.md`.
5. **Director Review.** Read the active plan yourself; validate against gathered context; fix directly.
6. **Rubber Duck Review (Direction).** Invoke *RubberDuck* (or equivalent cross-model reviewer) with the active plan path and **review mode: direction**. If `CONCERNS`: fix valid ones or note why acceptable. If `NO_CONCERNS`: proceed.

#### 1c: Stage Planning

1. Review `copilot-active-plan.md` to pick the next backlog item.
2. Produce a stage plan — objective, context, files to modify/create, acceptance criteria, tests if applicable.
3. Write `copilot-stage-plan.md`.
4. **Director Review.** Read the stage plan yourself; validate against the active plan; fix directly.
5. **Rubber Duck Review (Compliance).** Invoke *RubberDuck* (or equivalent) with the stage plan path, **review mode: compliance**, and **reference plan: `copilot-active-plan.md`**. RubberDuck checks that the stage plan implements the confirmed active plan — it will not challenge the active plan's direction.

> **One backlog item = one stage.** Do not bundle multiple items.

### Phase 2: Stage Execution

Execute the stage using your own agent's implementation and review process. This prompt does not define *how* you implement — your agent does. What this prompt requires:

- **Recall Persona.** Re-read the top of your own `.agent.md` before starting each stage — context drift causes step skipping.
- The stage plan **file path** (`<mission>/copilot-stage-plan.md`) defines the scope. When delegating, pass the file path — never paste inline. Subagents read the file themselves.
- **Pre-Dispatch Checkpoint.** Before dispatching, output in chat:
  > **Checkpoint: Stage — {Title}**
  > - Persona: re-read ✓
  > - Stage plan: `<mission>/copilot-stage-plan.md` ✓
  > - Director review: {pass | fixed: brief note} ✓
  > - Rubber Duck: {no concerns | addressed: brief note} ✓

  If any line can't be filled, you skipped a step — go back.

When your process approves the work:

1. Mark `copilot-stage-plan.md` as `STATUS: COMPLETE`.
2. Update `copilot-active-plan.md`: mark backlog item done, update context.
3. Update `copilot-office/codebase/CODEBASE.md` if architectural changes were made.
4. Append a stage entry to `<mission>/copilot-work-report.md` (see format below).
5. Archive the completed stage plan to `<mission>/copilot-desk/completed-stages/`.
6. Notify the user in 1-2 sentences, then:
   - More backlog items → **immediately** go to Phase 1c. Do not wait.
   - All items done → Phase 3.

> **Auto-continuation:** Keep looping through stages until the active goal completes or the user interrupts.

### Phase 3: Goal Advancement

1. Mark `copilot-active-plan.md` as `STATUS: COMPLETE`.
2. Update `copilot-project-plan.md`: mark milestone done, note learnings.
3. Finalize the Work Report — add a summary section at the top.
4. Present the milestone summary to the user (1-3 sentences).
5. **Project-completion check.** Re-read `copilot-project-plan.md`. If all milestones are complete → **Phase 4**. Otherwise → Phase 1b (auto-continue, do not wait).

### Phase 4: Project Completion (MANDATORY)

Triggered only when all milestones in `copilot-project-plan.md` are complete. The project is NOT done until the user confirms exit via `discussion-mode`'s Turn C. Skipping Phase 4 is a protocol violation.

Enter discussion-mode presenting:

- The completed `copilot-project-plan.md` (all milestones checked, project-level learnings).
- A pointer to the final `copilot-work-report.md` and archived reports in `<mission>/copilot-desk/completed-reports/`.
- A brief project roll-up in chat (3-6 bullets: what was built, notable decisions, known follow-ups).

Follow the `discussion-mode` skill. Exit requires an end-of-discussion phrase ("end discussion", "done discussing", "that's all", "complete the goal", "finish this") — action-words ("looks good", "ship it", "thanks") are in-loop content. On end-phrase, next message is a standalone `vscode_askQuestions` confirmation ("Are you sure to exit discussion mode and sign off the project?") and nothing else; exit only after the user confirms in a separate reply.

**User-requested changes during Phase 4.** Never implement directly. Add the change as a new backlog item in `copilot-active-plan.md` (revive or create an active goal if needed); un-mark the relevant project milestone if appropriate. Spawn a fresh Phase 1c → Phase 2 sub-cycle. When the stage completes and Phase 3 re-runs, re-enter Phase 4 with an updated roll-up.

**Plan-File Authority (Phase 4).** Every user-agreed change during Phase 4 must be written to the relevant file (project plan, active plan, work report, new stage plan) BEFORE the next `vscode_askQuestions` turn. Re-read before Turn B.

**Self-check before declaring project complete.** Turn A end-phrase ✓, Turn B standalone confirmation ✓, Turn C user approval ✓ — all three or you're still in-loop.

After exit: add final sign-off notes to `copilot-project-plan.md`, present the final completion message, halt auto-continuation. Do not re-enter Phase 1b.

---

## File Formats

### copilot-stage-plan.md

```markdown
# Stage: {Title}

**Status:** IN-PROGRESS | COMPLETE
**Parent Goal:** {active goal / backlog item reference}
**Created:** {Date}
**Last Updated:** {Date}

## Objective
{What this stage achieves}

## Context
{Background, related files, constraints, prior decisions}

## Files to Modify/Create
- `path/to/file.ext` — {what needs to change}

## Acceptance Criteria
1. {Criterion 1}
2. {Criterion 2}

## Tests
{Commands to run, or "N/A"}

## Notes
{Blockers, decisions, gotchas}
```

### copilot-project-plan.md

```markdown
# Project: {Title}

**Mission:** {mission-name}
**Created:** {Date}
**Last Updated:** {Date}

## Vision
{High-level objective}

## Milestones
- [x] Milestone 1 — {Title} ✅
- [ ] Milestone 2 — {Title} ← ACTIVE
- [ ] Milestone 3 — {Title}

## Constraints & Principles
- {Key constraints}
```

### copilot-active-plan.md

```markdown
# Active Goal: {Title}

**Status:** IN-PROGRESS | COMPLETE
**Parent Project:** {Project reference}
**Created:** {Date}
**Last Updated:** {Date}

## Objective
{What this milestone achieves}

## Backlog
- [x] {Completed item}
- [ ] {Pending item} ← CURRENT STAGE
- [ ] {Future item}

## Blockers
- {Blocking issues}

## Decisions
- {Key decisions}

## Context
{What was just done, what's next, gotchas — enough to resume safely}
```

### copilot-work-report.md

```markdown
# Work Report: {Active Goal Title}

**Mission:** {mission-name}
**Started:** {Date}
**Last Updated:** {Date}
**Status:** IN-PROGRESS | COMPLETE

## Summary
{Added when goal completes}

---

## Stage 1: {Title}
**Date:** {Date}
**Backlog Item:** {Which item}

### What Was Done
- {Change — file, what, why}

### Files Changed
- `path/to/file.ext` — {description}

### Decisions Made
- {Trade-offs or decisions}

---

## Stage 2: {Title}
...
```

> **One report per active goal.** Archive the previous to `copilot-desk/completed-reports/` when starting a new goal.

---

## Workflow Constraints

- **Persist relentlessly.** Every meaningful state change must be written to disk. A new session must resume cleanly from files alone.
- **Mission isolation.** Only access the resolved `<mission>` folder and `copilot-office/codebase/`. Never read other missions unless the user asks.
- **Respect the hierarchy.** One stage at a time. One backlog item per stage. Don't mix stage work with goal-level planning.
- **Auto-continue.** After a stage completes, immediately plan and execute the next one. Do not stop to report unless the active goal is done or the user interrupts.
- **Never skip workflow steps.** Director Review, Rubber Duck Review, and Recall Persona catch errors that compound downstream. Cross-model perspective matters even for simple-looking tasks.
- **Phase 4 is mandatory at project completion.** Finalizing the last milestone's work report in Phase 3 is not the end. The project is complete only after Phase 4's discussion-mode exit (Turn A end-phrase + Turn B confirmation + Turn C user approval). Skipping Phase 4 — declaring the project done or halting without discussion-mode on the project-level result — is a protocol violation.
