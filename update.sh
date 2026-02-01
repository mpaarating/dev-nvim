#!/usr/bin/env bash
set -euo pipefail

# pair.nvim updater

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}▸${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }

echo ""
echo "╭────────────────────────────────────────╮"
echo "│          pair.nvim updater              │"
echo "╰────────────────────────────────────────╯"
echo ""

cd "$SCRIPT_DIR"

info "Pulling latest changes..."
git pull --ff-only
success "Repository updated"

echo ""

info "Syncing plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
success "Plugins synced"

echo ""
success "Update complete!"
echo ""
