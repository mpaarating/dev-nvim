# dev-nvim AI Pair Programming Demo
# Shows the complete workflow of collaborating with AI coding assistants
# using the `ce` (claude-edit) command for split-pane development.
#
# REQUIRES: Claude CLI installed, `ce` function in shell profile

Output ../docs/screenshots/demo-ai-pairing.gif
Output ../docs/screenshots/demo-ai-pairing.webm

Set FontSize 14
Set Width 1400
Set Height 900
Set Theme "TokyoNight"
Set Padding 20
Set TypingSpeed 35ms

# ============================================
# SETUP: Source shell profile for ce command
# ============================================
Type "source ~/.zshrc"
Enter
Sleep 500ms
Type "cd ~/Code/personal/dev-nvim"
Enter
Sleep 500ms

# ============================================
# SCENE 1: Launch claude-edit split pane
# ============================================
Type "# claude-edit: Neovim + Claude Code side by side"
Enter
Sleep 1s

Type "ce lua/config/options.lua"
Enter
Sleep 5s

# ============================================
# SCENE 2: Navigate between panes
# ============================================
# Focus editor (left)
Ctrl+h
Sleep 1s

# Focus Claude (right)
Ctrl+l
Sleep 1s

# Back to editor
Ctrl+h
Sleep 500ms

# ============================================
# SCENE 3: Select code and copy for AI
# ============================================
Type "gg"
Sleep 300ms
Type "V"
Sleep 200ms
Type "15j"
Sleep 500ms

# Copy with file path + line numbers
Type " cc"
Sleep 2s
Escape
Sleep 1s

# ============================================
# SCENE 4: Ask Claude a question
# ============================================
# Focus Claude pane
Ctrl+l
Sleep 500ms

Type "Add a comment explaining what these options do"
Sleep 1s
Enter
Sleep 6s

# ============================================
# SCENE 5: Switch back and see changes
# ============================================
Ctrl+h
Sleep 2s

# Show diff of what Claude changed
Type " cD"
Sleep 3s
Type "q"
Sleep 500ms

# ============================================
# SCENE 6: Toggle Claude pane
# ============================================
Type " ct"
Sleep 1.5s
Type " ct"
Sleep 1.5s

# ============================================
# SCENE 7: Exit
# ============================================
Escape
Escape
Sleep 300ms
Type ":qa!"
Enter
Sleep 500ms

Type "# ✨ dev-nvim: AI pair programming made seamless"
Enter
Sleep 2s
