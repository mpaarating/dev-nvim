-- Claude Send: Send text directly to Claude terminal
local M = {}

function M.send_to_claude(text)
  local claude = require("config.claude-edit")
  if not claude.claude_bufnr or not vim.api.nvim_buf_is_valid(claude.claude_bufnr) then
    vim.fn.setreg("+", text)
    vim.notify("Claude not running - copied to clipboard", vim.log.levels.WARN)
    return
  end

  local chan = vim.bo[claude.claude_bufnr].channel
  if chan then
    -- Send text then carriage return to submit
    vim.fn.chansend(chan, text)
    vim.fn.chansend(chan, "\r")
    vim.cmd("wincmd l")
    vim.cmd("startinsert")
  end
end

function M.send_selection()
  -- Get visual selection bounds (works while still in visual mode)
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local filepath = vim.fn.expand("%:.")
  local ft = vim.bo.filetype

  local text = string.format("```%s %s:%d-%d\n%s\n```",
    ft, filepath, start_line, end_line, table.concat(lines, "\n"))
  M.send_to_claude(text)
end

function M.send_buffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local filepath = vim.fn.expand("%:.")
  local ft = vim.bo.filetype

  local text = string.format("```%s %s\n%s\n```", ft, filepath, table.concat(lines, "\n"))
  M.send_to_claude(text)
end

vim.keymap.set("v", "<leader>cs", M.send_selection, { desc = "Send selection to Claude" })
vim.keymap.set("n", "<leader>cs", M.send_buffer, { desc = "Send buffer to Claude" })

return M
