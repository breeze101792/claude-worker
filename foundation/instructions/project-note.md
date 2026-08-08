# Project Note

Trigger: User asks to "add project note", "generate project docs", or similar.

Action:
When in a project folder, create 3 documentation files to help people understand the codebase:

## 1. `docs/arch.md` — Architecture Analysis

Analyze and document:
- **Source code design** — folder structure, key modules, class/function organization
- **High-level design** — overall architecture, data flow, key components
- **Other useful context** — design patterns used, conventions, anything that helps understanding

## 2. `docs/build.md` — Build Guide

Parse and document:
- Makefiles, config files (CMakeLists.txt, package.json, Cargo.toml, etc.)
- Setup/build scripts (setup.py, Makefile, build.sh, etc.)
- Dependencies and how to install/build the project

Include step-by-step build instructions.

## 3. `docs/repos.md` — Module/Dependency Analysis

Analyze and document:
- Submodules, git submodules
- External dependencies (package managers, external repos)
- Each module's purpose and how they relate

---

Output:
- If `notes/` exists as a global folder, create files under `notes/<project-name>/`
- Otherwise, create files under `docs/`