# AGENTS.md

> Rules for every opencode agent when they touch this project's config and agent files.

## Rules

1. **Plain English.** Write opencode markdown files in concise, accurate, plain English: short declarative sentences, no metaphors, specific words over general ones.
2. **Traditional Chinese only.** If output is Chinese, output in Traditional Chinese (zh-Hant), not Simplified Chinese. This applies to all output, not just markdown.

## Subagents

| Agent | What it does | Purpose | Use when |
| --- | --- | --- | --- |
| `debugger` | Reproduces hard bugs, traces the code path, proves a root cause, applies a minimal fix, and verifies it. | Serious debugging that needs a powerful reasoning model. | A bug resists quick fixes, errors or crashes have no obvious cause, or a stack trace needs tracing to source. |
| `recruiter` | Writes valid opencode agent files from an approved shortlist. Dispatched by `hr` after approval. | Hires new team members from a spec it receives. | New subagents or primary agents are approved and need files created. |
| `tester` | Surveys the project, builds the test plan, writes tests with the project's framework, runs the suite, and reports coverage. | Test design, execution, and coverage reporting. | A test plan is needed, tests must be written or extended, or the suite must run and report coverage. |
| `ui-designer` | Designs tasteful, modern, accessible interfaces and writes handoff-ready design docs plus an HTML/CSS mockup. | Clean UI design work before code. | A website or interface should not ship with a default look and needs design tokens, layout, and component specs first. |

## Shared knowledge

`~/projects/notebook` is our shared notebook. OpenCode and the user use it to read knowledge, write notes, and plan work together.
