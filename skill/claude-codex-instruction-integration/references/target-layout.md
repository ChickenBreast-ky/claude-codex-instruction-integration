# Target Layout

Aim for this structure after setup:

```text
~/.claude/CLAUDE.md
~/.codex/AGENTS.md -> ~/.claude/CLAUDE.md

~/.claude/skills/<skill-name>/
~/.codex/skills/<skill-name> -> ~/.claude/skills/<skill-name>
```

## Meaning

- `~/.claude` is the source side.
- `~/.codex` is the consumer side.
- Shared skills should live once, not twice.

## Default Direction

Use this direction unless the user explicitly asks otherwise:

1. Global instruction file:
   - source: `~/.claude/CLAUDE.md`
   - consumer link spelling: `~/.codex/AGENTS.md`
2. Shared skills:
   - source: `~/.claude/skills/<skill-name>`
   - consumer link: `~/.codex/skills/<skill-name>`

## Case Sensitivity Note

- On the usual macOS default filesystem, `AGENTS.md` and `agents.md` can point to the same single directory entry.
- Treat `~/.codex/AGENTS.md` as the canonical spelling.
- Do not assume `~/.codex/AGENTS.md` and `~/.codex/agents.md` are two separately removable files.

## Verification Checklist

- `ls -l ~/.codex/AGENTS.md`
- `readlink ~/.codex/AGENTS.md`
- `ls -ld ~/.claude/skills/<skill-name> ~/.codex/skills/<skill-name>`
- `readlink ~/.codex/skills/<skill-name>`
