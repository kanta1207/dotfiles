# Initialize zoxide's shell functions only when the binary is available.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
