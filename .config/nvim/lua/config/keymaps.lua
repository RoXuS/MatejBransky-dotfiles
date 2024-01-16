-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local myKeys = require("myKeys")

vim.keymap.set(myKeys.motion.bigLeft.mode, myKeys.motion.bigLeft.shortcut, "6h")
vim.keymap.set(myKeys.motion.bigDown.mode, myKeys.motion.bigDown.shortcut, "6j")
vim.keymap.set(myKeys.motion.bigUp.mode, myKeys.motion.bigUp.shortcut, "6k")
vim.keymap.set(myKeys.motion.bigRight.mode, myKeys.motion.bigRight.shortcut, "6l")

vim.keymap.set(
  myKeys.misc.deleteBlackHole.mode,
  myKeys.misc.deleteBlackHole.shortcut,
  [["_d]],
  { desc = myKeys.misc.deleteBlackHole.desc }
)

vim.keymap.set(
  myKeys.misc.openFolderInFinder.mode,
  myKeys.misc.openFolderInFinder.shortcut,
  ":!open %:h<CR>",
  { desc = myKeys.misc.openFolderInFinder.desc }
)

-- search for visually selected text
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
local searchSelected = [[y/\V\c<C-r>=escape(@", '')<CR><CR>]]

vim.keymap.set(
  myKeys.searchReplace.replaceWord.mode,
  myKeys.searchReplace.replaceWord.shortcut,
  "viw" .. searchSelected .. "``cgn",
  { desc = myKeys.searchReplace.replaceWord.desc }
)

vim.keymap.set(
  myKeys.searchReplace.replaceSelected.mode,
  myKeys.searchReplace.replaceSelected.shortcut,
  searchSelected .. "``cgn",
  { desc = myKeys.searchReplace.replaceSelected.desc }
)
vim.keymap.set(
  myKeys.searchReplace.searchInSelected.mode,
  myKeys.searchReplace.searchInSelected.shortcut,
  "<esc>/\\%V",
  { desc = myKeys.searchReplace.searchInSelected.desc }
)

vim.keymap.set(
  myKeys.searchReplace.substiteSubstring.mode,
  myKeys.searchReplace.substiteSubstring.shortcut,
  [[:s/\%V]],
  { desc = myKeys.searchReplace.substiteSubstring.desc }
)
