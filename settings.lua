data:extend{
	{
		type = "double-setting",
		name = "yield",
		setting_type = "startup",
		order = "a",
		default_value = 0.1,
		-- E3 series
		-- in kT TNT
		allowed_values = {
			0.022, 0.047, 0.1, 0.22, 0.47, 1, 2.2, 4.7, 10, 22, 47, 100
		}
	},
	{
		type = "int-setting",
		name = "height",
		setting_type = "startup",
		order = "b",
		-- meters
		default_value = 100,
		minimum_value = 0,
		maximum_value = 5000
	},
	{
		-- Range increment for damage
		-- Use smaller values for a more accurate damage model
		-- This heavily impacts performance
		type = "int-setting",
		name = "stride",
		setting_type = "startup",
		order = "c",
		-- meters
		default_value = 50,
		minimum_value = 1,
		maximum_value = 500
	},
}
