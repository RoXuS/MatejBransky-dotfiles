local renderer = require("neo-tree.ui.renderer")
local my_keys = require("my_keys")

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
    init = function()
      -- avoid netrw flickering (https://github.com/LazyVim/LazyVim/discussions/2366)
      vim.api.nvim_create_autocmd("BufEnter", {
        -- make a group to be able to delete it later
        group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
        callback = function()
          local f = vim.fn.expand("%:p")
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd("Neotree current dir=" .. f)
            -- neo-tree is loaded now, delete the init autocmd
            vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
          end
        end,
      })
      -- keymaps
    end,
    opts = {
      filesystem = {
        -- nvim <DIR> shows neo-tree in the position = "current" (netrw style)
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        -- change the filter into a full path search with space as an implicit `".*"`,
        -- so `fi init` will match: `./sources/filesystem/init.lua`
        find_by_full_path_words = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        window = {
          mappings = {
            ["z"] = "none",
            -- Find/grep for a file under the current node using Telescope and select it.
            -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
            [my_keys.explorer.findInSelected.shortcut] = "telescope_find",
            [my_keys.explorer.grepInSelected.shortcut] = "telescope_grep",
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
            local success, index = pcall(Marked.get_index_of, path)
            if success and index and index > 0 then
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

          [my_keys.explorer.close.shortcut] = "close_window",
          [my_keys.explorer.prevSibling.shortcut] = { prevSibling, desc = my_keys.explorer.prevSibling.desc },
          [my_keys.explorer.nextSibling.shortcut] = { nextSibling, desc = my_keys.explorer.nextSibling.desc },
          [my_keys.explorer.split.shortcut] = "split_with_window_picker",
          [my_keys.explorer.vsplit.shortcut] = "vsplit_with_window_picker",
          [my_keys.harpoon.mark.shortcut] = {
            function(state)
              local node = state.tree:get_node()
              if node.type ~= "directory" then
                require("harpoon.mark").toggle_file(node.id)
                require("neo-tree.sources.manager").refresh("filesystem")
              end
            end,
            desc = my_keys.harpoon.mark.desc,
          },
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
    },
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
        my_keys.explorer.floatingExplorer.shortcut,
        function()
          require("neo-tree.command").execute({
            position = "float",
            -- dir = require("lazyvim.util").root(),
            reveal = true,
            reveal_force_cwd = true,
          })
        end,
        desc = my_keys.explorer.floatingExplorer.desc,
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
        my_keys.explorer.showSidebarExplorer.shortcut,
        function()
          require("neo-tree.command").execute({
            action = "focus",
            position = "left",
          })
        end,
        desc = my_keys.explorer.showSidebarExplorer.desc,
      },
      {
        my_keys.explorer.hideSidebarExplorer.shortcut,
        function()
          require("neo-tree.command").execute({
            action = "close",
          })
        end,
        desc = my_keys.explorer.hideSidebarExplorer.desc,
      },
    },
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

  -- connect operations to LSP
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
