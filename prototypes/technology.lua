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
