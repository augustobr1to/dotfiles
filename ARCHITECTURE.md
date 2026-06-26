# Architecture

This document describes the layout and intent of the repository.

Typical structure

- Top-level dotfiles (e.g. `.zshrc`, `.gitconfig`) are intended to be symlinked into the home directory.
- `bin/` contains user scripts installed into `~/bin` (e.g. `claude-tooling-setup`).
- `nvim/`, `tmux/`, and other tool-specific directories contain configuration for those tools.

Claude Code (multi-profile)

- Three accounts run from separate config dirs (`~/.claude`, `~/.claude-sp`,
  `~/.claude-sc`), selected by the `claude` / `claudesp` / `claudesc` aliases.
- Per-profile tooling (`rtk` hook, `caveman` plugin) is not symlinked — the
  config dirs hold mutable session state — so it is installed imperatively by
  `bin/claude-tooling-setup`, which is idempotent and re-runnable. See
  [docs/CLAUDE-TOOLING.md](docs/CLAUDE-TOOLING.md).

Design goals

- Keep configurations modular and easy to version-control.
- Prefer small, auditable scripts rather than opaque installers.
