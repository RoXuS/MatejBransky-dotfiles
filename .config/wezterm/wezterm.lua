require("events")

local keymaps = require("keymaps")
local ui = require("ui")
local U = require("utils")
local scrollback_to_nvim = require("scrollback-to-nvim")

local config = {}

config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

U.object_assign(config, ui)
table.insert(config.keys, scrollback_to_nvim.key)

return config
