#!/usr/bin/env bash
set -euo pipefail

skill_name="claude-codex-instruction-integration"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="${repo_root}/skill/${skill_name}"
claude_skills_dir="${HOME}/.claude/skills"
codex_skills_dir="${HOME}/.codex/skills"
target_dir="${claude_skills_dir}/${skill_name}"
link_path="${codex_skills_dir}/${skill_name}"
force=0

usage() {
  cat <<'EOF'
Install the claude-codex-instruction-integration skill into ~/.claude/skills
and link it into ~/.codex/skills.

Usage:
  ./scripts/install.sh [--force]

Options:
  --force   Stage existing conflicting paths under ~/.trash-staging/ before replacing them.
  -h, --help
EOF
}

stage_existing_path() {
  local path="$1"
  local stamp staging_root destination
  stamp="$(date +%Y%m%d-%H%M%S)"
  staging_root="${HOME}/.trash-staging/${skill_name}_install_${stamp}"
  destination="${staging_root}${path}"
  mkdir -p "$(dirname "${destination}")"
  mv "${path}" "${destination}"
  printf 'Staged existing path: %s -> %s\n' "${path}" "${destination}"
}

ensure_replaceable() {
  local path="$1"
  if [ ! -e "${path}" ] && [ ! -L "${path}" ]; then
    return 0
  fi

  if [ "${force}" -eq 1 ]; then
    stage_existing_path "${path}"
    return 0
  fi

  printf 'Refusing to overwrite existing path without --force: %s\n' "${path}" >&2
  printf 'Re-run with --force to stage the existing path under ~/.trash-staging/ first.\n' >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ ! -d "${source_dir}" ]; then
  printf 'Skill source directory not found: %s\n' "${source_dir}" >&2
  exit 1
fi

mkdir -p "${claude_skills_dir}" "${codex_skills_dir}"

if [ -L "${target_dir}" ]; then
  ensure_replaceable "${target_dir}"
elif [ -e "${target_dir}" ]; then
  ensure_replaceable "${target_dir}"
fi

if [ -L "${link_path}" ]; then
  current_target="$(readlink "${link_path}")"
  if [ "${current_target}" = "${target_dir}" ] && [ -d "${target_dir}" ]; then
    printf 'Codex link already points to the installed skill: %s\n' "${link_path}"
  else
    ensure_replaceable "${link_path}"
  fi
elif [ -e "${link_path}" ]; then
  ensure_replaceable "${link_path}"
fi

cp -R "${source_dir}" "${target_dir}"
ln -sfn "${target_dir}" "${link_path}"

printf 'Installed skill source: %s\n' "${target_dir}"
printf 'Created Codex link: %s -> %s\n' "${link_path}" "$(readlink "${link_path}")"
