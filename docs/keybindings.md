# Keybindings Reference

Leader key: `<Space>`

Press `<Space>` and wait for which-key to show available options.
Press `<Space>?` for the built-in cheatsheet.

## Navigation

### Windows

| Key | Action |
|-----|--------|
| `<C-h>` | Go to left window |
| `<C-j>` | Go to lower window |
| `<C-k>` | Go to upper window |
| `<C-l>` | Go to right window |
| `<C-Up>` | Increase window height |
| `<C-Down>` | Decrease window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |
| `<C-w>=` | Equal window sizes |

### Tabs

| Key | Action |
|-----|--------|
| `<Space><Tab><Tab>` | New tab |
| `<Space><Tab>]` | Next tab |
| `<Space><Tab>[` | Previous tab |
| `<Space><Tab>d` | Close tab |
| `<Space><Tab>f` | First tab |
| `<Space><Tab>l` | Last tab |

### Jumps

| Key | Action |
|-----|--------|
| `<C-o>` | Jump back |
| `<C-i>` | Jump forward |
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `]q` | Next quickfix item |
| `[q` | Previous quickfix item |

## Files & Search

### File Explorer

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle file tree |
| `<Space>fn` | New file |

### Telescope

| Key | Action |
|-----|--------|
| `<Space>ff` | Find files |
| `<Space>fF` | Find all files (including hidden) |
| `<Space>/` | Live grep (search in files) |
| `<Space>fb` | Buffers |
| `<Space>fr` | Recent files |

### Search (Telescope)

| Key | Action |
|-----|--------|
| `<Space>sk` | Search keymaps |
| `<Space>sh` | Search help pages |
| `<Space>sb` | Search current buffer |
| `<Space>sw` | Search word under cursor |
| `<Space>sm` | Search marks |
| `<Space>s"` | Search registers |
| `<Space>sR` | Resume last search |

### Inside Telescope Picker

| Key | Action |
|-----|--------|
| `<CR>` | Open file |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<A-h>` | Toggle hidden files |
| `<A-i>` | Toggle ignored files |
| `<C-n>` / `<C-p>` | Next/previous item |
| `<Esc>` | Close picker |

## Code & LSP

### Information

| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<Space>cd` | Line diagnostics |

### Actions

| Key | Action |
|-----|--------|
| `<Space>ca` | Code action |
| `<Space>cr` | Rename symbol |
| `<Space>cf` | Format file |

### Diagnostics

| Key | Action |
|-----|--------|
| `<Space>xx` | Document diagnostics |
| `<Space>xX` | Workspace diagnostics |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |

## Git

### LazyGit

| Key | Action |
|-----|--------|
| `<Space>gg` | Open LazyGit |

Inside LazyGit:

| Key | Context | Action |
|-----|---------|--------|
| `Space` | Files | Stage/unstage |
| `a` | Files | Stage all |
| `c` | Commits | Commit |
| `A` | Commits | Amend |
| `p` | Commits | Cherry pick |
| `s` | Commits | Squash down |
| `f` | Commits | Fixup |
| `Space` | Branches | Checkout |
| `n` | Branches | New branch |
| `M` | Branches | Merge into |
| `R` | Branches | Rebase onto |
| `f` | Sync | Fetch |
| `p` | Sync | Pull |
| `P` | Sync | Push |
| `?` | Any | Show all keys |
| `q` | Any | Quit |

### Gitsigns

| Key | Action |
|-----|--------|
| `<Space>gs` | Git status (telescope) |
| `<Space>gc` | Git commits (telescope) |
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<Space>ghs` | Stage hunk |
| `<Space>ghr` | Reset hunk |
| `<Space>ghp` | Preview hunk |
| `<Space>ghb` | Blame line |
| `<Space>ghd` | Diff this |

## Editing

### Movement

| Key | Action |
|-----|--------|
| `j` / `k` | Move down/up (respects wrapped lines) |
| `<A-j>` | Move line down |
| `<A-k>` | Move line up |

### Operations

| Key | Action |
|-----|--------|
| `<C-s>` | Save file |
| `<` / `>` | Indent (in visual mode, stays selected) |
| `p` | Paste (in visual mode, doesn't yank replaced text) |
| `<Esc>` | Clear search highlight |

### Text Objects

| Key | Action |
|-----|--------|
| `ciw` | Change inner word |
| `ci"` / `ci'` / `` ci` `` | Change inside quotes |
| `ci(` / `ci[` / `ci{` | Change inside brackets |
| `ca(` / `ca[` / `ca{` | Change around brackets |
| `dap` | Delete paragraph |
| `yiw` | Yank word |

## Terminal

### ToggleTerm

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle float terminal |
| `<Space>tf` | Float terminal |
| `<Space>th` | Horizontal terminal |
| `<Space>tv` | Vertical terminal |

### In Terminal Mode

| Key | Action |
|-----|--------|
| `<Esc><Esc>` | Exit terminal mode (for scrolling/copying) |
| `i` | Re-enter terminal mode |
| `<C-h/j/k/l>` | Navigate to other windows |

## AI Workflow

These keybindings optimize working with AI coding assistants that edit files directly.

### Context & Diff

| Key | Action |
|-----|--------|
| `<Space>cc` | Copy buffer for AI (with file:line format) |
| `<Space>cc` (visual) | Copy selection for AI |
| `<Space>cd` | Diff against saved version |
| `<Space>cD` | Diff against git HEAD |
| `:ClaudeContext` | Copy buffer/range for AI |
| `:ClaudeDiff` | Show diff against saved |
| `:ClaudeDiffGit` | Show diff against git HEAD |

### Sessions

| Key | Action |
|-----|--------|
| `<Space>qs` | Restore session (per project) |
| `<Space>ql` | Restore last session |
| `<Space>qd` | Don't save current session |

## Claude-Edit (when enabled)

| Key | Action |
|-----|--------|
| `<C-h>` | Go to editor (left pane) |
| `<C-l>` | Go to Claude (right pane) |
| `<Space>ct` | Toggle Claude terminal |
| `<Space>ch` | Claude-edit help |
| `gf` (in terminal) | Open file under cursor |

## Utilities

| Key | Action |
|-----|--------|
| `<Space>?` | Show cheatsheet |
| `<Space>v?` | Show vim cheatsheet |
| `<Space>np` | Now playing (when enabled) |
| `<Space>qq` | Quit all |
