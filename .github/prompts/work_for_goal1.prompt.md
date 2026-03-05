---
name: work_for_goal
description: Work for the main goal with planning, execution, and reporting.
---

<!-- The difference from `work_for_request` is:
1. Deploying subagents is not directed.
2. Confirmation for the next step is not requested.
 -->

## 1. Decide the next step for the main goal

Run a custom agent named exactly 'Plan' as subagent to do the following:
1. Read [project context instructions](../instructions/project_context.instructions.md) to understand the project context.
2. Check the current plan and progress.
3. Modify or generate the current plan. Plan for maximum productivity(as many tasks as possible), but be careful not to let the volume of work hinder your progress. You don't need to modify the plan if it is still valid and tasks remain in the backlog.

## 2. Implement the plan
Run subagents to implement the current plan. Leverage subagents for every possible task to keep context clean. So run a new subagent for each distinct task: implementation, research, testing, debugging, etc. Proceed through the backlog continuously without stopping between tasks. Only pause execution if you encounter a critical blocker, require clarification, or reach a milestone that necessitates manual verification.

## 3. Report
Upon reaching a natural stopping point, deploy subagents to provide a comprehensive report.
