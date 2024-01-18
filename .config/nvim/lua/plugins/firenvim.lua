if vim.g.started_by_firenvim ~= true then
  return {}
end

-- local enabled = {
--   "firenvim",
--   "flit.nvim",
--   "lazy.nvim",
--   "leap.nvim",
--   "mini.ai",
--   "mini.comment",
--   "mini.pairs",
--   "mini.surround",
--   "nvim-treesitter",
--   "nvim-treesitter-textobjects",
--   "nvim-ts-context-commentstring",
--   "vim-repeat",
--   "LazyVim",
-- }

local disabled = {
  "noice.nvim",
  "telescope.nvim",
}

local Config = require("lazy.core.config")
-- Config.options.checker.enabled = false
-- Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return (not vim.tbl_contains(disabled, plugin.name)) or plugin.embeddable
end

-- Add some firenvim specific keymaps
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "LazyVimKeymaps",
--   callback = function()
--     vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
--   end,
-- })

return {
  -- embed neovim in a browser (Chrome, Firefox)
  -- https://github.com/glacambre/firenvim
  {
    "glacambre/firenvim",

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    opts = function()
      vim.g.firenvim_config = {
        -- globalSettings = { alt = "all" },
        localSettings = {
          [".*"] = {
            -- cmdline = "neovim",
            -- content = "text",
            -- priority = 0,
            -- selector = "textarea",
            takeover = "never",
          },
        },
      }
    end,
  },
}
