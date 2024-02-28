local my_keys = require("my_keys")

return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set(
        my_keys.git.copyFilepath.mode,
        my_keys.git.copyFilepath.shortcut,
        ":<C-U>call setreg(v:register, fugitive#Object(@%))<CR>",
        { desc = "Copy file path", silent = true }
      )

      vim.keymap.set(
        my_keys.git.openInBrowser.mode,
        my_keys.git.openInBrowser.shortcut,
        "<Cmd>GBrowse<CR>",
        { desc = my_keys.git.openInBrowser.desc }
      )

      vim.keymap.set(
        my_keys.git.copyFileLink.mode,
        my_keys.git.copyFileLink.shortcut,
        "<Cmd>GBrowse!<CR>",
        { desc = my_keys.git.copyFileLink.desc }
      )

      vim.keymap.set(
        my_keys.git.copyLineLink.mode,
        my_keys.git.copyLineLink.shortcut,
        ":.GBrowse!<CR>",
        { desc = my_keys.git.copyLineLink.desc, silent = true }
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
    },
  },
}
