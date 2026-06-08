# Architecture

This document describes the layout and intent of the repository.

Typical structure

- Top-level dotfiles (e.g. `.zshrc`, `.gitconfig`) are intended to be symlinked into the home directory.
- `bin/` may contain user scripts that are installed into `~/bin`.
- `nvim/`, `tmux/`, and other tool-specific directories contain configuration for those tools.

Design goals

- Keep configurations modular and easy to version-control.
- Prefer small, auditable scripts rather than opaque installers.
