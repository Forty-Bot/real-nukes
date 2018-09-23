local cfg = {}

cfg.yield = 1 -- kT TNT
cfg.height = 260 -- m

-- Scaling factor when compared to a 1 kT blast
cfg.scale = cfg.yield^(1/3)

return cfg
