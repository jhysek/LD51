extends Node2D

var selected_level = "01"
var default_level = "01"

var all = {
	"01": {
		sources = 4,
		enemies = 2,
		enemy_types = ["01", "01"],
		finished = false,
		next = "02",
		locked = false,
		unlocks = ["02"],
		target_power = 1500,
		disabled_buildings = ["Battery", "LaserAbsorber"]
	},
	
	"02": {
		sources = 2,
		enemies = 3,
		enemy_types = ["01", "01", "-", "02"],
		finished = false,
		next = "03",
		locked = true,
		unlocks = ["03"],
		target_power = 1500,
		disabled_buildings = ["LaserAbsorber"]
	},
	
	"03": {
		sources = 2,
		enemies = 6,
		enemy_types = ["01", "01", "01", "01", "-", "02", "02"],
		finished = false,
		locked = true,
		unlocks = ["04", "05", "09"],
		next = "04",
		target_power = 2000,
		disabled_buildings = ["LaserAbsorber"]
	},
	
	"04": {
		sources = 2,
		enemies = 6,
		enemy_types = ["02", "02", "02", "-", "01", "01", "01"],
		finished = false,
		locked = true,
		next = "06",
		unlocks = ["06"],
		target_power = 3000
	},
	
	"05": {
		sources = 2,
		enemies = 6,
		enemy_types = ["02", "01", "01", "-", "01", "03", "03"],
		finished = false,
		locked = true,
		next = "07",
		unlocks = ["07"],
		target_power = 3000
	},
	
	"06": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01","-", "02", "02", "-", "03", "03", "03", "-", "01", "01"],
		finished = false,
		locked = true,
		next = "08",
		unlocks = ["08"],
		target_power = 4000
	},
	###############################
	"07": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "-", "02", "02", "-", "03", "03", "-", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "10",
		unlocks = ["10"],
		target_power = 5000
	},
	"08": {
		sources = 2,
		enemies = 12,
		enemy_types = ["01", "01", "01", "-", "02", "02", "03", "03", "-", "03", "01", "01", "-", "02", "02"],
		finished = false,
		locked = true,
		next = "11",
		unlocks = ["11"],
		target_power = 5000
	},
	"09": {
		sources = 1,
		enemies = 10,
		enemy_types = ["01", "01", "01", "-", "02", "02", "-", "03", "03", "03", "-", "01", "01"],
		finished = false,
		locked = true,
		next = "13",
		unlocks = ["11", "12", "13"],
		target_power = 2000
	},
	"10": {
		sources = 4,
		enemies = 10,
		enemy_types = ["01", "01", "01", "-", "02", "02", "03", "-", "03", "03", "-", "01", "01"],
		finished = false,
		locked = true,
		next = "12",
		unlocks = ["12"],
		target_power = 5000
	},
	"11": {
		sources = 2,
		enemies = 14,
		enemy_types = ["01", "01", "01", "-", "02", "02", "03", "-", "03", "03", "01", "01", "-", "03", "03", "03", "04"],
		finished = false,
		locked = true,
		next = "13",
		unlocks = ["13"],
		target_power = 5000
	},
	"12": {
		sources = 3,
		enemies = 17,
		enemy_types = ["01", "01", "01", "-", "02", "02", "-", "03", "03", "03", "01", "01", "-", "02", "02", "-", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "13",
		unlocks = ["13"],
		target_power = 5000
	},
	"13": {
		sources = 4,
		enemies = 26,
		enemy_types = ["01", "01", "01", "-", "02", "02", "03", "-", "03", "03", "01", "01", "-", "03", "02", "02", "03", "-", "01", "02", "01", "-", "03", "03", "03", "-", "03", "03", "03", "-", "03", "03", "03"],
		finished = false,
		locked = true,
		next = null,
		unlocks = [],
		target_power = 10000
	}
}

func current_level():
	return all[selected_level]
	
func current_level_succeeded():
	var finished_level = current_level()
	if !finished_level.finished:
		finished_level.finished = true
		for unlock_id in finished_level.unlocks:
			all[unlock_id].locked = false
		if finished_level.has("next") and finished_level.next:
			default_level = finished_level.next
		
func set_current_level(level_code):
	if all.has(level_code):
		selected_level = level_code
