local H = {}

-- Convert a lua table into a lua syntactically correct string
H.table_to_string = function(tbl)
  local result = "{"
  for k, v in pairs(tbl) do
    -- Check the key type (ignore any numerical keys - assume its an array)
    if type(k) == "string" then
      result = result .. '["' .. k .. '"]' .. "="
    end

    -- Check the value type
    if type(v) == "table" then
      result = result .. H.table_to_string(v)
    elseif type(v) == "boolean" then
      result = result .. tostring(v)
    else
      result = result .. '"' .. v .. '"'
    end
    result = result .. ","
  end
  -- Remove leading commas from the result
  if result ~= "" then
    result = result:sub(1, result:len() - 1)
  end
  return result .. "}"
end

-- Show multiline output in one message
---@source: https://github.com/folke/noice.nvim/discussions/141#discussioncomment-3985199
H.debug = function(...)
  local msg = vim.inspect(...)
  vim.notify(msg, vim.log.levels.INFO, {
    title = "Debug",
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "lua")
    end,
  })
end

H.is_in_table = function(buffer, bufferTable)
  for _, buf in ipairs(bufferTable) do
    if buf == buffer then
      return true
    end
  end
  return false
end

return H
