local wezterm = require("wezterm")

require("events")

local utils = require("utils")
local keymaps = require("keymaps")
local ui = require("ui")
local scrollback_to_nvim = require("scrollback-to-nvim")
local open_in_nvim = require("open-in-nvim")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.hyperlink_rules = open_in_nvim.hyperlink_rules

config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

table.insert(config.keys, scrollback_to_nvim.key)
utils.object_assign(config, ui)

return config
