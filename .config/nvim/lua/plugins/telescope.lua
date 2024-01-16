local myKeys = require("myKeys")

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        myKeys.telescope.findHiddenIncluded.shortcut,
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
            find_command = { "rg", "--files", "-g", "!{.git,node_modules,.gradle,tmp,dist,test-results}" },
          })
        end,
        desc = myKeys.telescope.findHiddenIncluded.desc,
      },
      {
        myKeys.telescope.showQuickfixLists.shortcut,
        function()
          require("telescope.builtin").quickfixhistory()
        end,
        desc = myKeys.telescope.showQuickfixLists.desc,
      },
    },
    opts = {
      defaults = {
        -- show me the filename first
        path_display = function(_, rawPath)
          local utils = require("telescope.utils")
          local tail = utils.path_tail(rawPath)
          local path = utils.transform_path({
            path_display = {
              absolute = 0,
            },
          }, rawPath)
          return string.format("%s -- %s", tail, path)
        end,

        mappings = {
          n = {
            [myKeys.telescope.togglePreview.shortcut] = require("telescope.actions.layout").toggle_preview,
          },
          i = {
            [myKeys.telescope.togglePreview.shortcut] = require("telescope.actions.layout").toggle_preview,
          },
        },

        layout_strategy = "vertical",
      },
      pickers = {
        -- Sorts all buffers after most recent used.
        -- Not just the current and last one.
        buffers = {
          sort_mru = true,
        },
        -- prioritize file paths in the result (=> disable inline preview)
        -- https://github.com/nvim-telescope/telescope.nvim/issues/2121
        lsp_references = {
          show_line = false,
        },
        lsp_definitions = {
          show_line = false,
        },
      },
    },
  },

  -- fuzzy finder prioritizing filenames and smartcase search
  {
    "natecraddock/telescope-zf-native.nvim",
    config = function()
      require("telescope").load_extension("zf-native")
    end,
  },
}
