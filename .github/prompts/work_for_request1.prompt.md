---
name: work_for_request
description: Base prompt to plan-work-report cycle for a request.
---

<!-- 
This prompt generally does not direct the agent to deploy subagents. 
This is supposed to be used for simple tasks, where we can keep context clean more easily than large and complex tasks. 
-->

1. Use skill "plan" to plan tasks for user request. Plan for maximum productivity(as many tasks as possible), but be careful not to let the volume of work hinder your progress. Show the plan as it is to user in dialogue. Use the #askQuestions tool to seek user confirmation. Do not place the plan text inside the tool's question placeholder; keep the plan in the main chat and use the tool only for confirmation. If the user refuses the plan, then repeat step 1 to generate a modified plan with user's feedback. If the user accepts the plan, then proceed to step 2.

2. Implement the plan. Do not stop between tasks. Work through the backlog as far as possible. Only pause execution if you encounter a critical blocker, require user clarification, or reach a milestone that requires manual verification.

3. Deploy subagent to make a detailed report, based on the plan and the work done. Show the next steps if any.