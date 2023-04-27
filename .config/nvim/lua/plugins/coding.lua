return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>k", vim.diagnostic.open_float, mode = "n" },
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
}
