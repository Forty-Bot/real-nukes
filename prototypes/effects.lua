local effects = {}

local const = require("const")

-- Linear interpolation for y given x
local function lerp(x0, y0, x1, y1, x)
	if x0 == x1 then
		return nil -- don't divide by 0
	else
		return (y0 * (x1 - x) + y1 * (x - x0)) / (x1 - x0)
	end
end

-- Get overpressures and ranges of a blast
--  scale: scaling factor relative to a 1 kT burst
--  height: height of burst in meters
--  returns table[range (meters)] = pressure (psi)
function effects.get_pressures(scale, height)
	-- Height converted to feet and adjusted for scale
	local h = (height * const.meter_foot) / scale
	local ret = {}
	for p, isobar in pairs(const.overpressure_table) do
		local last = nil
		for i, point in ipairs(isobar) do
			-- Does the isobar cross h?
			if last and ((last[1] >= h and point[1] <= h)
				or (point[1] >= h and h >= last[1])) then
				-- Sometimes we have a horizontal isobar
				-- in which case just use the larger of the two
				local range = lerp(last[1], last[2], point[1], point[2], h)
					or math.max(last[2], point[2])
				ret[range * const.foot_meter * scale] = p
			end
			last = point
		end
	end
	return ret
end

-- Speed of the shock wave at a given overpressure
-- Glasstone 77 p97
function effects.shock_speed(overpressure)
	return const.sound_speed * math.sqrt(1 + (6 / 7) * (overpressure / const.atm))
end

return effects
