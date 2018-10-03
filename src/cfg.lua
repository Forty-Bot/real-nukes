local cfg = {}

cfg.yield = 1 -- kT TNT
cfg.height = 250 -- m
-- Range increment for damage
-- Use smaller values for a more accurate damage model
-- This heavily impacts performance
cfg.stride = 250 -- m

return cfg
