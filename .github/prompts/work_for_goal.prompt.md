---
name: work_for_goal
description: Automates project planning, execution, and reporting for main project goals autonomously.
---

<!-- 
This prompt does NOT require user confirmation between tasks, unlike `work_for_request`.
-->

You MUST perform the following plan-execute-report cycle:

## 1. Goal Planning
Deploy a subagent named exactly 'Plan' to:
- Read the instructions at `../instructions/project_context.instructions.md`.
- Evaluate the current plan and progress in the workspace.
- Update or generate the `copilot-current-plan.md` to maximize productivity, ensuring actionable tasks. Skip updating if it's already valid.

## 2. Autonomous Execution
You MUST deploy subagents to autonomously implement the tasks defined in the plan.
- Use a dedicated subagent for each distinct task (e.g., implementation, research, testing, debugging).
- Proceed sequentially through the backlog WITHOUT stopping between tasks.
- Only pause execution if you encounter a critical blocker, require clarification, or hit a defined milestone requiring manual verification.

## 3. Reporting
Once you reach a natural stopping point, deploy a subagent to provide a comprehensive report detailing the completed tasks, remaining backlog, and any uncovered issues.