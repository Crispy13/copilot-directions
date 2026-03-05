---
name: work_for_request
description: Interactive plan-work-report cycle for handling isolated user requests.
---

<!-- 
This prompt generally avoids deploying subagents because it handles simple tasks.
It explicitly requires user confirmation before execution.
-->

You MUST perform the following interactive workflow:

1. **Interactive Planning:** Use the `plan` skill to generate actionable steps resolving the user's request. Maximize productivity while avoiding unmanageable task volume. Present the plan directly within your chat message.
   - You MUST use the `vscode_askQuestions` tool to seek the user's explicit confirmation.
   - Do NOT place the plan text inside the tool's question property; output the plan plainly in the main chat.
   - If the user rejects the plan, you MUST restart Step 1 incorporating their feedback.
   
2. **Execution Phase:** Once the plan is confirmed, execute it sequentially. Do NOT stop between tasks. Work through the backlog continuously. You may only pause if you encounter a critical blocker or require further clarification.

3. **Status Reporting:** Deploy a subagent (or summarize directly) to generate a detailed report based on the executed plan, identifying what was achieved and what the next steps are.