return {
  -- Theme
  {
    "navarasu/onedark.nvim",
    opts = function(_, opts)
      opts.highlights = {
        -- I like VS Code colors for git symbols
        ["NeoTreeGitUntracked"] = { fg = "$green", fmt = "none" },
      }
    end,
  },

  -- LazyVim config
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },

  -- finally working theme switcher!
  {
    "cormacrelf/dark-notify",
    init = function()
      require("dark_notify").run()
    end,
  },

  -- Nvim dashboard (something like a "welcome screen")
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        -- give me some decent dashboard header
        header = {
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                    === NEOVIM ===                   ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
          "                                                     ",
        },
      },
    },
  },

  -- the real Vim 🥷 doesn't use tabs!
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  -- Better leap/hop/easy motions
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        -- Leave my search alone!
        search = {
          enabled = false,
        },
      },
    },
  },

  -- Lang code highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "graphql",
        "styled",
      },
    },
  },

  -- Give me color highlights (e.g.: red, #ff0, hsla(210,28%,27%) )
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        RGB = true,
        names = false,
        hsl_fn = true,
      },
    },
  },

  -- Markdown click-link support
  {
    "jghauser/follow-md-links.nvim",
  },

  -- JSX autoclose/autorename support
  {
    "windwp/nvim-ts-autotag",
    opts = {
      enable_close_on_slash = false,
    },
  },

  -- Support prompts the user to pick a window for opening the file
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  -- Statusline:
  --  +-------------------------------------------------+
  --  | A | B | C                             X | Y | Z |
  --  +-------------------------------------------------+
  --
  -- LazyVim defaults:
  -- * A: mode (n, i, <C-v>, V,...)
  -- * B: git branch
  -- * C: root_dir | diagnostics | filetype icon + file path
  -- * X: last command | noice.api.status.mode??? | DAP (bug icon) | LazyVim updates (packages) | git diff
  -- * Y: progress [%] | location (line:column)
  -- * Z: clocks

  -- Show filenames in windows
  {
    "b0o/incline.nvim",
    opts = {
      hide = {
        cursorline = true,
      },
      -- Use basic render with one enhancement: show dirname for index.* files
      -- e.g. src/Foobar/index.tsx => Foobar/i
      render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local res = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"

        if string.match(res, "^index%.[^.]+$") then
          local directory = vim.fn.fnamemodify(bufname, ":h:t")
          local extension = vim.fn.fnamemodify(bufname, ":e")

          res = directory .. "/"

          if extension ~= "" then
            res = res .. extension
          end
        end

        if vim.api.nvim_get_option_value("modified", { buf = props.buf }) then
          res = res .. " [+]"
        end

        return res
      end,
    },
    -- Optional: Lazy load Incline
    event = "VeryLazy",
  },

  -- Keep reasonable amount of opened buffers
  {
    "axkirillov/hbac.nvim",
    config = true,
  },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
      handlers = {
        -- cursor = false,
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },

  {
    "echasnovski/mini.animate",
    enabled = false,
    opts = {
      cursor = {
        enable = false,
      },
      scroll = {
        enable = true,
        timing = require("mini.animate").gen_timing.cubic({ easing = "in-out", duration = 150, unit = "total" }),
      },
    },
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>h", "<Cmd>UndotreeToggle<CR>", { desc = "Undotree" } },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VimEnter", -- needed for folds to load in time and comments closed
    init = function()
      -- vim.o.foldenable = true
      vim.o.foldcolumn = "1"
      -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
      -- auto-closing them after leaving insert mode, however ufo does not seem to
      -- have equivalents for zr and zm because there is no saved fold level.
      -- Consequently, the vim-internal fold levels need to be disabled by setting
      -- them to 99
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
    end,
    keys = {
			-- stylua: ignore start
			{ "zm", function() require("ufo").closeAllFolds() end, desc = "󱃄 Close All Folds" },
			{ "zr", function() require("ufo").openFoldsExceptKinds { "comment", "imports" } end, desc = "󱃄 Open All Regular Folds" },
			{ "zR", function() require("ufo").openFoldsExceptKinds {} end, desc = "󱃄 Open All Folds" },
			-- { "z1", function() require("ufo").closeFoldsWith(1) end, desc = "󱃄 Close L1 Folds" },
			-- { "z2", function() require("ufo").closeFoldsWith(2) end, desc = "󱃄 Close L2 Folds" },
			-- { "z3", function() require("ufo").closeFoldsWith(3) end, desc = "󱃄 Close L3 Folds" },
			-- { "z4", function() require("ufo").closeFoldsWith(4) end, desc = "󱃄 Close L4 Folds" },
      { "zh", "zMzvzz", {desc = "Close folds around the cursor"} },
      -- stylua: ignore end
    },
    opts = {
      provider_selector = function(_, ft, _)
        -- INFO some filetypes only allow indent, some only LSP, some only
        -- treesitter. However, ufo only accepts two kinds as priority,
        -- therefore making this function necessary :/
        local lspWithOutFolding = { "markdown", "sh", "css", "html", "python" }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { "treesitter", "indent" }
        end
        return { "lsp", "indent" }
      end,
      -- when opening the buffer, close these fold kinds
      -- use `:UfoInspect` to get available fold kinds from the LSP
      -- close_fold_kinds_for_ft = {
      --   default = { "imports", "comment" },
      -- },
      open_fold_hl_timeout = 800,
    },
  },
}
