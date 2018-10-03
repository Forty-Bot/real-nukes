local cfg = {}

local meta = {
	__index = function(table, index)
		return settings.startup[index].value
	end
}

setmetatable(cfg, meta)

return cfg
