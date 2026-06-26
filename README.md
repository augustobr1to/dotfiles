# Dotfiles

A personal collection of configuration files used to customize and streamline my development environment. This repository includes settings for shell, editor, terminal, and other tools, with a focus on productivity, consistency, and portability across systems.

## Documentation

See the repository-level documentation for contribution guidelines, installation, usage, security, and maintenance notes:

- [CONTRIBUTING](CONTRIBUTING.md)
- [CODE OF CONDUCT](CODE_OF_CONDUCT.md)
- [INSTALLATION](INSTALLATION.md)
- [USAGE](USAGE.md)
- [ARCHITECTURE](ARCHITECTURE.md)
- [CLAUDE CODE TOOLING (rtk + caveman)](docs/CLAUDE-TOOLING.md)
- [SECURITY](SECURITY.md)
- [SUPPLY CHAIN SECURITY](docs/SUPPLY-CHAIN-SECURITY.md)
- [MAINTENANCE](MAINTENANCE.md)
- [FAQ](FAQ.md)

## Claude Code

This setup runs three Claude Code accounts, selected by the `claude`, `claudesp`,
and `claudesc` aliases (see `.zsh_aliases`). Per-profile tooling — `rtk`,
`caveman`, and a curated set of marketplace plugins — is installed into each
config dir with `bin/claude-tooling-setup`. See
[CLAUDE CODE TOOLING](docs/CLAUDE-TOOLING.md) for the plugin list and details.
