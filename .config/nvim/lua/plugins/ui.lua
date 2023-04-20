return {
  -- finally working theme switcher
  {
    "cormacrelf/dark-notify",
    init = function()
      require("dark_notify").run()
    end,
  },
  {
    "navarasu/onedark.nvim",
    opts = function(_, opts)
      opts.highlights = {
        -- I like VS Code colors for git symbols
        ["NeoTreeGitUntracked"] = { fg = "$green", fmt = "none" },
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  -- describe my keybindings
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").register({
        ["<leader>y"] = {
          name = "use system clipboard",
        },
        ["<leader>Y"] = {
          name = "use system clipboard (line)",
        },
        ["<leader>d"] = {
          name = "delete to black hole",
        },
        ["<leader>t"] = {
          name = "+Terminal",
        },
        ["<leader>k"] = "Show diag. in a floating window.",
      })
    end,
  },
  -- the real Vim 🥷 doesn't use tabs!
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      default_component_configs = {
        name = {
          -- I like to keep git status visualized just by letter-symbols
          use_git_status_colors = false,
        },
        git_status = {
          -- I like VS Code-like symbols with simple letters
          symbols = {
            renamed = "R",
            untracked = "U",
            modified = "M",
            deleted = "D",
            conflict = "C",
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- show me the filename first
        path_display = function(_, path)
          local tail = require("telescope.utils").path_tail(path)
          return string.format("%s -- %s", tail, path)
        end,
        mappings = {
          n = {
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          i = {
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
        layout_strategy = "vertical",
      },
      pickers = {
        lsp_references = {
          -- prioritize file paths in the result (=> disable inline preview)
          -- https://github.com/nvim-telescope/telescope.nvim/issues/2121
          show_line = false,
        },
        lsp_definitions = {
          show_line = false,
        },
      },
    },
  },
}
