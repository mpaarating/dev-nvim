-- Cheatsheet: floating window with keybindings
local M = {}

local cheatsheet = [[
╭───────────────────────────────────────────────────────────────────╮
│                    NEOVIM CHEATSHEET  (<Space> = menu)            │
├───────────────────────────────────────────────────────────────────┤
│  CLAUDE WORKFLOW                   │  FILES & SEARCH              │
│    <Space>cc     Copy for Claude   │    <Space>e     File tree    │
│    <Space>cd     Diff unsaved      │    <Space>ff    Find files   │
│    <Space>cD     Diff git HEAD     │    <Space>/     Live grep    │
│    <Space>ct     Toggle Claude     │    <Space>fb    Buffers      │
│    <Space>ch     Claude help       │    <Space>fr    Recent files │
│    gf (in term)  Open file at line │    <Space>fF    All files    │
├────────────────────────────────────┼──────────────────────────────┤
│  CLAUDE-EDIT (ce mode)             │  SESSION                     │
│    <C-h>         Go to editor      │    <Space>qs    Restore sess │
│    <C-l>         Go to Claude      │    <Space>ql    Last session │
│    <Esc><Esc>    Exit term mode    │    <Space>qd    Don't save   │
│    i             Enter term mode   │                              │
├────────────────────────────────────┼──────────────────────────────┤
│  GIT (neovim)                      │  CODE / LSP                  │
│    <Space>gg     LazyGit (q=quit)  │    gd           Go to def    │
│    <Space>gs     Git status        │    gr           References   │
│    <Space>gc     Git commits       │    gi           Implementatn │
│    ]h / [h       Next/prev hunk    │    gt           Type def     │
│    <Space>ghs    Stage hunk        │    K            Hover info   │
│    <Space>ghr    Reset hunk        │    <C-k>        Signature    │
│    <Space>ghp    Preview hunk      │    <Space>ca    Code action  │
│    <Space>ghb    Blame line        │    <Space>cr    Rename       │
│    <Space>ghd    Diff this         │    <Space>cf    Format       │
├────────────────────────────────────┼──────────────────────────────┤
│  SEARCH (<Space>s...)              │  DIAGNOSTICS                 │
│    <Space>sk     Keymaps ⭐        │    <Space>xx    Doc diagnost │
│    <Space>sh     Help pages        │    <Space>xX    Workspace    │
│    <Space>sb     Buffer search     │    ]d / [d      Next/prev    │
│    <Space>sw     Word under cursor │    ]q / [q      Quickfix     │
│    <Space>sm     Marks             │    <Space>cd    Line diag    │
│    <Space>s"     Registers         │                              │
│    <Space>sR     Resume search     │                              │
├────────────────────────────────────┴──────────────────────────────┤
│  LAZYGIT (inside <Space>gg)                                       │
│    BRANCHES           │  COMMITS            │  FILES              │
│      b   New branch   │    c   Commit       │    Space  Stage     │
│      Space Checkout   │    A   Amend        │    a      Stage all │
│      n   Rename       │    p   Pick (cherry)│    d      Discard   │
│      d   Delete       │    r   Revert       │    e      Edit file │
│      M   Merge into   │    g   Reset to     │                     │
│      R   Rebase onto  │    s   Squash down  │  SYNC               │
│    STASH              │    f   Fixup        │    f      Fetch     │
│      s   Stash        │                     │    p      Pull      │
│      g   Pop          │    ?   All keys     │    P      Push      │
├────────────────────────────────────┬──────────────────────────────┤
│  TELESCOPE PICKER (inside search)  │  TEXT OBJECTS (change/del)  │
│    <CR>          Open file         │    ciw         Change word   │
│    <C-x>         Open horiz split  │    ci" ci' ci` Inside quotes │
│    <C-v>         Open vert split   │    ci( ci[ ci{ Inside braces │
│    <C-t>         Open in new tab   │    ca( ca[ ca{ Around braces │
│    <A-h>         Toggle hidden     │    dap         Delete paragr │
│    <A-i>         Toggle ignored    │    yiw         Yank word     │
├────────────────────────────────────┼──────────────────────────────┤
│  WINDOWS & NAVIGATION              │  EDITING                     │
│    <C-h/j/k/l>   Move between panes│    <A-j/k>      Move line    │
│    <C-arrows>    Resize window     │    <C-s>        Save file    │
│    <C-w>=        Equal pane sizes  │    < / >        Indent       │
│    <C-o> / <C-i> Jump back/forward │    p            Paste        │
├────────────────────────────────────┼──────────────────────────────┤
│  TERMINAL (toggleterm)             │  UTILITIES                   │
│    <C-\>          Float terminal   │    <Space>np    Now playing  │
│    <Space>tf      Float terminal   │    <Space>?     This cheatsheet│
│    <Space>th      Horiz terminal   │    <Space>v?    Vim cheatsheet│
│    <Space>tv      Vert terminal    │    <Space>sk    Search keymaps│
╰───────────────────────────────────────────────────────────────────╯
]]

function M.show()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(cheatsheet, '\n')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'cheatsheet')

  local width = 72
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

-- Set up the keybinding
vim.keymap.set('n', '<leader>?', M.show, { desc = 'Cheatsheet', silent = true })

return M
