extends Node2D

onready var space = get_node("EditingSpace")
var config

export var w = 0
export var h = 0

var grid = []

func _ready():
	generate_grid()
	space.update_visual(w, h, grid)
	
func generate_grid():
	for x in range(w + 1):
		grid.append([])
		grid[x] = []
		
		for y in range(h + 1):
			grid[x].append([])
			grid[x][y] = 0
			
