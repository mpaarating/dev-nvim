# dev-nvim AI Pair Programming Demo
# Shows the complete workflow using `ce` (claude-edit) command.

Output ../docs/screenshots/demo-ai-pairing.gif
Output ../docs/screenshots/demo-ai-pairing.webm

Set Shell "zsh"
Set FontSize 14
Set Width 1400
Set Height 900
Set Theme "TokyoNight"
Set Padding 20
Set TypingSpeed 50ms

# ============================================
# SETUP: Reset file to clean state
# ============================================
Hide
Type "cd ~/Code/personal/dev-nvim && git checkout lua/config/options.lua"
Enter
Sleep 500ms
Show

# ============================================
# SCENE 1: Launch claude-edit split pane
# ============================================
Type "./demo/ce lua/config/options.lua"
Enter
Sleep 3s

# ============================================
# SCENE 2: Switch to Claude pane to handle bypass dialog
# ============================================
# After setup, focus is in editor (left). Switch to Claude (right)
Ctrl+l
Sleep 1s

# Handle the bypass permissions confirmation dialog
# Select option 2: "Yes, I accept"
Down
Sleep 300ms
Enter
Sleep 4s

# ============================================
# SCENE 3: Switch back to editor pane
# ============================================
# Double escape to exit terminal mode, then Ctrl+h to go left
Escape
Escape
Sleep 300ms
Ctrl+h
Sleep 800ms

# ============================================
# SCENE 4: Select code and copy for AI context
# ============================================
Type "gg"
Sleep 300ms
Type "V"
Sleep 200ms
Type "10j"
Sleep 500ms

# Copy with file path + line numbers (shows notification)
Type " cc"
Sleep 2s
Escape
Sleep 500ms

# ============================================
# SCENE 5: Ask Claude to make an edit
# ============================================
# Switch to Claude pane - autocmd will enter insert mode
Ctrl+l
Sleep 500ms

# Type request to Claude
Sleep 300ms
Type "Add a comment at the top of lua/config/options.lua explaining what these Neovim options configure"
Sleep 500ms
Enter

# Wait for Claude to process and make the edit
Sleep 15s

# ============================================
# SCENE 6: Switch back to see changes
# ============================================
Escape
Escape
Sleep 300ms
Ctrl+h
Sleep 2s

# ============================================
# SCENE 7: Review the diff with LazyGit (floating window)
# ============================================
Type " gg"
Sleep 2s

# Navigate in lazygit to show the diff
Type "2"
Sleep 1s

# Close lazygit
Type "q"
Sleep 500ms

# ============================================
# SCENE 8: Toggle Claude pane off/on
# ============================================
Type " ct"
Sleep 1s
Type " ct"
Sleep 1s

# ============================================
# SCENE 9: Clean exit
# ============================================
Escape
Sleep 300ms
Type ":qa!"
Enter
Sleep 1s
