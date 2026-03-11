---
name: work_for_goal
description: Automates planning, execution, and reporting for the active mission autonomously.
---

<!-- 
This prompt does NOT require user confirmation between tasks, unlike `work_for_request`.
-->

# Workflow
You MUST perform the following workflow:

## Definitions
- `Mission goal`: the higher-level objective described in `copilot-office/<mission-name>/copilot-project-plan.md`.
- `Active plan`: `copilot-office/<mission-name>/copilot-active-plan.md`, which tracks the currently active goal and the working state needed to continue it.
- `Stage plan`: `copilot-office/<mission-name>/copilot-stage-plan.md`, which defines the next actionable stage to execute.
- `Active goal`: the concrete goal you are currently trying to achieve in this run. It may be a user-provided subgoal or, if no subgoal is active, the mission goal itself.
- `Stage objective`: the specific slice of the active goal described in the current stage plan.

## 0. Resolve The Active Goal
- First resolve `copilot-office/<mission-name>/` using `../instructions/project_context.instructions.md`.
- Then determine the `active goal` using this priority:
1. If the user gives an explicit request in the current prompt, that request is the active goal.
2. Otherwise, if session history or `copilot-office/<mission-name>/copilot-active-plan.md` already shows an unresolved active goal, continue that active goal.
3. Otherwise, use the mission goal from `copilot-office/<mission-name>/copilot-project-plan.md` as the active goal.
- Do not confuse the mission goal with the active goal. The mission goal is the larger objective; the active goal is what you are currently pursuing.
- If the active goal is vague or cannot be determined safely, ask for clarification using `vscode_askQuestions` instead of making assumptions.
- If `copilot-office/<mission-name>/copilot-active-plan.md` is missing, stale, or no longer matches the active goal, run a custom agent named exactly 'Plan' as subagent to create or update it using the `## Active Plan Rules` section below.
- Do not move to step 1 until the active goal is resolved safely and the active plan is usable, or a genuine blocker is reported.

## 1. Plan The Next Stage
Run a custom agent named exactly 'Plan' as subagent to update or generate the next stage plan:
- If the `Plan` subagent is unavailable, stop and report that blocker instead of silently substituting another agent.
1. Confirm the resolved mission folder and ignore unrelated mission folders unless the user explicitly asks for cross-mission work.
2. Read the mission context from:
  - `copilot-office/<mission-name>/copilot-project-plan.md`
  - `copilot-office/<mission-name>/copilot-active-plan.md`
  - `copilot-office/<mission-name>/copilot-stage-plan.md`
  - `copilot-office/<mission-name>/copilot-desk/`
  - `copilot-office/codebase/CODEBASE.md` when shared architecture matters
3. Distinguish the mission goal from the active goal.
4. Break the active goal into stages if necessary, but plan only the next stage to execute now.
5. Update or generate `copilot-office/<mission-name>/copilot-stage-plan.md` for the next stage to execute now.
6. Keep `copilot-office/<mission-name>/copilot-stage-plan.md` detailed, concrete, and execution-oriented:
  - Capture the current stage objective, ordered tasks, dependencies, verification steps, and immediate blockers.
  - Replace or rewrite this file when the current stage is completed or re-scoped rather than appending a long history.

  


## 2. Execute The Current Stage
Run a subagent to execute the plan defined in `copilot-office/<mission-name>/copilot-stage-plan.md`:
- When delegating to subagents, include these:
  1. the resolved mission name
  2. `../instructions/project_context.instructions.md` (to understand project context)
  3. the stage plan file (direct order for subagent)
- Tell them to stay within that mission folder and its related shared docs.
- Use a dedicated subagent for each distinct multi-step task (e.g., implementation, research, testing, debugging).
- Only pause execution if you encounter a critical blocker, require clarification, or hit a defined milestone requiring manual verification.
- Do not silently switch to another mission folder mid-run.
- The execution subagent owns substantive implementation, research, testing, and debugging work for this stage.
- The main agent may use direct tool calls only for minimal coordination work, such as checking the updated stage files, reading a concise result, or validating whether another handoff is needed.
- Do not use the main agent for substantive stage execution when that work belongs to the execution subagent.
- Do not pass unrelated mission files, the full mission history, the entire `copilot-desk/`, or long raw logs unless the current stage truly depends on them.
- After completing the current stage, reassess the active goal.
- If the active goal or its working state changed materially, run a custom agent named exactly 'Plan' as subagent to update `copilot-office/<mission-name>/copilot-active-plan.md` using the `## Active Plan Rules` section below.
- If the active goal is not yet resolved and no genuine blocker exists, return to step 1 with updated state and plan the next stage.
- Keep iterating stages until the active goal is resolved or blocked.

## 3. Reporting
Once you reach a natural stopping point, Run a subagent to provide a comprehensive report detailing the resolved mission folder, whether it came from current session history or the inspection step, the mission goal, the active goal, completed stages, remaining backlog, any plan cleanup performed, and any uncovered issues or blockers.

## Active Plan Rules
Keep `copilot-office/<mission-name>/copilot-active-plan.md` actionable, current, and scoped to the active goal:
    - Preserve enough context for a future agent to resume work safely.
    - Keep the active goal, active backlog, blockers, key unresolved decisions, and the minimum recent progress needed to continue.
    - Remove or compress irrelevant, outdated, duplicated, or archival content when it is causing confusion.
    - Move durable design notes, reference material, and other non-operational content into `copilot-office/<mission-name>/copilot-desk/` when appropriate, and leave a short pointer in `copilot-office/<mission-name>/copilot-active-plan.md`.