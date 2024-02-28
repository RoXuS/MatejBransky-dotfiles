-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local my_keys = require("my_keys")

vim.keymap.set(
  my_keys.misc.deleteBlackHole.mode,
  my_keys.misc.deleteBlackHole.shortcut,
  [["_d]],
  { desc = my_keys.misc.deleteBlackHole.desc }
)

vim.keymap.set(
  my_keys.misc.openFolderInFinder.mode,
  my_keys.misc.openFolderInFinder.shortcut,
  ":!open %:h<CR>",
  { desc = my_keys.misc.openFolderInFinder.desc }
)

-- search for visually selected text
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
local searchSelected = [[y/\V\c<C-r>=escape(@", '')<CR><CR>]]

vim.keymap.set(
  my_keys.searchReplace.replaceWord.mode,
  my_keys.searchReplace.replaceWord.shortcut,
  "viw" .. searchSelected .. "``cgn",
  { desc = my_keys.searchReplace.replaceWord.desc }
)

vim.keymap.set(
  my_keys.searchReplace.replaceSelected.mode,
  my_keys.searchReplace.replaceSelected.shortcut,
  searchSelected .. "``cgn",
  { desc = my_keys.searchReplace.replaceSelected.desc }
)
vim.keymap.set(
  my_keys.searchReplace.searchInSelected.mode,
  my_keys.searchReplace.searchInSelected.shortcut,
  "<esc>/\\%V",
  { desc = my_keys.searchReplace.searchInSelected.desc }
)

vim.keymap.set(
  my_keys.searchReplace.substiteSubstring.mode,
  my_keys.searchReplace.substiteSubstring.shortcut,
  [[:s/\%V]],
  { desc = my_keys.searchReplace.substiteSubstring.desc }
)
