local my_keys = require("my_keys")

return {
  -- Leave my Enter, Tab and arrow keys alone!
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.config.disable,
        ["<CR>"] = cmp.config.disable,
        [my_keys.completion.accept.shortcut] = cmp.mapping.confirm({ select = true }),
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

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {
        {
          my_keys.snippet.jumpNext.shortcut,
          function()
            require("luasnip").jump(1)
          end,
          mode = my_keys.snippet.jumpNext.mode,
        },
        {
          my_keys.snippet.jumpPrev.shortcut,
          function()
            require("luasnip").jump(-1)
          end,
          mode = my_keys.snippet.jumpPrev.mode,
        },
      }
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        -- require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = "./lua/snippets" })
      end,
    },
  },

  -- Better snippet editor
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    keys = {
      {
        my_keys.snippet.add.shortcut,
        function()
          require("scissors").addNewSnippet()
        end,
        mode = my_keys.snippet.add.mode,
        desc = my_keys.snippet.add.desc,
      },
      {
        my_keys.snippet.edit.shortcut,
        function()
          require("scissors").editSnippet()
        end,
        desc = my_keys.snippet.edit.desc,
      },
    },
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/lua/snippets",
      jsonFormatter = "jq",
    },
  },
}
