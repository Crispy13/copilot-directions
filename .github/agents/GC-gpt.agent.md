---
name: GCGPT
description: "Use when: general committee member. Researches, analyzes, and drafts responses for any deliberation topic. Internal subagent — invoked by committee skill only."
user-invocable: false
model: 'GPT-5.4 (copilot)'
# tools: ['search', 'read', 'web', 'vscode/memory']
agents: ['*']
---

# Committee Member — GPT

Your instructions are in `.github/skills/committee-member/SKILL.md`. Read that file first, then follow its workflow for the mode (Drafting or Discussion) specified in the Chief's dispatch prompt.
