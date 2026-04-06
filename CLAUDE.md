# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a meta-project that creates LLM context configuration files. These files define agent behavior, tool usage patterns, and initialization sequences that Claude Code and other LLM CLI tools read at startup. The files are designed to be universal and dependency-free (plain Markdown).

## Architecture

This project has a layered context file structure, read in order at session start:

1. **AGENTS.md** — General behavior guidelines for all agents (decision patterns, error handling, boundaries)
2. **TOOLS.md** — Tool usage notes and effective patterns for editor/search/shell/agent tools
3. **BOOTSTRAP.md** — Initialization sequence and bootstrap workflow

The files are intended to be loaded together, not in isolation. AGENTS.md establishes "how to behave," TOOLS.md establishes "how to use available tools," and BOOTSTRAP.md establishes "in what order to load context."

## Development Commands

This is a Markdown-only project with no build system, tests, or dependencies. There are no common commands to run.

## File Structure

| File | Purpose |
|------|---------|
| `AGENTS.md` | Agent behavior definitions, decision patterns, boundaries |
| `TOOLS.md` | Tool specifications, usage patterns, constraints |
| `BOOTSTRAP.md` | Agent initialization sequence |
| `CLAUDE.md` | This file — primary context for Claude Code |

## Context Loading Order

Per BOOTSTRAP.md, context loads in this order:
1. Memory (`MEMORY.md`) — user preferences, past feedback
2. Project-specific configs (`CLAUDE.md`, `AGENTS.md`, `TOOLS.md`)
3. Current working state

## Notes

- This project intentionally contains no code — only Markdown configuration files
- The context files are meant to be referenced by external tools, not executed
- No build, lint, test, or run commands exist
