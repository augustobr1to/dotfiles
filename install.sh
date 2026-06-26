#!/usr/bin/env bash
set -euo pipefail
# Simple installer for the dotfiles repository.
# - Backs up existing target files to ~/dotfiles_backup_TIMESTAMP
# - Symlinks top-level dotfiles, `bin/`, and `.config/` to $HOME

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"

DRY_RUN=0
WITH_CLAUDE_TOOLING=0
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    # Also install rtk + caveman into every Claude Code config dir after
    # symlinking (see bin/claude-tooling-setup and docs/CLAUDE-TOOLING.md).
    --with-claude-tooling) WITH_CLAUDE_TOOLING=1 ;;
  esac
done

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

# Claude Code tooling (rtk + caveman) is a separate, opt-in step because it
# writes into the live ~/.claude* config dirs rather than just symlinking.
if [[ $WITH_CLAUDE_TOOLING -eq 1 ]]; then
  echo
  echo "Running Claude Code tooling setup..."
  "$REPO_ROOT/bin/claude-tooling-setup"
else
  echo
  echo "To also install rtk + caveman into your Claude Code config dirs, run:"
  echo "  ./install.sh --with-claude-tooling   (or: bin/claude-tooling-setup)"
fi
