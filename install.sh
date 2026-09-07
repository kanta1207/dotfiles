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

# Install Homebrew packages declared in Brewfile when available.
if [ "$(uname -s)" = "Darwin" ]; then
  if command -v brew >/dev/null 2>&1; then
    BREW="$(command -v brew)"
  elif [ -x /opt/homebrew/bin/brew ]; then
    BREW=/opt/homebrew/bin/brew
  else
    BREW=""
  fi

  if [ -n "$BREW" ]; then
    if [ -f "$DOTFILES/Brewfile" ]; then
      echo "→ Installing Homebrew packages from Brewfile"
      "$BREW" bundle --file="$DOTFILES/Brewfile"
    else
      echo "→ Skipping Homebrew bundle (Brewfile not found)"
    fi
  else
    echo "→ Skipping Homebrew bundle (Homebrew not installed). Install Homebrew and run 'brew bundle --file \"$DOTFILES/Brewfile\"' to install Brewfile packages."
  fi
else
  echo "→ Skipping Homebrew bundle (macOS only)"
fi

# Symlink helper that never replaces an existing destination.
link_item() {
  local src="$1"
  local dest="$2"
  local label="$3"

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    echo "→ Skipping $label (not found)"
    return 0
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "→ Already linked $label"
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "Error: refusing to replace existing $dest" >&2
    return 1
  fi

  echo "→ Linking $label"
  ln -s "$src" "$dest"
}

# ------------------------------------------------------------
# Core dotfiles
# ------------------------------------------------------------
link_item "$DOTFILES/.zshrc"     "$HOME/.zshrc"     ".zshrc"
link_item "$DOTFILES/.bashrc"    "$HOME/.bashrc"    ".bashrc"
link_item "$DOTFILES/.gitconfig" "$HOME/.gitconfig" ".gitconfig"
link_item "$DOTFILES/.zprofile"  "$HOME/.zprofile"  ".zprofile"

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
else
  echo "→ Skipping starship.toml (not found)"
fi

# ------------------------------------------------------------
# SSH Configuration
# ------------------------------------------------------------
if [ -e "$DOTFILES/ssh/config" ]; then
  echo "→ Setting up SSH configuration"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  link_item "$DOTFILES/ssh/config" "$HOME/.ssh/config" "SSH config"
  chmod 600 "$HOME/.ssh/config"
else
  echo "→ Skipping SSH config (not found)"
fi

echo "Dotfiles setup complete."
