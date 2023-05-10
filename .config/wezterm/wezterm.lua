local keys = require("keymaps")
local ui = require("ui")

local function object_assign(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end

	return t1
end

local config = {
	keys = keys,
}

object_assign(config, ui)

return config
