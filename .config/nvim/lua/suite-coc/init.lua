local H = require('utils.helpers')

local my_keys = require("my_keys")

local M = {}

-- disable LazyVim default plugins for the native LSP solution
local disabled_plugins = {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "williamboman/mason.nvim",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  "saadparwaiz1/cmp_luasnip",
  "stevearc/conform.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
}

for _, plugin in ipairs(disabled_plugins) do
  table.insert(M, { plugin, enabled = false })
end

table.insert(M, {
  "folke/trouble.nvim",
  keys = {
    { my_keys.lsp.diagList.shortcut, false }
  }
})

table.insert(M, {
  "neoclide/coc.nvim",
  branch = "release",
  lazy = false,
  config = function()
    -- Some servers have issues with backup files, see #649
    vim.opt.backup = false
    vim.opt.writebackup = false

    -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    -- delays and poor user experience
    vim.opt.updatetime = 300

    -- Always show the signcolumn, otherwise it would shift the text each time
    -- diagnostics appeared/became resolved
    vim.opt.signcolumn = "yes"
  end,
  opts = function()
    -- Autocomplete
    function _G.check_back_space()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
    vim.api.nvim_create_augroup("CocGroup", {})
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "CocGroup",
      command = "silent call CocActionAsync('highlight')",
      desc = "Highlight symbol under cursor on CursorHold",
    })

    -- Setup formatexpr specified filetype(s)
    vim.api.nvim_create_autocmd("FileType", {
      group = "CocGroup",
      pattern = "typescript,json",
      command = "setl formatexpr=CocAction('formatSelected')",
      desc = "Setup formatexpr specified filetype(s).",
    })

    -- Update signature help on jump placeholder
    vim.api.nvim_create_autocmd("User", {
      group = "CocGroup",
      pattern = "CocJumpPlaceholder",
      command = "call CocActionAsync('showSignatureHelp')",
      desc = "Update signature help on jump placeholder",
    })

    -- Apply the most preferred quickfix action on the current line.
    -- keyset("n", "<leader>cf", "<Plug>(coc-fix-current)", getCodeActionOpts())

    -- keyset("x", "<leader>ar", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
    -- keyset("n", "<leader>ar", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

    -- Run the Code Lens actions on the current line
    -- keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", getCodeActionOpts())

    -- Map function and class text objects
    -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
    -- keyset("x", "if", "<Plug>(coc-funcobj-i)", getCodeActionOpts())
    -- keyset("o", "if", "<Plug>(coc-funcobj-i)", getCodeActionOpts())
    -- keyset("x", "af", "<Plug>(coc-funcobj-a)", getCodeActionOpts())
    -- keyset("o", "af", "<Plug>(coc-funcobj-a)", getCodeActionOpts())
    -- keyset("x", "ic", "<Plug>(coc-classobj-i)", getCodeActionOpts())
    -- keyset("o", "ic", "<Plug>(coc-classobj-i)", getCodeActionOpts())
    -- keyset("x", "ac", "<Plug>(coc-classobj-a)", getCodeActionOpts())
    -- keyset("o", "ac", "<Plug>(coc-classobj-a)", getCodeActionOpts())

    -- Remap <C-f> and <C-b> to scroll float windows/popups
    ---@diagnostic disable-next-line: redefined-local
    -- local opts = { silent = true, nowait = true, expr = true }
    -- keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
    -- keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
    -- keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
    -- keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
    -- keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
    -- keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

    -- Use CTRL-S for selections ranges
    -- Requires 'textDocument/selectionRange' support of language server
    -- keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
    -- keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

    -- Add `:Format` command to format current buffer
    vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

    -- " Add `:Fold` command to fold current buffer
    vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

    -- Add `:OR` command for organize imports of the current buffer
    vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

    -- Add (Neo)Vim's native statusline support
    -- NOTE: Please see `:h coc-status` for integrations with external plugins that
    -- provide custom statusline: lightline.vim, vim-airline
    vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

    -- extract status diagnostic
    vim.cmd([[
      function! StatusDiagnostic() abort
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info) | return '' | endif
        let msgs = []
        if get(info, 'error', 0)
          call add(msgs, 'E' . info['error'])
        endif
        if get(info, 'warning', 0)
          call add(msgs, 'W' . info['warning'])
        endif
        return join(msgs, ' ')
      endfunction
    ]])

    -- automatically refresh the statusline
    vim.cmd('autocmd User CocStatusChange,CocDiagnosticChange lua require("lualine").refresh()')
  end,
  keys = {
    -- GoTo code navigation
    {
      my_keys.lsp.goToDefinition.shortcut,
      "<Plug>(coc-definition)",
      mode = my_keys.lsp.goToDefinition.mode,
      silent = true,
      desc = my_keys.lsp.goToDefinition.desc,
    },
    {
      my_keys.lsp.goToTypeDefinition.shortcut,
      "<Plug>(coc-type-definition)",
      mode = my_keys.lsp.goToTypeDefinition.mode,
      silent = true,
      desc = my_keys.lsp.goToTypeDefinition.desc,
    },
    {
      my_keys.lsp.goToImplementation.shortcut,
      "<Plug>(coc-implementation)",
      mode = my_keys.lsp.goToImplementation.mode,
      silent = true,
      desc = my_keys.lsp.goToImplementation.desc,
    },
    {
      my_keys.lsp.goToReferences.shortcut,
      "<Plug>(coc-references)",
      mode = my_keys.lsp.goToReferences.mode,
      silent = true,
      desc = my_keys.lsp.goToReferences.desc,
    },

    -- Symbols
    {
      my_keys.lsp.outlineSymbols.shortcut,
      ":<C-u>CocList outline<cr>",
      desc = my_keys.lsp.outlineSymbols.desc,
      silent = true,
      nowait = true,
    },
    {
      my_keys.lsp.renameSymbol.shortcut,
      "<Plug>(coc-rename)",
      mode = my_keys.lsp.renameSymbol.mode,
      silent = true,
      desc = my_keys.lsp.renameSymbol.desc,
    },

    -- Remap keys for apply source code actions for current file.
    {
      my_keys.lsp.sourceAction.shortcut,
      "<Plug>(coc-codeaction-source)",
      mode = my_keys.lsp.sourceAction.mode,
      desc = my_keys.lsp.sourceAction.desc,
      silent = true,
      nowait = true,
    },
    {
      my_keys.lsp.renameFile.shortcut,
      "<Cmd>CocCommand workspace.renameCurrentFile<CR>",
      silent = true,
      desc = my_keys.lsp.renameFile.desc,
    },

    -- Code actions (keymaps order is important! last wins)
    -- Apply codeAction to the selected region
    -- Example: `<leader>aap` for current paragraph
    {
      my_keys.lsp.codeAction.shortcut,
      "<Plug>(coc-codeaction-selected)",
      mode = my_keys.lsp.codeAction.mode,
      desc = my_keys.lsp.codeAction.desc,
      silent = true,
      nowait = true,
    },
    -- Remap keys for apply code actions at the cursor position.
    {
      my_keys.lsp.codeAction.shortcut,
      "<Plug>(coc-codeaction-cursor)",
      desc = my_keys.lsp.codeAction.desc,
      silent = true,
      nowait = true,
    },

    -- Formatting selected code
    {
      my_keys.lsp.format.shortcut,
      -- "<Plug>(coc-format-selected)",
      "<Cmd>CocCommand prettier.formatFile<CR>",
      desc = my_keys.lsp.format.desc,
      mode = my_keys.lsp.format.mode,
      silent = true,
    },

    -- Hover help
    {
      my_keys.lsp.hoverInfo.shortcut,
      function()
        -- Use K to show documentation in preview window
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval("coc#rpc#ready()") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end,
      mode = my_keys.lsp.hoverInfo.mode,
      silent = true,
    },

    -- Diagnostics
    -- Use `[g` and `]g` to navigate diagnostics
    -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    {
      my_keys.lsp.diagList.shortcut,
      ":<C-u>CocList diagnostics<cr>",
      desc = my_keys.lsp.diagList.desc,
      silent = true,
      nowait = true,
      remap = true
    },
    {
      "[g",
      "<Plug>(coc-diagnostic-prev)",
      silent = true,
    },
    {
      "]g",
      "<Plug>(coc-diagnostic-next)",
      silent = true,
    },

    -- Completion
    -- NOTE: There's always a completion item selected by default, you may want to enable
    -- no select by setting `"suggest.noselect": true` in your configuration file
    {
      my_keys.completion.next.shortcut,
      'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
      silent = true,
      noremap = true,
      expr = true,
      replace_keycodes = false,
    },
    {
      my_keys.completion.prev.shortcut,
      [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
      silent = true,
      noremap = true,
      expr = true,
      replace_keycodes = false,
    },
    {
      my_keys.completion.accept.shortcut,
      [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
      silent = true,
      noremap = true,
      expr = true,
      replace_keycodes = false,
    },
    {
      my_keys.completion.show.shortcut,
      "coc#refresh()",
      silent = true,
      noremap = true,
      expr = true,
      replace_keycodes = false,
    },

    -- Restart CoC
    {
      my_keys.lsp.restart.shortcut,
      ":<C-u>CocRestart<cr>",
      desc = my_keys.lsp.restart.desc,
      silent = true,
      nowait = true,
    },

    -- CoC-specific commands
    {
      "<space>ce",
      ":<C-u>CocList extensions<cr>",
      desc = "CoC extensions",
      silent = true,
      nowait = true,
    },
    {
      "<space>cc",
      ":<C-u>CocList commands<cr>",
      desc = "CoC commands",
      silent = true,
      nowait = true,
    },
  },
})

table.insert(M, {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "neoclide/coc.nvim"
  },
  opts = function(_, opts)
    opts.sections.lualine_z = { "g:coc_status" }
  end
})

-- vim.print(M)

return M
