# Project Instruction — Creating a New Project with Claude Code

How to build a project from scratch using Claude Code, from idea to working codebase.

| File | Phase | Purpose |
|------|-------|---------|
| CLAUDE.md | 0 | How Claude behaves in this project |
| .gitignore | 0 | What not to commit |
| ARCH.md | 1 | Complete architectural blueprint |
| PLAN.md | 2 | Executable implementation steps |
| README.md | 3 | Project landing page for newcomers |
| WORKFLOW.md | 5 | Daily dev guide, testing, conventions |
| WORKLOG.md | 6 | Chronological session journal |

---

## Phase 0: Project Setup (one-time)

### 0.1 Create the repo

```bash
mkdir my-project && cd my-project && git init
```

### 0.2 Set up CLAUDE.md

Create a `CLAUDE.md` at the project root. This tells Claude how to behave in this project. Start minimal:

```markdown
# CLAUDE.md

## Context Loading
When working in this project, load context files in this order:
1. MEMORY.md — user preferences and past feedback
2. Project-specific config (e.g., CLAUDE.md)
3. Global config

## Rules
- Run tests after every code change
- Commit after milestones, not after every edit
- Use fresh conversations for major phases
```

### 0.3 Set up .gitignore

Use a standard gitignore template for your language (GitHub's templates). Add project-specific entries as you go:

```
# Build artifacts
build/
dist/

# Dependencies
node_modules/
vendor/

# Local config (never commit)
*.local.*
.env
```

---

## Phase 1: ARCH.md — High-Level Design

### When
First, before any code. This is the blueprint everything else builds on. Don't skip this — a bad ARCH.md produces a broken PLAN.md and a confused implementation.

### How to generate

**Step 1 — Dump your ideas.** Start a fresh conversation. Describe your project in plain language — what it does, who it's for, what problem it solves. Don't structure anything yet, just get it all out. Include:
- What the project does at a high level
- Any constraints (language, platform, performance, deployment)
- Existing systems it must work with
- Rough ideas about how it might work

**Step 2 — Generate the first draft.**

> "Create ARCH.md for this project. Include: overview, ASCII architecture diagram showing all components and their connections, component descriptions (what each does, its interface, its dependencies), data flow (step-by-step through the system), directory structure tree, and design decisions with rationale. Do NOT include implementation steps or code. Write for a developer who will implement from this spec."

**Step 3 — Iterate.** The first draft will have gaps. Push Claude to improve it:

> "Review ARCH.md — are any components missing? Are the interfaces between components clear enough to implement? Is the data flow complete end-to-end? Add anything that's missing."

> "For each component, add: what problem it solves, what it owns vs. delegates, and what assumptions it makes about other components."

> "For each design decision, add: what alternatives we considered and why we rejected them."

**Step 4 — Lock it.** Once satisfied, add a note at the top:

> Design locked: <date>. Changes after this date require updating PLAN.md.

### What good looks like

```markdown
# <project> — High-Level Design

> Design locked: YYYY-MM-DD

## Overview
(2-3 sentences on what this project is and why it exists)

## Architecture
(Diagram showing all components and how they connect)

## Components
### <Component A>
- **Purpose**: why it exists
- **Interface**: what it exposes (functions, endpoints, messages)
- **Dependencies**: what it needs from other components
- **Assumptions**: what it assumes about its inputs and dependencies
- **Owns**: what state or responsibility is exclusively its

### <Component B>
(same structure, repeat for each)

## Data Flow
(Step-by-step: how data or control moves through the system for each major scenario)

## Directory Structure
(Tree diagram of the planned codebase)

## Design Decisions
- **Decision**: We chose X over Y
  - **Why**: Z
  - **Alternatives considered**: A (rejected because...), B (rejected because...)
```

### Common mistakes
- **Too vague**: "Component A handles data" — how? What data? What's the interface?
- **Too implementation-heavy**: including code snippets, function signatures — save that for PLAN.md
- **Missing error paths**: only describes the happy path
- **Unclear boundaries**: what does each component own vs. delegate?

### Verification

Before moving on, confirm ARCH.md covers:
- Every component with clear interfaces and dependencies
- Complete data flow through the system (happy path + error paths)
- At least 3 design decisions with rationale and rejected alternatives
- A reader unfamiliar with the project could explain it back to you

---

## Phase 2: PLAN.md — Implementation Plan

### When
After ARCH.md is reviewed and approved. Before writing any code.

### How to generate

**Step 1 — Feed ARCH.md as input.** Start a fresh conversation and attach ARCH.md. This is critical — a fresh conversation with ARCH.md gives Claude clean context focused only on the design.

**Step 2 — Generate the plan.**

> "Create PLAN.md based on ARCH.md. Break implementation into numbered phases. Each phase must include: exactly which files to create or edit, what each file does, and at least one concrete verification command with expected output. The plan must be executable by another Claude instance without human help between phases. Tests come last in each phase. Each phase should be ~3-8 files, completable in one turn."

**Step 3 — Pressure-test the plan.**

> "For each phase, identify: what could go wrong, what dependency might be missing, and whether the verification actually proves the phase is complete."

> "For each verification command, write the exact expected output. If a command could fail silently, add a stronger check."

**Step 4 — Trace coverage.** Map every component from ARCH.md to at least one phase:

> "List every component from ARCH.md and which phase implements it. Flag any ARCH.md component not covered by a phase."

### What good looks like

Key rules:

- **Verification commands must be concrete and falsifiable**: the command either passes or fails, no interpretation
- **Each phase is one turn of work**: ~3-8 files, completable in one Claude response
- **Phases are strictly sequential**: Phase N+1 assumes Phase N is fully complete
- **Tests last in each phase**: write the implementation, verify it works, then add tests
- **Every file appears in exactly one phase**: no ambiguity about when to create something

```markdown
# <project> — Implementation & Verification Plan

Based on [ARCH.md](ARCH.md). Written for Claude to implement and verify.

---

## Phase 1: Scaffolding

### What to create
- `src/main` — entry point, parses args, calls into core
- `src/config` — loads and validates configuration
- `Makefile` — build, test, run targets

### How Claude verifies
```bash
make build && ./bin/my-project --help
# Expected: usage text with all subcommands listed
```

### Tests
- `tests/test_config.py` — valid config loads, invalid config fails with clear error

---

## Phase 2: Core logic

(same structure — what to create, how to verify, tests)

---
```

### Common mistakes
- **Vague verifications**: "check that the server starts" — what exactly proves it's working?
- **Phases too large**: 15 files in one phase — Claude will lose context mid-implementation
- **Missing dependencies**: Phase 3 uses a library added in Phase 1, but Phase 1 didn't include it
- **Tests written first**: the implementation doesn't exist yet, so tests can't pass
- **No expected output**: verification commands without expected output are ambiguous

### Verification

Before implementing, confirm the plan:
- Every ARCH.md component is covered by at least one phase
- At least one test per phase
- All verification commands have expected output
- Each phase is completable in one turn (~3-8 files)

---

## Phase 3: README.md — Project Landing Page

### When
After ARCH.md and PLAN.md exist, before or during early implementation.

### How to prompt Claude

> "Create README.md. Include: one-line description, architecture overview, quick start (install + build + run commands), and links to ARCH.md and WORKFLOW.md. Keep it under 100 lines. Write for someone who just cloned the repo."

### What good looks like

```markdown
# <project>

(One sentence on what it does)

## Quick Start
```bash
make build
./bin/my-project
```

## Documentation
- [ARCH.md](ARCH.md) — full architecture and design decisions
- [WORKFLOW.md](WORKFLOW.md) — development workflow and testing
```

---

## Phase 4: Implement (following PLAN.md)

### Workflow

1. Pick the next incomplete phase from PLAN.md
2. Tell Claude: "Implement Phase N from PLAN.md"
3. Claude creates files, writes code, runs verification commands
4. Review the changes
5. Update WORKLOG.md with what was done
6. Commit
7. Repeat

### Key practices

- **Fresh conversations for major phases**. Claude performs better with focused context.
- **Always run tests after changes**.
- **Commit after milestones**, not after every file edit. One commit per phase is a good rhythm.
- **Never let tests destroy real data**. Use separate databases, separate ports, test fixtures.

---

## Phase 5: WORKFLOW.md — Development Guide

### When
After the project has a working build, a test suite, and stable conventions. Typically after 3-4 implementation phases when patterns have emerged.

### How to generate

**Step 1 — Let patterns settle first.** Don't write WORKFLOW.md too early. Implement a few phases so real conventions emerge naturally. If you write it before any code exists, it'll be speculative and wrong.

**Step 2 — Generate from the actual codebase.**

> "Read through the codebase and create WORKFLOW.md documenting the actual conventions in use — not what we planned, but what's really there. Include: quick start (exact commands to build, test, run), project layout (directory tree with one-line descriptions), how to add a new <component/feature> (step-by-step with concrete file paths), code conventions (naming, patterns, error handling), and testing (how to run all tests, a single file, a single test)."

**Step 3 — Fill in the gaps.**

> "For each convention documented, add a one-sentence reason why. For each step in 'adding a new X', verify the steps work by tracing through the existing code."

> "Add a section on common pitfalls — what would a new developer get wrong on their first day?"

### What good looks like

```markdown
# <project> — Development Guide

## Quick Start
```bash
# Exact commands that work on a fresh clone
make setup
make build
make test
./bin/my-project --help
```

## Project Layout
```
src/
  main          — entry point
  core/         — business logic
  util/         — shared helpers
tests/
  unit/
  integration/
```

## Adding a new <component>
1. Create `src/<name>` with the interface
2. Register it in `src/registry`
3. Add tests in `tests/unit/test_<name>`
4. Run `make test` to confirm nothing broke
5. Update this file if the pattern changed

## Code Conventions
- **Naming**: snake_case for files and functions
- **Error handling**: return error codes, don't throw
- **Logging**: use the project logger, never printf
- **Dependencies**: prefer standard library, justify every external dep

## Testing
```bash
make test              # all tests
make test test_name    # single test
```

## Common Pitfalls
- The config loader validates at startup — if your component starts before config, it'll get defaults, not real values
- Test fixtures share a database — don't run tests in parallel
```

### Common mistakes
- **Written too early**: conventions haven't emerged yet, so the doc describes wishes not reality
- **Copied from another project**: conventions should reflect this codebase, not a template
- **No concrete commands**: "run the tests" instead of `make test`
- **Too long**: if it's over 150 lines, split it — the point is to be scanned quickly

### Verification

- Every command in WORKFLOW.md works when copy-pasted into a terminal
- A new developer can add a component by following the guide without asking questions
- Conventions documented match what's actually in the code

---

## Phase 6: WORKLOG.md — Session Journal

### When
Start during design phase. Update after every session.

### How to prompt Claude

At the end of each session:

> "Update WORKLOG.md with today's work. Include: context, design decisions, what was implemented, problems and fixes."

### What good looks like

```markdown
# <project> — Work Log

## YYYY-MM-DD: <title>

### Context
(What we're building toward)

### Design decisions
- **Decision**: (what and why)

### Implementation
- Phase 1: Scaffolding — created X, Y, Z
- Phase 2: Core logic — implemented A, B, C

### Problems and fixes
- **Problem**: description
  - **Fix**: what changed
```

Keep it chronological. Don't edit old entries — append new ones. This creates an honest record of how the project evolved.

---

## Config File Pattern

For projects that need local configuration, use the example/template pattern:

1. Create `myproject.example.conf` with defaults — **commit this**
2. Add `myproject.conf` to `.gitignore` — **never commit**
3. In the build or start script, copy example → real on first run if missing
4. Code only reads the real config, never the example
5. Test fixture also copies example if real config missing

This lets everyone customize locally without risking accidental commits.

---

## Quick Reference: Files at a Glance

| File | Created | Audience | Purpose |
|------|---------|----------|---------|
| CLAUDE.md | Phase 0 | Claude | How to behave in this project |
| ARCH.md | Phase 1 | Developers, Claude | Complete architectural blueprint |
| PLAN.md | Phase 2 | Claude | Executable implementation steps |
| README.md | Phase 3 | New contributors | What this is, how to run it |
| WORKFLOW.md | Phase 5 | Developers | Daily dev guide, testing, conventions |
| WORKLOG.md | Ongoing | Future self | Chronological record of what happened |
| .gitignore | Phase 0 | Git | What not to commit |
