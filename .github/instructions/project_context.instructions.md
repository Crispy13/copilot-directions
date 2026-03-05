---
description: Define locations and rules for project context, planning, and documentation files.
applyTo: '**'
---

# Project Context Reference

You must utilize the following files and directories to maintain project alignment and track progress. Review relevant context files before making changes, and update them when milestones are reached.

## 1. Project Goal (`copilot-project-plan.md`)
- **Purpose:** Defines the high-level objective and long-term plan for the project.
- **Agent Rule:** Read this to understand the core mission. Propose updates only when the fundamental direction or scope of the project changes.

## 2. Current Working Plan (`copilot-current-plan.md`)
- **Purpose:** Tracks immediate next steps, current tasks, and recent progress.
- **Agent Rule:** Read this to know what to work on next. Update this file continuously as tasks are completed or new actionable steps are identified.

## 3. Codebase Overview (`copilot-desk/CODEBASE.md`)
- **Purpose:** Explains architectural decisions, main components, and project structure.
- **Agent Rule:** Use this file to understand how different modules interact. Update it when a major component, new service, or architectural pattern is introduced.

## 4. Project Desk (`copilot-desk/`)
- **Purpose:** A directory for storing decisions, reference materials, technical specs, and scratchpad notes.
- **Agent Rule:** Save important design choices, data schemas, or reference snippets here as separate Markdown files to retain knowledge across sessions.