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

local effects = require("effects")
local const = require("const")
local util = require("util")

-- Formulae and data from <http://nuclearsecrecy.com/nukemap/> and Glasstone and Dolan 77
local yield = .02 -- kT TNT
local burst_height = 30 -- m
-- Scaling factor when compared to a 1 kT blast
local scale = yield^(1/3)

local pressures = effects.get_pressures(scale, burst_height)

-- How spread out the individual explosions are
-- This really helps reduce the amount of projectiles needed
local sparse = 2

local protos = {}
local waves = {}
for range, p in pairs(pressures) do
	if not waves[p] then
		wave = {
			type = "projectile",
			name = "nuke-wave" .. p,
			flags = {"not-on-map"},
			acceleration = 0,
			action = {
				{
					type = "direct",
					action_delivery = {
						type = "instant",
						target_effects = {
							{
								type = "create-entity",
								entity_name = "explosion"
							},
							{
								type = "show-explosion-on-chart",
								scale = 1
							}
						}
					}
				},	
				{
					type = "area",
					radius = sparse - 1,
					action_delivery = {
						type = "instant",
						target_effects = {
							type = "damage",
							damage = {amount = p * const.psi_dmg, type = "explosion"}
						}
					}
				},
			},
			animation = {
				filename = "__core__/graphics/empty.png",
				frame_count = 1,
				width = 1,
				height = 1,
				priority = "high"
			}
		}
		waves[p] = true
		table.insert(protos, wave)
	end
end

local projectile = table.deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])
projectile.name = "nuke-shell"
projectile.map_color = {r=0, g=1, b=0}
projectile.picture.filename = "__real-nukes__/graphics/nuke-shell.png"
projectile.chart_picture.filename = "__real-nukes__/graphics/nuke-shoot-map-visualization.png"

for range, p in util.spairs(pressures) do
	log(range .. " " .. p)
end
target_effects = {}
local r = 1
for range, p in util.spairs(pressures) do
	repeat
		log(r .. " " .. range .. " " .. p)
		table.insert(target_effects, {
			type = "nested-result",
			action = {
				type = "cluster",
				cluster_count = math.max((2/sparse) * math.pi * r, 2),
				distance = r,
				action_delivery = {
					type = "projectile",
					projectile = "nuke-wave" .. p,
					starting_speed = const.sound_speed * const.tick_second
				}
			}
		})
		r = r + sparse
	until r > range
end
projectile.action.action_delivery.target_effects = target_effects
table.insert(protos, projectile)

local nuke = table.deepcopy(data.raw.ammo["artillery-shell"])
nuke.name = "nuke"
nuke.icon = "__real-nukes__/graphics/nuke.png"
nuke.ammo_type.action.action_delivery.projectile = "nuke-shell"
table.insert(protos, nuke)

table.insert(protos, {
	type = "recipe",
	name = "nuke",
	enabled = false,
	energy_required = 75,
	ingredients = {
		{"artillery-shell", 1},
		{"atomic-bomb", 1}
	},
	result = "nuke"
})

print("Hello world!")
data:extend(protos)
