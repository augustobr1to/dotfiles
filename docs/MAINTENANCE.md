# Maintenance

Guidance for keeping these dotfiles up to date.

- Test changes locally before committing or opening a PR.
- Keep changes small and incremental.
- Use branches for experimental or breaking changes.
- Refresh Claude Code tooling after upstream releases by re-running
  `bin/claude-tooling-setup` (idempotent). When bumping caveman, review the
  pinned release tag noted in [SUPPLY-CHAIN-SECURITY.md](SUPPLY-CHAIN-SECURITY.md).

Automation

- Consider CI checks for linting, syntax, or quick smoke tests of scripts that run in CI containers.
