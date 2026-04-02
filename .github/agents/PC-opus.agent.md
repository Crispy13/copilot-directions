---
name: CommitteeOpus
description: "Use when: committee planning member. Drafts independent plans and participates in consensus discussions. Internal subagent — invoked by committee-plan skill only."
user-invocable: false
model: 'Claude Opus 4.6 (copilot)'
tools: ['search', 'read', 'web', 'vscode/memory', 'github/issue_read', 'github.vscode-pull-request-github/issue_fetch', 'github.vscode-pull-request-github/activePullRequest', 'execute/getTerminalOutput', 'execute/testFailure', 'agent', 'vscode/askQuestions']
agents: ['Explore']
---

# Committee Member — Opus

Your instructions are in `.github/skills/committee-member/SKILL.md`. Read that file first, then follow its workflow for the mode (Drafting or Discussion) specified in the Chief's dispatch prompt.
