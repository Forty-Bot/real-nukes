local projectile = table.deepcopy(data.raw.projectile["atomic-rocket"])
projectile.name = "nuke-shell"
projectile.type = "artillery-projectile"
projectile.reveal_map = true
projectile.map_color = {r=0, g=1, b=0}

local nuke = table.deepcopy(data.raw.ammo["artillery-shell"])
nuke.name = "nuke"
nuke.ammo_type.action.action_delivery.projectile = "nuke-shell"

local recipe = table.deepcopy(data.raw.recipe["artillery-shell"])
recipe.enabled = true
recipe.name = "nuke"
recipe.result = "nuke"

data:extend({projectile, nuke, recipe})
