local my_keys = require("my_keys")

return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set(my_keys.references.copyFilepath.mode, my_keys.references.copyFilepath.shortcut, function()
        local git_root = vim.fn.FugitiveWorkTree()
        local relative_path = vim.fn.expand("%:.")

        if git_root ~= "" then
          local abs_path = vim.fn.expand("%:p")
          relative_path = require("plenary.path"):new(abs_path):make_relative(git_root)
        end

        vim.fn.setreg("*", relative_path)
      end, { desc = my_keys.references.copyFilepath.desc, silent = true })

      vim.keymap.set(
        my_keys.references.openInBrowser.mode,
        my_keys.references.openInBrowser.shortcut,
        "<Cmd>GBrowse<CR>",
        { desc = my_keys.references.openInBrowser.desc }
      )

      vim.keymap.set(
        my_keys.references.copyFileLink.mode,
        my_keys.references.copyFileLink.shortcut,
        "<Cmd>GBrowse!<CR>",
        { desc = my_keys.references.copyFileLink.desc }
      )

      vim.keymap.set(
        my_keys.references.copyLineLink.mode,
        my_keys.references.copyLineLink.shortcut,
        ":.GBrowse!<CR>",
        { desc = my_keys.references.copyLineLink.desc, silent = true }
      )
    end,
  },
  -- supports Gitlab connection
  {
    "shumphrey/fugitive-gitlab.vim",
    config = function()
      vim.g.fugitive_gitlab_domains = {
        "https://gitlab.ataccama.dev",
      }
      vim.g.gitlab_api_keys = {
        ["https://gitlab.ataccama.dev"] = vim.env.GITLAB_ACCESS_TOKEN,
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { my_keys.git.branchHistory.shortcut, ":DiffviewFileHistory<CR>", desc = my_keys.git.branchHistory.desc },
      { my_keys.git.fileHistory.shortcut, ":DiffviewFileHistory %<CR>", desc = my_keys.git.fileHistory.desc },
      { my_keys.git.closeHistory.shortcut, ":tabclose<CR>", desc = my_keys.git.closeHistory.desc },
      { "<leader>gu", ":DiffviewOpen --imply-local<CR>", desc = "Uncommited changes" },
      { "<leader>gr", ":DiffviewOpen origin/", desc = "Review PR" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gl",
        function()
          require("gitsigns.actions").toggle_current_line_blame()
        end,
        desc = "Toggle current line blame",
      },
    },
  },
}
