# dev-nvim AI Pair Programming Demo
# Shows the complete workflow of collaborating with AI coding assistants
#
# Story: You're working with Claude Code. It edits your files directly.
# dev-nvim makes this seamless with auto-reload, diffs, and context copying.

Output ../docs/screenshots/demo-ai-pairing.gif
Output ../docs/screenshots/demo-ai-pairing.webm

Set FontSize 14
Set Width 1400
Set Height 900
Set Theme "TokyoNight"
Set Padding 20
Set TypingSpeed 35ms

# ============================================
# SCENE 1: You're coding, want to ask AI for help
# ============================================
Type "cd ~/Code/personal/dev-nvim"
Enter
Sleep 500ms
Type "nvim lua/config/options.lua"
Enter
Sleep 2s

# Select code to share with Claude
Type "gg"
Sleep 300ms
Type "V"
Sleep 200ms
Type "20j"
Sleep 500ms

# Copy with file path + line numbers (formatted for AI)
Type " cc"
Sleep 2s
Escape
Sleep 1s

# ============================================
# SCENE 2: Claude edits your file externally
# ============================================
# Background nvim, simulate Claude editing the file
Ctrl+z
Sleep 500ms

Type "# Claude Code edits your file..."
Enter
Sleep 500ms
Type "echo '-- Added by Claude: improved performance' >> lua/config/options.lua"
Enter
Sleep 1s

# Return to nvim
Type "fg"
Enter
Sleep 1.5s

# ============================================
# SCENE 3: File auto-reloads! (no annoying prompt)
# ============================================
# Go to end to see the new line
Type "G"
Sleep 1s

# ============================================
# SCENE 4: Review what Claude changed
# ============================================
# Diff against git HEAD to see all AI changes
Type " cD"
Sleep 3s
Type "q"
Sleep 500ms

# ============================================
# SCENE 5: Continue the conversation
# ============================================
# Select the new code to discuss
Type "G"
Sleep 300ms
Type "V"
Sleep 200ms
Type "k"
Sleep 300ms

# Copy for follow-up with Claude
Type " cc"
Sleep 2s
Escape
Sleep 1s

# ============================================
# SCENE 6: Clean up the demo edit
# ============================================
Type "G"
Sleep 300ms
Type "dd"
Sleep 300ms
Type ":w"
Enter
Sleep 500ms

# ============================================
# SCENE 7: The integrated experience - claude-edit
# ============================================
Type ":q"
Enter
Sleep 500ms

Type "# Or use claude-edit for a split-pane experience:"
Enter
Sleep 1s

Type "ce lua/config/options.lua"
Enter
Sleep 3s

# Show navigation between panes
Ctrl+h
Sleep 800ms
Ctrl+l
Sleep 800ms
Ctrl+h
Sleep 500ms

# Toggle Claude pane
Type " ct"
Sleep 1s
Type " ct"
Sleep 1s

# Exit
Escape
Escape
Sleep 300ms
Type ":qa!"
Enter
Sleep 500ms

Type "# ✨ Seamless AI collaboration with dev-nvim"
Enter
Sleep 2s
