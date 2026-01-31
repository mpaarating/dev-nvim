-- Claude-Edit: Neovim + Claude Code integrated workflow
local M = {}

-- Track the Claude terminal buffer
M.claude_bufnr = nil
M.claude_winnr = nil

-- Keybinding help content
local help_content = [[
╭─────────────────────────────────────────────────────────╮
│                  claude-edit keybindings                │
├─────────────────────────────────────────────────────────┤
│  Navigation                                             │
│    <C-h>           Move to editor (left)                │
│    <C-l>           Move to Claude (right)               │
│    <C-Left/Right>  Resize panes                         │
│                                                         │
│  Claude Terminal                                        │
│    <leader>ct      Toggle Claude terminal               │
│    <leader>cR      Restart Claude terminal              │
│    <esc><esc>      Exit terminal mode (scroll/copy)     │
│    i               Re-enter terminal mode               │
│                                                         │
│  Context & Communication                                │
│    <leader>cc      Copy buffer/selection for Claude     │
│    <leader>cs      Send buffer/selection to Claude      │
│    <leader>ce      Copy diagnostics for Claude          │
│    <leader>cC      Copy all open buffers                │
│                                                         │
│  Quick Actions                                          │
│    <leader>cA      Accept changes (save)                │
│    <leader>cr      Revert changes                       │
│    <leader>cp      Preview changes (diff)               │
│    <leader>cd      Diff unsaved changes                 │
│    <leader>cD      Diff against git HEAD                │
│    <leader>cu      Undo tree                            │
│                                                         │
│  Git Integration                                        │
│    <leader>gg      LazyGit (floating)                   │
│    <leader>gs      Git status (telescope)               │
│    ]h / [h         Next/prev git hunk                   │
│                                                         │
│  Help                                                   │
│    <leader>ch      Show this help                       │
│    q               Close this help                      │
╰─────────────────────────────────────────────────────────╯
]]

function M.show_help()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(help_content, '\n'))
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local width = 60
  local height = 38
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
  })

  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
  vim.keymap.set('n', '<esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end

function M.toggle_claude()
  if M.claude_winnr and vim.api.nvim_win_is_valid(M.claude_winnr) then
    -- Hide: close the window but keep buffer
    vim.api.nvim_win_hide(M.claude_winnr)
    M.claude_winnr = nil
  elseif M.claude_bufnr and vim.api.nvim_buf_is_valid(M.claude_bufnr) then
    -- Show: reopen the buffer in a vsplit
    vim.cmd('vsplit')
    vim.cmd('wincmd l')
    vim.api.nvim_win_set_buf(0, M.claude_bufnr)
    vim.cmd('vertical resize 80')
    M.claude_winnr = vim.api.nvim_get_current_win()
    vim.cmd('wincmd h')
  end
end

-- Set up keymaps for terminal buffer (gf to open files)
function M.setup_terminal_keymaps()
  local buf = M.claude_bufnr
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

  -- From terminal (normal mode), jump to a file mentioned by Claude
  vim.keymap.set('n', 'gf', function()
    local file = vim.fn.expand('<cfile>')
    -- Handle file:line format (e.g., "src/main.lua:42")
    local path, line = file:match("^(.+):(%d+)$")
    if not path then
      path = file
      line = nil
    end

    if vim.fn.filereadable(path) == 1 then
      vim.cmd('wincmd h')  -- Go to editor pane
      vim.cmd('edit ' .. vim.fn.fnameescape(path))
      if line then
        vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
      end
    else
      vim.notify("File not found: " .. path, vim.log.levels.WARN)
    end
  end, { buffer = buf, desc = 'Open file under cursor' })
end

-- Restart Claude terminal
function M.restart_claude()
  if M.claude_bufnr and vim.api.nvim_buf_is_valid(M.claude_bufnr) then
    local chan = vim.bo[M.claude_bufnr].channel
    if chan then
      vim.fn.jobstop(chan)
    end
    vim.api.nvim_buf_delete(M.claude_bufnr, { force = true })
  end

  M.claude_bufnr = nil
  M.claude_winnr = nil
  M.setup()
  vim.notify("Claude terminal restarted", vim.log.levels.INFO)
end

-- Status line component showing Claude connection
function M.statusline()
  if not M.claude_bufnr then
    return ""
  end

  if not vim.api.nvim_buf_is_valid(M.claude_bufnr) then
    return "󰚩 Claude (dead)"
  end

  local chan = vim.bo[M.claude_bufnr].channel
  if not chan or vim.fn.jobwait({ chan }, 0)[1] ~= -1 then
    return "󰚩 Claude (exited)"
  end

  return "󰚩 Claude"
end

function M.setup()
  local claude_cmd = os.getenv('CLAUDE_EDIT_CMD') or 'claude'

  -- Create the layout: vsplit with Claude terminal on right
  vim.cmd('vsplit')
  vim.cmd('wincmd l')
  vim.cmd('terminal ' .. claude_cmd)
  vim.cmd('vertical resize 80')

  -- Store references
  M.claude_bufnr = vim.api.nvim_get_current_buf()
  M.claude_winnr = vim.api.nvim_get_current_win()

  -- Name the buffer for easy identification
  vim.api.nvim_buf_set_name(M.claude_bufnr, 'claude://terminal')

  -- Set up terminal-specific keymaps
  M.setup_terminal_keymaps()

  -- Focus back on editor
  vim.cmd('wincmd h')

  -- Set up keybindings
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<leader>ct', M.toggle_claude, vim.tbl_extend('force', opts, { desc = 'Toggle Claude terminal' }))
  vim.keymap.set('n', '<leader>ch', M.show_help, vim.tbl_extend('force', opts, { desc = 'Claude-edit help' }))
  vim.keymap.set('n', '<leader>cR', M.restart_claude, vim.tbl_extend('force', opts, { desc = 'Restart Claude terminal' }))

  -- Auto-enter insert mode when entering Claude terminal
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'claude://terminal',
    callback = function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd('startinsert')
      end
    end,
  })
end

return M
