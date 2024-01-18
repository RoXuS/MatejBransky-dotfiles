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
}
