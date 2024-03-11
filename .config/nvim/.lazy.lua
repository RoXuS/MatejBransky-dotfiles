local Util = require("lazyvim.util")

vim.keymap.set("n", "<leader>a", function()
  Util.terminal({ "ldf" }, { esc_esc = false, ctrl_hjkl = false })
end, { desc = "Lazygit (dotfiles)" })

return {}
