# Funcs
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Resend CLI
export PATH="$HOME/.resend/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/augustobrito/.bun/_bun" ] && source "/Users/augustobrito/.bun/_bun"

# Mise — manages Node, pnpm, and other runtimes (must come before Vite+)
eval "$(mise activate zsh)"

# Vite+ — bundling/build tooling only, NOT node shims
[[ -f "$HOME/.vite-plus/env" ]] && . "$HOME/.vite-plus/env"
# NOTE: Do NOT add .vite-plus/shims to PATH — that would override mise's Node

# Starship
eval "$(starship init zsh)"

# Ports
DEV_PORTS=(4984 8080 8787 5172 5173 5174 5175 3333 3000)

# Git aliases (gsync/gst/glog/gbr/gclean/wtl/wtp) live in ~/.zsh_aliases —
# single source of truth, sourced above. Do not redefine them here.

[[ -f "$HOME/.acme.sh/acme.sh.env" ]] && . "$HOME/.acme.sh/acme.sh.env"

# opencode
export PATH=/Users/augustobrito/.opencode/bin:$PATH

# Claude Code - Native Installer
export PATH="$HOME/.local/bin:$PATH"

# Claude Code multi-account aliases (claude/claudesp/claudesc) live in
# ~/.zsh_aliases — single source of truth, sourced above.