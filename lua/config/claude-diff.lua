-- Claude Diff: View changes for reviewing what Claude modified
local M = {}

-- Show diff against last saved version
function M.diff_unsaved()
  local ft = vim.bo.filetype
  local filepath = vim.fn.expand("%:p")

  if vim.fn.filereadable(filepath) == 0 then
    vim.notify("File not saved yet", vim.log.levels.WARN)
    return
  end

  -- Read saved version
  local saved = vim.fn.readfile(filepath)

  -- Create a scratch buffer with saved version
  vim.cmd("vnew")
  local diff_buf = vim.api.nvim_get_current_buf()
  vim.bo[diff_buf].buftype = "nofile"
  vim.bo[diff_buf].bufhidden = "wipe"
  vim.bo[diff_buf].filetype = ft
  vim.api.nvim_buf_set_name(diff_buf, "saved://" .. vim.fn.expand("#:t"))

  -- Set saved content
  vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, saved)
  vim.bo[diff_buf].modifiable = false

  -- Enable diff mode on both buffers
  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")

  vim.notify("Showing diff against saved version (q to close diff)", vim.log.levels.INFO)
end

-- Show diff against git HEAD
function M.diff_git()
  -- Use gitsigns if available
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.diffthis("HEAD")
    return
  end

  -- Fallback: manual git diff
  local filepath = vim.fn.expand("%:.")
  if filepath == "" then
    vim.notify("No file to diff", vim.log.levels.WARN)
    return
  end

  local handle = io.popen("git show HEAD:" .. vim.fn.shellescape(filepath) .. " 2>/dev/null")
  if not handle then
    vim.notify("Failed to get git version", vim.log.levels.ERROR)
    return
  end

  local git_content = handle:read("*a")
  handle:close()

  if git_content == "" then
    vim.notify("File not in git or no changes from HEAD", vim.log.levels.INFO)
    return
  end

  local ft = vim.bo.filetype

  -- Create scratch buffer with git version
  vim.cmd("vnew")
  local diff_buf = vim.api.nvim_get_current_buf()
  vim.bo[diff_buf].buftype = "nofile"
  vim.bo[diff_buf].bufhidden = "wipe"
  vim.bo[diff_buf].filetype = ft
  vim.api.nvim_buf_set_name(diff_buf, "git://" .. vim.fn.expand("#:t"))

  vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, vim.split(git_content, "\n"))
  vim.bo[diff_buf].modifiable = false

  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")

  vim.notify("Showing diff against git HEAD", vim.log.levels.INFO)
end

-- Close diff view and reset diff mode
function M.close_diff()
  vim.cmd("diffoff!")
  -- Close any scratch diff buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("^saved://") or name:match("^git://") then
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

-- Commands
vim.api.nvim_create_user_command("ClaudeDiff", M.diff_unsaved, { desc = "Diff against saved version" })
vim.api.nvim_create_user_command("ClaudeDiffGit", M.diff_git, { desc = "Diff against git HEAD" })
vim.api.nvim_create_user_command("ClaudeDiffClose", M.close_diff, { desc = "Close diff view" })

-- Keymaps
vim.keymap.set("n", "<leader>cd", M.diff_unsaved, { desc = "Diff unsaved changes" })
vim.keymap.set("n", "<leader>cD", M.diff_git, { desc = "Diff against git HEAD" })

return M
