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

local effects = require("effects")
local const = require("const")
local util = require("util")
local cfg = require("cfg")

-- Scaling factor when compared to a 1 kT blast
local scale = cfg.yield^(1/3)

local protos = {
	{
		type = "projectile",
		name = "nuke-sentinel",
		flags = {"not-on-map"},
		acceleration = 0,
		animation = {
			filename = "__core__/graphics/empty.png",
			frame_count = 1,
			width = 1,
			height = 1,
			priority = "high"
		}
	},
}

local projectile = table.deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])
projectile.name = "nuke-shell"
projectile.map_color = {r=0, g=1, b=0}
projectile.picture.filename = "__real-nukes__/graphics/nuke-shell.png"
projectile.chart_picture.filename = "__real-nukes__/graphics/nuke-shoot-map-visualization.png"
projectile.height_from_ground = cfg.height

target_effects = {
	{
		type = "create-entity",
		entity_name = "nuke-sentinel",
		trigger_created_entity = true
	}
}

-- Do an extrapolation for range 0
-- Not the best mathematically, but w/e...
local pressures = effects.get_pressures(scale, cfg.height)
local iter = util.spairs(pressures)
local p0 = {iter()}
local p1 = {iter()}
if #p0 == 0 then
	pressures[0] = 0
	pressures[1] = 0
else
	-- We need the defaults in the case of exactly one pressure range
	pressures[0] = util.lerp(p0[1], p0[2], p1[1] or p0[1] + 1, p1[2] or p0[2], 0)
end

local last_damage = 0
local max_range = math.floor(util.spairs(pressures, util.reverse)())
for range = max_range, 1, -cfg.stride do
	damage = util.table_lerp(pressures, range) * const.psi_dmg
	tick = math.floor(range * const.second_tick / const.sound_speed)
	log(range .. " " .. damage .. " " .. damage - last_damage .. " " .. tick)
	table.insert(protos, {
		type = "projectile",
		name = const.press_prefix .. tick,
		flags = {"not-on-map"},
		acceleration = 0,
		animation = {
			filename = "__core__/graphics/light-medium.png",
			frame_count = 1,
			width = 300,
			height = 300,
			priority = "high"
		},
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					type = "nested-result",
					action = {
						type = "area",
						radius = range,
						action_delivery = {
							type = "instant",
							target_effects = {
								{
									type = "damage",
									damage = {amount = damage , type = "explosion"}
								},
								{
									type = "show-explosion-on-chart",
									scale = 1
								}
							}
						}
					}
				}
			}
		},
	})
	table.insert(target_effects, {
		type = "nested-result",
		action = {
			type = "cluster",
			cluster_count = math.max((2/cfg.stride) * math.pi * range, 2),
			distance = range,
			action_delivery = {
				type = "projectile",
				-- Just need a do-nothing projectile
				projectile = "nuke-sentinel",
				starting_speed = const.sound_speed * const.tick_second,
				target_effects = {
					type = "create-entity",
					entity_name = "big-artillery-explosion",
				}
			}
		}
	})
	last_damage = damage
end
projectile.action.action_delivery.target_effects = target_effects
table.insert(protos, projectile)

local nuke = table.deepcopy(data.raw.ammo["artillery-shell"])
nuke.name = "nuke"
nuke.localised_description = {"item-description.nuke", cfg.yield}
nuke.icon = "__real-nukes__/graphics/nuke.png"
nuke.ammo_type.action.action_delivery.projectile = "nuke-shell"
table.insert(protos, nuke)

table.insert(protos, {
	type = "recipe",
	name = "nuke",
	localised_description = {"recipe-description.nuke", cfg.yield},
	enabled = false,
	energy_required = 75,
	ingredients = {
		{"artillery-shell", 1},
		{"atomic-bomb", 1}
	},
	result = "nuke"
})

data:extend(protos)
