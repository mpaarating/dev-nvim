# dev-nvim Send to Claude Demo
# Shows the direct send workflow: select code → <leader>cf → Claude receives with prompt

Output ../docs/screenshots/demo-send-to-claude.gif
Output ../docs/screenshots/demo-send-to-claude.webm

Set Shell "zsh"
Set FontSize 14
Set Width 1400
Set Height 900
Set Theme "TokyoNight"
Set Padding 20
Set TypingSpeed 50ms

# ============================================
# SETUP: Reset demo file
# ============================================
Hide
Type "cd ~/Code/personal/dev-nvim && git checkout demo/sample-buggy.lua 2>/dev/null || true"
Enter
Sleep 500ms
Show

# ============================================
# SCENE 1: Launch claude-edit split pane
# ============================================
Type "./demo/ce demo/sample-buggy.lua"
Enter
Sleep 3s

# Close Lazy window if it opened
Type "q"
Sleep 500ms

# ============================================
# SCENE 2: Handle Claude dialogs
# ============================================
# First dialog: "Yes, I trust this folder" (option 1, already selected)
Ctrl+l
Sleep 1s
Enter
Sleep 2s

# Second dialog: "Yes, allow external imports" (option 1, already selected)
Enter
Sleep 3s

# ============================================
# SCENE 3: Switch back to editor
# ============================================
Escape
Escape
Sleep 300ms
Ctrl+h
Sleep 800ms

# ============================================
# SCENE 4: Navigate to buggy function
# ============================================
Type "gg"
Sleep 300ms
Type "4j"
Sleep 300ms

# ============================================
# SCENE 5: Select the function with visual mode
# ============================================
Type "V"
Sleep 200ms
Type "5j"
Sleep 500ms

# ============================================
# SCENE 6: Send with "fix" template (<leader>cf)
# ============================================
# This sends "Please fix any bugs in this code:" + the selected code
Type " cf"
Sleep 1s

# ============================================
# SCENE 7: Watch Claude process the request
# ============================================
# The cursor is now in Claude terminal, request was sent
Sleep 12s

# ============================================
# SCENE 8: Switch back to see changes
# ============================================
Escape
Escape
Sleep 300ms
Ctrl+h
Sleep 2s

# ============================================
# SCENE 9: Show the diff of changes
# ============================================
Type " cd"
Sleep 2s

# Close diff
Type ":diffoff!"
Enter
Sleep 500ms
Type ":bd"
Enter
Sleep 500ms

# ============================================
# SCENE 10: Clean exit
# ============================================
Type ":qa!"
Enter
Sleep 1s
