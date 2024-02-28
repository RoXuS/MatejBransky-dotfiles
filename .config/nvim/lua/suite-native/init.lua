local cmp = require("suite-native.cmp")
local lsp = require("suite-native.lsp")

local M = {
  {
    "folke/lazy.nvim",
    opts = {
      spec = {
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.formatting.prettier" },
        { import = "lazyvim.plugins.extras.lang.json" },
      },
    },
  },
}

vim.list_extend(M, cmp)
vim.list_extend(M, lsp)

return M
