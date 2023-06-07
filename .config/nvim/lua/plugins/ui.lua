local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        ---@diagnostic disable-next-line: missing-parameter
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

return {
  -- finally working theme switcher
  {
    "cormacrelf/dark-notify",
    init = function()
      require("dark_notify").run()
    end,
  },
  {
    "navarasu/onedark.nvim",
    opts = function(_, opts)
      opts.highlights = {
        -- I like VS Code colors for git symbols
        ["NeoTreeGitUntracked"] = { fg = "$green", fmt = "none" },
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  -- allow the normal mode in floating windows
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        insert_only = false,
      },
    },
  },
  -- describe my keybindings
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").register({
        ["<leader>d"] = {
          name = "delete to black hole",
        },
        ["<leader>k"] = "Show diag. in a floating window.",
      })
    end,
  },
  -- the real Vim 🥷 doesn't use tabs!
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    -- Master the navigation between main files
    -- https://youtu.be/Qnos8aApa9g
    --
    -- I forked it because of the important PR which fixes removing the file
    -- https://github.com/MatejBransky/harpoon/pull/1
    "MatejBransky/harpoon",
    init = function()
      local whichKey = require("which-key")
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>m", mark.toggle_file)

      whichKey.register({
        ["<leader>m"] = "Toggle harpoon mark",
      })

      vim.keymap.set("n", "<M-h>", ui.toggle_quick_menu)

      vim.keymap.set("n", "<M-q>", function()
        ui.nav_file(1)
      end)
      vim.keymap.set("n", "<M-w>", function()
        ui.nav_file(2)
      end)
      vim.keymap.set("n", "<M-e>", function()
        ui.nav_file(3)
      end)
      vim.keymap.set("n", "<M-r>", function()
        ui.nav_file(4)
      end)
      vim.keymap.set("n", "<M-t>", function()
        ui.nav_file(5)
      end)

      require("telescope").load_extension("harpoon")
    end,
    opts = {
      tabline = false,
      menu = {
        width = 100,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- I need the normal mode in editing popups
      use_popups_for_input = false, -- If false, inputs will use vim.ui.input() instead of custom floats.
      event_handlers = {
        -- allow quick navigation in the file explorer as in the file buffer
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.cmd([[
              setlocal relativenumber
            ]])
          end,
        },
      },
      default_component_configs = {
        name = {
          -- I like to keep git status visualized just by letter-symbols
          use_git_status_colors = false,
        },
        git_status = {
          -- I like VS Code-like symbols with simple letters
          symbols = {
            renamed = "R",
            untracked = "U",
            modified = "M",
            deleted = "D",
            conflict = "C",
          },
        },
      },
      window = {
        mappings = {
          -- remove unused mapping so I can use "tf" and "tg" mappings
          ["t"] = false,
          -- emulate Atom's tree-view component (https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163)
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163#discussioncomment-4747082
          ["h"] = function(state)
            local node = state.tree:get_node()
            if (node.type == "directory" or node:has_children()) and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          ["l"] = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node:has_children() then
              if not node:is_expanded() then
                state.commands.toggle_node(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          end,
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        -- change the filter into a full path search with space as an implicit `".*"`,
        -- so `fi init` will match: `./sources/filesystem/init.lua`
        find_by_full_path_words = true,
        window = {
          mappings = {
            -- Find/grep for a file under the current node using Telescope and select it.
            -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
            ["tf"] = "telescope_find",
            ["tg"] = "telescope_grep",
          },
        },
        commands = {
          telescope_find = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require("telescope.builtin").find_files(getTelescopeOpts(state, path))
          end,
          telescope_grep = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
          end,
        },
        components = {
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-index
          harpoon_index = function(config, node)
            local Marked = require("harpoon.mark")
            local path = node:get_id()
            local succuss, index = pcall(Marked.get_index_of, path)
            if succuss and index and index > 0 then
              return {
                text = string.format(" → %d", index), -- <-- Add your favorite harpoon like arrow here
                highlight = config.highlight or "NeoTreeDirectoryIcon",
              }
            else
              return {}
            end
          end,
        },
        renderers = {
          file = {
            { "icon" },
            { "name", use_git_status_colors = true },
            { "harpoon_index" }, --> This is what actually adds the component in where you want it
            { "diagnostics" },
            { "git_status", highlight = "NeoTreeDimText" },
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
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
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          i = {
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
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
  -- symbols outline
  {
    "simrat39/symbols-outline.nvim",
    opts = {
      show_relative_numbers = true,
    },
  },
}
