-- Claude Actions: Quick actions after Claude edits
local M = {}

function M.accept()
  vim.cmd("write")
  vim.notify("Changes accepted and saved", vim.log.levels.INFO)
end

function M.revert()
  vim.cmd("edit!")
  vim.notify("Reverted to last saved version", vim.log.levels.INFO)
end

function M.preview()
  require("config.claude-diff").diff_unsaved()
end

vim.keymap.set("n", "<leader>cA", M.accept, { desc = "Accept Claude changes" })
vim.keymap.set("n", "<leader>cr", M.revert, { desc = "Revert Claude changes" })
vim.keymap.set("n", "<leader>cp", M.preview, { desc = "Preview Claude changes" })

return M
