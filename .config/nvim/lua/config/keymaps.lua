-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local which_key = require("which-key")
local my_keys = require("my_keys")

vim.keymap.set("i", "=", "=<c-g>u")
vim.keymap.set("i", ":", ":<c-g>u")

vim.keymap.set(
  my_keys.misc.deleteBlackHole.mode,
  my_keys.misc.deleteBlackHole.shortcut,
  [["_d]],
  { desc = my_keys.misc.deleteBlackHole.desc }
)

vim.keymap.set(
  my_keys.references.openInFinder.mode,
  my_keys.references.openInFinder.shortcut,
  ":!open %:h<CR>",
  { desc = my_keys.references.openInFinder.desc }
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

-- keep cursor in the center while "scrolling"
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "H", "<Nop>", { remap = false })
vim.keymap.set("n", "L", "<Nop>", { remap = false })
vim.keymap.set("n", "J", "5j", { desc = "big move down" })
vim.keymap.set("n", "K", "5k", { desc = "big move up", remap = false })

-- ...this constantly irritating mistake of inadvertently executing the macro recording... :angry:
vim.keymap.set("n", "<leader>m", "q", { desc = "Start macro recording", remap = false })
vim.keymap.set("n", "q", "<Nop>", { remap = false })

which_key.add({
  { "<leader>d", desc = "diffWin" },
})
vim.keymap.set(
  my_keys.misc.diffWin.mode,
  my_keys.misc.diffWin.shortcut,
  "<Cmd>windo diffthis<CR>",
  { desc = my_keys.misc.diffWin.desc }
)
vim.keymap.set(
  my_keys.misc.diffWinQuit.mode,
  my_keys.misc.diffWinQuit.shortcut,
  "<Cmd>diffoff!<CR>",
  { desc = my_keys.misc.diffWinQuit.desc }
)
