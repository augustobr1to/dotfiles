# Claude Code Tooling (rtk + caveman)

This repo manages three separate Claude Code accounts/profiles, each backed by
its own config dir. The shell aliases that select them live in `.zsh_aliases`:

| Alias      | Config dir        | Account              |
|------------|-------------------|----------------------|
| `claude`   | `~/.claude`       | coody.app (default)  |
| `claudesp` | `~/.claude-sp`    | solarprime.com.br    |
| `claudesc` | `~/.claude-sc`    | spaceclass.com.br    |

Because each config dir is an independent profile, per-profile tooling must be
installed once **per dir**. Two tools are managed this way:

- **rtk** ([Rust Token Killer](https://github.com/)) — a token-optimizing CLI
  proxy wired in as a Claude Code `PreToolUse` hook. `rtk init -g` installs the
  hook, an `RTK.md` instruction file, an `@RTK.md` reference in `CLAUDE.md`, and
  patches `settings.json`.
- **caveman** ([JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman))
  — a Claude Code plugin (slash commands, skills, statusline badge, "caveman
  mode"). Installed via the upstream `install.sh`.

## Install / refresh

Run the bundled, idempotent helper (re-running only fills in gaps):

```bash
bin/claude-tooling-setup           # install into all three config dirs
bin/claude-tooling-setup --dry-run # preview the exact commands, change nothing
```

Or fold it into the dotfiles installer:

```bash
./install.sh --with-claude-tooling
```

## What it runs, per config dir

```bash
# rtk — RTK_CLAUDE_DIR selects which Claude config dir to target
RTK_CLAUDE_DIR="$dir" rtk init -g --auto-patch

# caveman — CLAUDE_CONFIG_DIR scopes the plugin install, hooks, and settings.json
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh \
  | CLAUDE_CONFIG_DIR="$dir" bash -s -- --non-interactive
```

> The `--config-dir` flag in caveman only scopes the hook files; the
> `CLAUDE_CONFIG_DIR` **environment variable** is what scopes `claude plugin
> install` to the right profile, so the helper uses the env var.

## Prerequisites

- **rtk**: `brew install rtk` — verify with `rtk gain` (watch out for the
  `reachingforthejack/rtk` name collision; you want the one where `rtk gain`
  works).
- **caveman**: Node.js >= 18 and `curl`.

## Verify

```bash
# rtk: each dir should report hook + RTK.md + settings.json "configured"
for d in ~/.claude ~/.claude-sp ~/.claude-sc; do
  echo "== $d =="; RTK_CLAUDE_DIR="$d" rtk init -g --show | sed -n '3,7p'
done

# caveman: each dir should list the plugin
for d in ~/.claude ~/.claude-sp ~/.claude-sc; do
  echo "== $d =="; grep -o 'caveman@caveman' "$d/plugins/installed_plugins.json"
done
```

Then restart any running Claude Code sessions so the hooks reload. Inside a
session, run `/caveman` (or say "caveman mode") to confirm the plugin is live.

## Supply chain

The caveman installer pins its remote fetches to an immutable release tag (not
the moving `main` branch), so a push upstream can't silently change what gets
executed. See [SUPPLY-CHAIN-SECURITY.md](SUPPLY-CHAIN-SECURITY.md). As always,
review `bin/claude-tooling-setup` and the upstream `install.sh` before running.
