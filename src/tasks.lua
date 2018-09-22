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

local tasks = {}

-- Lookup table for functions
-- Note that we recreate this on every load
-- This allows mostly smooth migration to new code
tasks.funcs = {
	-- ["name"] = fully.qualified.name
}

if not global.tasks then
	global.tasks = {}
end

script.on_event(defines.events.on_tick, function (e)
	if not global.tasks[e.tick] then
		return
	end

	for _, task in ipairs(global.tasks[e.tick]) do
		-- Ensure we still run all events even if earlier functions break
		ok, err = pcall(function ()
			funcs[task.fname](table.unwrap(task.args))
		end)
		if not ok then
			log(err)
		end
	end
	global.tasks[e.tick] = nil
end)

-- Run a function at some tick in the future
function tasks.run_at(tick, fname, ...)
	if not global.events[tick] then
		global.events[tick] = {}
	end
	
	-- Ensure the function exists
	-- This is mostly for sanity/debugging
	local _ = funcs[fname]
	table.insert(global.tasks[tick], {
		.fname = fname,
		.args = ...
	})
end

return tasks
