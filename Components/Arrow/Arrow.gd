extends Sprite

onready var game = get_node("/root/Game")

func place(direction, pos, cell_size):
	var displacement = Vector2(0,0)
	match direction:
		0: 
			rotation_degrees = 180
			displacement = Vector2(0, - cell_size.y)
		1: 
			rotation_degrees = 270
			displacement = Vector2(cell_size.x, 0)
		2: 
			rotation_degrees = 0
			displacement = Vector2(0, cell_size.y)
		3: 
			rotation_degrees = 90
			displacement = Vector2(-cell_size.x,0)
		
	position = pos + Vector2(32, 24) + displacement / 2
