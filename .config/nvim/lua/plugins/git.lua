local myKeys = require("myKeys")

return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set(
        myKeys.git.copyFilepath.mode,
        myKeys.git.copyFilepath.shortcut,
        "y<C-g>",
        { desc = "Copy file path" }
      )

      vim.keymap.set(
        myKeys.git.openInBrowser.mode,
        myKeys.git.openInBrowser.shortcut,
        "<Cmd>GBrowse<CR>",
        { desc = myKeys.git.openInBrowser.desc }
      )

      vim.keymap.set(
        myKeys.git.copyFileLink.mode,
        myKeys.git.copyFileLink.shortcut,
        "<Cmd>GBrowse!<CR>",
        { desc = myKeys.git.copyFileLink.desc }
      )

      vim.keymap.set(
        myKeys.git.copyLineLink.mode,
        myKeys.git.copyLineLink.shortcut,
        ":.GBrowse!<CR>",
        { desc = myKeys.git.copyLineLink.desc, silent = true }
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
      { myKeys.git.branchHistory.shortcut, ":DiffviewFileHistory<CR>", desc = myKeys.git.branchHistory.desc },
      { myKeys.git.fileHistory.shortcut, ":DiffviewFileHistory %<CR>", desc = myKeys.git.fileHistory.desc },
      { myKeys.git.closeHistory.shortcut, ":tabclose<CR>", desc = myKeys.git.closeHistory.desc },
    },
  },
}
