extends Node

var selected_level = 0

var all = {
	"01": {
		sources = 3,
		enemies = 1,
		finished = false
	}
}

func _ready():
	#TODO: generate random levels?
	pass

func current_level():
	return all[selected_level]
