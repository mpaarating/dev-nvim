# dev-nvim LSP Demo
# Shows: Hover documentation, Go to definition, Live grep

Output ../docs/screenshots/demo-lsp.gif
Output ../docs/screenshots/demo-lsp.webm

Set FontSize 14
Set Width 1200
Set Height 800
Set Theme "TokyoNight"
Set Padding 20
Set TypingSpeed 40ms

# Open a Lua file with LSP support
Type "cd ~/Code/personal/dev-nvim && nvim lua/config/options.lua"
Enter
Sleep 2s

# Find vim.opt and show hover docs
Type "/vim.opt"
Enter
Sleep 500ms
Escape
Type "w"
Sleep 300ms
Type "K"
Sleep 2.5s
Escape
Sleep 500ms

# Go to definition
Type "gg"
Sleep 300ms
Type "/require"
Enter
Escape
Type "w"
Sleep 300ms
Type "gd"
Sleep 2s

# Go back
Ctrl+o
Sleep 1s

# Live grep search
Type " /"
Sleep 1s
Type "keymap.set"
Sleep 1.5s
Enter
Sleep 1.5s

# Quit
Type ":qa!"
Enter
Sleep 500ms
