---
name: fit-skill-to-copilot
description: >-
  Adapt a Claude-authored skill to run faithfully under GitHub Copilot. Use when the user
  asks to "port", "adapt", "convert", or "fit" a Claude skill to Copilot, when they point
  at a skill folder (commonly under `anthropics-skills/` or `obra-superpowers/`) and ask
  for a Copilot version, or when they paste a Claude SKILL.md and want it reworked.
  Preserves the original skill's behavior as closely as possible; only rewrites the
  Claude-specific surfaces (tool names, subagent invocation, memory paths, interactive
  questioning, grading/viewer scripts, frontmatter fields).
argument-hint: "Path to the Claude skill folder or SKILL.md"
---

# Fit Skill To Copilot

Claude-authored skills describe behavior in Claude's vocabulary — tools like `Bash` and `Edit`, spawning subagents via the `Task` tool, interactive clarifying questions handled inline, eval pipelines that use `eval-viewer/generate_review.py`. Copilot has the same underlying capabilities, but the surface is different. This skill adapts a Claude skill to Copilot **without changing what the skill does** — only how it says to do it.

The goal is behavioral parity. If the original skill works correctly on Claude, the adapted skill should work correctly on Copilot. Anything the original does not require (a Claude-specific script, a Claude-specific tool name) gets translated; anything the original requires that Copilot can express (file reads, subagent delegation, memory writes) gets restated in Copilot terms.

## When To Skip

- The original skill is already Copilot-native (references `run_in_terminal`, `vscode_askQuestions`, `runSubagent`, `memory`).
- The skill's value depends on a Claude-specific capability Copilot cannot reproduce (e.g., Claude's Artifacts, Canvas, or a specific Anthropic API call). In that case, adaptation will silently drop the skill's core value — tell the user, don't pretend.
- The user wants a full redesign, not a port. Redesigns belong to `skill-creator`, not this skill.

## Procedure

### 1. Read the original skill end-to-end

Read every file in the source skill folder. At minimum: `SKILL.md`, `evals/evals.json` if present, everything under `references/`, `scripts/`, `agents/`, `assets/`. Do not skim. Claude-isms are scattered, not concentrated.

Note:
- Every tool name mentioned (`Bash`, `Edit`, `Read`, `Write`, `Task`, `Glob`, `Grep`, `WebFetch`, `WebSearch`, `mcp__*`)
- Every subagent-spawning instruction (anything that talks about "launching a subagent", "spawning", "the Task tool", "run this as a subagent")
- Every memory reference (Claude's memory paths and conventions)
- Every script the skill runs (especially ones specific to Anthropic's toolchain)
- Any UI-ish mechanism (interactive questions, artifacts, canvas, slash commands)
- Any frontmatter field that is Claude-specific

### 2. Classify what changes and what stays

| Bucket | Action |
|---|---|
| Prose describing what the skill does and why | KEEP verbatim |
| Workflow structure, phases, decision trees | KEEP verbatim |
| Anti-patterns, examples of wrong behavior | KEEP verbatim |
| Tool names, invocation syntax | TRANSLATE |
| Subagent spawning instructions | TRANSLATE |
| Memory paths / conventions | TRANSLATE |
| Scripts written against Claude APIs | REWRITE |
| Interactive clarifying questions | TRANSLATE to `vscode_askQuestions` |
| `CLAUDE.md`, `claude-with-access-to-the-skill` references | TRANSLATE |
| Artifacts, Canvas, Anthropic-only capabilities | FLAG to user; do not silently drop |

The rule: if removing a Claude-ism would change the skill's **observable behavior**, it must be replaced by the Copilot equivalent. If it would not, leave it.

### 3. Apply the translation map

| Claude surface | Copilot equivalent |
|---|---|
| `Bash` tool / `bash` invocation | `run_in_terminal` |
| `Read` tool | `read_file` |
| `Edit` tool | `replace_string_in_file` (single edit) or `multi_replace_string_in_file` (batch) |
| `Write` tool | `create_file` |
| `Glob` tool | `file_search` |
| `Grep` tool | `grep_search` |
| `Task` tool / "spawn a subagent" / "launch an agent" | `runSubagent` with `{agentName, description, prompt}` |
| `WebFetch` / `WebSearch` | `fetch_webpage` |
| `NotebookEdit` | `edit_notebook_file` |
| `NotebookRead` | `copilot_getNotebookSummary` + `read_file` on cell ranges, or `read_notebook_cell_output` |
| "run the notebook cell" | `run_notebook_cell` |
| `SlashCommand` (`/foo` commands in Claude Code) | Invoke the relevant skill or agent directly; slash commands have no Copilot equivalent |
| `Skill` tool (explicit skill loading) | No equivalent — Copilot loads skills automatically based on trigger phrases. Remove the explicit load step and trust the skill-trigger mechanism |
| Claude's memory tool | the `memory` tool with `/memories/`, `/memories/session/`, `/memories/repo/` scopes |
| Interactive clarifying question inline in chat | `vscode_askQuestions` with header/question/options/allowFreeformInput |
| "Ask the user" / "confirm with the user" | `vscode_askQuestions`; reference `discussion-mode` skill if the confirmation is at a checkpoint |
| `claude-with-access-to-the-skill <task>` (in eval descriptions) | `runSubagent` configured to read the SKILL.md first, then execute the task |
| `agents/grader.md` referenced as a subagent | inline grading via a script or a `runSubagent` call targeting a generic agent; the grader prompt is preserved |
| `agents/analyzer.md` | same pattern as grader |
| `eval-viewer/generate_review.py` | Replace with a `benchmark.md` written by the agent comparing runs; note to user if they want the HTML viewer it must be ported separately |
| `CLAUDE.md` at repo root | `.github/copilot-instructions.md` or `AGENTS.md` depending on repo convention |
| `/skill-test`, `/skill-create` slash commands | N/A — remove or convert to plain instructions |
| `mcp__server__tool` | `mcp_server_tool` (underscore style in Copilot) |
| Claude Artifacts / Canvas | No direct equivalent — FLAG to user and recommend a workspace file as a fallback |

When a Claude skill says "spawn a subagent with these instructions", the Copilot translation is always a `runSubagent` call. Choose the agent name based on the task:

- Code changes → `CodeEngineer`
- Reviewing changes for correctness → `CodeReviewer`
- Plan critique → `RubberDuck`
- Multi-step planning → `Planner`
- Codebase exploration only → `Explore`
- Fast targeted search — files by pattern or keyword → `search_subagent` directly (it's a tool, not an agent)
- Generic / no specialized agent fits → `runSubagent` without `agentName` (defaults to current agent)

### 4. Write to a sibling folder

Output goes to `<original-skill>-copilot/` (sibling of the source folder). **Preserve every file and directory in the source**, including files that look like metadata or legal boilerplate. Specifically:

- `LICENSE`, `LICENSE.txt`, `LICENSE.md`, `NOTICE`, `COPYING` — copy **verbatim**. Never drop, never edit.
- `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` — copy verbatim unless they mention Claude-specific surfaces; then translate only those mentions.
- `.gitignore`, `.editorconfig`, dotfiles — copy verbatim.
- Data files (`*.json`, `*.xml`, `*.yaml`, `*.csv`, `*.txt`) that are not prose — copy verbatim unless they contain Claude-specific identifiers.

Before writing the output, enumerate every path under the source folder (e.g., `find <skill>/ -type f`) and confirm each one has a corresponding path in the output — either a translated version or a verbatim copy. A missing file is a bug; a deliberate deletion must be recorded in `COPILOT_ADAPTATION_NOTES.md`.

Folder layout:

```
<skill>/                 <skill>-copilot/
├── SKILL.md              ├── SKILL.md
├── evals/                ├── evals/
│   └── evals.json        │   └── evals.json
├── references/           ├── references/
│   └── *.md              │   └── *.md
└── scripts/              └── scripts/
    └── *.py                  └── *.py
```

For each file:

- **`SKILL.md`** — apply the translation map. Keep the frontmatter fields supported by Copilot (`name`, `description`, `argument-hint`). Drop unsupported fields silently.
- **`evals/evals.json`** — keep `prompt` verbatim. Translate `expected_output` only if it describes Claude-specific behavior (e.g., "the agent uses the Task tool" → "the agent uses `runSubagent`"). The source may use Claude-specific assertion schema fields; look at existing Copilot evals in this repo (e.g., `.github/skills/*/evals/evals.json`) to confirm the target schema before translating. If the repo has no existing eval convention, keep the source schema and note the decision in `COPILOT_ADAPTATION_NOTES.md`.
- **`references/*.md`** — usually pure prose, keep verbatim. Scan for Claude-isms and translate only those.
- **`scripts/*.py`** — if the script calls Anthropic APIs, flag to user (do not silently break). If the script is generic Python (file processing, JSON massaging), keep as-is. If it shells out to `claude` CLI, translate the invocation style but flag if the underlying tool is Claude-specific.
- **`agents/*.md`** — these are subagent prompts. Preserve the prompt content; change only the framing sentences that describe the agent environment.

### 5. Flag residuals

At the end, write a `COPILOT_ADAPTATION_NOTES.md` in the output folder listing:

- Every Claude-ism that was translated, with line-or-section pointers
- Every Claude-ism that was flagged as untranslatable (Artifacts, Canvas, Anthropic-only APIs)
- Any behavioral deltas the user should be aware of (e.g., "the eval viewer HTML was replaced by a benchmark.md; if you want the interactive viewer, port eval-viewer/ separately")
- Anything in the source that looked like a Claude-ism but you left alone, with rationale

This file is the audit trail. Without it, the user has no way to verify the adaptation was faithful.

### 6. Verification checklist

Before handing the adapted skill back, verify:

- [ ] Every tool name in the output maps to a real Copilot tool (no stray `Bash`, `Edit`, `Task`, `Glob`, `Grep`)
- [ ] Every subagent-spawning instruction uses `runSubagent` with a concrete `agentName` or explicit reason for no agent
- [ ] Every interactive clarifying question uses `vscode_askQuestions` with well-formed parameters (header ≤ 50 chars, question ≤ 200 chars, options if applicable)
- [ ] Memory references use Copilot's scope paths (`/memories/`, `/memories/session/`, `/memories/repo/`)
- [ ] No references to `claude-with-access-to-the-skill`, `CLAUDE.md` as repo root, `/skill-test` slash commands, Anthropic-only capabilities remain
- [ ] Every file under the source folder has a counterpart in the output folder (verbatim copy or translated version). Deliberate deletions are listed in `COPILOT_ADAPTATION_NOTES.md` with rationale. Pay special attention to `LICENSE*`, `NOTICE`, `README`, `CHANGELOG`, dotfiles, and any `*.json`/`*.xml`/`*.txt` data files — these are easy to overlook.
- [ ] `COPILOT_ADAPTATION_NOTES.md` exists and lists every translation + every flagged item
- [ ] The workflow logic in `SKILL.md` is unchanged (same phases, same decision points, same anti-patterns)

If any checkbox fails, go back to step 3.

### 7. Functional smoke test

The verification checklist above catches translation gaps. It does **not** catch "the adapted skill is grammatically correct but doesn't actually work in Copilot." Before declaring the adaptation done, run a lightweight functional test.

#### 7a. Static lint pass

Scan the adapted skill for **dangling references** — things it mentions that don't exist in Copilot:

- **Tool names**: every tool invoked in the SKILL.md and scripts must be either (a) a real Copilot tool (e.g., `run_in_terminal`, `replace_string_in_file`, `fetch_webpage`, `vscode_askQuestions`, `runSubagent`), or (b) an obvious shell command. Grep for backticked identifiers and confirm.
- **Agent names**: every `runSubagent` call with an `agentName` must name an agent the user actually has. The standard set in this repo is `CodeEngineer`, `CodeReviewer`, `RubberDuck`, `Planner`, `Explore`. If the adapted skill invents agents that don't exist, either name a real one or document the requirement in NOTES.
- **Memory paths**: every memory path must start with `/memories/`, `/memories/session/`, or `/memories/repo/`. Paths like `/skill-test/` or `~/.claude/` are Claude-isms.
- **File paths referenced from within the skill**: if the adapted `SKILL.md` tells the agent to "read `scripts/foo.py`", confirm `scripts/foo.py` actually exists in the output folder.
- **Frontmatter**: `name` matches the folder, `description` is present and non-empty, no unsupported Claude-only frontmatter fields remain.

#### 7b. Behavioral smoke test

Spawn a fresh subagent (`runSubagent` with `agentName: "Explore"`) and give it **only** the adapted SKILL.md path. Ask it to describe, in 3–5 bullet points, how it would handle a trivial input that matches the skill's trigger phrases. Read its response and check for:

- Does it reference any tool, agent, or path that doesn't exist?
- Does it get confused by translated instructions (e.g., says "I would use the Task tool" because the translation was incomplete)?
- Does it produce a plan that's actually executable in Copilot, or does it trip on a Claude-ism you missed?

If the subagent's plan is clean and executable, the adaptation passes. If it hallucinates capabilities or references missing surfaces, iterate on the translation and re-run the smoke test.

Record the smoke-test outcome — including the subagent's plan — in `COPILOT_ADAPTATION_NOTES.md` under a `## Smoke Test` section.

**Step 7a is never optional.** The static lint has no runtime cost and catches the most common adaptation bugs. Step 7b (behavioral smoke test) may be skipped only when the skill is too operationally heavy to exercise in isolation (e.g., it requires a running browser or a multi-hour evaluation loop). If you skip 7b, say so in `COPILOT_ADAPTATION_NOTES.md` with a specific reason — "too complex" is not a reason.

## Writing Style Notes

- Keep the original author's voice. If the Claude skill has personality, preserve it.
- Do not add "for Copilot" disclaimers throughout the prose — they are noise. The adaptation is structural, not stylistic.
- Do not rename concepts the user may have internalized (e.g., if the skill calls its phases "Phase 1 / Phase 2", keep those labels).

## Anti-Patterns

**Silent capability drop.** A Claude skill depends on Artifacts. The Copilot version has no Artifacts, so the skill's output will not work as the author intended. Writing the adapted skill without telling the user is a trap. Always flag untranslatable capabilities in `COPILOT_ADAPTATION_NOTES.md`.

**Over-translating prose.** The procedural paragraphs, motivations, and anti-patterns from the original are skill-level wisdom, not Claude-isms. Rewriting them in "Copilot voice" erases the author's thinking. Leave prose alone unless it references a Claude-specific surface.

**Translating tool names but not workflows.** Replacing `Task` with `runSubagent` without picking a concrete `agentName` leaves the Copilot agent without guidance. The translation is `Task → runSubagent({agentName: ..., description: ..., prompt: ...})`, not just a string substitution.

**Dropping `evals/evals.json` because it "uses Claude syntax".** The `prompt` fields are usually model-agnostic. Keep them. Only the `expected_output` and any assertion schema need translation.

**Ignoring the source folder structure.** The user chose the original layout. Preserve it. If a `scripts/` folder existed, the adapted skill has a `scripts/` folder — even if it is empty after the adaptation and you write a stub README inside.

**Dropping legal / metadata / data files because they "aren't the skill".** `LICENSE.txt`, `NOTICE`, `README.md`, `CHANGELOG`, `.gitignore`, and bare data files (`*.json`, `*.xml`, `*.txt`) are part of the skill's distribution. Silently dropping `LICENSE.txt` when copying an open-source skill is a *licensing violation*, not just an oversight. Enumerate the source tree (`find <skill>/ -type f`) and confirm every file has a counterpart in the output before handing back.

**Skipping the notes file.** Without `COPILOT_ADAPTATION_NOTES.md` the adaptation is opaque. The user cannot check your work. The notes file is mandatory.

**Skipping the smoke test because "the translations look right."** Translations that look right on paper routinely fail when the Copilot agent tries to execute them: an `agentName` the user doesn't have, a memory path that doesn't start with `/memories/`, a referenced script file you forgot to copy over. The smoke test in Step 7 catches these. Don't skip it. If the skill is too operationally heavy to smoke-test in full, at minimum do the static lint pass in Step 7a.

**Fabricating Copilot capabilities that don't exist.** When you can't find a Copilot equivalent for a Claude surface, the temptation is to invent one that sounds plausible — e.g., writing `artifact_panel` when Copilot has no such tool, or naming `agentName: "Adapter"` when no such agent exists. *Do not fabricate.* If no equivalent exists, flag the capability in `COPILOT_ADAPTATION_NOTES.md` and either leave the instruction with a `TODO` pointing at the flagged residual, or fall back to a documented Copilot primitive (a workspace file, a `vscode_askQuestions` prompt, a `run_in_terminal` command). Step 7a exists specifically to catch this — every name in the adapted skill must resolve to something real.
