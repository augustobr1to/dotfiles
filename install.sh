#!/usr/bin/env bash
set -euo pipefail
# Simple installer for the dotfiles repository.
# - Backs up existing target files to ~/dotfiles_backup_TIMESTAMP
# - Symlinks top-level dotfiles, `bin/`, and `.config/` to $HOME

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]] || [[ "${1:-}" == "-n" ]]; then
  DRY_RUN=1
fi

echo "Installing dotfiles from $REPO_ROOT"

TARGETS=()
for path in "$REPO_ROOT"/.[!.]* "$REPO_ROOT"/bin "$REPO_ROOT"/.config; do
  [ -e "$path" ] || continue
  name="$(basename "$path")"
  # Skip .git and any backup files
  if [[ "$name" == ".git" ]] || [[ "$name" == ".gitignore" ]]; then
    continue
  fi
  TARGETS+=("$name")
done

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "No targets found to link.";
  exit 0
fi

echo "Targets to link: ${TARGETS[*]}"
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Dry-run mode: no changes will be made."
  exit 0
fi

mkdir -p "$BACKUP_DIR"

for name in "${TARGETS[@]}"; do
  src="$REPO_ROOT/$name"
  dest="$HOME/$name"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "Backing up existing $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi

  echo "Linking $src -> $dest"
  ln -s "$src" "$dest"
done

echo "Installation complete. Backups (if any) are in $BACKUP_DIR"
