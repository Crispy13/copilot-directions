---
name: init
description: Init the project workflow, workspace, and core plan.
---

You MUST deploy subagents to sequentially execute the following initialization steps:

1. **Understand Workspace:** Analyze the current workspace and codebase context to understand the main goal.
2. **Locate Project Plan:** Read `copilot-project-plan.md` to grasp the main objective and project scope. If the file is missing, you MUST stop and ask the user to provide the project plan. You cannot proceed without it.
3. **Initialize Desk Directory:** Ensure the `copilot-desk/` folder exists. If not, create it immediately. This directory will hold architectural decisions, notes, and preferences.
4. **Draft Current Plan:** Use the `plan` skill to generate `copilot-current-plan.md` to direct immediate next steps. The plan MUST be designed for maximum productivity (as many tasks as possible without causing context overflow).
5. **Report to User:** Present the parsed project plan and proposed next steps to the user concisely. Use a subagent if necessary to summarize. Explicitly ask for clarification if there is conflicting information.