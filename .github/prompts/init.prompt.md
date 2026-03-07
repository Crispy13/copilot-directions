---
name: init
description: Init the project workflow, workspace, and active mission plan.
---

You MUST perform the following initialization steps. Use subagents when useful, but keep the flow centered on one resolved mission folder.

1. **Understand Workspace:** Analyze the current workspace and codebase context to understand the requested mission and the surrounding architecture.
2. **Resolve Mission Folder:** Resolve `copilot-office/<mission-name>/` using the rules in `../instructions/project_context.instructions.md`. Prefer the mission already established in the current session history. If none exists, inspect the current request and closely related mission references to infer it. Ask the user with `vscode_askQuestions` only if that still does not resolve the mission safely.
3. **Initialize Mission Structure:** Ensure `copilot-office/`, `copilot-office/codebase/`, `copilot-office/<mission-name>/`, `copilot-office/<mission-name>/copilot-desk/`, and `copilot-office/<mission-name>/copilot-chat-logs/` exist.
4. **Locate or Draft Project Plan:** Read `copilot-office/<mission-name>/copilot-project-plan.md` to grasp the mission objective and scope. If the file is missing, draft a minimal project plan from the workspace context and the user request, clearly mark it as provisional, and tell the user that it should be reviewed.
5. **Draft Current Plan:** Read or create `copilot-office/<mission-name>/copilot-current-plan.md` to direct immediate next steps. Keep this plan focused on the active mission only.
6. **Report to User:** Present the resolved mission folder, whether it came from current session history or the inspection step, parsed project plan, immediate next steps, and any missing context concisely. If shared docs appear to conflict with mission-specific docs, call that out explicitly.