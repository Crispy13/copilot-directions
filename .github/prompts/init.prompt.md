---
name: init
description: Init the project.
---

Deploy subagents to do the following steps:

1. Understand this workspace and codebase for the main goal.

2. Read `copilot-project-plan.md` for the main goal and plan of the project. You can do downstream tasks without this file. Request project plan file to user if the file does not exist.

3. Make `copilot-desk/` folder. It will contains decisions, notes, and other relevant information for the project(e.g. workflow for tasks, prefered libraries, coding preferences, etc.). 

4. Use skill "plan" to make `copilot-current-plan.md` to direct next steps, based on the main plan. Plan for maximum productivity(as many tasks as possible), but be careful not to let the volume of work hinder your progress.

5. Report the project plan and next steps to user. You should be concise but informative. You can also ask user for clarification if you find any conflicting information or if you are not sure about the next steps. Use subagent for this.