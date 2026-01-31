#!/usr/bin/env bash
set -euo pipefail

# dev-nvim installer
# https://github.com/mpaarating/dev-nvim

REPO_URL="https://github.com/mpaarating/dev-nvim.git"
INSTALL_DIR="${HOME}/.dotfiles/nvim"
CONFIG_DIR="${HOME}/.config/nvim"
BACKUP_DIR="${HOME}/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}▸${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; }

# Check if command exists
has_cmd() { command -v "$1" &>/dev/null; }

# Compare versions: returns 0 if $1 >= $2
version_gte() {
  printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# Extract version number from nvim --version
get_nvim_version() {
  nvim --version | head -n1 | sed -E 's/NVIM v([0-9]+\.[0-9]+).*/\1/'
}

echo ""
echo "╭────────────────────────────────────────╮"
echo "│         dev-nvim installer             │"
echo "╰────────────────────────────────────────╯"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Prerequisites
# ─────────────────────────────────────────────────────────────────────────────

info "Checking prerequisites..."

errors=0

# Git
if has_cmd git; then
  success "git found"
else
  error "git not found - please install git first"
  ((errors++))
fi

# Neovim
if has_cmd nvim; then
  nvim_version=$(get_nvim_version)
  if version_gte "$nvim_version" "0.11"; then
    success "nvim $nvim_version found (>= 0.11 required)"
  else
    error "nvim $nvim_version found, but >= 0.11 is required"
    echo "  Install newer version: https://github.com/neovim/neovim/releases"
    ((errors++))
  fi
else
  error "nvim not found - please install Neovim >= 0.11"
  echo "  https://github.com/neovim/neovim/releases"
  ((errors++))
fi

# Node.js (for LSP servers)
if has_cmd node; then
  node_version=$(node --version | sed 's/v//')
  success "node $node_version found"
else
  warn "node not found - some LSP servers require Node.js"
  echo "  Consider installing: https://nodejs.org/"
fi

# Ripgrep (for telescope live_grep)
if has_cmd rg; then
  success "ripgrep found"
else
  warn "ripgrep not found - telescope live_grep won't work"
  echo "  Install: brew install ripgrep"
fi

# fd (for telescope find_files)
if has_cmd fd; then
  success "fd found"
else
  warn "fd not found - telescope file finder will be slower"
  echo "  Install: brew install fd"
fi

if [[ $errors -gt 0 ]]; then
  echo ""
  error "Please fix the errors above and re-run the installer"
  exit 1
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Backup existing config
# ─────────────────────────────────────────────────────────────────────────────

if [[ -e "$CONFIG_DIR" ]]; then
  if [[ -L "$CONFIG_DIR" ]]; then
    current_target=$(readlink "$CONFIG_DIR")
    if [[ "$current_target" == "$INSTALL_DIR" ]]; then
      info "Existing symlink points to install location - will update in place"
    else
      info "Removing existing symlink: $CONFIG_DIR -> $current_target"
      rm "$CONFIG_DIR"
    fi
  else
    info "Backing up existing config to $BACKUP_DIR"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
    success "Backup created at $BACKUP_DIR"
  fi
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Clone or update repository
# ─────────────────────────────────────────────────────────────────────────────

if [[ -d "$INSTALL_DIR/.git" ]]; then
  info "Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull --ff-only
  success "Repository updated"
else
  info "Cloning repository to $INSTALL_DIR..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone "$REPO_URL" "$INSTALL_DIR"
  success "Repository cloned"
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Create symlink
# ─────────────────────────────────────────────────────────────────────────────

if [[ ! -L "$CONFIG_DIR" ]] || [[ "$(readlink "$CONFIG_DIR")" != "$INSTALL_DIR" ]]; then
  info "Creating symlink: $CONFIG_DIR -> $INSTALL_DIR"
  mkdir -p "$(dirname "$CONFIG_DIR")"
  ln -sf "$INSTALL_DIR" "$CONFIG_DIR"
  success "Symlink created"
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Interactive feature configuration
# ─────────────────────────────────────────────────────────────────────────────

info "Configuring optional features..."
echo ""

features_file="$INSTALL_DIR/lua/user/features.lua"
enable_claude_edit="false"
enable_nowplaying="false"

# Claude-edit integration
if has_cmd claude; then
  echo -n "Enable claude-edit integration? (opens Claude in a split pane) [y/N] "
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    enable_claude_edit="true"
    success "claude-edit enabled"
    echo ""
    echo "  Usage: Run 'ce <file>' to open Neovim with Claude in a split pane"
    echo "  Setup: Add to your shell profile:"
    echo ""
    echo "    # Claude-edit: open file with Claude in split pane"
    echo "    ce() {"
    echo "      if [[ -z \"\$1\" ]]; then"
    echo "        echo \"Usage: ce <file>\""
    echo "        return 1"
    echo "      fi"
    echo "      CLAUDE_EDIT_CMD=\"claude\" nvim \"\$1\" -c 'lua require(\"config.claude-edit\").setup()'"
    echo "    }"
    echo ""
  else
    info "claude-edit skipped"
  fi
else
  info "Claude CLI not found - skipping claude-edit integration"
  echo "  Install Claude: https://docs.anthropic.com/en/docs/claude-code"
fi

echo ""

# Now Playing (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  echo -n "Enable now-playing integration? (shows current track from Spotify/Apple Music) [y/N] "
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    enable_nowplaying="true"
    success "now-playing enabled"
    echo "  Keybinding: <leader>np to show current track"
  else
    info "now-playing skipped"
  fi
else
  info "Skipping now-playing (macOS only feature)"
fi

echo ""

# Write features file
info "Writing feature configuration..."
cat > "$features_file" << EOF
-- Feature flags for dev-nvim
-- Generated by install.sh - edit manually or re-run installer to change
return {
  claude_edit = $enable_claude_edit,
  nowplaying = $enable_nowplaying,
}
EOF
success "Feature config written to lua/user/features.lua"

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Install plugins
# ─────────────────────────────────────────────────────────────────────────────

info "Installing plugins (this may take a moment)..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
success "Plugins installed"

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────────────────────────────────────

echo "╭────────────────────────────────────────╮"
echo "│         Installation complete!         │"
echo "╰────────────────────────────────────────╯"
echo ""
echo "Next steps:"
echo "  1. Open Neovim: nvim"
echo "  2. Press <Space>? for the keybinding cheatsheet"
echo "  3. Run :checkhealth to verify setup"
echo ""
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Your previous config was backed up to:"
  echo "  $BACKUP_DIR"
  echo ""
fi
echo "To update later: ~/.dotfiles/nvim/update.sh"
echo "To uninstall:    ~/.dotfiles/nvim/uninstall.sh"
echo ""
