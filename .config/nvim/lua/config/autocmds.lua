-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  callback = function(tbl)
    local set_offset = require("bufferline.api").set_offset

    local bufwinid
    local last_width
    local autocmd = vim.api.nvim_create_autocmd("WinScrolled", {
      callback = function()
        bufwinid = bufwinid or vim.fn.bufwinid(tbl.buf)
        local width = vim.api.nvim_win_get_width(bufwinid) + 1

        if last_width ~= width then
          set_offset(width, "FileTree")
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufWipeout", {
      buffer = tbl.buf,
      callback = function()
        vim.api.nvim_del_autocmd(autocmd)
        set_offset(0)
      end,
      once = true,
    })
  end,
  pattern = "neo-tree", -- or any other filetree's `ft`
})
