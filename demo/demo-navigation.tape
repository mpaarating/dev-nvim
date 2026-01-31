# dev-nvim Navigation Demo
# Shows: File explorer, Telescope find files, Buffer navigation

Output ../docs/screenshots/demo-navigation.gif
Output ../docs/screenshots/demo-navigation.webm

Set FontSize 14
Set Width 1200
Set Height 800
Set Theme "TokyoNight"
Set Padding 20
Set TypingSpeed 40ms

# Open nvim
Type "cd ~/Code/personal/dev-nvim && nvim ."
Enter
Sleep 2s

# File explorer
Type " e"
Sleep 1.5s

# Navigate into lua/config
Type "jjjl"
Sleep 500ms
Type "jl"
Sleep 500ms

# Open a file
Type "jj"
Sleep 200ms
Enter
Sleep 1s

# Close explorer
Type " e"
Sleep 500ms

# Telescope find files
Type " ff"
Sleep 1s
Type "options"
Sleep 1s
Enter
Sleep 1s

# Show open buffers
Type " fb"
Sleep 1.5s
Enter
Sleep 1s

# Quit
Type ":qa"
Enter
Sleep 500ms
