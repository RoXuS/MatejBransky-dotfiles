-- How to write custom picker: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md

local Helpers = require("utils.helpers")

-- main module which is used to create a new picker
local pickers = require("telescope.pickers")
-- provides interfaces to fill the picker with items
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
-- holds the user's configuration (table)
local conf = require("telescope.config").values
-- holds all actions that can be mapped by a user
local actions = require("telescope.actions")
-- gives us a few utility functions we can use to get the current picker, current selection or current line
local action_state = require("telescope.actions.state")

---@alias ListItem { label: string, hex: string }
---@alias Entry { display: string, ordinal: string, index: string, value: ListItem }

local picker = function(opts)
  opts = opts or {}

  local picker = pickers.new(opts, {
    -- picker label
    prompt_title = "colors",

    -- fill the picker with items
    finder = finders.new_table({
      ---@type ListItem[]
      results = {
        { label = "red", hex = "#ff0000" },
        { label = "green", hex = "#00ff00" },
        { label = "blue", hex = "#0000ff" },
      },
      ---@param entry ListItem
      ---@return Entry
      entry_maker = function(entry)
        return {
          value = entry,
          -- string or a function(tbl)
          display = entry.label,
          -- used for sorting
          ordinal = entry.hex,
          -- set the absolute path of the file to make sure it's always found
          -- path = nil
          -- specify a line number in the file (e.g. in the grep picker)
          -- lnum = nil
        }
      end,
    }),

    -- sorting strategy
    sorter = conf.generic_sorter(opts),

    -- replaces default actions
    ---@param prompt_bufnr number buffer number of the prompt buffer
    ---@param map function maps actions or functions to arbitrary key sequences
    ---@return boolean
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        ---@type Entry
        local selection = action_state.get_selected_entry()

        -- print(Helpers.table_to_string(selection))
        Helpers.debug(selection)

        vim.api.nvim_put({ selection.value.hex }, "", false, true)
      end)
      -- The "false" value means that only the actions defined in the function should be attached
      return true
    end,
  })

  -- start the picker
  picker:find()
end

-- open telescope with the picker
picker(require("telescope.themes").get_dropdown({}))
