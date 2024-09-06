local my_keys = require("my_keys")

--- Comparator function to prioritize required fields over optional fields.
-- This function compares two completion items, focusing on whether they are
-- "Field" kinds and whether they are required or optional. Required fields
-- are those without a trailing "?", while optional fields have a trailing "?".
-- Required fields are prioritized over optional ones. If the comparison is
-- inconclusive (both are required or both optional), it defers to the next comparator.
--
-- ```lua
-- compare_field_priority({
--   completion_item = { kind = CompletionItemKind.Field, label = 'foobar' }
-- }, {
--   completion_item = { kind = CompletionItemKind.Field, label = 'bongo?' }
-- }) == true
-- ```
--
---@param entry1 cmp.Entry The first completion entry to compare.
---@param entry2 cmp.Entry The second completion entry to compare.
---@return true|false|nil # `true` if entry1 should be prioritized over entry2, `false` if entry2 should be prioritized over entry1, or `nil` to defer to the next comparator.
local function compare_field_priority(entry1, entry2)
  local field_kind = vim.lsp.protocol.CompletionItemKind.Field

  -- Check if both entries are fields
  local are_both_fields = entry1.completion_item.kind == field_kind and entry2.completion_item.kind == field_kind
  if not are_both_fields then
    return nil -- Skip comparison if either entry is not a field
  end

  -- Determine if the fields are required (required fields do not have a trailing "?")
  local is_field_1_required = not entry1.completion_item.label:find("?$")
  local is_field_2_required = not entry2.completion_item.label:find("?$")

  -- Prioritize required fields over optional ones
  if is_field_1_required and not is_field_2_required then
    return true
  elseif not is_field_1_required and is_field_2_required then
    return false
  end

  -- If both fields are either required or both optional, defer to the next comparator
  return nil
end

return {
  -- Leave my Enter, Tab and arrow keys alone!
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.config.disable,
        ["<CR>"] = cmp.config.disable,
        [my_keys.completion.accept.shortcut] = cmp.mapping.confirm({ select = true }),
        ["<Up>"] = cmp.config.disable,
        ["<Down>"] = cmp.config.disable,
      }))
      opts.sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry)
            return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
          end,
        },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      })
      opts.sorting = {
        -- Taken from the official default config:
        -- https://github.com/hrsh7th/nvim-cmp/blob/ae644feb7b67bf1ce4260c231d1d4300b19c6f30/lua/cmp/config/default.lua#L67-L78
        comparators = {
          cmp.config.compare.offset, -- Compare by the offset (position) of the completion item in the text
          cmp.config.compare.exact, -- Prioritize exact matches over partial ones
          -- cmp.config.compare.scopes, -- This comparator is commented out in the official config
          cmp.config.compare.score, -- Score-based sorting (higher relevance gets prioritized)
          compare_field_priority,
          cmp.config.compare.recently_used, -- Prioritize items that were recently used
          cmp.config.compare.locality, -- Sort by locality (closer items in the current buffer get higher priority)
          cmp.config.compare.kind, -- Sort by kind (e.g., Fields, Functions, Variables)
          -- cmp.config.compare.sort_text,    -- This comparator is commented out in the official config
          cmp.config.compare.length, -- Prefer shorter completion items
          cmp.config.compare.order, -- Use predefined order as the last tiebreaker
        },
      }
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {
        {
          my_keys.snippet.jumpNext.shortcut,
          function()
            require("luasnip").jump(1)
          end,
          mode = my_keys.snippet.jumpNext.mode,
        },
        {
          my_keys.snippet.jumpPrev.shortcut,
          function()
            require("luasnip").jump(-1)
          end,
          mode = my_keys.snippet.jumpPrev.mode,
        },
      }
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        -- require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = "./lua/snippets" })
      end,
    },
  },

  -- Better snippet editor
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", -- optional
    keys = {
      {
        my_keys.snippet.add.shortcut,
        function()
          require("scissors").addNewSnippet()
        end,
        mode = my_keys.snippet.add.mode,
        desc = my_keys.snippet.add.desc,
      },
      {
        my_keys.snippet.edit.shortcut,
        function()
          require("scissors").editSnippet()
        end,
        desc = my_keys.snippet.edit.desc,
      },
    },
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/lua/snippets",
      jsonFormatter = "jq",
    },
  },
}
