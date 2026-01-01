# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash"

export PATH="$HOME/.local/bin:$PATH"

# Local overrides (not tracked)
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash"