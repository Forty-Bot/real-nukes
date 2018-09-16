local projectile = table.deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])
projectile.name = "nuke-shell"
projectile.map_color = {r=0, g=1, b=0}
projectile.picture.filename = "__real-nukes__/graphics/nuke-shell.png"
projectile.chart_picture.filename = "__real-nukes__/graphics/nuke-shoot-map-visualization.png"
projectile.action.action_delivery.target_effects = data.raw.projectile["atomic-rocket"].action.action_delivery.target_effects

local nuke = table.deepcopy(data.raw.ammo["artillery-shell"])
nuke.name = "nuke"
nuke.ammo_type.action.action_delivery.projectile = "nuke-shell"

local recipe = table.deepcopy(data.raw.recipe["artillery-shell"])
recipe.enabled = true
recipe.name = "nuke"
recipe.result = "nuke"

data:extend({projectile, nuke, recipe})
