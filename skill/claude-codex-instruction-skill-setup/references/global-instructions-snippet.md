Merge these blocks into `~/.claude/CLAUDE.md` if equivalent policies are missing. If similar blocks already exist, edit the existing text instead of pasting duplicate copies.

```md
## File And Directory Delete Safety Protocol

Do not permanently delete files or directories immediately. Always use this loop:

1. **Stage**: Move the delete target into `~/.trash-staging/`, grouped by project name and date.
   - Example: `~/.trash-staging/project-name_2026-03-11/`
   - Preserve the original path structure under the staging folder.
2. **Report**: Show the moved items to the user and ask for explicit deletion approval.
3. **Wait**: Do not run `rm` until the user approves.
4. **Delete**: Only after approval, permanently delete the staged folder.

Exceptions:
- Rebuildable artifacts such as build outputs, `node_modules`, and `__pycache__` can be deleted immediately.
- Do not treat a git-tracked source file as safely disposable without user confirmation.

## Skill Path Policy

Core rules:
- Do not rewrite the entire skill layout unless the user asks for it.
- Only use the Claude-origin plus Codex-symlink pattern for skills the user explicitly designates.
- Do not automatically sync built-in or unrelated pre-existing skills.
- Treat `~/.codex/AGENTS.md` as the canonical Codex-side compatibility spelling.
- On case-insensitive filesystems, do not mistake `~/.codex/AGENTS.md` and `~/.codex/agents.md` for two different files without checking first.

Defaults for newly requested skill install or creation:
- If the user asks to newly install or newly create a skill, treat that request as approval to use the shared pattern.
- Handle it in this order:
  1. Create or install the source skill under `~/.claude/skills/{skill-name}`.
  2. Create `~/.codex/skills/{skill-name}` as a symlink to the Claude-side source.
  3. Keep future edits on the Claude-side source so both tools use the same files.
- Keep `~/.claude/CLAUDE.md` as the instruction source and link `~/.codex/AGENTS.md -> ~/.claude/CLAUDE.md`.
- If both sides already have separate skill copies, preserve the current state first, then decide which copy becomes canonical.
- If the canonical source is unclear, ask the user before proceeding.

Shared-skill registry note:
- Only list skills that the user explicitly marked as shared or explicitly asked to newly install/create with this pattern.

Expansion rule:
- Do not convert additional older skills into this pattern unless the user explicitly asks.
- On case-insensitive filesystems, do not try to delete `~/.codex/agents.md` as if it were always a separate duplicate file.
```
