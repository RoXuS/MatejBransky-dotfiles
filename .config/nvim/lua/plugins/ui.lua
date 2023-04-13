return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    -- opts = {
    --   options = {
    --     show_buffer_close_icons = false,
    --   },
    -- },
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   dependencies = "romgrk/barbar.nvim",
  -- },
  {
    "romgrk/barbar.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    init = function()
      vim.g.barbar_auto_setup = true
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- closable = false,
      -- animation = true,
      -- insert_at_start = true,
      auto_hide = true,
      -- fix icon of pinned tabs
      icon_pinned = "車",

      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        -- NvimTree = true,
        -- Or, specify the text used for the offset:
        -- undotree = { text = "undotree" },
        -- Or, specify the event which the sidebar executes when leaving:
        ["neo-tree"] = { event = "BufWipeout" },
        -- Or, specify both
        -- Outline = { event = "BufWinLeave", text = "symbols-outline" },
      },
    },
    version = "^1.0.0", -- optional: only update when a new 1.x version is released}
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
