return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>k", vim.diagnostic.open_float, mode = "n" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "graphql",
      },
    },
  },
  -- Leave my Enter, Tab and arrow keys alone!
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.config.disable,
        ["<CR>"] = cmp.config.disable,
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<Up>"] = cmp.config.disable,
        ["<Down>"] = cmp.config.disable,
      }))
      opts.sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry)
            return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
          end,
        },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      })
    end,
  },
  -- Leave my Tab key alone!
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- disable auto popup of function documenation
        -- https://github.com/LazyVim/LazyVim/discussions/345
        signature = {
          auto_open = false,
        },
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {},
  },
  {
    "jghauser/follow-md-links.nvim",
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup()

      require("telescope").setup({
        extensions = {
          package_info = {
            -- Optional theme (the extension doesn't set a default theme)
            theme = "ivy",
          },
        },
      })

      require("telescope").load_extension("package_info")

      require("which-key").register({
        ["<leader>n"] = {
          name = "npm dependencies",
          s = "Show dependency versions",
          c = "Hide dependency versions",
          t = "Toggle dependency versions",
          u = "Update dependency on the line",
          d = "Delete dependency on the line",
          i = "Install a new dependency",
          p = "Install a different dependency version",
        },
      })

      -- Show dependency versions
      vim.keymap.set({ "n" }, "<LEADER>ns", require("package-info").show, { silent = true, noremap = true })

      -- Hide dependency versions
      vim.keymap.set({ "n" }, "<LEADER>nc", require("package-info").hide, { silent = true, noremap = true })

      -- Toggle dependency versions
      vim.keymap.set({ "n" }, "<LEADER>nt", require("package-info").toggle, { silent = true, noremap = true })

      -- Update dependency on the line
      vim.keymap.set({ "n" }, "<LEADER>nu", require("package-info").update, { silent = true, noremap = true })

      -- Delete dependency on the line
      vim.keymap.set({ "n" }, "<LEADER>nd", require("package-info").delete, { silent = true, noremap = true })

      -- Install a new dependency
      vim.keymap.set({ "n" }, "<LEADER>ni", require("package-info").install, { silent = true, noremap = true })

      -- Install a different dependency version
      vim.keymap.set({ "n" }, "<LEADER>np", require("package-info").change_version, { silent = true, noremap = true })
    end,
  },
}
