# Copilot Adaptation Notes

Source: `anthropics-skills/skills/skill-creator/`
Target: `tmp/fit-skill-to-copilot-workspace/iteration-3/skill-creator-target/outputs/skill-creator-copilot/`

## Translated Claude-isms

- `SKILL.md` frontmatter: added Copilot-supported `argument-hint` while preserving `name` and `description`.
- `SKILL.md`, overview and closing loop summary: translated `claude-with-access-to-the-skill` to explicit `runSubagent` guidance that tells the subagent to read the skill first.
- `SKILL.md`, Capture Intent / Interview / Test Case Review / fallback review feedback: routed user-question steps through `vscode_askQuestions`, and pointed explicit confirmation checkpoints at the `discussion-mode` skill.
- `SKILL.md`, Interview and Research: translated generic subagent guidance to `runSubagent` / `search_subagent`.
- `SKILL.md`, Running and evaluating test cases: translated subagent spawning into concrete Copilot guidance with `runSubagent` and explicit agent choices.
  - Eval execution: `CodeEngineer` by default for implementation/file-making tasks, `Explore` for read-only evals.
  - Grading: `CodeReviewer`.
  - Benchmark analysis: `RubberDuck`.
- `SKILL.md`, baseline snapshotting: translated raw shell copy guidance into `run_in_terminal` guidance.
- `SKILL.md`, description optimization: replaced Claude-specific trigger wording with Copilot wording, moved temp-file examples from `/tmp` to `./tmp`, and changed the file-open instruction to `run_in_terminal` with a platform-appropriate launcher.
- `SKILL.md`, environment sections: translated `Claude.ai-specific instructions` into `Environments Without Subagents`, and `Cowork-Specific Instructions` into `Headless / Remote IDE Instructions`.
- `references/schemas.md`: translated tool-name examples from Claude surfaces (`Read`, `Write`, `Bash`, `Edit`, `Glob`, `Grep`) to Copilot-style names (`read_file`, `create_file`, `run_in_terminal`, `replace_string_in_file`, `file_search`, `grep_search`). Also updated the benchmark model example to `gpt-5.4`.
- `agents/grader.md`: translated the tool-usage evidence example and metrics example from Claude tool names to Copilot-style names.
- `eval-viewer/viewer.html`: translated the viewer instructions from returning to a Claude Code session to returning to a Copilot chat session.
- `scripts/generate_report.py`: translated the viewer explainer text from Claude-specific wording to generic optimization-harness wording.
- `scripts/quick_validate.py`: added `argument-hint` to the accepted frontmatter keys so the adapted skill validates cleanly.
- `scripts/run_eval.py`, `scripts/improve_description.py`, and `scripts/run_loop.py`: replaced silently Claude-dependent implementations with explicit Copilot placeholders that preserve the file layout and CLI entry points but fail fast with a clear explanation.

## Agent Mapping Notes For `agents/*.md`

- `agents/grader.md` maps cleanly to `CodeReviewer`.
- `agents/comparator.md` best maps to `CodeReviewer` for output-quality evaluation. `RubberDuck` is a reasonable alternate if you want a more deliberative comparison pass.
- `agents/analyzer.md` best maps to `RubberDuck` for post-hoc analysis and improvement synthesis.

## Flagged Residuals And Behavioral Deltas

- `scripts/run_eval.py`, `scripts/improve_description.py`, and `scripts/run_loop.py` in the source depended on a Claude-specific external trigger-eval / rewrite harness. Copilot does not expose a public equivalent in this repository, so these files were converted into explicit placeholders that fail fast instead of silently pretending the automation still works.
- `SKILL.md`, Description Optimization section: the automated loop is preserved as workflow guidance, but it now explicitly tells the operator to fall back to a manual in-chat loop when no Copilot-compatible external harness is available.
- `SKILL.md` and `references/schemas.md`, timing capture guidance: the source assumed subagent completion notifications always surfaced `total_tokens` and `duration_ms`. The adapted wording makes this conditional because Copilot environments vary.
- `SKILL.md`, Environments Without Subagents: the source had a concrete Claude web-app fallback. The adaptation preserves the same workflow logic but makes the fallback generic instead of naming a Claude-only product surface.

## Claude-isms Intentionally Left Alone

- `agents/analyzer.md` was left verbatim because its prompt content is already generic and only describes analysis workflow, not Claude-specific runtime surfaces.
- `agents/comparator.md` was left verbatim for the same reason: it is a generic blind-comparison prompt with no Claude-only tool names or product-specific instructions.
- `assets/eval_review.html` was left verbatim because it contains no Claude-specific UI surfaces.
- `eval-viewer/generate_review.py` was left verbatim because it is a generic local viewer generator and server with no Claude-specific runtime dependency.
- `scripts/__init__.py`, `scripts/aggregate_benchmark.py`, `scripts/package_skill.py`, and `scripts/utils.py` were left alone because they perform generic Python/file-processing tasks and do not depend on Claude-specific APIs or prompts.
- `LICENSE.txt` was copied byte-for-byte without modification, as required.

## File Treatment Summary

Translated files:
- `SKILL.md`
- `references/schemas.md`
- `agents/grader.md`
- `eval-viewer/viewer.html`
- `scripts/generate_report.py`
- `scripts/quick_validate.py`
- `scripts/run_eval.py`
- `scripts/improve_description.py`
- `scripts/run_loop.py`

Verbatim copies:
- `LICENSE.txt`
- `agents/analyzer.md`
- `agents/comparator.md`
- `assets/eval_review.html`
- `eval-viewer/generate_review.py`
- `scripts/__init__.py`
- `scripts/aggregate_benchmark.py`
- `scripts/package_skill.py`
- `scripts/utils.py`

## Verification Checklist

- [x] Every translated tool name in the output maps to a Copilot-facing surface. No stray `Bash`, `Edit`, `Task`, `Glob`, `Grep`, `/skill-test`, `claude-with-access-to-the-skill`, or `CLAUDE.md` references remain in the adapted skill files.
- [x] Every subagent-spawning instruction in `SKILL.md` uses `runSubagent` with a concrete agent choice or an explicit fallback rationale.
- [x] Interactive clarifying-question guidance in `SKILL.md` routes through `vscode_askQuestions`.
- [x] Memory references were not present in the source skill, so no non-Copilot memory paths remain.
- [x] No references to `Claude`, `Claude Code`, `Claude.ai`, Anthropic-only product surfaces, or `claude -p` remain in the adapted skill files.
- [x] Every file under the source folder has a counterpart in the output folder. No source files were dropped.
- [x] `COPILOT_ADAPTATION_NOTES.md` exists and lists every translation, every flagged residual, and the intentionally unchanged files.
- [x] The workflow logic in `SKILL.md` is unchanged at a phase/decision-point level: draft -> test -> review -> improve -> repeat -> package remains intact.

## File Parity Audit

- Source files: 18
- Output counterparts from source: 18
- Additional file added by the adaptation: `COPILOT_ADAPTATION_NOTES.md`
- Deliberate deletions: none
