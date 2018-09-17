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

data:extend({
	{
		type = "technology",
		name = "atomic-bomb-2",
		icon_size = 128,
		icon = "__base__/graphics/technology/atomic-bomb.png",
		effects = {
			{
				type = "unlock-recipe",
				recipe = "nuke"
			}
		},
		prerequisites = {"atomic-bomb", "artillery"},
		unit = {
			count = 7500,
			ingredients = {
				{"science-pack-1", 1},
				{"science-pack-2", 1},
				{"science-pack-3", 1},
				{"military-science-pack", 1},
				{"production-science-pack", 1},
				{"high-tech-science-pack", 1}
			},
			time = 60
		},
		order = "e-a-c"
	}
})
