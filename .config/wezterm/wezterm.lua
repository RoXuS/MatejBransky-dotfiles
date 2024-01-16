require("events")

local keymaps = require("keymaps")
local ui = require("ui")
local U = require("utils")

local config = {}

config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

U.object_assign(config, ui)

return config
