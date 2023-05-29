local M = {}

---@param t1 any[]
---@param t2 any[]
function M.object_assign(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
	return t1
end

return M
