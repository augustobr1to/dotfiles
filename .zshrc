# Funcs
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# Aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

. "$HOME/.local/bin/env"

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
. "$HOME/.vite-plus/env"
# NOTE: Do NOT add .vite-plus/shims to PATH — that would override mise's Node

# Starship
eval "$(starship init zsh)"

# Ports
DEV_PORTS=(5173 5174 3333 3000)

# Git: Sync & Inspect
alias gsync='git fetch origin --prune && git branch -vv'
alias gst='git status -sb'
alias glog='git log --oneline --graph --decorate --all'
alias gbr='git branch -vv'

# Git: Branch Cleanup
alias gclean='git branch -vv | grep ": gone]" | awk "{print \$1}" | xargs git branch -D'

# Git: Worktree
alias wtl='git worktree list'
alias wtp='git worktree prune'