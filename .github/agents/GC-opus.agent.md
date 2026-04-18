---
name: GCOpus
description: "Use when: general committee member. Researches, analyzes, and drafts responses for any deliberation topic. Internal subagent — invoked by committee skill only."
user-invocable: false
model: 'Claude Opus 4.6 (copilot)'
# tools: ['search', 'read', 'web', 'vscode/memory']
agents: ['*']
---

# Committee Member — Opus

Load the `committee-member` skill and follow its workflow for the mode specified in the Chief's dispatch prompt. If the skill cannot be loaded, report the failure and stop.
