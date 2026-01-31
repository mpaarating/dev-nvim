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

-- Copy diagnostics with context
function M.copy_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.fn.expand("%:.")
  local diagnostics = vim.diagnostic.get(bufnr)

  if #diagnostics == 0 then
    vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
    return
  end

  local severity_icons = {
    [vim.diagnostic.severity.ERROR] = "ERROR",
    [vim.diagnostic.severity.WARN] = "WARN",
    [vim.diagnostic.severity.INFO] = "INFO",
    [vim.diagnostic.severity.HINT] = "HINT",
  }

  local context = { "Diagnostics for " .. filepath .. ":\n" }
  local ft = vim.bo[bufnr].filetype

  for _, diag in ipairs(diagnostics) do
    local line = diag.lnum + 1
    local start_ctx = math.max(0, diag.lnum - 2)
    local end_ctx = math.min(vim.api.nvim_buf_line_count(bufnr), diag.lnum + 3)
    local ctx_lines = vim.api.nvim_buf_get_lines(bufnr, start_ctx, end_ctx, false)

    table.insert(context, string.format("```%s %s:%d", ft, filepath, line))
    for _, l in ipairs(ctx_lines) do
      table.insert(context, l)
    end
    table.insert(context, "```")
    table.insert(context, string.format("%s: %s", severity_icons[diag.severity] or "DIAG", diag.message))
    if diag.source then
      table.insert(context, string.format("Source: %s", diag.source))
    end
    table.insert(context, "")
  end

  vim.fn.setreg("+", table.concat(context, "\n"))
  vim.notify(string.format("Copied %d diagnostic(s)", #diagnostics), vim.log.levels.INFO)
end

-- Copy all open buffers
function M.copy_multi_buffer()
  local context = {}
  local count = 0

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      if filepath ~= "" and not filepath:match("^term://") and not filepath:match("^claude://") then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local ft = vim.bo[bufnr].filetype
        local rel = vim.fn.fnamemodify(filepath, ":.")

        table.insert(context, string.format("```%s %s", ft, rel))
        vim.list_extend(context, lines)
        table.insert(context, "```\n")
        count = count + 1
      end
    end
  end

  if count == 0 then
    vim.notify("No buffers to copy", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", table.concat(context, "\n"))
  vim.notify(string.format("Copied %d buffer(s)", count), vim.log.levels.INFO)
end

-- Keymaps
vim.keymap.set("n", "<leader>cc", M.copy_buffer, { desc = "Copy buffer for Claude" })
vim.keymap.set("v", "<leader>cc", M.copy_selection, { desc = "Copy selection for Claude" })
vim.keymap.set("n", "<leader>ce", M.copy_diagnostics, { desc = "Copy diagnostics for Claude" })
vim.keymap.set("n", "<leader>cC", M.copy_multi_buffer, { desc = "Copy all buffers for Claude" })

return M
