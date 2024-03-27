-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.conceallevel = 0 -- Show markup characters
vim.opt.showtabline = 0 -- Hide tabline

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

-- **lazygit** now automatically uses the colors of your current colorscheme.
-- This is enabled by default. To disable, add the below to your `options.lua`
vim.g.lazygit_config = false
