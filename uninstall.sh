#!/usr/bin/env bash
set -euo pipefail

# pair.nvim uninstaller

INSTALL_DIR="${HOME}/.dotfiles/nvim"
CONFIG_DIR="${HOME}/.config/nvim"
DATA_DIR="${HOME}/.local/share/nvim"
STATE_DIR="${HOME}/.local/state/nvim"
CACHE_DIR="${HOME}/.cache/nvim"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}▸${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

echo ""
echo "╭────────────────────────────────────────╮"
echo "│        pair.nvim uninstaller            │"
echo "╰────────────────────────────────────────╯"
echo ""

# Check if symlink exists and points to our install
if [[ -L "$CONFIG_DIR" ]]; then
  current_target=$(readlink "$CONFIG_DIR")
  if [[ "$current_target" == "$INSTALL_DIR" ]]; then
    info "Removing symlink: $CONFIG_DIR"
    rm "$CONFIG_DIR"
    success "Symlink removed"
  else
    warn "Config symlink points elsewhere: $current_target"
    warn "Skipping symlink removal"
  fi
else
  warn "No symlink at $CONFIG_DIR - nothing to remove"
fi

echo ""

# Check for backups
backups=$(find "${HOME}/.config" -maxdepth 1 -name "nvim.backup.*" -type d 2>/dev/null | sort -r | head -n5)
if [[ -n "$backups" ]]; then
  echo "Found backup(s):"
  echo "$backups" | while read -r backup; do
    echo "  $backup"
  done
  echo ""
  echo -n "Restore most recent backup? [y/N] "
  read -r response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    most_recent=$(echo "$backups" | head -n1)
    mv "$most_recent" "$CONFIG_DIR"
    success "Restored: $most_recent -> $CONFIG_DIR"
  fi
fi

echo ""

# Optionally remove installed repo
echo -n "Remove cloned repository at $INSTALL_DIR? [y/N] "
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  rm -rf "$INSTALL_DIR"
  success "Repository removed"
fi

echo ""

# Optionally clean plugin data
echo -n "Remove plugin data (~/.local/share/nvim, etc.)? [y/N] "
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
  [[ -d "$DATA_DIR" ]] && rm -rf "$DATA_DIR" && info "Removed $DATA_DIR"
  [[ -d "$STATE_DIR" ]] && rm -rf "$STATE_DIR" && info "Removed $STATE_DIR"
  [[ -d "$CACHE_DIR" ]] && rm -rf "$CACHE_DIR" && info "Removed $CACHE_DIR"
  success "Plugin data cleaned"
fi

echo ""
success "Uninstall complete"
echo ""
