extends Node

var  definitions = {
	PowerSource = {
		price = 500,
		description ="Generates power pulse every 10 seconds. Place on power source only.",
		name = "Power Plant",
		hitpoints = 200
	},
	
	"Turret": {
		price = 200,
		name = "Laser Turret",
		description = "Shoots laser beam whenever it receives a power pulse. Can rotate if receives location data.",
		hitpoints = 100
	},
	
	"Battery": {
		price = 500,
		name = "Battery / buffer",
		description = "Stores energy and release it in smaller pulses every 1s. Charges if receives power pulse.",
		hitpoints = 100
	},
	
	"MotionDetector": {
		price = 250,
		name = "Radar",
		description = "Scans surrounding whenever receives a power pulse. If detects enemy, broadcasts powerpulse with location data.",
		hitpoints = 50
	}
}

var enemies = {
	"0": {
		speed = 1000,
		attack = 10,
		hitpoints = 10,
	},
	
	"1": {
		speed = 500,
		attack = 20,
		hitpoints = 50
	},
	
	"2":  {
		speed = 500,
		attack = 10,
		hitpoints = 10
	}
}
