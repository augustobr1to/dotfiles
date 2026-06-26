# Installation

These notes describe common installation approaches for these dotfiles. Adjust commands to your system.

Clone the repo:

```bash
git clone https://github.com/augustobr1to/dotfiles.git
cd dotfiles
```

If there is an install script (e.g. `install.sh`), run it:

```bash
./install.sh
```

If no script exists, the typical manual installation is to create symlinks from the repo files into your home directory. Example:

```bash
ln -s $PWD/.zshrc ~/.zshrc
ln -s $PWD/.config/nvim ~/.config/nvim
```

Always review scripts before running them.

## Claude Code tooling (rtk + caveman)

The dotfiles drive three Claude Code accounts via the `claude` / `claudesp` /
`claudesc` aliases (`~/.claude`, `~/.claude-sp`, `~/.claude-sc`). The `rtk` hook
and the `caveman` plugin must be installed into each config dir. Use the bundled
helper (idempotent):

```bash
bin/claude-tooling-setup            # install into all three config dirs
bin/claude-tooling-setup --dry-run  # preview only

# or fold it into the dotfiles install:
./install.sh --with-claude-tooling
```

Prerequisites: `brew install rtk`, plus Node.js >= 18 and `curl` for caveman.
See [docs/CLAUDE-TOOLING.md](docs/CLAUDE-TOOLING.md) for the full breakdown.
