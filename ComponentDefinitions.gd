extends Node

var available_components = [
	
	{ 
		code = "PowerSource",
		name = "Power plant",
		description = "",
		price = 400,
		config = {
			output = "1000"
		}
	},
	
	{ 
		code = "Laser",
		name = "Laser cannon",
		description = "",
		price = 400,
		config = {
			hp_per_energy_unit = 1
		}
	},
	
	{ 
		code = "Pulsar",
		name = "Power pulse",
		description = "",
		price = 400,
		config = {
			hp_per_energy_unit = 2,
			radius = 200
		}
	},
	
	{
		code = "MotionDetector",
		name = "Motion detector",
		description = "",
		price = "2000",
		config = {
			consumption = 10,
			radius = 200
		}
	},

	{
		code = "BatterySmall",
		name = "Small battery",
		description = "",
		price = "1000"
		
	}
]
