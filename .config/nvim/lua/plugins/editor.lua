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

  -- Keep reasonable amount of opened buffers
  -- {
  --   "axkirillov/hbac.nvim",
  --   config = true,
  -- },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify", "neo-tree" },
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
    "mbbill/undotree",
    keys = {
      { "<leader>fu", "<Cmd>UndotreeToggle<CR>", desc = "Undotree" },
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
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      local base_winbar = {
        lualine_a = {
          {
            "filename",
            path = 0,
          },
        },

        -- show path to the file
        lualine_c = {
          {
            "filename",
            file_status = false,
            path = 2,

            -- Shortens path to leave 5 spaces in the window
            -- for other components. (terrible name)
            shorting_target = 5,
            fmt = function(path)
              local root_path = LazyVim.root.cwd()

              -- INFO: handle the worktree dir as the project root
              local git_root = vim.fn.FugitiveWorkTree()

              if git_root ~= "" then
                root_path = git_root
              end

              return vim.fn.fnamemodify(path:sub(#root_path + 2), ":h") .. "/"
            end,
          },
        },

        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },

        -- show harpoon index
        lualine_y = {

          {
            "filename",
            file_status = false,
            path = 2,
            fmt = function(path)
              local Marked = require("harpoon.mark")
              local success, index = pcall(Marked.get_index_of, path)
              if success and index and index > 0 then
                return string.format("%d*", index) -- <-- Add your favorite harpoon like arrow here
              end
            end,
          },
          -- Git worktree name 󰊢 | Git-project folder name  | CWD folder name 
          {
            function()
              local cwd_root = LazyVim.root.get()
              local git_root = vim.fs.find(".git", { path = cwd_root, upward = true })[1]
              local worktree_name, worktree_match = vim.fn.FugitiveGitDir():gsub(".*worktrees/", "")

              if worktree_match == 1 then
                return worktree_name .. " 󰊢"
              end

              if git_root then
                return vim.fn.fnamemodify(git_root, ":h:t") .. " "
              end

              return vim.fn.fnamemodify(cwd_root, ":t") .. " "
            end,
          },
        },
      }

      opts.winbar = vim.deepcopy(base_winbar)
      opts.winbar.lualine_c[1].color = "StatusLineNC"
      opts.inactive_winbar = vim.deepcopy(base_winbar)

      opts.options.disabled_filetypes.winbar = {
        "neo-tree",
        "quickfix",
        "qf",
        "prompt",
        "trouble",
        "dashboard",
        "alpha",
        "starter",
        "noice",
        "git",
        "nofile",
        "fugitiveblame",
        "DiffviewFiles",
      }

      -- simplify global statusline
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        -- { LazyVim.lualine.pretty_path() },
      }

      table.insert(opts.sections.lualine_y, "fileformat")

      return opts
    end,
  },

  -- Trouble.nvim
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
    },
  },

  {
    "rcarriga/nvim-notify",
    url = "https://github.com/MatejBransky/nvim-notify.git",
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        ["<leader>o"] = { name = "+ref" },
      },
    },
  },

  {
    "LunarVim/bigfile.nvim",
    opts = {
      features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        -- "matchparen",
        "vimopts",
        "filetype",
      },
    },
  },

  {
    "fei6409/log-highlight.nvim",
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        ["markdown"] = false,
        ["markdown.mdx"] = false,
      },
    },
  },
}
