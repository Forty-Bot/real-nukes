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

local runtime = {}

tasks = require("tasks")
const = require("const")

local protos = {}
script.on_init(function ()
	for name, _ in pairs(game.entity_prototypes) do
		if string.find(name, const.press_prefix, 1, true) then
			-- ugly hack, but lua is shit
			tick = ({string.match(name,
					"([^" .. const.sep .. "]*)" .. const.sep .. "([^" .. const.sep .. "]*)"
				)})[2]
			protos[name] = tick
		end
	end
end)

script.on_event(defines.events.on_trigger_created_entity, function (e)
	if e.entity.name ~= 'nuke-sentinel' then
		return
	end

	for _name, tick in pairs(protos) do
		tasks.run_at(e.tick + tick, 'create_entity', {
			name = _name,
			position = e.entity.position,
			target = e.entity.position,
			-- Not important, needed for rounding I think?
			speed = 10000,
			force = e.entity.force
		})
	end
end)

function tasks.create_entity(t)
	game.surfaces.nauvis.create_entity(t)
end
tasks.funcs['create_entity'] = tasks.create_entity

return runtime
