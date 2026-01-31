-- Claude Context: Copy code context for sharing with Claude
local M = {}

-- Format: filepath:startline-endline followed by code
function M.copy_context(start_line, end_line)
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.fn.expand("%:.")  -- Relative path
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  -- Detect language for code fence
  local ft = vim.bo[bufnr].filetype
  local lang = ft ~= "" and ft or ""

  local context = {}

  -- Header with file path and line range
  if start_line == end_line then
    table.insert(context, string.format("```%s %s:%d", lang, filepath, start_line))
  else
    table.insert(context, string.format("```%s %s:%d-%d", lang, filepath, start_line, end_line))
  end

  -- Code content
  for _, line in ipairs(lines) do
    table.insert(context, line)
  end

  table.insert(context, "```")

  local result = table.concat(context, "\n")

  -- Copy to system clipboard
  vim.fn.setreg("+", result)
  vim.fn.setreg("*", result)

  -- Notify
  local line_count = end_line - start_line + 1
  vim.notify(string.format("Copied %d line(s) from %s", line_count, filepath), vim.log.levels.INFO)
end

-- Copy entire buffer
function M.copy_buffer()
  local line_count = vim.api.nvim_buf_line_count(0)
  M.copy_context(1, line_count)
end

-- Copy visual selection
function M.copy_selection()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  M.copy_context(start_line, end_line)
end

-- Commands
vim.api.nvim_create_user_command("ClaudeContext", function(opts)
  if opts.range > 0 then
    M.copy_context(opts.line1, opts.line2)
  else
    M.copy_buffer()
  end
end, { range = true, desc = "Copy code context for Claude" })

-- Keymaps
vim.keymap.set("n", "<leader>cc", M.copy_buffer, { desc = "Copy buffer for Claude" })
vim.keymap.set("v", "<leader>cc", M.copy_selection, { desc = "Copy selection for Claude" })

return M
