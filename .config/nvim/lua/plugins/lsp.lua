local myKeys = require("myKeys")

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { myKeys.motion.bigUp.shortcut, "6k" }

      keys[#keys + 1] = { myKeys.lsp.hoverInfo.shortcut, vim.lsp.buf.hover, desc = myKeys.lsp.hoverInfo.desc }

      vim.keymap.set(myKeys.lsp.log.mode, myKeys.lsp.log.shortcut, "<Cmd>LspLog<CR>", { desc = myKeys.lsp.log.desc })
      vim.keymap.set(myKeys.lsp.log.mode, myKeys.lsp.info.shortcut, "<Cmd>LspInfo<CR>", { desc = myKeys.lsp.info.desc })
      vim.keymap.set(
        myKeys.lsp.log.mode,
        myKeys.lsp.restart.shortcut,
        "<Cmd>LspRestart<CR>",
        { desc = myKeys.lsp.restart.desc }
      )

      vim.keymap.set(
        myKeys.lsp.showDiagWindow.mode,
        myKeys.lsp.showDiagWindow.shortcut,
        vim.diagnostic.open_float,
        { desc = myKeys.lsp.showDiagWindow.desc }
      )
    end,
    opts = {
      setup = {
        eslint = function(_, opts)
          opts.filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "svelte",
            "astro",
            "graphql",
          }
        end,
      },
      servers = {
        graphql = {
          filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript" },
        },
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    keys = {
      {
        myKeys.lsp.organizeImports.shortcut,
        "<cmd>TSToolsOrganizeImports<CR>",
        desc = myKeys.lsp.organizeImports.desc,
      },
      { myKeys.lsp.renameFile.shortcut, "<cmd>TSToolsRenameFile<CR>", desc = myKeys.lsp.renameFile.desc },
    },
    opts = {
      settings = {
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = "all",
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeCompletionsForModuleExports = true,
          quotePreference = "auto",
        },
      },
    },
  },
  -- Reduce UI noice
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
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- disable inline diagnostic messages
        virtual_text = false,
      },
    },
  },
}
