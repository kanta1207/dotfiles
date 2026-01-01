# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# ------------------------------------------------------------
# PATH: common
# ------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------
# Node / Ruby toolchains
# ------------------------------------------------------------

# nodebrew (only if installed)
if [ -x "$HOME/.nodebrew/current/bin/node" ]; then
  export PATH="$HOME/.nodebrew/current/bin:$PATH"
fi

# rbenv (only if installed)
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# anyenv (only if installed)
if command -v anyenv >/dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

# nvm (only if installed via Homebrew)
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
fi
if [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]; then
  . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# pnpm (only if installed)
PNPM_HOME="$HOME/Library/pnpm"
if [ -d "$PNPM_HOME" ]; then
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

# bun (only if installed)
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  # completions (optional)
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# volta (optional)
export VOLTA_FEATURE_PNPM=1

# ------------------------------------------------------------
# Cursor helper (only if Cursor is installed)
# ------------------------------------------------------------
if [ -d "/Applications/Cursor.app" ]; then
  function cursor {
    open -a "/Applications/Cursor.app" "$@"
  }
fi

# ------------------------------------------------------------
# Antigravity (only if present)
# ------------------------------------------------------------
if [ -d "$HOME/.antigravity/antigravity/bin" ]; then
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

# ------------------------------------------------------------
# Local overrides (NOT tracked)
#   - secrets (tokens)
#   - machine-specific env vars
# ------------------------------------------------------------
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# ------------------------------------------------------------
# Rust (only if present)
# ------------------------------------------------------------
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ------------------------------------------------------------
# Prompt (Starship) (only if installed)
# ------------------------------------------------------------
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"