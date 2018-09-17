--[[
Copyright (C) <year>  <name of author>

This file is part of Realistic Nukes

Realistic Nukes is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Realistic Nukes is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

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
