#!/usr/bin/env bash
set -e

# Configure repository root; assumes repo is cloned to ~/dotfiles.
DOTFILES="$HOME/dotfiles"

# Abort early if the repository is missing.
if [ ! -d "$DOTFILES" ]; then
  echo "Error: DOTFILES directory not found at $DOTFILES" >&2
  exit 1
fi

echo "Setting up dotfiles from $DOTFILES"

# Ensure base directories exist.
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Symlink helper that only links when the source exists.
link_item() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [ -e "$src" ] || [ -L "$src" ]; then
    echo "→ Linking $label"
    ln -sfn "$src" "$dest"
  else
    echo "→ Skipping $label (not found)"
  fi
}

# ------------------------------------------------------------
# Core dotfiles
# ------------------------------------------------------------
link_item "$DOTFILES/.zshrc"     "$HOME/.zshrc"     ".zshrc"
link_item "$DOTFILES/.bashrc"    "$HOME/.bashrc"    ".bashrc"
link_item "$DOTFILES/.gitconfig" "$HOME/.gitconfig" ".gitconfig"

# ------------------------------------------------------------
# Config directories
# ------------------------------------------------------------
link_item "$DOTFILES/.config/git"     "$HOME/.config/git"     ".config/git"
link_item "$DOTFILES/.config/wezterm" "$HOME/.config/wezterm" ".config/wezterm"
link_item "$DOTFILES/.config/ghostty" "$HOME/.config/ghostty" ".config/ghostty"

# ------------------------------------------------------------
# Starship
# ------------------------------------------------------------
if [ -e "$DOTFILES/.config/starship.toml" ] || [ -L "$DOTFILES/.config/starship.toml" ]; then
  link_item "$DOTFILES/.config/starship.toml" "$HOME/.config/starship.toml" ".config/starship.toml"
elif [ -e "$DOTFILES/starship.toml" ] || [ -L "$DOTFILES/starship.toml" ]; then
  link_item "$DOTFILES/starship.toml" "$HOME/.config/starship.toml" ".config/starship.toml (repo root)"
else
  echo "→ Skipping starship.toml (not found)"
fi

echo "Dotfiles setup complete."
