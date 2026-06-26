# Usage

This repository contains configuration files for your development environment. How you use them depends on which tools you use.

Common examples:

- Shell: link or source `~/.zshrc` or `~/.bashrc` from the repo.
- Neovim: link `~/.config/nvim` to the repo's `nvim` configuration.
- Git: install `~/.gitconfig` and any helper scripts in `~/bin`.
- Claude Code: switch accounts with the `claude` / `claudesp` / `claudesc`
  aliases, and install per-profile tooling with `bin/claude-tooling-setup`
  (see [docs/CLAUDE-TOOLING.md](docs/CLAUDE-TOOLING.md)).

Inspect the files in the repo to see what will be applied to your environment. Use the installation instructions before making changes to your live environment.
