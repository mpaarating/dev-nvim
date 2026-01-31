# Customization Guide

Your customizations go in `lua/user/` — this directory is gitignored, so your changes won't conflict with updates.

## Adding Custom Settings

Create `lua/user/init.lua`:

```lua
-- lua/user/init.lua
-- This file is loaded after all other config

-- Custom options
vim.opt.relativenumber = true
vim.opt.scrolloff = 10

-- Custom keymaps
vim.keymap.set('n', '<leader>x', ':echo "Hello!"<CR>', { desc = 'My custom binding' })

-- Custom autocommands
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
```

## Adding Plugins

Create files in `lua/user/plugins/`. Lazy.nvim automatically loads them.

```lua
-- lua/user/plugins/surround.lua
return {
  "tpope/vim-surround",
}
```

```lua
-- lua/user/plugins/copilot.lua
return {
  "github/copilot.vim",
  event = "InsertEnter",
}
```

```lua
-- lua/user/plugins/colorscheme.lua
-- Override the default colorscheme
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin")
  end,
}
```

## Feature Flags

The installer creates `lua/user/features.lua`:

```lua
-- lua/user/features.lua
return {
  claude_edit = true,   -- Enable claude-edit integration
  nowplaying = false,   -- Disable now-playing
}
```

Edit this file to toggle features, or re-run `install.sh`.

## LSP Configuration

### Adding Language Servers

The default config includes common servers. To add more, create:

```lua
-- lua/user/plugins/lsp-extras.lua
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Add servers to install
    opts.servers = opts.servers or {}
    opts.servers.elixirls = {}
    opts.servers.ocamllsp = {}
    return opts
  end,
}
```

### Custom LSP Settings

```lua
-- lua/user/plugins/lsp-settings.lua
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.tsserver = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
          },
        },
      },
    }
    return opts
  end,
}
```

## Overriding Core Config

To override a core plugin's configuration:

```lua
-- lua/user/plugins/telescope-override.lua
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        vertical = { width = 0.9 },
      },
    },
  },
}
```

## Adding Keymaps to Which-Key

```lua
-- lua/user/plugins/which-key-extras.lua
return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    opts.defaults = opts.defaults or {}
    opts.defaults["<leader>m"] = { name = "+my-stuff" }
    return opts
  end,
}
```

Then add keymaps with that prefix:

```lua
-- lua/user/init.lua
vim.keymap.set('n', '<leader>ma', ':echo "A"<CR>', { desc = 'Do A' })
vim.keymap.set('n', '<leader>mb', ':echo "B"<CR>', { desc = 'Do B' })
```

## Environment Variables

### CLAUDE_EDIT_CMD

Override the Claude command for claude-edit:

```bash
# Use a different Claude binary
CLAUDE_EDIT_CMD="/path/to/claude" nvim file.txt

# Or with arguments
CLAUDE_EDIT_CMD="claude --model opus" nvim file.txt
```

## Tips

### Check for Errors

After making changes, run `:checkhealth` to verify everything works.

### Lazy-loading

For better startup time, lazy-load plugins:

```lua
return {
  "my/plugin",
  event = "VeryLazy",  -- Load after startup
  -- or
  ft = "python",       -- Load for specific filetypes
  -- or
  cmd = "MyCommand",   -- Load when command is used
  -- or
  keys = {             -- Load when keymap is pressed
    { "<leader>mp", "<cmd>MyCommand<cr>", desc = "My Plugin" },
  },
}
```

### Debugging

Check which plugins are loaded:

```vim
:Lazy
```

Check if your user config loaded:

```vim
:lua print(vim.inspect(require('user')))
```

View all keymaps:

```vim
:Telescope keymaps
```

Or press `<Space>sk`.
