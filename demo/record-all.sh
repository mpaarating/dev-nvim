#!/bin/bash
# Record all demo GIFs
# Run from the demo/ directory

set -e

mkdir -p ../docs/screenshots

echo "Recording demo-overview..."
vhs demo-overview.tape

echo "Recording demo-navigation..."
vhs demo-navigation.tape

echo "Recording demo-lsp..."
vhs demo-lsp.tape

echo "Recording demo-git..."
vhs demo-git.tape

echo "Recording demo-ai-pairing..."
vhs demo-ai-pairing.tape

echo "Recording demo-send-to-claude..."
vhs demo-send-to-claude.tape

echo ""
echo "✨ All demos recorded to docs/screenshots/"
ls -lh ../docs/screenshots/*.gif
