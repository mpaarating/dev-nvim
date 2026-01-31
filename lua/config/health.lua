-- Health check module for dev-nvim
local M = {}

function M.check()
  vim.health.start("dev-nvim")

  -- Neovim version
  local v = vim.version()
  if v.minor >= 11 then
    vim.health.ok(string.format("Neovim %d.%d.%d", v.major, v.minor, v.patch))
  else
    vim.health.error("Neovim 0.11+ required")
  end

  -- Claude CLI
  if vim.fn.executable("claude") == 1 then
    vim.health.ok("Claude CLI found")
  else
    vim.health.warn("Claude CLI not found", { "Install: https://docs.anthropic.com/en/docs/claude-code" })
  end

  -- Clipboard
  if vim.fn.has("clipboard") == 1 then
    vim.health.ok("Clipboard support available")
  else
    vim.health.error("No clipboard support", { "Linux: Install xclip or xsel" })
  end

  -- Optional tools
  if vim.fn.executable("rg") == 1 then
    vim.health.ok("ripgrep found")
  else
    vim.health.warn("ripgrep not found", { "brew install ripgrep" })
  end

  if vim.fn.executable("fd") == 1 then
    vim.health.ok("fd found")
  else
    vim.health.info("fd not found (optional)")
  end

  -- Features
  local ok, features = pcall(require, "user.features")
  if ok then
    vim.health.ok("claude_edit: " .. (features.claude_edit and "enabled" or "disabled"))
    vim.health.ok("nowplaying: " .. (features.nowplaying and "enabled" or "disabled"))
  else
    vim.health.info("No user/features.lua found")
  end
end

return M
