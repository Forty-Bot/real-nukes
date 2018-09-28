--[[
Copyright (C) 2018 Sean Anderson

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
-- f: function(a, b)
-- close over the table if you want to reference it
function util.spairs(t, f)
	local keys = {}
	for k in pairs(t) do
		keys[#keys+1] = k
	end
	
	table.sort(keys, f)

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

-- Reverse sort
function util.reverse(a, b)
	return a >= b
end

-- Linear interpolation for y given x
function util.lerp(x0, y0, x1, y1, x)
	if x0 == x1 then
		return nil -- don't divide by 0
	else
		return (y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	end
end

-- Look up a value in a table and lerp it
-- should be in the form table[x] = y
-- Will not extrapolate, only interpolate
function util.table_lerp(table, x)
		local x0, y0 = nil
		for x1, y1 in util.spairs(table) do
			if x0 and ((x0 >= x and x1 <= x) or (x1 >= x and x >= x0)) then
				return util.lerp(x0, y0, x1, y1, x)
			end
			x0 = x1
			y0 = y1
		end
end

return util
