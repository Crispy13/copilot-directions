---
name: init_mission
description: "Initialize a mission under copilot-office/missions, resolve mission_folder, and draft the project, active, and stage plans."
argument-hint: "Mission name and objective"
---

## Definition
- `<mission-folder>`: the resolved mission path placeholder. Set it to `copilot-office/missions/<mission-name>` before using mission files.

## Workflow
You MUST perform the following initialization steps. Use subagents when useful, but keep the flow centered on one resolved mission folder.

1. **Resolve Mission Folder:** If the user does not give a mission name, you must ask for it with the `vscode_askQuestions` tool. This is the init phase, so there should be no prior mission resolution from session history. Resolve the `<mission-folder>` placeholder using the rules in `../instructions/project_context.instructions.md`.

2. **Understand Workspace:** Run subagents to analyze the current workspace and codebase context to understand the requested mission and the surrounding architecture.

3. **Initialize Mission Structure:** Ensure `copilot-office/`, `copilot-office/codebase/`, `<mission-folder>`, and `<mission-folder>/copilot-desk/` exist.

4. **Locate or Draft Project Plan:** Read `<mission-folder>/copilot-project-plan.md` to grasp the mission objective and scope. If the file is missing, draft a minimal project plan from the workspace context and the user request, clearly mark it as provisional, and tell the user that it should be reviewed.

5. **Draft Active Plan:** Read or create `<mission-folder>/copilot-active-plan.md` to capture the initial active goal, active backlog, blockers, key decisions, and enough context to resume work safely.

6. **Draft Stage Plan:** Read or create `<mission-folder>/copilot-stage-plan.md` to define the first actionable stage for the active goal. Keep this file short, concrete, and execution-oriented.

7. **Report to User:** Present the resolved mission folder, whether it came from current session history or the inspection step, parsed project plan, initial active goal, first stage, and any missing context concisely. If shared docs appear to conflict with mission-specific docs, call that out explicitly.

## Notes
1. You must run an agent named exactly 'Planner' as a subagent to do all planning work. If the 'Planner' subagent is unavailable, stop and report that blocker instead of silently substituting another agent.