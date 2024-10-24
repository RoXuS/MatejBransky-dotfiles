local my_keys = require("my_keys")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neoconf.nvim",
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- first I have to disable the default hover shortcut so I can my custom
      keys[#keys + 1] = { "K", false }
      -- then I can map it to the desired one
      keys[#keys + 1] = { my_keys.lsp.hoverInfo.shortcut, vim.lsp.buf.hover, desc = my_keys.lsp.hoverInfo.desc }

      keys[#keys + 1] = {
        my_keys.lsp.prevRef.shortcut,
        function()
          LazyVim.lsp.words.jump(-vim.v.count1)
        end,
        has = "documentHighlight",
        desc = my_keys.lsp.prevRef.desc,
      }
      keys[#keys + 1] = {
        my_keys.lsp.nextRef.shortcut,
        function()
          LazyVim.lsp.words.jump(vim.v.count1)
        end,
        has = "documentHighlight",
        desc = my_keys.lsp.nextRef.desc,
      }

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
      inlay_hints = { enabled = false },
      diagnostics = {
        -- disable inline diagnostic messages
        virtual_text = false,
      },

      servers = {
        eslint = {
          -- INFO: root_dir v1: look for the package.json first (mostly the root dir)
          --
          -- This solution might be problematic in the case of published Nx modules
          -- that have their own package.json but their .eslintrc* file might still reference
          -- the root .eslintrc*.
          root_dir = function(filename, bufnr)
            local lspconfig_util = require("lspconfig.util")
            local find_root_dir = lspconfig_util.root_pattern("package.json", ".git", ".eslintrc*")
            local found_root_dir = find_root_dir(filename)
            -- if the root dir wasn't found fallback to the cwd
            return found_root_dir or vim.fn.getcwd()
          end,

          -- INFO: root_dir v2: better for Nx monorepos, worse for monorepos without root-dependent ESLint configs
          --
          -- root_dir_v2 = require('lspconfig.util').root_pattern('.git')

          -- INFO: root_dir v3: attempt to resolve the root dir cleverly (unfinished)
          --
          -- root_dir_v3 = function(filename, bufnr)
          --   local lspconfig_util = require("lspconfig.util")
          --   local find_root_dir = lspconfig_util.root_pattern("package.json", ".git", ".eslintrc*")
          --   local found_root_dir = find_root_dir(filename)
          --
          --   local eslintrc_dir = lspconfig_util.root_pattern(".eslintr*")(filename)
          --   local eslintrc_file = eslintrc_dir .. "/.eslintrc.json"
          --
          --   -- vim.print("eslintrc_file: " .. eslintrc_file)
          --
          --   local eslintrc = vim.fn.readblob(eslintrc_file)
          --   -- vim.print("eslintrc" .. eslintrc)
          --   local json_content = vim.fn.json_decode(eslintrc)
          --   local extendsStrOrList = json_content.extends
          --   vim.print(extendsStrOrList)
          --
          --   if type(extendsStrOrList) == "string" then
          --     vim.print("relative extend (string): " .. vim.startswith(extendsStrOrList, "../"))
          --   else
          --     for _, item in ipairs(extendsStrOrList) do
          --       local relativePath = vim.startswith(extendsStrOrList[1], "../")
          --       vim.print("relative extend (list item): " .. (relativePath and "yes" or "no"))
          --     end
          --   end
          -- end,
        },
        graphql = {
          -- narrow eslint-graphql detection
          filetypes = { "graphql" },
        },

        -- https://github.com/LazyVim/LazyVim/pull/4406
        ts_ls = {
          enabled = false,
        },

        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "@styled/typescript-styled-plugin",
                    location = "/Users/Matej.Bransky/Library/pnpm/global/5/node_modules/@styled/typescript-styled-plugin",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
          },
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
        hover = {
          silent = true, -- set to true to not show a message if hover is not available
        },
      },
    },
  },
}
