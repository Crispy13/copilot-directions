---
name: load_history
description: "Load mission history from mission_folder, including plans, chat logs, desk notes, and shared codebase context."
argument-hint: "Mission name to load"
---

## Definitions
- `<mission-folder>`: the resolved mission path placeholder. Set it to `copilot-office/missions/<mission-name>` before reading mission history.

You MUST perform the following context-gathering steps.

## 1. Context Acquisition
1. Ask the current mission name with `vscode_askQuestions` tool if the user does not give the mission name explicitly. Then, resolve the `<mission-folder>` placeholder using the rules in `../instructions/project_context.instructions.md`.
2. Read and retrieve context from:
- `<mission-folder>/copilot-project-plan.md`: Digest mission goals.
- `<mission-folder>/copilot-active-plan.md`: Digest the currently active goal, working backlog, blockers, and unresolved decisions.
- `<mission-folder>/copilot-stage-plan.md`: Digest the next actionable stage and immediate tasks.
- `<mission-folder>/copilot-chat-logs/`: Read logs in chronological order and summarize them internally to prevent context bloat.
- `<mission-folder>/copilot-desk/`: Read files to understand past decisions and reference materials. Summarize heavily.
- `copilot-office/codebase/CODEBASE.md`: Understand shared workspace architecture and conventions that may affect the active mission.
3. Ignore unrelated mission folders unless the user explicitly asks for cross-mission comparison or migration work.

## 2. Status Report
After gathering context, you MUST present a concise and informative status report to the user summarizing:
- The resolved mission folder and the current state of that mission.
- Whether that mission came from current session history or the inspection step.
- The active goal and immediate next stage.
- Any conflicting information between mission-specific docs and shared docs.
- Any missing context that requires the user's clarification before proceeding.