local myKeys = require("myKeys")

return {
  -- Leave my Enter, Tab and arrow keys alone!
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.config.disable,
        ["<CR>"] = cmp.config.disable,
        [myKeys.completion.accept.shortcut] = cmp.mapping.confirm({ select = true }),
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
      return {
        {
          myKeys.snippet.jumpNext.shortcut,
          function()
            require("luasnip").jump(1)
          end,
          mode = myKeys.snippet.jumpNext.mode,
        },
        {
          myKeys.snippet.jumpPrev.shortcut,
          function()
            require("luasnip").jump(-1)
          end,
          mode = myKeys.snippet.jumpPrev.mode,
        },
      }
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = "./lua/snippets" })
      end,
    },
  },

  -- Better snippets
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    keys = {
      {
        myKeys.snippet.add.shortcut,
        function()
          require("scissors").addNewSnippet()
        end,
        mode = myKeys.snippet.add.mode,
        desc = myKeys.snippet.add.desc,
      },
      {
        myKeys.snippet.edit.shortcut,
        function()
          require("scissors").editSnippet()
        end,
        desc = myKeys.snippet.edit.desc,
      },
    },
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/lua/snippets",
      jsonFormatter = "jq",
    },
  },
}
