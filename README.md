# Claude Codex Instruction Integration

[한국어 README](./README.ko.md)

Public skill for integrating Claude and Codex around one editable instruction source, plus a predictable linking pattern for newly requested shared skills.

## Quick Start

```bash
git clone https://github.com/ChickenBreast-ky/claude-codex-instruction-integration.git
cd claude-codex-instruction-integration
./scripts/install.sh
```

Then ask:

- `Use $claude-codex-instruction-integration in new-machine mode and apply the setup.`
- `Use $claude-codex-instruction-integration in existing-machine mode, inspect the current state, then clean up and apply the setup.`

## What It Does

This skill covers three setup jobs:

1. Normalize global instructions so `~/.claude/CLAUDE.md` is the source of truth and Codex reads it through a compatibility symlink.
2. Add a policy for newly requested skill installs and skill creation so the Claude side holds the real skill directory and the Codex side points to it.
3. Add a delete-safety policy so destructive deletes are staged for approval before permanent removal.

It supports two execution modes:

- `New machine setup`
- `Existing machine cleanup and apply`

## Install

Run the installer from the cloned repository.

```bash
./scripts/install.sh
```

If the target paths already exist and you want the installer to stage and replace them safely:

```bash
./scripts/install.sh --force
```

## Use

Example prompts:

- `Use $claude-codex-instruction-integration in new-machine mode and apply the setup.`
- `Use $claude-codex-instruction-integration in existing-machine mode, inspect the current state, then clean up and apply the setup.`

## Repository Layout

- `scripts/install.sh`
  - Safe installer for copying the skill into `~/.claude/skills` and linking it into `~/.codex/skills`.
- `skill/claude-codex-instruction-integration/`
  - The actual skill folder to install.
- `README.md`
  - Human-facing overview and installation notes.

## Notes

- The skill uses generic home-directory paths such as `~/.claude`, `~/.codex`, and `~/.trash-staging`.
- Review the policy snippet before using it as-is in your own environment.
- The installer stages conflicting paths under `~/.trash-staging/` when run with `--force`.
