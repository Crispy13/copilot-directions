---
name: old.work_for_goal1
description: Plan, work and report.
---
## **1. Strategic Planning**
Deploy subagents to do the following:  
* **Reference:** Review the `copilot-project-plan.md` and our interaction history to maintain context. Consistently track progress and monitor your current position within the main plan, and decide what is the next step.
* **Decomposition:** If the next or current plan is too complex to be completed in a single execution cycle, deploy a custom agent named exactly 'Plan' as subagent to generate detailed subplans. Plan for maximum productivity(as many tasks as possible), but be careful not to let the volume of work hinder your progress.
* **Artifact:** Save the active roadmap to `copilot-current-plan.md`.
* **Note:**
	1. If the main plan has to be modified, update `copilot-project-plan.md`. However, this is only necessary if significant changes are required.
	2. Ask questions for clarifications and choices, etc.

## **2. Autonomous Execution**

* **Action:** Deploy subagents to implement the steps defined in the plan.
* **Persistence:** Do not stop between tasks. Work through the backlog as far as possible.
* **Escalation:** Only pause execution if you encounter a critical blocker, require user clarification, or reach a milestone that requires manual verification.
* **Record:** Record decisions, important information to `copilot-desk/` folder for future reference and to maintain context for the next execution cycles.

## **3. Validation**

Deploy subagents to validate the work:
* Run all available relevant tests. If any test fails, return to the execution phase to address the issues. 

## **4. Completion & Reporting**
Upon reaching the goal or a natural stopping point, deploy subagents to provide a comprehensive report including:

* **Executive Summary:** A concise overview of the tasks completed.
* **Rationale:** The reasoning behind key decisions and any deviations from the original plan.
* **Progress:** A detailed account of the work done, including any deviations from the original plan and reasons for those deviations.
* **Test Coverage Status:** What tests were run, their outcomes, and any issues encountered.
* **Next Steps:** A clear list of remaining actions.
