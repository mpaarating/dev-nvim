-- Neovim Configuration for Claude + Development Workflow
-- Modern Lua-based configuration optimized for productivity

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core settings
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.cheatsheet")
require("config.vimsheet")

-- Claude workflow features (always loaded)
require("config.claude-context")
require("config.claude-diff")
require("config.claude-send")
require("config.claude-actions")

-- Optional features (controlled by lua/user/features.lua)
-- Run install.sh to configure, or manually create lua/user/features.lua
local ok, features = pcall(require, "user.features")
if ok and features then
  if features.nowplaying then
    require("config.nowplaying")
  end
  if features.claude_edit then
    require("config.claude-edit").setup()
  end
end

-- User customizations (loaded last, after all config)
pcall(require, "user")

-- Plugin setup
require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
