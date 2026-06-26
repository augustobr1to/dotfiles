# Supply Chain Security Settings Explained

## mise (mise-en-place)

mise secures the dev toolchain (Node.js, Python, Terraform, etc.), **not package dependencies**. It verifies authenticity and integrity when installing tools.

### Settings Location

- Global: `~/.config/mise/config.toml`
- Local: `mise.toml`
- CLI: `mise settings key=value`
- Env: `MISE_<KEY>`

### Recommended Security Settings

```toml
[settings]
minimum_release_age = "7d"
slsa = true
github_attestations = true
provenance_api_failures_fatal = true
lockfile = true
locked = true
gpg_verify = true
paranoid = true
```

### Key Settings Explained

| Setting | Purpose | Default |
|---------|---------|---------|
| **`minimum_release_age = "7d"`** | Blocks tool versions published less than 7 days ago. | `None` (no delay) |
| **`slsa = true`** | Verifies SLSA provenance attestations for supply-chain integrity. | `true` (enabled) |
| **`github_attestations = true`** | Verifies GitHub Artifact Attestations for authenticity. | `true` (enabled) |
| **`provenance_api_failures_fatal = true`** | Treats provenance API errors as install failures. | `true` (fail on error) |
| **`lockfile = true`** | Creates `mise.lock` with pinned versions. | `None` (enabled) |
| **`locked = true`** | Fails if tools lack pre-resolved URLs in lockfile. | `false` |
| **`gpg_verify = true`** | Uses GPG to verify all tool signatures. | `None` (backend default) |
| **`paranoid = true`** | Enables extra-secure behavior. | `false` |

## pnpm

pnpm is the **only** package manager covering all three major supply chain defenses: new-package quarantine, whitelisted build scripts, and exotic-source blocking.

### Settings Location

- Global: `~/.pnpmrc`
- Local: `.pnpmrc`

### Recommended Security Settings

```ini
minimumReleaseAge=10080
blockExoticSubdeps=true
allowBuilds=esbuild,sharp,postcss,typescript
trustPolicy=no-downgrade
lockfile=true
```

### Key Settings Explained

| Setting | Purpose | Default |
|---------|---------|---------|
| **`minimumReleaseAge=10080`** | Blocks packages published <7 days ago (10080 minutes). | `1440` in v11 (1 day) |
| **`blockExoticSubdeps=true`** | Prevents transitive deps from git repos/tarballs. | `false` |
| **`allowBuilds=esbuild,sharp,...`** | Whitelist packages allowed to run build scripts. | Disables all by default in v10+ |
| **`trustPolicy=no-downgrade`** | Blocks installation if trust level decreases. | `no-downgrade` |
| **`lockfile=true`** | Commits exact versions. | `true` |

## npm

npm can delay newly published versions and block install scripts, but script blocking is **all-or-nothing with no whitelist**.

### Settings Location

- Global: `~/.npmrc`
- Local: `.npmrc`

### Recommended Security Settings

```ini
min-release-age=7
ignore-scripts=true
package-lock=true
engine-strict=true
```

### Key Settings Explained

| Setting | Purpose | Default |
|---------|---------|---------|
| **`min-release-age=7`** | Refuses packages published <7 days ago. Requires npm ≥ 11.10.0. | `0` (no delay) |
| **`ignore-scripts=true`** | Blocks `postinstall`/`preinstall` scripts. | `false` |
| **`package-lock=true`** | Enforces lockfile integrity. | `true` |
| **`engine-strict=true`** | Enforces minimum npm version. | `false` |

## Comparison Summary

| Capability | mise | pnpm | npm |
|------------|------|------|-----|
| **New-release quarantine** | ✅ `minimum_release_age` | ✅ `minimumReleaseAge` | ✅ `min-release-age` (npm 11.10+) |
| **Build script whitelist** | ❌ (tools, not packages) | ✅ `allowBuilds` | ❌ (`ignore-scripts` is all-or-nothing) |
| **Exotic-source blocking** | ❌ | ✅ `blockExoticSubdeps` | ❌ |
| **Provenance verification** | ✅ SLSA + GitHub attestations | ⚠️ Partial | ⚠️ Partial |
| **Lockfile enforcement** | ✅ `locked` | ✅ `lockfile` | ✅ `package-lock` |

## Claude Code tooling installers (rtk + caveman)

`bin/claude-tooling-setup` installs two external tools into each Claude Code
config dir (see [CLAUDE-TOOLING.md](CLAUDE-TOOLING.md)). Both are run through a
thin, auditable wrapper rather than blind one-liners.

| Tool | Install path | Supply-chain notes |
|------|--------------|--------------------|
| **rtk** | `brew install rtk` | Homebrew formula; pinned/auditable via the tap. The wrapper only calls the already-installed `rtk` binary (`rtk init -g`), never downloads it. |
| **caveman** | `curl … install.sh \| bash` → `npx github:JuliusBrussee/caveman` | The upstream installer pins **all** remote fetches to an immutable release tag (currently `v1.9.0`), not the moving `main` branch, so an upstream push cannot silently change what executes. It ships a `checksums.sha256` integrity manifest for the hook files. |

The same helper also installs Claude Code **marketplace plugins** (see
[CLAUDE-TOOLING.md](CLAUDE-TOOLING.md)). Most come from the first-party
`anthropics/claude-plugins-official` marketplace; `warp` comes from the vendor
marketplace `warpdotdev/claude-code-warp`. Adding a marketplace and installing
its plugins runs third-party code — review the marketplace and pin/track the
plugin versions you depend on.

Guidance:

- **Review before running.** Read `bin/claude-tooling-setup` and the upstream
  `install.sh` (and bump-pinned tag) before each run; use `--dry-run` to see the
  exact commands first.
- **Pin awareness.** Caveman's pinned ref can be overridden with `CAVEMAN_REF`
  for testing — leave it unset in normal use so you get the vetted release tag.
- **Scope.** The installs only touch `~/.claude*` config dirs (hooks, plugin,
  `settings.json`); they do not modify package manifests or lockfiles.
