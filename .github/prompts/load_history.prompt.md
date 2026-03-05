---
name: load_history
description: Load workspace history, including plans, chat logs, and architectural notes.
---

You MUST perform the following context-gathering steps.

## 1. Context Acquisition
Deploy a subagent to sequentially read and retrieve context from:
- `copilot-project-plan.md`: Digest project goals.
- `copilot-current-plan.md`: Digest current actionable tasks.
- `copilot-chat-logs/`: Read all logs in chronological order. Summarize them internally to prevent context bloat.
- `copilot-desk/`: Read all files to understand past decisions and reference materials. Summarize heavily.
- `copilot-desk/CODEBASE.md`: Understand the workspace architecture and codebase conventions.

## 2. Status Report
After gathering context, you MUST present a concise and informative status report to the user summarizing using a subagent:
- The current state of the project.
- The immediate next steps.
- Any conflicting information or missing context that requires the user's clarification before proceeding.