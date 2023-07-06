-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local whichKey = require("which-key")

-- search for visually selected text
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
local searchSelected = [[y/\V<C-r>=escape(@", '')<CR><CR>]]

-- Show diag. in floating window
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float)
-- delete to blackhole register
vim.keymap.set("n", "<leader>d", '"_d')
-- replace a word under the cursor
vim.keymap.set("n", "<leader>r", "viw" .. searchSelected .. "``cgn")

-- document added keymappings in normal mode
whichKey.register({
  ["<leader>d"] = {
    name = "delete to blackhole register",
  },
  ["<leader>k"] = "Show diag. in a floating window.",
  ["<leader>r"] = "Replace a word under the cursor",
}, {
  mode = "n",
})

-- replace a selection and keep the original value in the register
vim.keymap.set("x", "<leader>p", [["_dP]])
-- change a selection (repeatable action)
vim.keymap.set("v", "<leader>rr", searchSelected .. "``cgn")
-- delete to blackhole register
vim.keymap.set("v", "<leader>d", '"_d')
-- search within visual selection
vim.keymap.set("v", "<leader>/", "<esc>/\\%V")

-- substitution in visual selection
vim.keymap.set("x", "<leader>rv", [[:s/\%V]])

-- document added keymappings in visual/select mode
whichKey.register({
  ["<leader>/"] = "Search within the selection",
  ["<leader>r"] = {
    name = "replace",
    v = "Substite in the visual selection",
    r = "Change the selection (repeatable action for other occurences)",
  },
  ["<leader>p"] = "Replace the selected",
  ["<leader>d"] = "Delete to blackhole register",
}, {
  mode = "v",
})
