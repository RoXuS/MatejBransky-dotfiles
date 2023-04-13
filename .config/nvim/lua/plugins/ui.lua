return {
  -- use buffers  instead of tabs
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- path_display = { truncate = 3 }
        path_display = function(opts, path)
          local tail = require("telescope.utils").path_tail(path)
          return string.format("%s -- %s", tail, path)
        end,
        mappings = {
          n = {
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          i = {
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
        preview = {
          hide_on_startup = true, -- hide previewer when picker starts
        },
      },
    },
  },
}
