local util = {}

-- Iterate over a table sorted by f, or the default ordering if f is nil
-- f: function(t, a, b)
function util.spairs(t, f)
	local keys = {}
	for k in pairs(t) do
		keys[#keys+1] = k
	end

	if f then
		table.sort(keys, function(a, b) return f(t, a, b) end)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

return util
