---
name: review-directions
description: 'Review and improve VS Code Copilot direction files. Use for .instructions.md, .prompt.md, .agent.md, SKILL.md, copilot-instructions.md, and AGENTS.md. If target files are attached or explicitly referenced, review only those target files; otherwise review all direction markdown files in the workspace.'
argument-hint: 'Which direction files should be reviewed or improved?'
user-invocable: true
---

# Review Directions

Use this skill to review and improve VS Code Copilot customization files.

`Direction files` means these customization files:
- `.github/instructions/*.instructions.md`
- `.github/prompts/*.prompt.md`
- `.github/agents/*.agent.md`
- `.github/skills/*/SKILL.md`
- `copilot-instructions.md` in the workspace root or `.github/`
- `AGENTS.md` in the workspace root or `.github/`

## When to Use
- Review a changed prompt, agent, instruction, or skill
- Clean up ambiguous or conflicting direction files
- Check whether Copilot customization files follow VS Code conventions
- Improve discovery text, frontmatter, workflow structure, and scope boundaries

## Required Copilot References

Before reviewing or editing direction files, read the relevant Copilot-provided markdown guidance for the file types in scope.

Always read:
- `copilot-skill:/agent-customization/SKILL.md`

Read the matching creation prompts when relevant by locating them in the current environment or using attached files:
- `create-agent.prompt.md`
- `create-instructions.prompt.md`
- `create-prompt.prompt.md`
- `create-skill.prompt.md`

Read the matching reference docs when relevant by locating them in the current environment:
- `agents.md`
- `instructions.md`
- `prompts.md`
- `skills.md`
- `workspace-instructions.md`

Do NOT hardcode versioned extension asset paths. If these files are not attached in the conversation, locate the currently installed Copilot assets dynamically before proceeding.

If several direction file types are involved, read all relevant references before making changes.

## Review Scope

1. If the user explicitly identifies target direction files by attachment or file reference, review only those target files.
2. Treat files attached only to invoke this skill or provide creation instructions as instruction context, not review targets.
3. Exclude this skill file itself from the review target set unless the user explicitly asks to review `review-directions/SKILL.md`.
4. If no explicit target direction files remain after applying those exclusions, review all direction files in the workspace.
5. Ignore non-direction markdown files unless the user explicitly asks for them.

## Review Procedure

1. Identify the target direction files.
	- Separate review targets from instruction-only attachments.
	- If the only attached direction file is this skill file and the user did not explicitly ask to review it, treat that attachment as instruction context and fall back to workspace-wide review.
2. Determine the file types involved and load the relevant Copilot reference markdown listed above.
	- If `copilot-instructions.md` or `AGENTS.md` is in scope, you MUST also read `workspace-instructions.md`.
   - If the needed Copilot prompt or reference files are not attached, locate them by filename in the currently installed Copilot assets instead of assuming a fixed absolute path.
3. Read the current file contents before proposing or applying changes.
4. Review for these issues:
- Invalid or weak YAML frontmatter
- Missing or low-signal `description` fields
- Wrong scope or wrong primitive choice
- Ambiguous instructions, conflicting rules, or hidden assumptions
- Over-broad patterns such as `applyTo: "**"` when narrower scope is better
- Discovery problems where trigger words are missing from descriptions
- Workflow steps that are too vague, contradictory, or operationally incomplete
- Direction files that drift from the actual behavior expected in this workspace
5. If the user asked for review only, report findings first in review format.
6. If the user asked to improve the files, apply focused fixes directly when the intent is clear.
7. After edits, validate the modified files for syntax or diagnostics issues.

## Improvement Rules

- Prefer the smallest change that makes the direction clearer, more consistent, or more enforceable.
- Preserve the user's intent even when rewriting for clarity.
- Fix contradictions explicitly rather than layering new rules on top of conflicting old ones.
- Make operational behavior explicit when a rule currently exists only as vague prose.
- Do not broaden a file's scope unless the user explicitly wants that.
- If a requested change would materially alter the workflow or enforcement model, explain that before making broader changes.

## Output Expectations

For review-only requests:
- Present findings first, ordered by severity, with file references.
- Keep the summary brief.

For improve requests:
- State what was changed and why.
- Mention any remaining ambiguities or follow-up choices.
- Confirm whether validation passed.

## Completion Check

The skill is complete when:
- The correct files were reviewed based on attachments or workspace scope
- Relevant Copilot guidance was consulted for each file type reviewed
- Clear issues were fixed or reported
- Modified files were validated
