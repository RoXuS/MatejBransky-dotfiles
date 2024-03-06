-- local suite_coc = require("suite-coc")
local suite_native = require("suite-native")

local M = {}

-- I had to disable it because the prettier formatter didn't work in the native suite
-- if vim.env.NVIM_SUITE_COC == "true" then
--   vim.list_extend(M, suite_coc)
-- else
vim.list_extend(M, suite_native)
-- end

vim.list_extend(M, {
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
    config = function()
      local scrollbar = require("scrollbar")
      scrollbar.setup({
        excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
})

return M
