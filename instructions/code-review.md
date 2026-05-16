# Code Review

Trigger: User asks to "review code", "review PR", "review commit", or similar.

## Steps

### 1. Identify Target Code

- If a commit hash or branch is provided, use `git show <ref>` or `git diff <ref>^..<ref>` to get pushed code
- If no ref provided, use `git diff` (unstaged) to read uncommitted changes
- Use `git log` to understand commit context if needed

### 2. Review the Code

Check for:

**Logic & Correctness**
- Logic defects, edge cases, off-by-one errors
- Incorrect assumptions or boundary conditions
- Missing error handling

**Memory Safety**
- Buffer overflows, use-after-free, null pointer dereferences
- Uninitialized variables
- Memory leaks (allocations without frees)

**Security**
- Injection vulnerabilities (SQL, command, path)
- Authentication/authorization gaps
- Hardcoded secrets or credentials

**Concurrency**
- Race conditions
- Deadlocks or livelocks
- Shared mutable state without proper synchronization

**Performance**
- Unnecessary O(n²) loops or expensive operations
- Missing indices or caches where appropriate
- Resource leaks (file handles, connections)

**Style & Maintainability**
- Overly complex code that could be simplified
- Missing documentation for non-obvious logic
- Inconsistent naming or patterns

### 3. Review Project Context

- Read `ARCH.md` or similar architecture docs if they exist
- Check `CLAUDE.md`, `.claude/config.json`, or project docs for conventions
- Look at existing code patterns in the same area for consistency

### 4. Review Commit Message

Check if commit message includes:
- **What** changed (clear summary)
- **Why** it changed (purpose/motivation)
- **Breaking changes** if any
- **Related issues** or ticket references

Flag if message is vague, missing context, or has poor formatting.

### 5. Generate Review Report

Create `review_[commit_title].md` in the project root:

```markdown
# Code Review: [commit title]

**Commit:** [hash]
**Author:** [author]
**Date:** [date]

## Summary

[1-2 sentence overview of the change]

## Issues Found

### [Severity] — [Category]
[Description of issue]
- Location: [file:line or function]
- Suggestion: [how to fix]

## Recommendations

[Any additional suggestions not blocking but worth considering]

## Commit Message Review

[Feedback on the commit message quality]
```

Severity levels: `Critical`, `High`, `Medium`, `Low`, `Nit`