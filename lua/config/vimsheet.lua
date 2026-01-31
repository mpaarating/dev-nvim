-- Vim Cheatsheet: floating window with Vim motions and commands
local M = {}

local vimsheet = [[
╭───────────────────────────────────────────────────────────────────────╮
│                      VIM CHEATSHEET  (built-in)                       │
├───────────────────────────────────────────────────────────────────────┤
│  MOTIONS (movement)                │  OPERATORS (action)              │
│    h j k l     Left/Down/Up/Right  │    d          Delete             │
│    w / W       Word / WORD forward │    c          Change (del+insert)│
│    b / B       Word / WORD back    │    y          Yank (copy)        │
│    e / E       End of word/WORD    │    >          Indent right       │
│    0 / $       Start / End of line │    <          Indent left        │
│    ^ / g_      First / Last char   │    =          Auto-indent        │
│    gg / G      Start / End of file │    gU / gu    Upper / lowercase  │
│    { / }       Paragraph back/fwd  │                                  │
│    %           Matching bracket    │  OPERATOR + MOTION = ACTION      │
│    f{c} / F{c} Find char fwd/back  │    dw         Delete word        │
│    t{c} / T{c} Till char fwd/back  │    c$         Change to line end │
│    ; / ,       Repeat f/t fwd/back │    y}         Yank paragraph     │
├────────────────────────────────────┼──────────────────────────────────┤
│  TEXT OBJECTS (use with operator)  │  EDITING                         │
│    iw / aw     Inner/around word   │    i / a      Insert / Append    │
│    is / as     Inner/around sent.  │    I / A      Insert/Append line │
│    ip / ap     Inner/around para.  │    o / O      Open line below/up │
│    i" / a"     Inner/around quotes │    r          Replace char       │
│    i' / a'     Inner/around quotes │    R          Replace mode       │
│    i` / a`     Inner/around backt. │    x / X      Delete char fwd/bk │
│    i( / a(     Inner/around parens │    s / S      Subst char / line  │
│    i[ / a[     Inner/around square │    J          Join lines         │
│    i{ / a{     Inner/around curly  │    ~ / g~     Toggle case        │
│    it / at     Inner/around tag    │    . (dot)    Repeat last change │
│    i> / a>     Inner/around <>     │    u / <C-r>  Undo / Redo        │
├────────────────────────────────────┼──────────────────────────────────┤
│  SEARCH & REPLACE                  │  REGISTERS                       │
│    /pattern    Search forward      │    "ayy       Yank to reg a      │
│    ?pattern    Search backward     │    "ap        Paste from reg a   │
│    n / N       Next / Prev match   │    "+y        Yank to clipboard  │
│    *           Search word (fwd)   │    "+p        Paste from clipbrd │
│    #           Search word (back)  │    "0p        Paste last yank    │
│    :s/a/b/g    Replace in line     │    :reg       Show registers     │
│    :%s/a/b/g   Replace in file     │    <C-r>{reg} Paste in insert    │
│    :%s/a/b/gc  Replace w/ confirm  │                                  │
├────────────────────────────────────┼──────────────────────────────────┤
│  MARKS & JUMPS                     │  MACROS                          │
│    m{a-z}      Set local mark      │    q{a-z}     Record macro       │
│    m{A-Z}      Set global mark     │    q          Stop recording     │
│    '{a-z}      Jump to mark line   │    @{a-z}     Play macro         │
│    `{a-z}      Jump to mark exact  │    @@         Repeat last macro  │
│    ''          Jump to last pos    │    5@a        Play macro 5 times │
│    `.          Jump to last edit   │                                  │
│    <C-o>       Jump list back      │  VISUAL MODE                     │
│    <C-i>       Jump list forward   │    v          Char visual        │
│    :jumps      Show jump list      │    V          Line visual        │
│    :marks      Show marks          │    <C-v>      Block visual       │
├────────────────────────────────────┼──────────────────────────────────┤
│  WINDOWS (built-in)                │  COMMAND-LINE                    │
│    <C-w>s      Split horizontal    │    :e {file}  Edit file          │
│    <C-w>v      Split vertical      │    :w         Write (save)       │
│    <C-w>c      Close window        │    :q / :q!   Quit / Force quit  │
│    <C-w>o      Close others        │    :wq / ZZ   Write and quit     │
│    <C-w>H/J/K/L Move window        │    :!{cmd}    Run shell command  │
│    <C-w>r/R    Rotate windows      │    :r {file}  Read file into buf │
│    <C-w>T      Move to new tab     │    :r !{cmd}  Read cmd output    │
├───────────────────────────────────────────────────────────────────────┤
│  Press <Space>sk to search all keymaps  │  <Space>? for custom keys  │
╰───────────────────────────────────────────────────────────────────────╯
]]

function M.show()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(vimsheet, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'cheatsheet')

  local width = 76
  local height = #lines
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
  })

  -- Close with q or Esc
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end

-- Set up keybindings
vim.keymap.set('n', '<leader>v?', M.show, { desc = 'Vim Cheatsheet', silent = true })
vim.keymap.set('n', '<leader>hv', M.show, { desc = 'Vim Cheatsheet', silent = true })

-- Create command
vim.api.nvim_create_user_command('VimSheet', M.show, { desc = 'Show Vim cheatsheet' })

return M
