-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local os = require("os")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Save last nvim server id when nvim loses focus (FocusLost)
autocmd("FocusLost", {
  group = augroup("focus_lost", {}),
  pattern = "*",
  callback = function()
    local servername = vim.v.servername
    -- TODO: use OS-agnostic temp dir path
    vim.fn.writefile({ servername }, "/tmp/nvim-focuslost")
  end,
})
