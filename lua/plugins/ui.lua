-- UI Enhancements - Cyberpunk vibes
return {
  -- Noice: Fancy command line, messages, and notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {},
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        progress = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          position = { row = 5, col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 8, col = "50%" },
          size = { width = 60, height = 10 },
          border = { style = "rounded", padding = { 0, 1 } },
        },
      },
    },
  },

  -- Notify: Beautiful notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#1a1b26",
      fps = 60,
      level = 2,
      render = "compact",
      stages = "fade_in_slide_out",
      timeout = 3000,
      top_down = true,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = "",
      },
    },
  },

  -- Dashboard: Cyberpunk startup screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Cyberpunk ASCII art header
      dashboard.section.header.val = {
        [[                                                    ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        [[                                                    ]],
        [[        ╔═══════════════════════════════════╗       ]],
        [[        ║   W A K E   U P ,   S A M U R A I ║       ]],
        [[        ║     we have code to burn...       ║       ]],
        [[        ╚═══════════════════════════════════╝       ]],
        [[                                                    ]],
      }

      dashboard.section.header.opts.hl = "DashboardHeader"

      -- Menu buttons
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Footer
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms"
      end

      dashboard.section.footer.opts.hl = "DashboardFooter"

      -- Layout
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Highlight groups for cyberpunk colors
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#7dcfff" })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#565f89" })

      alpha.setup(dashboard.config)

      -- Disable folding on alpha buffer
      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
  },

  -- Lualine: Sleek statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "" }, right_padding = 2 },
        },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
        },
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " } },
          "encoding",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy" },
    },
  },

  -- Bufferline: Buffer tabs at top
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned" },
      { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "bdelete! %d",
        indicator = { style = "icon", icon = "▎" },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 15,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          { filetype = "neo-tree", text = "File Explorer", highlight = "Directory", separator = true },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = "thin",
        always_show_bufferline = true,
        hover = { enabled = true, delay = 200, reveal = { "close" } },
      },
      highlights = {
        fill = { bg = "#1a1b26" },
        background = { bg = "#1a1b26", fg = "#565f89" },
        buffer_selected = { fg = "#c0caf5", bold = true, italic = false },
        buffer_visible = { fg = "#565f89" },
        close_button = { fg = "#565f89", bg = "#1a1b26" },
        close_button_selected = { fg = "#f7768e" },
        indicator_selected = { fg = "#7aa2f7" },
        modified = { fg = "#e0af68" },
        modified_selected = { fg = "#e0af68" },
        separator = { fg = "#1a1b26", bg = "#1a1b26" },
        separator_selected = { fg = "#1a1b26" },
        tab_selected = { bg = "#7aa2f7", fg = "#1a1b26" },
      },
    },
  },

  -- Scrollbar: Shows diagnostics and search on scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = false,
      throttle_ms = 100,
      handle = {
        text = " ",
        blend = 30,
        color = "#7aa2f7",
        color_nr = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true,
      },
      marks = {
        Cursor = { text = "•", priority = 0, gui = nil, color = "#7dcfff", cterm = nil, color_nr = nil, highlight = "Normal" },
        Search = { text = { "-", "=" }, priority = 1, gui = nil, color = "#ff9e64", cterm = nil, color_nr = nil, highlight = "Search" },
        Error = { text = { "-", "=" }, priority = 2, gui = nil, color = "#f7768e", cterm = nil, color_nr = nil, highlight = "DiagnosticVirtualTextError" },
        Warn = { text = { "-", "=" }, priority = 3, gui = nil, color = "#e0af68", cterm = nil, color_nr = nil, highlight = "DiagnosticVirtualTextWarn" },
        Info = { text = { "-", "=" }, priority = 4, gui = nil, color = "#0db9d7", cterm = nil, color_nr = nil, highlight = "DiagnosticVirtualTextInfo" },
        Hint = { text = { "-", "=" }, priority = 5, gui = nil, color = "#1abc9c", cterm = nil, color_nr = nil, highlight = "DiagnosticVirtualTextHint" },
        Misc = { text = { "-", "=" }, priority = 6, gui = nil, color = "#bb9af7", cterm = nil, color_nr = nil, highlight = "Normal" },
        GitAdd = { text = "▎", priority = 7, gui = nil, color = "#9ece6a", cterm = nil, color_nr = nil, highlight = "GitSignsAdd" },
        GitChange = { text = "▎", priority = 7, gui = nil, color = "#e0af68", cterm = nil, color_nr = nil, highlight = "GitSignsChange" },
        GitDelete = { text = "▎", priority = 7, gui = nil, color = "#f7768e", cterm = nil, color_nr = nil, highlight = "GitSignsDelete" },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = false,
      },
    },
  },

  -- Todo Comments: Highlight TODO, FIXME, HACK, etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search todos" },
    },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = { fg = "NONE", bg = "BOLD" },
      merge_keywords = true,
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      colors = {
        error = { "#f7768e" },
        warning = { "#e0af68" },
        info = { "#7dcfff" },
        hint = { "#9ece6a" },
        default = { "#bb9af7" },
        test = { "#ff9e64" },
      },
    },
  },

  -- Smooth Scrolling: Animated scroll
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "sine",
      pre_hook = nil,
      post_hook = nil,
      performance_mode = false,
    },
  },
}
