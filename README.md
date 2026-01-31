# dev-nvim

> A modern Neovim configuration optimized for AI-assisted development workflows.

<!-- Screenshot placeholder - add your own with: <Space>? to show cheatsheet, then screenshot -->
<!-- <p align="center"><img src="docs/screenshots/cheatsheet.png" alt="Cheatsheet" width="600"></p> -->

## Why dev-nvim?

Built for developers who work with AI coding assistants like Claude Code. Features like **auto-reload on external changes**, **context copying**, and **diff views** make it effortless to collaborate with AI that edits your files directly.

## Quick Start

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mpaarating/dev-nvim/main/install.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/mpaarating/dev-nvim.git ~/.dotfiles/nvim
~/.dotfiles/nvim/install.sh
```

## Features

### Core Features

- **Fast startup** — Lazy-loaded plugins via [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP out of the box** — TypeScript, Python, Lua, Go, Rust, and more via [mason.nvim](https://github.com/williamboman/mason.nvim)
- **Fuzzy finding** — [Telescope](https://github.com/nvim-telescope/telescope.nvim) with fzf-native for fast search
- **Git integration** — [LazyGit](https://github.com/jesseduffield/lazygit) + [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- **Modern UI** — [Tokyo Night](https://github.com/folke/tokyonight.nvim) theme, [lualine](https://github.com/nvim-lualine/lualine.nvim), [which-key](https://github.com/folke/which-key.nvim)
- **Syntax highlighting** — [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for accurate highlighting
- **Built-in cheatsheet** — Press `<Space>?` anytime

### AI Workflow Features

Designed for seamless collaboration with AI coding assistants:

- **Auto-reload** — Files automatically reload when modified externally (no more "file changed on disk" prompts)
- **Context copying** — `<Space>cc` copies code with file path and line numbers, formatted for AI consumption
- **Diff views** — `<Space>cd` shows unsaved changes, `<Space>cD` diffs against git HEAD
- **Session persistence** — Automatically saves/restores your session per project

### Optional Features

Configured during installation:

- **claude-edit** — Split-pane workflow with Claude Code (requires [Claude CLI](https://docs.anthropic.com/en/docs/claude-code))
- **now-playing** — Show current track from Spotify/Apple Music (macOS only)

## Key Bindings

Press `<Space>?` for the full cheatsheet. Here are the essentials:

| Key | Action |
|-----|--------|
| `<Space>` | Leader key (opens which-key menu) |
| `<Space>?` | Show cheatsheet |
| `<Space>e` | Toggle file explorer |
| `<Space>ff` | Find files |
| `<Space>/` | Live grep (search in files) |
| `<Space>gg` | Open LazyGit |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<Space>ca` | Code actions |
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-s>` | Save file |

### AI Workflow Keys

| Key | Action |
|-----|--------|
| `<Space>cc` | Copy buffer/selection for AI (with file:line format) |
| `<Space>cd` | Diff against saved version |
| `<Space>cD` | Diff against git HEAD |
| `<Space>qs` | Restore session |
| `<Space>ql` | Restore last session |

See [docs/keybindings.md](docs/keybindings.md) for the complete reference.

## Claude Code Integration

The `ce` (claude-edit) workflow opens a file in Neovim with Claude Code running in a split pane. This lets you edit code while chatting with Claude — changes sync automatically.

### Setup

1. Install [Claude CLI](https://docs.anthropic.com/en/docs/claude-code)
2. Run the installer and enable claude-edit when prompted
3. Add the `ce` function to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# Claude-edit: open file with Claude in split pane
ce() {
  if [[ -z "$1" ]]; then
    echo "Usage: ce <file>"
    return 1
  fi
  CLAUDE_EDIT_CMD="claude" nvim "$1" -c 'lua require("config.claude-edit").setup()'
}
```

4. Reload your shell: `source ~/.zshrc`

### Usage

```bash
ce src/myfile.ts
```

This opens:
- Left pane: Your file in Neovim
- Right pane: Claude Code terminal

| Key | Action |
|-----|--------|
| `<C-h>` | Focus editor (left) |
| `<C-l>` | Focus Claude (right) |
| `<Space>ct` | Toggle Claude pane |
| `<Space>ch` | Claude-edit help |
| `<Esc><Esc>` | Exit terminal mode (to scroll/copy) |
| `i` | Re-enter terminal mode |

Claude sees the file you're editing. Ask it to make changes, and they appear in your buffer.

## Customization

Add personal customizations without modifying core config:

```lua
-- lua/user/init.lua
vim.keymap.set('n', '<leader>x', ':echo "custom"<CR>')
vim.opt.relativenumber = true
```

Add plugins:

```lua
-- lua/user/plugins/my-plugins.lua
return {
  { "tpope/vim-surround" },
}
```

See [docs/customization.md](docs/customization.md) for more.

## Updating

```bash
~/.dotfiles/nvim/update.sh
```

Or manually:

```bash
cd ~/.dotfiles/nvim && git pull
nvim --headless "+Lazy! sync" +qa
```

## Uninstalling

```bash
~/.dotfiles/nvim/uninstall.sh
```

## Requirements

- **Neovim** >= 0.11
- **git**
- **Node.js** (for LSP servers)
- **ripgrep** (for telescope live grep)
- **fd** (optional, faster file finding)

### macOS

```bash
brew install neovim node ripgrep fd
```

### Ubuntu/Debian

```bash
# Neovim (use latest release, not apt)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

# Other dependencies
sudo apt install nodejs npm ripgrep fd-find
```

## Structure

```
dev-nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Plugin version locks
├── lua/
│   ├── config/           # Core configuration
│   │   ├── options.lua   # Neovim options
│   │   ├── keymaps.lua   # Key bindings
│   │   ├── autocmds.lua  # Auto commands
│   │   └── ...
│   ├── plugins/          # Plugin specifications
│   │   ├── lsp.lua       # LSP configuration
│   │   ├── telescope.lua # Fuzzy finder
│   │   └── ...
│   └── user/             # Your customizations (gitignored)
└── docs/                 # Documentation
```

## License

MIT
