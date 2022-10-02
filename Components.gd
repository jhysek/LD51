extends Node

var  definitions = {
	PowerSource = {
		price = 500,
		description ="Generates power pulse every 10 seconds. Place it on power source only.",
		name = "Power Plant",
		hitpoints = 200
	},
	
	"Turret": {
		price = 200,
		name = "Laser Turret",
		description = "Shoots laser beam whenever it receives a power pulse. Rotates if receives location data.",
		hitpoints = 100
	},
	
	"Battery": {
		price = 500,
		name = "Battery / buffer",
		description = "Stores energy and releases it in smaller pulses every 1s. Charges if receives power pulse. It's pre-charged.",
		hitpoints = 100
	},
	
	"MotionDetector": {
		price = 250,
		name = "Radar",
		description = "Scans surrounding whenever receives a power pulse. If detects enemy, broadcasts powerpulse with location data.",
		hitpoints = 50
	},
	
	"LaserAbsorber": {
		price = 100,
		name = "Laser Absorber",
		description = "When hit by laser, absorbs power and broadcast it as energy pulse.",
		hitpoints = 50
	}
}

var enemies = {
	"01": {
		speed = 50,
		attack = 10,
		hitpoints = 40,
		shooting = false,
		price = 50
	},
	
	"02": {
		speed = 25,
		attack = 20,
		hitpoints = 100,
		shooting = false,
		price = 200
	},
	
	"03":  {
		speed = 50,
		attack = 10,
		hitpoints = 30,
		shooting = true,
		price = 100
	}
}
