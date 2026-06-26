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
- **marketplace plugins** — a curated set installed via `claude plugin install`
  (see the table below).

## Plugins

Installed into every config dir from their marketplaces:

| Plugin | Marketplace |
|--------|-------------|
| `github` | `claude-plugins-official` (`anthropics/claude-plugins-official`) |
| `claude-md-management` | `claude-plugins-official` |
| `code-simplifier` | `claude-plugins-official` |
| `security-guidance` | `claude-plugins-official` |
| `remember` | `claude-plugins-official` |
| `superpowers` | `claude-plugins-official` |
| `skill-creator` | `claude-plugins-official` |
| `ralph-loop` | `claude-plugins-official` |
| `warp` | `claude-code-warp` (`warpdotdev/claude-code-warp`) |

The helper runs `claude plugin marketplace add <source>` for the marketplaces
above before installing, so it works on a fresh machine.

### Not installed as plugins (built-in features)

These were requested but are **not** `claude plugin install` plugins:

- **claude-in-chrome** — a built-in Claude Code feature. Install the Chrome
  extension and enable it with `claude --chrome` or `/chrome` in a session.
- **computer-use** — a built-in capability, not a marketplace plugin.
- **excalidraw** — no official marketplace plugin by that name (only third-party
  MCP servers / skills). Add one explicitly if you want it.

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

# plugins — ensure marketplaces, then install each plugin (CLAUDE_CONFIG_DIR scopes it)
CLAUDE_CONFIG_DIR="$dir" claude plugin marketplace add anthropics/claude-plugins-official
CLAUDE_CONFIG_DIR="$dir" claude plugin marketplace add warpdotdev/claude-code-warp
CLAUDE_CONFIG_DIR="$dir" claude plugin install code-simplifier@claude-plugins-official
# ... (see PLUGINS in bin/claude-tooling-setup for the full list)
```

> The `--config-dir` flag in caveman only scopes the hook files; the
> `CLAUDE_CONFIG_DIR` **environment variable** is what scopes `claude plugin
> install` to the right profile, so the helper uses the env var.

## Prerequisites

- **rtk**: `brew install rtk` — verify with `rtk gain` (watch out for the
  `reachingforthejack/rtk` name collision; you want the one where `rtk gain`
  works).
- **caveman**: Node.js >= 18 and `curl`.
- **plugins**: the `claude` CLI on `PATH` (or set `CLAUDE_BIN=/path/to/claude`;
  the helper also falls back to `~/.local/bin/claude`).

## Verify

```bash
# rtk: each dir should report hook + RTK.md + settings.json "configured"
for d in ~/.claude ~/.claude-sp ~/.claude-sc; do
  echo "== $d =="; RTK_CLAUDE_DIR="$d" rtk init -g --show | sed -n '3,7p'
done

# caveman + plugins: each dir should list them
for d in ~/.claude ~/.claude-sp ~/.claude-sc; do
  echo "== $d =="; CLAUDE_CONFIG_DIR="$d" claude plugin list
done
```

Then restart any running Claude Code sessions so the hooks reload. Inside a
session, run `/caveman` (or say "caveman mode") to confirm the plugin is live.

## Supply chain

The caveman installer pins its remote fetches to an immutable release tag (not
the moving `main` branch), so a push upstream can't silently change what gets
executed. See [SUPPLY-CHAIN-SECURITY.md](SUPPLY-CHAIN-SECURITY.md). As always,
review `bin/claude-tooling-setup` and the upstream `install.sh` before running.
