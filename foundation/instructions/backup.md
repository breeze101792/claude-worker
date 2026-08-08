# Backup

Trigger: User says "backup yourself" or similar.

Action:
1. Run `git status` to see all changed files
2. Run `git diff` to review staged and unstaged changes
3. Run `git log` to review recent commit messages
4. Stage all changes: `git add <files>` or `git add -A` if appropriate
5. Create a commit with a descriptive message

Commit message format:
```
<type>(<optional scope>): <short, imperative description of the change>

<Detailed explanation of the change:
- Why was this change necessary?
- How does it address the problem?
- What are the specific effects of this change?>
```

Guidelines:
- **Type**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, or `chore`.
- **Subject**: Use the imperative mood (e.g., "add feature", not "added feature" or "adds feature"). Keep it under 50 characters.
- **Body**: Wrap text at 72 characters. Focus on the "why" and "what" rather than the "how".