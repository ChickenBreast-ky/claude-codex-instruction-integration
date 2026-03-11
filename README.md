# Claude Codex Integration

Public skill for setting up one editable instruction source for Claude and Codex, plus a predictable pattern for newly requested shared skills.

## What It Does

This skill covers three setup jobs:

1. Normalize global instructions so `~/.claude/CLAUDE.md` is the source of truth and Codex reads it through a compatibility symlink.
2. Add a policy for newly requested skill installs and skill creation so the Claude side holds the real skill directory and the Codex side points to it.
3. Add a delete-safety policy so destructive deletes are staged for approval before permanent removal.

It supports two execution modes:

- `New machine setup`
- `Existing machine cleanup and apply`

## Install

Copy the skill directory into your Claude skills folder, then link it into your Codex skills folder.

```bash
mkdir -p ~/.claude/skills ~/.codex/skills
cp -R ./skill/claude-codex-integration ~/.claude/skills/claude-codex-integration
ln -sfn ~/.claude/skills/claude-codex-integration ~/.codex/skills/claude-codex-integration
```

## Use

Example prompts:

- `Use $claude-codex-integration in new-machine mode and apply the setup.`
- `Use $claude-codex-integration in existing-machine mode, inspect the current state, then clean up and apply the setup.`

## Repository Layout

- `skill/claude-codex-integration/`
  - The actual skill folder to install.
- `README.md`
  - Human-facing overview and installation notes.

## Notes

- The skill uses generic home-directory paths such as `~/.claude`, `~/.codex`, and `~/.trash-staging`.
- Review the policy snippet before using it as-is in your own environment.
