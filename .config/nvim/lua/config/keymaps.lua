-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local whichKey = require("which-key")

-- search for visually selected text
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
local searchSelected = [[y/\V<C-r>=escape(@", '')<CR><CR>]]

-- Show diag. in floating window
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float)

-- document added keymappings in normal mode
whichKey.register({
  ["<leader>k"] = "Show diag. in a floating window.",
}, {
  mode = "n",
})

-- change a selection (repeatable action)
vim.keymap.set("v", "<leader>r", searchSelected .. "``cgn")
-- search within visual selection
vim.keymap.set("v", "<leader>/", "<esc>/\\%V")

-- substitute in visual selection
vim.keymap.set("x", "<leader>v", [[:s/\%V]])

-- document added keymappings in visual/select mode
whichKey.register({
  ["<leader>/"] = "Search within the selection",
  ["<leader>v"] = "Substite in the visual selection",
  ["<leader>r"] = "Change the selection (repeatable action for other occurences)",
}, {
  mode = "v",
})
