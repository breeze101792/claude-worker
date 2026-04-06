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
<short description of changes made>

<optional detailed description>
```
