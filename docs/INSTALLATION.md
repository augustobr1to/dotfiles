# Installation

These notes describe common installation approaches for these dotfiles. Adjust commands to your system.

Clone the repo:

```bash
git clone https://github.com/augustobr1to/dotfiles.git
cd dotfiles
```

If there is an install or bootstrap script (e.g. `install.sh` or `bootstrap.sh`), run it:

```bash
./install.sh
# or
./bootstrap.sh
```

If no script exists, the typical manual installation is to create symlinks from the repo files into your home directory. Example:

```bash
ln -s $PWD/.zshrc ~/.zshrc
ln -s $PWD/.config/nvim ~/.config/nvim
```

Always review scripts before running them.
