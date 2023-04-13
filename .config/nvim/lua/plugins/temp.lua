-- https://github.com/LazyVim/LazyVim/issues/524
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ignore_install = { "help" }
  end,
}
