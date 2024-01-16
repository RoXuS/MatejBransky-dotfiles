-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.conceallevel = 0 -- Show markup characters
vim.opt.showtabline = 0 -- Hide tabline

--
-- Show custom indicator in the tab title
--
vim.opt.title = true

local cwd = vim.loop.cwd()

if cwd or cwd ~= "" then
  local rootFolder = cwd:match("[^/]*$")
  local gitFolder = cwd .. "/.git"
  local ok = vim.loop.fs_stat(gitFolder)

  if ok then
    -- Neovim instance is in the git repository
    vim.opt.titlestring = rootFolder .. " ●"
  else
    -- Neovim instance is somewhere else
    vim.opt.titlestring = rootFolder .. " ■"
  end
end
