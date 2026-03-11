---
name: claude-codex-instruction-skill-setup
description: Bootstrap or normalize a single-source-of-truth Claude/Codex workstation focused on shared instruction files and new-skill linking, using two explicit modes. Use this skill when the user wants either (1) a new-machine setup that applies a standard shared structure from scratch, or (2) an existing-machine cleanup-and-apply flow that inspects older instruction files and prior local setup before normalizing them. Trigger on requests like "set up Claude and Codex to share one instruction source", "new machine setup", "existing machine cleanup", "link Claude and Codex instruction files", or "install this skill so both tools use one source". For existing machines, inspect older `agent.md`-style files first and ask before merging their content into Claude. Always add the delete-safety rules, and only symlink skills that the user explicitly asked to newly install or newly create.
---

# Claude Codex Instruction Skill Setup

## Human Summary

This skill standardizes a Claude/Codex environment around one editable source.

Core outcomes:

1. Global instruction normalization
   - Keep `~/.claude/CLAUDE.md` as the canonical instruction file.
   - Point Codex to that file through a compatibility symlink.
   - If older `agent.md`-style files contain unique instructions, ask before merging them.
2. Shared-skill policy
   - Only newly requested installs or newly requested skill creations get the Claude-origin plus Codex-symlink treatment.
   - Do not auto-convert built-in or unrelated existing skills.
3. Delete-safety policy
   - Stage destructive deletes under `~/.trash-staging/`.
   - Only permanently delete after user approval.

Execution modes:

- `New machine setup`
- `Existing machine cleanup and apply`

Example trigger phrases:

- `Use this skill in new-machine mode and apply the setup.`
- `Use this skill in existing-machine mode, inspect the current state, then clean up and apply the setup.`

## Entry Modes

### 1) New Machine Setup

Use this when the machine is fresh, mostly empty, or the user wants a clean standard setup applied directly.

Expected behavior:

- Create the standard shared structure.
- Add the required global instruction blocks.
- Point the Codex compatibility instruction file to Claude.
- Apply shared-skill linking only for newly requested skills.
- Ask only if unexpected pre-existing instruction files or conflicting real files are discovered.

### 2) Existing Machine Cleanup And Apply

Use this when the machine already has history, older dotfiles, older agent files, or a mixed Claude/Codex setup that may need cleanup first.

Expected behavior:

- Inspect current files and links first.
- Identify which files are real sources and which are compatibility pointers.
- Summarize meaningful older instructions that may need merging.
- Ask before merging nontrivial older instruction content into `~/.claude/CLAUDE.md`.
- Normalize the final structure only after that review step.

## Mode Decision

- If the user explicitly says `new machine`, run the new-machine flow.
- If the user explicitly says `existing machine cleanup`, run the existing-machine flow.
- If the user only asks for a vague setup, choose the safer existing-machine flow unless the machine is clearly fresh.

## Quick Start

1. Read `references/target-layout.md`.
2. Inspect the current state before changing anything:

```bash
ls -ld ~/.claude ~/.codex ~/.claude/CLAUDE.md ~/.claude/agent.md ~/.codex/AGENTS.md ~/.codex/agent.md ~/.claude/skills ~/.codex/skills 2>/dev/null
```

3. Pick one mode before editing anything:
   - `New machine setup`
   - `Existing machine cleanup and apply`
4. If existing files or skill directories conflict with the target structure, back them up before replacing or re-linking them.
5. Some setups already use a global instruction file, but the filename is not always the same. Check common candidates such as `agent.md`, `AGENTS.md`, and `agents.md` under `~/.claude` or `~/.codex`.
6. For the existing-machine mode, if any of those real files contain meaningful instructions that are not already in `~/.claude/CLAUDE.md`, summarize the difference and ask whether that content should be merged into Claude before replacing it with a symlink.
7. Merge the policy block from `references/global-instructions-snippet.md` into `~/.claude/CLAUDE.md` without duplicating equivalent text.
8. Include the delete-safety block from the same reference so the machine inherits the staged-delete workflow by default.
9. Point `~/.codex/AGENTS.md` at `~/.claude/CLAUDE.md`.
10. On case-insensitive filesystems such as the usual macOS default, `~/.codex/AGENTS.md` and `~/.codex/agents.md` may be the same filesystem entry with different spelling. Treat them as one alias, not two separate files to clean up.
11. Only for skills the user explicitly asked to newly install or newly create in this setup, keep the origin at `~/.claude/skills/<skill-name>` and point `~/.codex/skills/<skill-name>` to it.
12. Do not bulk-sync preinstalled, bundled, or merely pre-existing skills unless the user explicitly asks to convert them too.
13. Verify with `ls -l` and `readlink`, then report the final topology and any preserved backups.

## Workflow

### 1) Confirm The Mode First

- `New machine setup` means: assume a clean setup target and minimize questions.
- `Existing machine cleanup and apply` means: inspect first, explain findings, then normalize.
- Do not blend the two modes into one vague flow.

### 2) Confirm The Canonical Side

- Treat `~/.claude/CLAUDE.md` as the canonical global instruction file.
- Treat `~/.claude/skills/<skill-name>` as the canonical home for any shared skill.
- Treat `.codex` as the consumer side that should point to the Claude side, with `~/.codex/AGENTS.md` as the canonical spelling for the compatibility link.
- If the user explicitly asks for separate copies instead of shared ones, stop using this workflow because it breaks the one-source-of-truth model.

### 3) Prepare The Filesystem Safely

- Ensure `~/.claude`, `~/.codex`, `~/.claude/skills`, and `~/.codex/skills` exist.
- If a target path already exists and is not the desired symlink, preserve it before replacing it.
- Prefer timestamped backups so the old state can be restored easily.
- Do not silently delete a real skill directory just to make a symlink.

Example:

```bash
mkdir -p ~/.claude ~/.codex ~/.claude/skills ~/.codex/skills
backup_dir="$HOME/.claude/backups/shared-setup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
```

### 4) Configure Shared Global Instructions

- Create or update `~/.claude/CLAUDE.md`.
- Different tools and past setups may have used different instruction filenames. Check likely candidates such as `~/.claude/agent.md`, `~/.claude/AGENTS.md`, `~/.claude/agents.md`, `~/.codex/agent.md`, `~/.codex/AGENTS.md`, and `~/.codex/agents.md`.
- If any of those paths already exists as a real file with nontrivial content, compare it against `~/.claude/CLAUDE.md`.
- In `Existing machine cleanup and apply` mode, if that older file appears to contain instructions missing from Claude, do not silently discard it. Summarize the missing points and ask whether to merge them into `~/.claude/CLAUDE.md`.
- In `New machine setup` mode, only ask if supposedly old instruction content is unexpectedly present.
- Merge or refresh the rules blocks from `references/global-instructions-snippet.md`.
- Edit in place if a near-equivalent policy already exists; do not paste a second copy of the same rule.
- Ensure the merged content includes the delete-safety protocol, not only the skill-linking policy.
- Point the Codex compatibility instruction path to the Claude file.
- On case-insensitive filesystems, do not try to delete `agents.md` separately from `AGENTS.md`. They may resolve to the same inode.

Useful commands:

```bash
ln -sfn "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"
ls -l "$HOME/.codex/AGENTS.md"
```

### 5) Configure Shared Skills For Newly Requested Installs Or Creates

- Apply this section only to skills the user explicitly asked to newly install or newly create during the current setup task.
- Do not sweep through built-in skills or older local skills and convert them automatically just because they already exist.
- When installing or creating a shared skill, make the real directory in `~/.claude/skills/<skill-name>`.
- Make `~/.codex/skills/<skill-name>` a symlink to that Claude directory.
- If the skill already exists only in Codex as a real directory, preserve it, move or copy the canonical content into Claude, then replace the Codex path with a symlink.
- If both sides already exist with different contents, compare before deciding which one becomes canonical. Default to Claude only after preserving both states.
- Keep the folder name identical on both sides so the link remains obvious and predictable.

Useful commands:

```bash
mkdir -p "$HOME/.claude/skills" "$HOME/.codex/skills"
ln -sfn "$HOME/.claude/skills/<skill-name>" "$HOME/.codex/skills/<skill-name>"
ls -ld "$HOME/.claude/skills/<skill-name>" "$HOME/.codex/skills/<skill-name>"
```

### 6) Verify And Report

- Confirm that `readlink ~/.codex/AGENTS.md` resolves to `~/.claude/CLAUDE.md`.
- If `~/.codex/agents.md` also resolves, explain whether it is just the same case-insensitive alias or a truly separate entry on that machine.
- Confirm that each shared skill under `.codex/skills/` resolves to the matching Claude path.
- Report:
  - which mode was used
  - canonical global file
  - which skills are shared through symlinks
  - what was backed up before changes
  - any paths intentionally left as standalone copies

## Quality Gates

- Keep exactly one editable source for each shared instruction file or shared skill.
- Never discard an existing file or skill without preserving it first.
- Ask before merging nontrivial content from an older `agent.md`-style file into `~/.claude/CLAUDE.md`.
- Do not leave duplicate policy blocks in `CLAUDE.md`.
- Do not auto-convert built-in or unrelated existing skills into shared symlinked skills.
- Keep symlink targets explicit and easy to verify.
- If the current machine state is ambiguous, stop and explain the ambiguity instead of guessing.

## References

- `references/target-layout.md`
- `references/global-instructions-snippet.md`
