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
		unlocks = ["02"]
	},
	
	"02": {
		sources = 3,
		enemies = 3,
		enemy_types = ["01", "01", "01"],
		finished = false,
		next = "03",
		locked = true,
		unlocks = ["03"]
	},
	
	"03": {
		sources = 2,
		enemies = 6,
		enemy_types = ["01", "01", "01", "01", "02", "02"],
		finished = false,
		locked = true,
		unlocks = ["04", "05"],
		next = "04"
	},
	
	"04": {
		sources = 2,
		enemies = 6,
		enemy_types = ["02", "02", "02", "01", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	
	"05": {
		sources = 2,
		enemies = 6,
		enemy_types = ["02", "01", "01", "01", "03", "03"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	
	"06": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	###############################
	"07": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	"08": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	"09": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	"10": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	"11": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	"12": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
	},
	"13": {
		sources = 2,
		enemies = 10,
		enemy_types = ["01", "01", "01", "02", "02", "03", "03", "03", "01", "01"],
		finished = false,
		locked = true,
		next = "",
		unlocks = []
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
		default_level = finished_level.next
		
func set_current_level(level_code):
	if all.has(level_code):
		selected_level = level_code
