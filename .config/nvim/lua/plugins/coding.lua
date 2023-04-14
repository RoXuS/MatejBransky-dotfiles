return {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  -- Leave my Enter alone!
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
        ["<CR>"] = cmp.config.disable,
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      }))
    end,
  },
}
