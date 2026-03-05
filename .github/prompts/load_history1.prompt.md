---
name: load_history
description: Load history of work with reading plans, chatlogs, and other relevant information.
---


## 1. Read history and context
Run subagents to do the following:
1. Read `copilot-project-plan.md` to understand the project plan and goals.
2. Read `copilot-current-plan.md` to understand the current state and task for the main plan.
3. Read chat log files in `copilot-chat-logs/` in chronological order. You should summarize this because it may be very long, but you should read all the lines.
4. Read all files in `copilot-desk/` directory. It contains decisions, notes, and other relevant information for the project. Summarize this also, maybe the files are very huge.
5. Understand this workspace and codebase: `copilot-desk/CODEBASE.md`. 

## 2. Report current status and next steps
Based on the information of 1, Deploy a subagent to report the current status and next steps to user. You should be concise but informative. You can also ask user for clarification if you find any conflicting information or if you are not sure about the next steps.