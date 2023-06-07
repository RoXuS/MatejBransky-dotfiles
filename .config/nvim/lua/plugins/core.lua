return {
  {
    "tpope/vim-fugitive",
  },
  {
    "sindrets/diffview.nvim",
    init = function()
      require("which-key").register({
        ["<leader>gD"] = "File history",
        ["<leader>gd"] = "Current file history",
        ["<leader>gq"] = "Quit diffview",
      })
    end,
    keys = {
      { "<leader>gD", ":DiffviewFileHistory<CR>" },
      { "<leader>gd", ":DiffviewFileHistory %<CR>" },
      { "<leader>gq", ":tabclose<CR>" },
    },
  },
}
