# LLM Context Files

> Project to create configuration files that LLMs read before taking action, making Claude Code and other CLI tools more efficient.

## What It Does

Provides structured context files that define agent behavior, tool usage, and initialization sequences. LLMs read these files at startup to understand boundaries, capabilities, and workflows — reducing miscommunication and improving output quality.

## Files

| File | Purpose |
|------|---------|
| `AGENTS.md` | Agent behavior rules |
| `TOOLS.md` | Tool usage notes |
| `BOOTSTRAP.md` | Initialization sequence |
| `INSTRUCTIONS.md` | Index of instruction documents |
| `instructions/` | Detailed instruction documents |

## Quick Start

```bash
# reference from CLAUDE.md
echo "Load context: /path/to/llm-context-files/" >> CLAUDE.md
```

## Tech Stack

- Plain Markdown (no dependencies, universal LLM compatibility)
- Language: Markdown
- Framework: None (file-based configuration)

## Comparison

| Approach | This Project | Others |
|----------|--------------|--------|
| Context injection | Explicit file-based | Prompt engineering |
| Tool definitions | Dedicated TOOLS.md | Scattered in prompts |
| Bootstrap | Structured sequence | Ad-hoc |
