local keys = require("keymaps")
local ui = require("ui")
local U = require("utils")

local config = {
	keys = keys,
}

U.object_assign(config, ui)

return config
