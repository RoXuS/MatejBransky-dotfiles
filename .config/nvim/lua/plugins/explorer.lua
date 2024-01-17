local renderer = require("neo-tree.ui.renderer")
local myKeys = require("myKeys")

local indexOf = function(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

local getSiblings = function(state, node)
  local parent = state.tree:get_node(node:get_parent_id())
  local siblings = parent:get_child_ids()
  return siblings
end

local nextSibling = function(state)
  local node = state.tree:get_node()
  local siblings = getSiblings(state, node)
  if not node.is_last_child then
    local currentIndex = indexOf(siblings, node.id)
    local nextIndex = siblings[currentIndex + 1]
    renderer.focus_node(state, nextIndex)
  end
end

local prevSibling = function(state)
  local node = state.tree:get_node()
  local siblings = getSiblings(state, node)
  local currentIndex = indexOf(siblings, node.id)
  if currentIndex > 1 then
    local nextIndex = siblings[currentIndex - 1]
    renderer.focus_node(state, nextIndex)
  end
end

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
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "-",
        function()
          require("neo-tree.command").execute({
            position = "current",
            reveal = true,
            reveal_force_cwd = true,
          })
        end,
      },
      -- Floating file explorer
      {
        myKeys.explorer.floatingExplorer.shortcut,
        function()
          require("neo-tree.command").execute({
            position = "float",
            -- dir = require("lazyvim.util").root(),
            reveal = true,
            reveal_force_cwd = true,
          })
        end,
        desc = myKeys.explorer.floatingExplorer.desc,
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ position = "float", dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({
            position = "left",
            -- dir = require("lazyvim.util").root(),
            reveal = true,
            -- reveal_force_cwd = true,
          })
        end,
        desc = "Explorer in the sidebar",
      },
      {
        myKeys.explorer.showSidebarExplorer.shortcut,
        function()
          require("neo-tree.command").execute({
            action = "focus",
            position = "left",
          })
        end,
        desc = myKeys.explorer.showSidebarExplorer.desc,
      },
      {
        myKeys.explorer.hideSidebarExplorer.shortcut,
        function()
          require("neo-tree.command").execute({
            action = "close",
          })
        end,
        desc = myKeys.explorer.hideSidebarExplorer.desc,
      },
    },
    -- init = function()
    --   if vim.fn.argc(-1) == 1 then
    --     local stat = vim.loop.fs_stat(vim.fn.argv(0))
    --     if stat and stat.type == "directory" then
    --       require("neo-tree").setup({
    --         window = {
    --           position = "current",
    --         },
    --       })
    --     end
    --   end
    -- end,
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
          -- remove unused mapping
          ["s"] = false,
          ["S"] = false,
          ["t"] = false,

          [myKeys.explorer.close.shortcut] = "close_window",
          [myKeys.explorer.prevSibling.shortcut] = { prevSibling, desc = myKeys.explorer.prevSibling.desc },
          [myKeys.explorer.nextSibling.shortcut] = { nextSibling, desc = myKeys.explorer.nextSibling.desc },
          [myKeys.explorer.split.shortcut] = "split_with_window_picker",
          [myKeys.explorer.vsplit.shortcut] = "vsplit_with_window_picker",
          -- emulate Atom's tree-view component (https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163)
          -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163#discussioncomment-4747082
          ["h"] = {
            function(state)
              local node = state.tree:get_node()
              if (node.type == "directory" or node:has_children()) and node:is_expanded() then
                state.commands.toggle_node(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
              end
            end,
            desc = "go up",
          },
          ["l"] = {
            function(state)
              local node = state.tree:get_node()
              if node.type == "directory" or node:has_children() then
                if not node:is_expanded() then
                  state.commands.toggle_node(state)
                else
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              end
            end,
            desc = "go down",
          },
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        -- change the filter into a full path search with space as an implicit `".*"`,
        -- so `fi init` will match: `./sources/filesystem/init.lua`
        find_by_full_path_words = true,
        follow_current_file = {
          enabled = false,
          leave_dirs_open = true,
        },
        window = {
          mappings = {
            -- Find/grep for a file under the current node using Telescope and select it.
            -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
            [myKeys.explorer.findInSelected.shortcut] = "telescope_find",
            [myKeys.explorer.grepInSelected.shortcut] = "telescope_grep",
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

  -- Support prompts the user to pick a window for opening the file
  {
    "s1n7ax/nvim-window-picker",
  },

  -- allow the normal mode in floating windows
  -- so I can use vim motions
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        insert_only = false,
      },
    },
  },
}
