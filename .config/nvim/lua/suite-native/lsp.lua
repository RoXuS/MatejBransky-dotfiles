local H = require("utils.helpers")
local my_keys = require("my_keys")

return {
  {
    "folke/neoconf.nvim",
    opts = {
      import = {
        vscode = false,
        coc = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neoconf.nvim",
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { my_keys.lsp.hoverInfo.shortcut, vim.lsp.buf.hover, desc = my_keys.lsp.hoverInfo.desc }

      vim.keymap.set(my_keys.lsp.log.mode, my_keys.lsp.log.shortcut, "<Cmd>LspLog<CR>", { desc = my_keys.lsp.log.desc })
      vim.keymap.set(
        my_keys.lsp.log.mode,
        my_keys.lsp.info.shortcut,
        "<Cmd>LspInfo<CR>",
        { desc = my_keys.lsp.info.desc }
      )
      vim.keymap.set(
        my_keys.lsp.log.mode,
        my_keys.lsp.restart.shortcut,
        "<Cmd>LspRestart<CR>",
        { desc = my_keys.lsp.restart.desc }
      )

      vim.keymap.set(
        my_keys.lsp.showDiagWindow.mode,
        my_keys.lsp.showDiagWindow.shortcut,
        vim.diagnostic.open_float,
        { desc = my_keys.lsp.showDiagWindow.desc }
      )
    end,
    opts = {
      diagnostics = {
        -- disable inline diagnostic messages
        virtual_text = false,
      },
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
        -- I moved this to project-specific config files (<project-dir>/.lazy.lua)
        -- tsserver = {
        --   init_options = {
        --     preferences = {
        --       importModuleSpecifierPreference = "non-relative",
        --       importModuleSpecifierEnding = "minimal",
        --     },
        --   },
        -- },
      },
    },
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   ft = { "typescript", "typescriptreact" },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "neovim/nvim-lspconfig",
  --   },
  --   keys = {
  --     {
  --       my_keys.lsp.organizeImports.shortcut,
  --       "<cmd>TSToolsOrganizeImports<CR>",
  --       desc = my_keys.lsp.organizeImports.desc,
  --     },
  --     { my_keys.lsp.renameFile.shortcut, "<cmd>TSToolsRenameFile<CR>", desc = my_keys.lsp.renameFile.desc },
  --   },
  --   opts = {
  --     settings = {
  --       -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
  --       -- "remove_unused_imports"|"organize_imports") -- or string "all"
  --       -- to include all supported code actions
  --       -- specify commands exposed as code_actions
  --       expose_as_code_action = "all",
  --       -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
  --       -- (see 💅 `styled-components` support section)
  --       tsserver_plugins = {
  --         "@styled/typescript-styled-plugin",
  --       },
  --       tsserver_file_preferences = {
  --         includeInlayParameterNameHints = "all",
  --         includeCompletionsForModuleExports = true,
  --         quotePreference = "auto",
  --       },
  --     },
  --   },
  -- },
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
        hover = {
          silent = true, -- set to true to not show a message if hover is not available
        },
      },
    },
  },
}
